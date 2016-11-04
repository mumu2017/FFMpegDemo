//
//  ZXVideoPlayerView.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ZxVideoPlayerParameterMinBufferedDuration;    // Float
extern NSString * const ZxVideoPlayerParameterMaxBufferedDuration;    // Float
extern NSString * const ZxVideoPlayerParameterDisableDeinterlacing;   // BOOL

@interface ZXVideoPlayerView : UIView

@property (copy, nonatomic) NSString *path;

@property (copy, nonatomic) void (^tapBlock)();
@property (copy, nonatomic) void (^panBlock)(UIPanGestureRecognizer *sender);


+ (id) videoPlayerWithContentPath: (NSString *) path
                       parameters: (NSDictionary *) parameters
                            frame:(CGRect)frame;

@property (readonly) BOOL playing;

- (void) play;
- (void) pause;
- (void) refresh;

- (void)didAppear;  //配合viewController的viewDidAppear方法使用
- (void)didDisappear;  //配合viewController的viewDidDisappear方法使用
- (void)handleMemoryWarning; //配合viewController的viewDidReceiveMemoryWarning方法使用

@end
