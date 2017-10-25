//
//  CustomNavigationController.m
//  Smart360
//
//  Created by sun on 15/7/28.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>


@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 当自定义返回按钮时保证边缘手势正常
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    [self.navigationBar setBackgroundColor:UIColorFromRGB(0x3f3c51)];
    self.navigationBar.barTintColor = UIColorFromRGB(0x3f3c51);
//    NSLog(@"自定义导航栏控制器  viewDidLoad");
//    [self.navigationBar setBackgroundImage:LOADIMAGE(@"BackgroundHeader", @"png") forBarMetrics:UIBarMetricsDefault];
    
}

//设置状态条的样式
- (UIStatusBarStyle)preferredStatusBarStyle {
//     NSLog(@"自定义导航栏控制器  UIStatusBarStyle");
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
     NSLog(@"自定义导航栏控制器 didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        [super pushViewController:viewController animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
        if (navigationController.viewControllers.count == 1) {
            self.interactivePopGestureRecognizer.enabled =NO;
        }
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
