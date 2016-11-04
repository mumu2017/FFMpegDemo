//
//  ZXRTSPPlayerVC.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXRTSPPlayerVC.h"
#import "ZXVideoPlayerView.h"
#import "ZXVideoControlView.h"
#import <pop/POP.h>
#import "ZXCameraControlModel.h"
#import "ZXSocketManager.h"

@interface ZXRTSPPlayerVC ()

@property (strong, nonatomic) ZXVideoPlayerView *playerView;
@property (strong, nonatomic) ZXVideoControlView *controlView;
@property (assign, nonatomic) BOOL isFullScreen;

@end

@implementation ZXRTSPPlayerVC

+ (ZXRTSPPlayerVC *)rtspPlayerVCWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    ZXRTSPPlayerVC *vc = [[ZXRTSPPlayerVC alloc] init];
    vc.URLString = URLString;
    vc.parameters = parameters;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;

    [self initSubviews];
}

- (void)initSubviews {
    
    self.playerView = [ZXVideoPlayerView videoPlayerWithContentPath:self.URLString parameters:self.parameters frame:CGRectMake(0, 64, self.view.frame.size.width, CGRectGetMaxY(self.view.frame)-44-64)];
    NSLog(@"frame=======%@", NSStringFromCGRect(self.playerView.frame));

    NSLog(@"centerpoint=======%@", NSStringFromCGPoint(self.playerView.center));
    [self.view addSubview:self.playerView];
    
    __weak ZXRTSPPlayerVC *weakSelf = self;

    self.playerView.tapBlock = ^(){
        __strong ZXRTSPPlayerVC *strongSelf = weakSelf;
        
        [strongSelf.controlView hideDirectionControlView];
        if (strongSelf.isFullScreen) {
            [strongSelf toggleFullScreen];
        }
        
    };
    
    self.controlView = [ZXVideoControlView videoControlView];
    self.controlView.frame = CGRectMake(0, CGRectGetMaxY(self.playerView.frame)-88, self.view.frame.size.width, 132);
    [self.view addSubview:self.controlView];
    
    self.controlView.playBlock = ^() {
        __strong ZXRTSPPlayerVC *strongSelf = weakSelf;

        [strongSelf togglePlay];
    };
    
    self.controlView.fullScreenBlock = ^() {
      
        __strong ZXRTSPPlayerVC *strongSelf = weakSelf;
        [strongSelf toggleFullScreen];
    };
    
    self.controlView.directionBlock = ^(Byte command, uint16_t para1 ,uint16_t para2) {
        __strong ZXRTSPPlayerVC *strongSelf = weakSelf;

        NSData *data = [ZXCameraControlModel controlDataWithCommand:command cameraID:strongSelf.cameraID para1:para1 para2:para2];
        [[ZXSocketManager getInstance] cameraDirectionControlWithData:data];
    };
    
}

- (void)toggleFullScreen {
    
    if (self.isFullScreen == NO) { //当前未全屏显示视频, 需隐藏navigationBar和controlView
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];

        POPSpringAnimation *playerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        playerPositionAnimation.springBounciness = 0;
        
        CGRect newFrame = self.view.bounds;
        playerPositionAnimation.toValue = [NSValue valueWithCGRect:newFrame];
        [self.playerView pop_addAnimation:playerPositionAnimation forKey:@"playerPositionAnimation"];
        
        POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        
        alphaAnimation.fromValue = @1.f;
        alphaAnimation.toValue = @0.f;
        
        alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            
            self.isFullScreen = YES;
            
        };
        [self.controlView pop_addAnimation:alphaAnimation forKey:@"viewAlphaIncreaseAnimation"];

    } else { //当前正全屏展示视频, 需显示navigationBar和controlView
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        POPSpringAnimation *playerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        playerPositionAnimation.springBounciness = 0;

        CGRect newFrame = CGRectMake(0, 64, self.view.frame.size.width, CGRectGetMaxY(self.view.frame)-44-64);
        playerPositionAnimation.toValue = [NSValue valueWithCGRect:newFrame];
        [self.playerView pop_addAnimation:playerPositionAnimation forKey:@"playerPositionAnimation"];
        
        POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        
        alphaAnimation.fromValue = @0.f;
        alphaAnimation.toValue = @1.f;
        alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            
            self.isFullScreen = NO;
            
        };
        [self.controlView pop_addAnimation:alphaAnimation forKey:@"viewAlphaIncreaseAnimation"];

    }
}

- (void)togglePlay {
    
    if (self.playerView.playing) {
        
        [self.playerView pause];
        
    } else {
        
        [self.playerView refresh];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.playerView didAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.playerView didDisappear];
}

@end
