//
//  ZXVedioControlVC.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/20.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KxMovieDecoder;

extern NSString * const ZxVideoParameterMinBufferedDuration;    // Float
extern NSString * const ZxVideoParameterMaxBufferedDuration;    // Float
extern NSString * const ZxVideoParameterDisableDeinterlacing;   // BOOL

@interface ZXVideoControlVC : UIViewController
+ (id) videoControlVCWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;

@property (readonly) BOOL playing;

- (void) play;
- (void) pause;

@end
