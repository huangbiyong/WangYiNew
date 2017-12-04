# WangYiNew


## 效果图
![效果](http://upload-images.jianshu.io/upload_images/9242195-44e637fcfa1138fd.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 使用
-  继承BYViewController
```
#import "BYViewController.h"

@interface ViewController : BYViewController


@end

```
- 在 viewDidLoad 添加自己的控制器，控制器必须写使用title
```
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
RecommendVC.title = @"首页";
[self addChildViewController:RecommendVC];

ProfileViewController *profileVC = [[ProfileViewController alloc]init];
profileVC.title = @"个人";
[self addChildViewController:profileVC];
}

```





