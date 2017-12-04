//
//  BYProtocol.h
//  iOS-仿网易
//
//  Created by huangbiyong on 2017/12/4.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYViewController;

@protocol BYProtocol <NSObject>

@optional

/*
 * 选中index试图
 */

- (void)viewController:(BYViewController*)vc didSelect:(NSInteger)index;

/*
 * 是否需要标题缩放
 * 默认缩放 1.3 scale
 */
- (BOOL)titleButtonScale;


/*
 *  不选中的颜色
 *  默认是是blackColor
 */
- (UIColor*)titleButtonNormalColor;

/*
 *  默认选中的颜色
 *  默认是红色
 */
- (UIColor*)titleButtonSelectColor;




@end
