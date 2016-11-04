//
//  ZXCameraModel.m
//  SocketDemo
//
//  Created by 陈林 on 2016/11/2.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXCameraModel.h"
#import "MJExtension.h"

@implementation ZXCameraModel

+ (NSArray *)cameraModelListWithJSONData:(NSData *)data {
    
    NSArray *array = [ZXCameraModel mj_objectArrayWithKeyValuesArray:data];
    
    return array;
}

- (NSString *)camaraURL {
    
    NSString *cameraURL = [NSString stringWithFormat:@"rtsp://uuc.gzopen.cn:554/media_proxy?media_type=monitoring&camera_id=%@&stream_type=1&audio=1&video=1", self.id];

    return cameraURL;
}

@end
