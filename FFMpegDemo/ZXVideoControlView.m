//
//  ZXVideoControlView.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXVideoControlView.h"
#import "ZXCameraControlModel.h"

@interface ZXVideoControlView()

@end

@implementation ZXVideoControlView

#define kControlButtonUp        25
#define kControlButtonDown        26
#define kControlButtonLeft        27
#define kControlButtonRight      28

+ (ZXVideoControlView *)videoControlView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ZXVideoControlView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.themeColor = [UIColor colorWithRed:26/225.f green:31/225.f blue:39/225.f alpha:1.0f];
    
    self.tintColor = [UIColor whiteColor];
    self.directionControlView.backgroundColor = [UIColor blackColor];
    self.directionControlView.alpha = 0.f;
    self.directionControlView.hidden = YES;
    
    UIImage *up = [[UIImage imageNamed:@"up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.upButton setImage:up forState:UIControlStateNormal];
    
    UIImage *down = [[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.downButton setImage:down forState:UIControlStateNormal];
    
    UIImage *left = [[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.leftButton setImage:left forState:UIControlStateNormal];
    
    UIImage *right = [[UIImage imageNamed:@"right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.rightButton setImage:right forState:UIControlStateNormal];
    
    self.upButton.tag = kControlButtonUp;
    self.downButton.tag = kControlButtonDown;
    self.leftButton.tag = kControlButtonLeft;
    self.rightButton.tag = kControlButtonRight;

}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    self.toolBar.barTintColor = themeColor;

}
- (IBAction)stopDirectionControl:(UIButton *)button {
    
    Byte command;
    uint16_t para1 = 7;
    uint16_t para2 = 1;
    
    switch (button.tag) {
        case kControlButtonUp:
        command = kPTZCtrl_TILT_UP;
        break;
        
        case kControlButtonDown:
        command = kPTZCtrl_TILT_DOWN;

        break;
        
        case kControlButtonLeft:
        command = kPTZCtrl_PAN_LEFT;

        break;
        
        case kControlButtonRight:
        command = kPTZCtrl_PAN_RIGHT;

        break;
        
        default:
        break;
    }

    if (_directionBlock) {
        _directionBlock(command, para1, para2);
    }
}

- (IBAction)directionAction:(UIButton *)button {
    
    Byte command;
    uint16_t para1 = 7;
    uint16_t para2 = 0;
    
    switch (button.tag) {
        case kControlButtonUp:
        command = kPTZCtrl_TILT_UP;
        break;
        
        case kControlButtonDown:
        command = kPTZCtrl_TILT_DOWN;
        
        break;
        
        case kControlButtonLeft:
        command = kPTZCtrl_PAN_LEFT;
        
        break;
        
        case kControlButtonRight:
        command = kPTZCtrl_PAN_RIGHT;
        
        break;
        
        default:
        break;
    }
    
    if (_directionBlock) {
        _directionBlock(command, para1, para2);
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    
    [super setTintColor:tintColor];
    
    self.upButton.tintColor = tintColor;
    self.leftButton.tintColor = tintColor;
    self.downButton.tintColor = tintColor;
    self.rightButton.tintColor = tintColor;

}

- (IBAction)playAction:(UIBarButtonItem *)sender {
    
    if (_playBlock) {
        _playBlock();
    }
}

- (IBAction)toggleFullScreen:(id)sender {
    
    if (_fullScreenBlock) {
        _fullScreenBlock();
    }
}


- (IBAction)showDirectionControlView:(id)sender {
    
    if (self.directionControlView.hidden == YES) {
        
        self.directionControlView.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.directionControlView.alpha = 0.9f;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)hideDirectionControlView {
    
    if (self.directionControlView.hidden == NO) {
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.directionControlView.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            self.directionControlView.hidden = YES;

        }];
    }
}

@end
