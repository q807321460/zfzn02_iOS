//
//  JSBaseViewController.h
//  Smart360
//
//  Created by sun on 15/7/24.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol navigationParamsDelegate <NSObject>

//导航前进参数
- (void)onParseNavigationToParams:(NSDictionary *)params;

//导航返回参数
- (void)onParseNavigationBackParams:(NSDictionary *)params;

@end


@interface JSBaseViewController : UIViewController <navigationParamsDelegate>

//@property (nonatomic, strong) MBProgressHUD *hud; //konnn
@property (nonatomic) MBProgressHUD *hud;

//返回（push）当前视图
-(void)backCurrentView:(id)sender;

- (void)setNavigationItemWithTitle:(NSString *)navigationTitle;

- (void)createNavigationItemBackButton;

//Left item
- (void)setNavigationItemLeftButtonWithTitle:(NSString *)title;
- (void)setNavigationItemLeftButtonWithNormalImg:(NSString *)img AndPressedImg:(NSString *)pressedImg;
- (void)setNavigationItemLeftButtonNoImageWithTitle:(NSString *)title;
- (void)leftItemClicked:(id)sender;

//Right item
- (void)setNavigationItemRightButtonWithTitle:(NSString *)title;

- (void)setNavigationItemRightButtonWithNormalImg:(NSString *)normalImg hightedImg:(NSString *)hightedImg;
- (void)rightItemClicked:(id)sender;

//导航前进方法
- (void)navigationToVc:(UIViewController *)vc;

- (void)navigationToVc:(UIViewController *)vc withParams:(NSDictionary *)params;

//导航返回方法
- (void)navigationBack;

- (void)navigationBackWithParams:(NSDictionary *)params;

- (void)navigationBackToVc:(UIViewController *)vc;

- (void)navigationBackToVc:(UIViewController *)vc withParams:(NSDictionary *)params;

#pragma make -
//显示刷新
-(void)showHud;
-(void)showHudWithText:(NSString *)text;
//隐藏刷新
-(void)hideHud;
#pragma mark - 导航栏不允许点击
-(void)showHudForBidOperation;
-(void)hideHudEnableOperation;

@end

