//
//  BYViewController.h
//  iOS-仿网易
//
//  Created by huangbiyong on 2017/12/4.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYProtocol.h"

@interface BYViewController : UIViewController

@property (nonatomic, weak) id<BYProtocol> deleagte;

@end
