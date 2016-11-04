//
//  ZXVideoControlView.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXVideoControlView : UIView

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *directionItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *volumeItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fullScreenItem;

@property (weak, nonatomic) IBOutlet UIView *directionControlView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) UIColor *themeColor;

@property (copy, nonatomic) void (^playBlock)();
@property (copy, nonatomic) void (^fullScreenBlock)();

@property (copy, nonatomic) void (^directionBlock)(Byte comman, uint16_t para1 ,uint16_t para2);


+ (ZXVideoControlView *)videoControlView;

- (void)hideDirectionControlView;

@end
