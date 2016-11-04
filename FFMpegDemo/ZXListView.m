//
//  ZXListView.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "ZXListView.h"
#import <pop/POP.h>

#define kDismissButtonHeight 44.f
#define kTableViewCellHeight    44.f
#define kTableViewHeaderHeight  50.f
@interface ZXListView()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIVisualEffectView *cover;

@end

@implementation ZXListView

+ (instancetype)listViewWithViewController:(UIViewController *)controller {
    ZXListView *listView = [[ZXListView alloc] initWithViewController:controller];
    
    return listView;
}

- (instancetype)initWithViewController:(UIViewController *)controller {
    
    NSAssert(controller != nil, @"controller为空, 请检查参数!");
    
    if (self = [super init]) {
        
        _controller = (controller.navigationController == nil) ? controller : controller.navigationController;
        self.frame = controller.view.bounds;
        [_controller.view addSubview:self];
        
        [self initWithSubviews];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initWithSubviews];
    }
    
    return self;
}

- (void)initWithSubviews {
    
    self.hidden = YES;
    [self cover];
    [self contentView];
    _isShowing = NO;
}

- (CGFloat)contentViewHeight {
    
    NSInteger count = 0;
    
    for (NSArray *arr in self.mumtipleSectionArray) {
        
        count += arr.count;
    }
    
    CGFloat navBarHeight = 0;
    
    if ([self.controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.controller;
        if (nav.navigationBarHidden == NO) {
            navBarHeight = 64;
        }
    } else {
        if (self.controller.navigationController.navigationBarHidden == NO) {
            navBarHeight = 64;
        }
    }
    
    CGFloat height = MIN(self.frame.size.height-navBarHeight, count * kTableViewCellHeight + self.mumtipleSectionArray.count * kTableViewHeaderHeight + kDismissButtonHeight);
    
    return height;
}

- (UIVisualEffectView *)cover {
    
    if (!_cover) {
        
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.bounds;
        
        _cover = effectView;
        [self addSubview:_cover];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        
        tap.numberOfTapsRequired = 1;
        [_cover addGestureRecognizer:tap];
        
        _cover.alpha = 0.f;
    }
    
    return _cover;
}

- (UIView *)contentView {
    
    if (!_contentView) {
//        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, self.frame.size.height-self.center.y)];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, self.contentViewHeight)];
        _contentView.backgroundColor = [UIColor yellowColor];

        [self addSubview:_contentView];
        
        [self dismissButton];
        [self tableView];
    }
    
    return _contentView;
}

- (UIButton *)dismissButton {
    
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        
        _dismissButton.frame = CGRectMake(0, 0, self.contentView.frame.size.width, kDismissButtonHeight);
        [self.contentView addSubview:_dismissButton];
        
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _dismissButton.backgroundColor = [UIColor darkGrayColor];
        [_dismissButton setTitle:@"点击关闭" forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _dismissButton;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, kDismissButtonHeight, self.contentView.frame.size.width, self.contentView.frame.size.height-kDismissButtonHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = kTableViewCellHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _tableView;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    [self resetSubiviewFrames];
}

- (void)resetSubiviewFrames {
    
    if (_cover) {
        _cover.frame = self.bounds;

    }
    
    if (_contentView) {
        
        CGRect contentFrame;
        
        if (self.isShowing == YES) {

            contentFrame = CGRectMake(0, CGRectGetMaxY(self.frame)-self.contentViewHeight, self.frame.size.width, self.contentViewHeight);
            
        } else {
            
            contentFrame = CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, self.contentViewHeight);
        }
        
        _contentView.frame = contentFrame;
        
        _dismissButton.frame = CGRectMake(0, 0, self.contentView.frame.size.width, kDismissButtonHeight);
        _tableView.frame = CGRectMake(0, kDismissButtonHeight, self.contentView.frame.size.width, self.contentView.frame.size.height-kDismissButtonHeight);
    }

}

- (void)setSingleSectionArray:(NSArray<NSArray *> *)singleSectionArray {
    
    _singleSectionArray = singleSectionArray;
    
    if (_singleSectionArray == nil) {
        return;
    }
    self.mumtipleSectionArray = @[_singleSectionArray];
}

- (void)setMumtipleSectionArray:(NSArray<NSArray *> *)mumtipleSectionArray {
    
    _mumtipleSectionArray = mumtipleSectionArray;
    
    [self.tableView reloadData];
    [self resetSubiviewFrames];
}

#pragma mark - action

- (void)showWithMultiPleSectionArray:(NSArray<NSArray *> *)mumtipleSectionArray {
    
    self.mumtipleSectionArray = mumtipleSectionArray;
    
    [self show];
}
- (void)showWithSingleSectionArray:(NSArray<NSArray *> *)singleSectionArray {
    
    self.singleSectionArray = singleSectionArray;
    
    [self show];
}

// 从控制器View底部弹出, 展示内容
- (void)show {
    
    self.hidden = NO;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    positionAnimation.springSpeed = 20;
    positionAnimation.springBounciness = 4;

    positionAnimation.fromValue = [NSValue valueWithCGRect:self.contentView.frame];

    CGRect toFrame = CGRectMake(0, CGRectGetMaxY(self.frame)-self.contentViewHeight, self.frame.size.width, self.contentViewHeight);

    positionAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    
    [self.contentView pop_addAnimation:positionAnimation forKey:@"viewPositionAnimation"];
    
    POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];

    alphaAnimation.fromValue = @0.f;
    alphaAnimation.toValue = @0.6f;
    alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        self.isShowing = YES;
        
    };
    [self.cover pop_addAnimation:alphaAnimation forKey:@"viewAlphaIncreaseAnimation"];
    
}

// 隐藏至控制器View底部
- (void)dismiss {
    
    self.isShowing = NO;

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.springSpeed = 20;
    positionAnimation.springBounciness = 1;
    positionAnimation.fromValue = [NSValue valueWithCGRect:self.contentView.frame];

    CGRect tbFrame = CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, self.contentViewHeight);

    positionAnimation.toValue = [NSValue valueWithCGRect:tbFrame];
    
    [self.contentView pop_addAnimation:positionAnimation forKey:@"viewPositionAnimation"];
    
    POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];

    alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){

        self.hidden = YES;

    };
    
    alphaAnimation.fromValue = @0.6f;
    alphaAnimation.toValue = @0.f;
    [self.cover pop_addAnimation:alphaAnimation forKey:@"viewAlphaDecreaseAnimation"];
    
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"zxlistviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    }
    
    cell.textLabel.text = self.mumtipleSectionArray[indexPath.section][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mumtipleSectionArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.mumtipleSectionArray[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    [view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor darkTextColor];
    
    if (self.sectionTitleArray.count > section) {
        label.text = self.sectionTitleArray[section];

    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kTableViewHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_selectionBlock) {
        _selectionBlock(indexPath);
    }
    
    [self dismiss];
}


@end
