//
//  ZXListView.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXListView : UIView

@property (strong, nonatomic) UIViewController *controller;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *dismissButton;

@property (strong, nonatomic) UIView *contentView;

//mumtipleSectionArray, 数据源, 里面装的数组, 每个数组是一个section
@property (strong, nonatomic) NSArray <NSArray *>*mumtipleSectionArray;

//mumtipleSectionArray, 数据源, 里面装的模型, 只有一个section的时候使用
@property (strong, nonatomic) NSArray <NSArray *>*singleSectionArray;
//section header title的数组
@property (strong, nonatomic) NSArray <NSString *>*sectionTitleArray;

// 选中cell后触发的block, 用处和didSelectCellAtIndexPath一样
@property (copy, nonatomic) void(^selectionBlock)(NSIndexPath *indexPath);

@property (assign, nonatomic) BOOL isShowing;

+ (instancetype)listViewWithViewController:(UIViewController *)controller;

- (void)showWithMultiPleSectionArray:(NSArray<NSArray *> *)mumtipleSectionArray;
- (void)showWithSingleSectionArray:(NSArray<NSArray *> *)singleSectionArray;

- (void)show;

- (void)dismiss;

@end
