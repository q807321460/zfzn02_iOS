//
//  JSBaseViewController.m
//  Smart360
//
//  Created by sun on 15/7/24.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
#import "UIBarButtonItem+CustomStyle.h"

@interface JSBaseViewController () {
    UILabel *_titleLabel;
    UIBarButtonItem *_rightBarButtonItem;
    BOOL isHudShowing ;

}

@end

@implementation JSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleView];
    
    NSLog(@"navigationController viewDidLoad = %@ %@ %@", self, self.navigationController, self.navigationController.viewControllers);
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"navigationController viewWillDisappear = %@ %@ %@", self, self.navigationController, self.navigationController.viewControllers);
}

//-(void)loadView {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//导航前进参数
- (void)onParseNavigationToParams:(NSDictionary *)params {
#ifdef DEBUG
    NSAssert(YES, @"Please implement 'onParseNavigationToParams' method in subclass");
#endif
}

//导航返回参数
- (void)onParseNavigationBackParams:(NSDictionary *)params {
#ifdef DEBUG
    NSAssert(YES, @"Please implement 'onParseNavigationBackParams' method in subclass");
#endif
}

- (void)createNavigationItemTitleView {
    _titleLabel.tag = 102;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
    self.navigationItem.titleView = _titleLabel;
    _titleLabel.enabled = YES;
    _titleLabel.textColor = UIColorFromRGB(0xffffff);
    self.navigationItem.titleView = _titleLabel;
}

- (void)createNavigationItemBackButton {
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"ios_return"] target:self action:@selector(backCurrentView:) isLeft:YES];
}

- (void)setNavigationItemRightButtonWithTitle:(NSString *)title {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:title target:self action:@selector(rightItemClicked:) isLeft:NO];
}

- (void)setNavigationItemRightButtonWithNormalImg:(NSString *)normalImg hightedImg:(NSString *)hightedImg {
//    UIImage *backgroundImg = [UIImage imageNamed:img];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.f, 0.f, 80, 44)];
    [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImageNormal:normalImg hightLighted:hightedImg];
//    [rightButton setAdjustsImageWhenDisabled:NO];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -60);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)setNavigationItemLeftButtonWithTitle:(NSString *)title {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:title target:self action:@selector(leftItemClicked:) isLeft:YES];
}

- (void)setNavigationItemLeftButtonNoImageWithTitle:(NSString *)title {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemNoImageWithTitle:title target:self action:@selector(leftItemClicked:) isLeft:YES];
}

- (void)setNavigationItemLeftButtonWithNormalImg:(NSString *)img AndPressedImg:(NSString *)pressedImg {
    UIImage *backgroundImg = [UIImage imageNamed:img];
     UIImage *hightedImg = [UIImage imageNamed:pressedImg];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0.f, 0.f, 22, 22)];
    [leftButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:backgroundImg forState:UIControlStateNormal];
    [leftButton setImage:hightedImg forState:UIControlStateHighlighted];
    [leftButton setAdjustsImageWhenDisabled:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


- (void)setNavigationItemWithTitle:(NSString *)navigationTitle {
    _titleLabel.text = navigationTitle;
    [_titleLabel adjustsFontSizeToFitWidth];
    self.navigationItem.titleView = _titleLabel;
}

- (void)backCurrentView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClicked:(id)sender {

}

- (void)leftItemClicked:(id)sender {
    [self navigationBack];
}

//-(void)loadView {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}

#pragma mark - navigation goto and back operations
#pragma mark navigation goto

- (void)navigationToVc:(UIViewController *)vc {
    [self navigationToVc:vc withParams:nil];
}

- (void)navigationToVc:(UIViewController *)vc withParams:(NSDictionary *)params {
    //容错
    if (!vc) {
        return;
    }
    
    JSBaseViewController *baseVc = (JSBaseViewController *)vc;
    if (params) {
        if(params && [baseVc respondsToSelector:@selector(onParseNavigationToParams:)]) {
            [baseVc performSelector:@selector(onParseNavigationToParams:) withObject:params];
        } else {
            JSlog(@"Warning！ViewController cannot conformsToProtocol.");
        }
    }
    
    [self.navigationController pushViewController:baseVc animated:YES];
}


#pragma mark navigation back
- (void)navigationBack {
    [self navigationBackWithParams:nil];
}

- (void)navigationBackWithParams:(NSDictionary *)params {
    [self navigationBackToVc:nil withParams:params];
}

- (void)navigationBackToVc:(UIViewController *)vc {
    [self navigationBackToVc:vc withParams:nil];
}

- (void)navigationBackToVc:(UIViewController *)vc withParams:(NSDictionary *)params {
    
    JSBaseViewController *baseVc = nil;
    if (!vc) {
        NSArray *vcArray = self.navigationController.viewControllers;
        baseVc = [vcArray objectAtIndex:vcArray.count - 2];
    } else {
        for (JSBaseViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[vc class]]) {
                baseVc = controller;
            }
        }
    }
    
    if (baseVc) {
        if (params) {
            if([baseVc respondsToSelector:@selector(onParseNavigationBackParams:)]) {
                [baseVc performSelector:@selector(onParseNavigationBackParams:) withObject:params];
            } else {
                JSlog(@"Warning！ViewController cannot conformsToProtocol.");
            }
        }
        
        [self.navigationController popToViewController:baseVc animated:YES];
    }
}

-(void)pushToViewControllerWithVCName:(NSString*)viewControllerStr animated:(BOOL)animated {
    [super pushToViewControllerWithVCName:viewControllerStr animated:animated];
}

#pragma make - Hud
-(void)showHud {
    [self showHudWithText:@"加载中..."];
}

-(void)showHudWithText:(NSString *)text {
    if (_hud) {
        [_hud removeFromSuperview];
    }
    
    //初始化
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //小矩形的背景色
    _hud.color = [UIColor grayColor];
    //显示的文字
    _hud.labelText = text;
}

-(void)hideHud {
    [_hud hide:YES];
}

#pragma mark - 导航栏不允许点击
-(void)showHudForBidOperation {
    if( !isHudShowing )
    {
        self.navigationController.view.userInteractionEnabled = NO ;
        self.navigationController.navigationBar.userInteractionEnabled = NO ;
//        self.navigationItem.leftBarButtonItem.enabled = NO ;
        self.navigationItem.rightBarButtonItem.enabled = NO ;
        [_hud show:YES];
        isHudShowing = YES ;
    }
    
}

-(void)hideHudEnableOperation {
    if( isHudShowing )
    {
        self.navigationController.view.userInteractionEnabled = YES ;
        self.navigationController.navigationBar.userInteractionEnabled = YES ;
        
//        self.navigationItem.leftBarButtonItem.enabled = YES ;
        self.navigationItem.rightBarButtonItem.enabled = YES ;
        [_hud hide:YES];
        isHudShowing = NO ;
    }
}

-(BOOL )isHudShowing {
    return isHudShowing ;
}



@end
