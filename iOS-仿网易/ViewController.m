//
//  ViewController.m
//  iOS-仿网易
//
//  Created by huangbiyong on 2017/12/4.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "RecommendViewController.h"
#import "ProfileViewController.h"

@interface ViewController () <BYProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"网易新闻";
    self.deleagte = self;
    
    //使用
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    homeVC.title = @"首页";
    [self addChildViewController:homeVC];
    
    HotViewController *hotVC = [[HotViewController alloc]init];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    
    VideoViewController *videoVC = [[VideoViewController alloc]init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    RecommendViewController *RecommendVC = [[RecommendViewController alloc]init];
    RecommendVC.title = @"推荐";
    [self addChildViewController:RecommendVC];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    profileVC.title = @"个人";
    [self addChildViewController:profileVC];
}


#pragma mark - BYProtocol
- (UIColor*)titleButtonSelectColor {
    return [UIColor redColor];
}

- (BOOL)titleButtonScale {
    return YES;
}

-(void)viewController:(BYViewController *)vc didSelect:(NSInteger)index {
    NSLog(@"index =  %ld",index);
}



@end
