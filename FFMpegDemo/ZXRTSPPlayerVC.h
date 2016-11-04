//
//  ZXRTSPPlayerVC.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXRTSPPlayerVC : UIViewController

@property (copy, nonatomic) NSString *cameraID;

@property (copy, nonatomic) NSString *URLString;
@property (strong, nonatomic) NSDictionary *parameters;

+ (ZXRTSPPlayerVC *)rtspPlayerVCWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

@end
