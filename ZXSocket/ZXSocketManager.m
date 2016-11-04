//
//  ZXSocketManager.m
//  SocketDemo
//
//  Created by 陈林 on 2016/11/2.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXSocketManager.h"
#import "RHSocketUtils.h"
#import "ZXSocketDataModel.h"
#import "RHSocketByteBuf.h"
#import "ZXCameraModel.h"

#define TAG_FIXED_LENGTH_HEADER 201
#define TAG_RESPONSE_BODY   202

#define kSocketHeaderLength 4   // 包头长度, 6个字节, 存储了整个包的长度
#define kSocketProtocalTypeLength 2 //协议号长度, 2个字节

#define TAG_UUC_HEARTBEAT 15
#define TAG_UUC_ACCOUNT_CHECK -1194
#define TAG_UUC_MONITOR_QUERY_JSON -1108

#define kSocketServerHost   @"uuc.gzopen.cn"
#define kSocketServerPort   6414

@interface ZXSocketManager()<GCDAsyncSocketDelegate>

@property (strong, nonatomic) NSThread *thread;  //心跳线程

@property (strong, nonatomic) NSData *heartBeatData; //心跳包数据

@property (copy, nonatomic) void (^loginBlock)(ZXSocketDataModel *socketData);
@property (copy, nonatomic) void (^cameraBlock)(NSArray *cameraList);

@end

@implementation ZXSocketManager

