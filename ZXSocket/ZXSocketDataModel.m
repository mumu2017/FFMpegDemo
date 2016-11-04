//
//  ZXSocketDataModel.m
//  SocketDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXSocketDataModel.h"
#import "YMSocketUtils.h"
#import <objc/runtime.h>
#import "RHSocketByteBuf.h"

// 后面NSString这是运行时能获取到的C语言的类型
NSString * const TYPE_UINT8   = @"TC";// char是1个字节，8位
NSString * const TYPE_UINT16   = @"TS";// short是2个字节，16位
NSString * const TYPE_UINT32   = @"TI";
NSString * const TYPE_UINT64   = @"TQ";
NSString * const TYPE_STRING   = @"T@\"NSString\"";
NSString * const TYPE_ARRAY   = @"T@\"NSArray\"";

@implementation ZXSocketDataModel

+ (ZXSocketDataModel *)socketDataModelFromData:(NSData *)data {
    
    RHSocketByteBuf *byteBuf = [[RHSocketByteBuf alloc] initWithData:data];
    
    int8_t userNamelength = [byteBuf readInt8:0];
    NSString *userName = [byteBuf readString:1 length:userNamelength];
    
    int8_t passwordlength = [byteBuf readInt8:1+userNamelength];
    NSString *password = [byteBuf readString:1+userNamelength+1 length:passwordlength];
    
    int8_t targetType = [byteBuf readInt8:1+userNamelength+1+passwordlength+1];

    int8_t optResult = [byteBuf readInt8:1+userNamelength+1+passwordlength+1+1];

    int8_t optLength = [byteBuf readInt8:1+userNamelength+1+passwordlength+1+1+1];
    NSString *optInfo = [byteBuf readString:1+userNamelength+1+passwordlength+1+1+1+1 length:optLength];
    
    /**
     int index = 0;
     
     int8_t userNamelength = [byteBuf readInt8:index];
     index += 1;
     NSLog(@"index === %d", index);
     
     NSString *userName = [byteBuf readString:index length:userNamelength];
     index += userNamelength;
     NSLog(@"index === %d", index);
     
     int8_t passwordlength = [byteBuf readInt8:index];
     index += 1;
     NSLog(@"index === %d", index);
     
     NSString *password = [byteBuf readString:index length:passwordlength];
     index += passwordlength;
     NSLog(@"index === %d", index);
     
     int8_t targetType = [byteBuf readInt8:index];
     index += 1;
     NSLog(@"index === %d", index);
     
     int8_t optResult = [byteBuf readInt8:index];
     index += 1;
     NSLog(@"index === %d", index);
     
     int8_t optLength = [byteBuf readInt8:index];
     index += 1;
     NSLog(@"index === %d", index);
     
     NSString *optInfo = [byteBuf readString:index length:optLength];
     */
    ZXSocketDataModel *model = [[ZXSocketDataModel alloc] init];
    model.userName = userName;
    model.password = password;
    model.targetType = targetType;
    model.optResult = optResult;
    model.optInfo = optInfo;
    
    return model;
}

+ (NSData *)requestDataWithUserName:(NSString *)userName password:(NSString *)password protocalType:(int16_t)protocalType {
    
    ZXSocketDataModel *logInModel = [[ZXSocketDataModel alloc] init];
    logInModel.targetType = kAccountCheckTargetType_SIP;
    logInModel.userName = userName;
    logInModel.password = password;
    logInModel.optInfo = @"";
    logInModel.optResult = 0;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    //header
    int32_t length = 20;
    int16_t protocalCode = protocalType;

    CFByteOrder order = CFByteOrderGetCurrent();
    if (order == CFByteOrderLittleEndian) { //如果是小端序, 则倒序成大端序
        
        length = CFSwapInt32(length);
        protocalCode = CFSwapInt16(protocalType);
    }
    
    RHSocketByteBuf *byteBuf = [[RHSocketByteBuf alloc] init];
    [byteBuf writeInt32:length];
    [byteBuf writeInt16:protocalCode];

    //body
    [byteBuf writeData:[logInModel RequestSpliceAttribute:logInModel]];

    NSLog(@"size of data ===== %ld", data.length);

    data = byteBuf.buffer;

    return data;
}

- (NSData *)RequestSpliceAttribute:(id)obj{
    
    NSMutableData *dataToSend = [[NSMutableData alloc] init];
    
    unsigned int numIvars; //成员变量个数
    
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]), &numIvars);
    
    NSString *type = nil;
    NSString *name = nil;
    
    for (int i = 0; i < numIvars; i++) {
        objc_property_t thisProperty = propertys[i];
        
        name = [NSString stringWithUTF8String:property_getName(thisProperty)];
        NSLog(@"%d.name:%@",i,name);
        type = [[[NSString stringWithUTF8String:property_getAttributes(thisProperty)] componentsSeparatedByString:@","] objectAtIndex:0]; //获取成员变量的数据类型
        NSLog(@"%d.type:%@",i,type);
        
        id propertyValue = [obj valueForKey:[(NSString *)name substringFromIndex:0]];
        NSLog(@"%d.propertyValue:%@",i,propertyValue);
        
        NSLog(@"\n");
        
        if ([type isEqualToString:TYPE_UINT8]) {
            uint8_t i = [propertyValue charValue];// 8位
            [dataToSend appendData:[YMSocketUtils byteFromUInt8:i]];
            NSLog(@"size of data ===== %ld", dataToSend.length);

        }else if([type isEqualToString:TYPE_UINT16]){
            uint16_t i = [propertyValue shortValue];// 16位
            [dataToSend appendData:[YMSocketUtils bytesFromUInt16:i]];
            NSLog(@"size of data ===== %ld", dataToSend.length);

        }else if([type isEqualToString:TYPE_UINT32]){
            uint32_t i = [propertyValue intValue];// 32位
            [dataToSend appendData:[YMSocketUtils bytesFromUInt32:i]];
            NSLog(@"size of data ===== %ld", dataToSend.length);

        }else if([type isEqualToString:TYPE_UINT64]){
            uint64_t i = [propertyValue longLongValue];// 64位
            [dataToSend appendData:[YMSocketUtils bytesFromUInt64:i]];
            NSLog(@"size of data ===== %ld", dataToSend.length);

        }else if([type isEqualToString:TYPE_STRING]){
            
            NSString *string = (NSString*)propertyValue;
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//            NSData *data = [(NSString*)propertyValue \
                            dataUsingEncoding:NSUTF8StringEncoding];// 通过utf-8转为data
            
            // 用2个字节拼接字符串的长度拼接在字符串data之前
            [dataToSend appendData:[YMSocketUtils byteFromUInt8:data.length]];
            NSLog(@"size of data ===== %ld", dataToSend.length);

            
            // 然后拼接字符串
            if (string.length == 0) {
                [dataToSend appendData:[YMSocketUtils byteFromUInt8:0]];
            } else {
                [dataToSend appendData:data];

            }
            NSLog(@"size of data ===== %ld", dataToSend.length);

            
        }else {
            NSLog(@"RequestSpliceAttribute:未知类型");
            NSAssert(YES, @"RequestSpliceAttribute:未知类型");
        }
    }
    
    // hy: 记得释放C语言的结构体指针
    free(propertys);
    
    return dataToSend;
}



@end
