//
//  ZXCameraControlModel.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/11/4.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXCameraControlModel.h"
#import "YMSocketUtils.h"
#import "RHSocketUtils.h"
#import "RHSocketByteBuf.h"
#import "ZXSocketManager.h"

@implementation ZXCameraControlModel

+ (NSData *)controlDataWithCommand:(unichar)command cameraID:(NSString *)cameraID para1:(uint16_t)para1 para2:(uint16_t)para2 {
    
    ZXCameraControlModel *model = [[ZXCameraControlModel alloc] init];
    
    model.command = command;
    model.reserve = 0;
    model.cameraID = cameraID;
    model.para1 = para1;
    model.para2 = para2;
    model.para3 = 0;
    model.para4 = 0;
    
    NSLog(@"cameraID: %@", model.cameraID);
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSData *controlData = [model controlData];
    //header
    int32_t length = (int32_t)controlData.length + 6;
    int16_t protocalCode = -6001;
    
    CFByteOrder order = CFByteOrderGetCurrent();
    if (order == CFByteOrderLittleEndian) { //如果是小端序, 则倒序成大端序
        
        length = CFSwapInt32(length);
        protocalCode = CFSwapInt16(-6001);
    }
    
    RHSocketByteBuf *byteBuf = [[RHSocketByteBuf alloc] init];
    [byteBuf writeInt32:length];
    [byteBuf writeInt16:protocalCode];
    
    //body
    [byteBuf writeData:controlData];
    
    NSLog(@"size of data ===== %ld", data.length);
    
    data = byteBuf.buffer;
    [ZXSocketManager dataToString:data];
//    NSLog(@"camera control data : %@", [ZXSocketManager dataToString:data]);
    
    return data;
}

- (uint16_t)cameraIDLength {
    
    uint16_t cameraIDLength = [[self.cameraID dataUsingEncoding:NSUTF8StringEncoding] length];
    
    return cameraIDLength;
}

- (NSData *)controlData {
    
    NSMutableData *controlData = [[NSMutableData alloc] init];

    [controlData appendData:[YMSocketUtils byteFromUInt8:self.command]];
    [controlData appendData:[YMSocketUtils byteFromUInt8:self.reserve]];
    [controlData appendData:[YMSocketUtils bytesFromUInt16:self.cameraIDLength]];
    
    [controlData appendData:[YMSocketUtils bytesFromUInt16:self.para1]];
    [controlData appendData:[YMSocketUtils bytesFromUInt16:self.para2]];
    [controlData appendData:[YMSocketUtils bytesFromUInt16:self.para3]];
    [controlData appendData:[YMSocketUtils bytesFromUInt16:self.para4]];

    [controlData appendData:[self.cameraID dataUsingEncoding:NSUTF8StringEncoding]];
    
    return controlData;
}

@end