+ (instancetype)getInstance {
    
    static ZXSocketManager* sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[ZXSocketManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Socket 连接
- (void)connect {
    
    ///TCP Socket
    if (self.socket.isConnected == NO) {
        
        if ([self.socket connectToHost:kSocketServerHost onPort:kSocketServerPort error:nil]) {
            NSLog(@"connection success");
            
        } else {
            NSLog(@"connection error");
        }
    }
}

- (void)dealloc {
    
    [self.socket disconnect];
}

#pragma mark - Socket 写数据
- (void)logIn { // 登录
    
    NSData *data = [ZXSocketDataModel requestDataWithUserName:@"10000" password:@"lyh" protocalType:-1193];
    
    [self.socket writeData:data withTimeout:-1 tag:TAG_UUC_ACCOUNT_CHECK];
    
    //    NSLog(@"datalength ===== %ld", data.length);
    //    NSString *content = [self dataToString:data];
    //    NSLog(@"data String =====%@", content);
}

- (void)send { //获取视频监控列表
    
    NSData *data = [ZXSocketDataModel requestDataWithUserName:@"10000" password:@"lyh" protocalType:-1108];
    [self.socket writeData:data withTimeout:-1 tag:TAG_UUC_MONITOR_QUERY_JSON];
    
    //    NSLog(@"datalength ===== %ld", data.length);
    //    NSString *content = [self dataToString:data];
    //    NSLog(@"data String =====%@", content);
    
}

#pragma mark - GCDAsyncSocketDelegate

#pragma mark 读数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSLog(@"%s", __func__);
    
    if (tag == TAG_FIXED_LENGTH_HEADER) {
        
        uint32_t bodyLength = [self getBodyLengthFromHeader:data];
        [self.socket readDataToLength:bodyLength withTimeout:-1 tag:TAG_RESPONSE_BODY];
        
    } else if (tag == TAG_RESPONSE_BODY) {
        
        [self handleResponseBody:data];
        
        // Start reading the next response
        //  [self.socket readDataToLength:kSocketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
    }
}

- (void)handleResponseBody:(NSData *)data {
    
    int16_t protocalType = [self getProtocalTypeFromBody:data];
    NSData *content = [data subdataWithRange:NSMakeRange(kSocketProtocalTypeLength, data.length-kSocketProtocalTypeLength)];
    
    switch (protocalType) {
        case TAG_UUC_ACCOUNT_CHECK: //登录
        {
            ZXSocketDataModel *socketData = [ZXSocketDataModel socketDataModelFromData:content];
            if (_loginBlock) {
                _loginBlock(socketData);
            }
            break;
        }
        case TAG_UUC_MONITOR_QUERY_JSON: //获取视频列表
        {
            NSArray *cameraList = [ZXCameraModel cameraModelListWithJSONData:content];
            if (_cameraBlock) {
                _cameraBlock(cameraList);
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    if (tag == TAG_UUC_HEARTBEAT) { // 如果是心跳包, 则读取信息
        return;
    }
    
    NSLog(@"%s", __func__);
    
    // 完成数据写入后, 开始读socket中服务器返回的数据
    [self.socket readDataToLength:kSocketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    NSLog(@"连接成功!");
    
    [self logIn]; // 连接成功后, 自动进行SI账号登录
    
    //开启线程发送心跳
    if (self.thread.isExecuting == NO) {
        [self.thread start];
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    NSLog(@"socket连接已断开 - 错误信息: %@", err);
    
    //如果因为错误断开连接, 则尝试重连
    if (err) {
        
        BOOL connected = NO;
        int connectionTime = 0;
        
        while (connected == NO && connectionTime < 5) { // 自动重连5次
            
            connected = [self.socket connectToHost:sock.connectedHost onPort:sock.connectedPort error:nil];
            connectionTime += 1;
            
            if (connected) {
                
                NSLog(@"自动重连 - 连接成功!");
                
            } else {
                NSLog(@"自动重连 - 连接失败!");
            }
        }
        
        
    } else {
        //正常断开
        NSLog(@"正常断开 - 成功");
        
    }
}

#pragma mark 心跳包
//开启不死线程不断发送心跳
- (void)threadStart {
    
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)heartBeat {
    
    [self.socket writeData:self.heartBeatData withTimeout:-1 tag:TAG_UUC_HEARTBEAT];
}

#pragma mark - Helper

// 从packet body中读取前两个字节中的协议号
- (int16_t)getProtocalTypeFromBody:(NSData *)data {
    
    NSAssert(data.length >= 2, @"包体长度不足2个字节, 数据错误!");
    
    int16_t val = 0;
    int16_t protocalType = 0;
    
    [data getBytes:&val range:NSMakeRange(0, 2)];
    
    CFByteOrder order = CFByteOrderGetCurrent();
    if (order == CFByteOrderLittleEndian) { //如果是小端序, 则将服务端发过来的大端序倒转
        
        protocalType = CFSwapInt16(val);
    } else {
        protocalType = val;
    }
    
    return protocalType;
}

// 从packet header中读取packet长度
- (uint32_t)getBodyLengthFromHeader:(NSData *)header {
    
    NSAssert(header.length == 2, @"包体长度不等于4个字节, 数据错误!");

    uint32_t length = [RHSocketUtils int32FromBytes:header];
    
    CFByteOrder order = CFByteOrderGetCurrent();
    
    if (order == CFByteOrderLittleEndian) { //如果是小端序, 则将服务端发过来的大端序倒转
        
        length = CFSwapInt32(length);
    }
    
    length -= kSocketHeaderLength;
    
    return length;
}

#pragma mark - 懒加载

- (GCDAsyncSocket *)socket {
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        _socket.IPv4PreferredOverIPv6 = NO;// 设置支持IPV6
    }
    return _socket;
}

- (NSThread *)thread { //心跳线程
    
    if (!_thread) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadStart) object:nil];
    }
    return _thread;
}

- (NSData *)heartBeatData { //心跳包数据
    if (!_heartBeatData) {
        
        int32_t length = 6;
        int16_t protocalCode = TAG_UUC_HEARTBEAT;
        
        CFByteOrder order = CFByteOrderGetCurrent();
        if (order == CFByteOrderLittleEndian) { //如果是小端序, 则倒序成大端序
            
            length = CFSwapInt32(length);
            protocalCode = CFSwapInt16(protocalCode);
        }
        
        RHSocketByteBuf *byteBuf = [[RHSocketByteBuf alloc] init];
        [byteBuf writeInt32:length];
        [byteBuf writeInt16:protocalCode];
        
        _heartBeatData = byteBuf.buffer;
        
    }
    return _heartBeatData;
}

#pragma mark - Debug

// 按照字节打印NSData

- (NSString *)dataToString:(NSData *)data
{
    Byte *dataPointer = (Byte *)[data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSUInteger index;
    for (index = 0; index < [data length]; index++)
    {
        //        [result appendFormat:@"0x%02x,", dataPointer[index]]; //16进制打印
        [result appendFormat:@"%02d,", dataPointer[index]];
        
    }
    return result;
}

@end
