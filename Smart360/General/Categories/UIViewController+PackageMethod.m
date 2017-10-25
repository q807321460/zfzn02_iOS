//
//  UIViewController+PackageMethod.m
//  Smart360
//
//  Created by sun on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "UIViewController+PackageMethod.h"

@implementation UIViewController (PackageMethod)

//自定义navigationBar的titlView
- (void)setTitle:(NSString *)title withFont:(NSInteger)fontValue withTitleColor:(UIColor *)color
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    titleLabel.textColor = color;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:fontValue];
    self.navigationItem.titleView = titleLabel;
}

//获得导航栏和状态栏高度
- (CGFloat)getNavigationBarHeightAndStatusBarHeight
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    return navigationBarHeight + statusBarHeight;

}

//根据视图控制器名称push
-(void)pushToViewControllerWithVCName:(NSString*)viewControllerStr animated:(BOOL)animated
{
    if (![viewControllerStr isEqualToString:@""]) {
        __autoreleasing Class controllerClass = NSClassFromString(viewControllerStr);
        __autoreleasing UIViewController *viewController = [[controllerClass alloc]init];
        [self.navigationController pushViewController:viewController animated:animated];
    }
}


//
//- (void)addTargetActionForTitleVie
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = self.navigationItem.titleView.bounds;
//    [self.navigationItem.titleView addSubview:button];
//    button.tag = 200;
////    [button addTarget:self action:@selector(handelTitleButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//}


@end
