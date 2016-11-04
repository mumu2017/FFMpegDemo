//
//  ViewController.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/19.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ViewController.h"
#import "ZXVideoControlVC.h"
#import "HLSPlayingVC.h"
#import "ZXVideoSourceListVC.h"
#import "ZXRTSPPlayerVC.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)playRSTP:(id)sender {
////        NSString *path = @"rtsp://admin:admin12345@221.236.245.41:8554/264/ch33/main/av_stream";
////    NSString *path = @"http://dlhls.cdn.zhanqi.tv/zqlive/34338_PVMT5.m3u8";
//    NSString *path = @"http://walterebert.com/playground/video/hls/sintel-trailer.m3u8";

//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    parameters[ZxVideoParameterDisableDeinterlacing] = @(YES);
//    
//    ZXVideoControlVC *vc = [ZXVideoControlVC videoControlVCWithContentPath:path parameters:parameters];
    ZXVideoSourceListVC
    *vc = [[ZXVideoSourceListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)playHLS:(id)sender {
    
    HLSPlayingVC *vc = [[HLSPlayingVC alloc] init];
    vc.URLString = @"http://walterebert.com/playground/video/hls/sintel-trailer.m3u8";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
