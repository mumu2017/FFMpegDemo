//
//  HLSPlayingVC.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/24.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "HLSPlayingVC.h"
#import <AVFoundation/AVFoundation.h>

@interface HLSPlayingVC ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation HLSPlayingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSURL *url = [NSURL URLWithString:self.URLString];
    NSMutableString *filepath = [[NSMutableString alloc]initWithString:self.URLString];
    
    NSURL *url = [NSURL URLWithString:self.URLString];
//    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 100, 44)];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"播放" forState:UIControlStateNormal];

}


- (void)play {
    
    [self.player play];
}



@end
