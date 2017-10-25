//
//  UIViewController+PackageMethod.h
//  Smart360
//
//  Created by sun on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PackageMethod)

//自定义navigationBar的titlView
- (void)setTitle:(NSString *)title withFont:(NSInteger)fontValue withTitleColor:(UIColor *)color;
//获得导航栏和状态栏高度
- (CGFloat)getNavigationBarHeightAndStatusBarHeight;

//给导航栏中间view添加点击事件
//- (void)addTargetActionForTitleVie;
//
-(void)pushToViewControllerWithVCName:(NSString*)viewControllerStr animated:(BOOL)animated;

@end
