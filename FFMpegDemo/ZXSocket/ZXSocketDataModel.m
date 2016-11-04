//
//  ZXSocketDataModel.m
//  SocketDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXSocketDataModel.h"
#import "YMSocketUtils.h"
#import "RHSocketByteBuf.h"
#import "ZXSocketManager.h"

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
    [byteBuf writeData:[ZXSocketManager requestSpliceAttribute:logInModel]];

    NSLog(@"size of data ===== %ld", data.length);

    data = byteBuf.buffer;

    return data;
}

@end
