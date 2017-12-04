//
//  BYViewController.m
//  iOS-仿网易
//
//  Created by huangbiyong on 2017/12/4.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYViewController.h"

#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height

@interface BYViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, assign) BOOL isInitialize;

@end

@implementation BYViewController

- (NSMutableArray *)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isInitialize == NO) {
        // 4.设置所有标题
        [self setupAllTitle];
        
        _isInitialize = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网易新闻";

    // 1.添加标题滚动视图
    [self setupTitleScrollView];
    
    // 2.添加内容滚动视图
    [self setupContentScrollView];
    
    
    // iOS7以后,导航控制器中scollView顶部会添加64的额外滚动区域
    if (@available(iOS 11.0, *)) {
        _titleScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UIScrollViewDelegate
// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前角标
    NSInteger i = scrollView.contentOffset.x / SW;
    
    // 获取标题按钮
    UIButton *titleButton = self.titleButtons[i];
    
    // 1.选中标题
    [self selButton:titleButton];
    
    // 2.把对应子控制器的view添加上去
    [self setupOneViewController:i];
}

// 只要一滚动就需要字体渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 字体缩放 1.缩放比例 2.缩放哪两个按钮
    NSInteger leftI = scrollView.contentOffset.x / SW;
    NSInteger rightI = leftI + 1;
    
    // 获取左边的按钮
    UIButton *leftBtn = self.titleButtons[leftI];
    NSInteger count = self.titleButtons.count;
    
    // 获取右边的按钮
    UIButton *rightBtn;
    if (rightI < count) {
        rightBtn = self.titleButtons[rightI];
    }
    
    // 0 ~ 1 =>  1 ~ 1.3
    // 计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x / SW;
    
    scaleR -= leftI;
    
    // 左边缩放比例
    CGFloat scaleL = 1 - scaleR;
    
    // 缩放按钮
    CGFloat scale = 0.3;
    if ([self.deleagte respondsToSelector:@selector(titleButtonScale)]) {
        if ([self.deleagte titleButtonScale] == NO) {
            scale = 0;
        }
    }
    
    
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * scale + 1, scaleL * scale + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * scale + 1, scaleR * scale + 1);
    
    // 颜色渐变
    UIColor *selectColor = [UIColor redColor];  //默认是红色
    if ([self.deleagte respondsToSelector:@selector(titleButtonSelectColor)]) {
        selectColor = [self.deleagte titleButtonSelectColor];
    }
    
    const CGFloat *components = CGColorGetComponents(selectColor.CGColor);

    UIColor *rightColor = [UIColor colorWithRed:scaleR*components[0] green:scaleR*components[1] blue:scaleR*components[2] alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL*components[0] green:scaleL*components[1] blue:scaleL*components[2] alpha:1];
    
    //UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    //UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}

/*
 颜色:3种颜色通道组成 R:红 G:绿 B:蓝
 
 白色: 1 1 1
 黑色: 0 0 0
 红色: 1 0 0
 */

#pragma mark - 选中标题
- (void)selButton:(UIButton *)button
{
    _selectButton.transform = CGAffineTransformIdentity;
    
    //为选择的颜色
    UIColor *nomalColor = [UIColor blackColor];  //默认是红色
    if ([self.deleagte respondsToSelector:@selector(titleButtonNormalColor)]) {
        nomalColor = [self.deleagte titleButtonNormalColor];
    }
    [_selectButton setTitleColor:nomalColor forState:UIControlStateNormal];
    
    
    // 被选中的颜色
    UIColor *selectColor = [UIColor redColor];  //默认是红色
    if ([self.deleagte respondsToSelector:@selector(titleButtonSelectColor)]) {
        selectColor = [self.deleagte titleButtonSelectColor];
    }
    
    [button setTitleColor:selectColor forState:UIControlStateNormal];
    
    // 标题居中
    [self setupTitleCenter:button];
    
    // 字体缩放:形变
    CGFloat scale = 0.3;
    if ([self.deleagte respondsToSelector:@selector(titleButtonScale)]) {
        if ([self.deleagte titleButtonScale] == NO) {
            scale = 0;
        }
    }
    
    button.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
    
    _selectButton = button;
    
    if ([self.deleagte respondsToSelector:@selector(viewController:didSelect:)]) {
        [self.deleagte viewController:self didSelect:button.tag];
    }
}

#pragma mark - 标题居中
- (void)setupTitleCenter:(UIButton *)button
{
    // 本质:修改titleScrollView偏移量
    CGFloat offsetX = button.center.x - SW * 0.5;
    // 处理最小偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 处理最大偏移量
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SW;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset: CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 添加一个子控制器的View
- (void)setupOneViewController:(NSInteger)i
{
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    CGFloat x = i * SW;
    vc.view.frame = CGRectMake(x, 0, SW  , self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}

#pragma mark - 处理标题点击
- (void)titleClick:(UIButton *)button
{
    NSInteger i = button.tag;
    
    // 1.标题颜色 变成 红色
    [self selButton:button];
    
    // 2.把对应子控制器的view添加上去
    [self setupOneViewController:i];
    
    // 3.内容滚动视图滚动到对应的位置
    CGFloat x = i * SW;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma mark - 设置所有标题
- (void)setupAllTitle
{
    // 已经把内容展示上去 -> 展示的效果是否是我们想要的(调整细节)
    // 1.标题颜色 为黑色
    // 2.需要让titleScrollView可以滚动
    
    // 添加所有标题按钮
    NSInteger count = self.childViewControllers.count;
    CGFloat btnW = 100;
    CGFloat btnH = self.titleScrollView.bounds.size.height;
    CGFloat btnX = 0;
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        btnX = i * btnW;
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 监听按钮点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 把标题按钮保存到对应的数组
        [self.titleButtons addObject:titleButton];
        
        if (i == 0) {
            [self titleClick:titleButton];
        }
        
        [self.titleScrollView addSubview:titleButton];
    }
    
    
    // 设置标题的滚动范围
    self.titleScrollView.contentSize = CGSizeMake(count * btnW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容的滚动范围
    self.contentScrollView.contentSize = CGSizeMake(count * SW, 0);
    
    // bug:代码跟我的一模一样,但是标题就是显示不出来
    // 内容往下移动,莫名其妙
}


#pragma mark - 添加标题滚动视图
- (void)setupTitleScrollView
{
    // 创建titleScrollView
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    CGFloat y = self.navigationController.navigationBarHidden? 20 : 64;
    titleScrollView.frame = CGRectMake(0, y, self.view.bounds.size.width, 44);
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
    
}

#pragma mark - 添加内容滚动视图
- (void)setupContentScrollView
{
    // 创建contentScrollView
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.frame = CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - y);
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
    
    // 设置contentScrollView的属性
    // 分页
    self.contentScrollView.pagingEnabled = YES;
    // 弹簧
    self.contentScrollView.bounces = NO;
    // 指示器
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
    self.contentScrollView.delegate = self;
    
}




























@end
