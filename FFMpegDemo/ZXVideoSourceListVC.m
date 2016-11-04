//
//  ZXVideoSourceListVC.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXVideoSourceListVC.h"
#import "ZXRTSPPlayerVC.h"
#import "ZXListView.h"
#import "ZXSocketManager.h"
#import "ZXCameraModel.h"

@interface ZXVideoSourceListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) ZXListView *listView;
@property (strong, nonatomic) ZXSocketManager *socketManager;
@property (strong, nonatomic) NSArray *cameraList;

@end

@implementation ZXVideoSourceListVC

#pragma mark - 控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViews];
    [self.socketManager connect]; // Socket连接, 连接成功则自动登录
}

- (void)configureViews {

    self.title = @"融合通信";
    self.view.backgroundColor = [UIColor colorWithRed:26/225.f green:31/225.f blue:39/225.f alpha:1.0f];

    [self tableView];
    [self listView];

}


#pragma mark - 菜单选择

- (void)handleListViewSelectedIndexPath:(NSIndexPath *)indexPath {
    
    //根据IndexPath, 定位到摄像头模型, 获取视频流URL
    ZXCameraModel *camara = self.cameraList[indexPath.row];
    NSString *path = [camara camaraURL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        parameters[@"ZxVideoParameterDisableDeinterlacing"] = @(YES);
    }
    
    ZXRTSPPlayerVC *vc = [ZXRTSPPlayerVC rtspPlayerVCWithURLString:path parameters:parameters];
    vc.cameraID = camara.id;
    vc.title = camara.name;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"监控上报室";
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:38/225.f green:129/225.f blue:121/225.f alpha:1.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self handleTableViewSelectionWithIndexPath:indexPath];
}

- (void)handleTableViewSelectionWithIndexPath:(NSIndexPath *)indexPath {
    
    self.listView.singleSectionArray = [self nameArrayWithCameraList:self.cameraList];
    self.listView.sectionTitleArray = @[@"远程摄像头"];
    
//    NSArray *arr = @[@"远程摄像头", @"远程摄像头"];
//    self.listView.mumtipleSectionArray = @[arr, arr, arr];
//    self.listView.sectionTitleArray = @[@"远程摄像头", @"远程摄像头", @"远程摄像头"];
    
    [self.listView show];
}

#pragma mark - Helper
-(NSArray *)nameArrayWithCameraList:(NSArray *)cameraList {
    
    if (cameraList.count == 0) {
        return nil;
    }
    
    NSMutableArray *arrM = [[NSMutableArray alloc] initWithCapacity:cameraList.count];
    
    for (ZXCameraModel *camara in cameraList) {
        [arrM addObject:camara.name];
    }
    
    return arrM;
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.rowHeight = 60;

    }
    
    return _tableView;
}

- (ZXSocketManager *)socketManager {
    
    if (!_socketManager) {
        _socketManager = [ZXSocketManager getInstance];
        
        __weak ZXVideoSourceListVC *weakSelf = self;
        _socketManager.cameraBlock = ^(NSArray *cameraList) {
            __strong ZXVideoSourceListVC *strongSelf = weakSelf;
            strongSelf.cameraList = cameraList;
        };
    }
    return _socketManager;
}


- (ZXListView *)listView {
    if (!_listView) {
        _listView = [ZXListView listViewWithViewController:self];
        
        __weak ZXVideoSourceListVC *weakSelf = self;
        
        _listView.selectionBlock = ^(NSIndexPath *indexPath) {
            __strong ZXVideoSourceListVC *strongSelf = weakSelf;
            
            [strongSelf handleListViewSelectedIndexPath:indexPath];
        };
    }
    
    return _listView;
}

@end
