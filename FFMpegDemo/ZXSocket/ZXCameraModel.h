//
//  ZXCameraModel.h
//  SocketDemo
//
//  Created by 陈林 on 2016/11/2.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXCameraModel : NSObject

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *mType;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *type;

+ (NSArray *)cameraModelListWithJSONData:(NSData *)data;

- (NSString *)camaraURL;

@end
