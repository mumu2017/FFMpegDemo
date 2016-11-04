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
    
    NSString *cameraURL;
    
    
    
    return cameraURL;
}

@end
