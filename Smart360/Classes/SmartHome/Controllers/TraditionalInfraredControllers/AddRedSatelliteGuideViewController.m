//
//  AddRedSatelliteGuideViewController.m
//  Smart360
//
//  Created by michael on 16/1/20.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "AddRedSatelliteGuideViewController.h"
#import "JSWebViewController.h"
#import "AddRedSatelliteViewController.h"

@interface AddRedSatelliteGuideViewController ()

@end

@implementation AddRedSatelliteGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    [self setTitle:@"红卫星" withFont:kTitleLabel_Font withTitleColor:kTitleLabel_Color];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    [self createUIContent];
    
}

- (void)createUIContent {

    UIImageView *lightImageView = [[UIImageView alloc] init];
    [self.view addSubview:lightImageView];
    lightImageView.image = IMAGE(@"RedSatellite_light01");
    [lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(94);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(IMAGE(@"RedSatellite_light01").size);
    }];
    
    //描述文字
    UIImageView *guideImageView = [[UIImageView alloc] init];
    [self.view addSubview:guideImageView];
    guideImageView.image = IMAGE(@"RedSatellite_Caption");
    [guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lightImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(IMAGE(@"RedSatellite_Caption").size);
    }];
    
    
    UIImageView *learnLinkImageView = [[UIImageView alloc] init];
    learnLinkImageView.userInteractionEnabled = YES;
    learnLinkImageView.image = IMAGE(@"RedSatellite_link");
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(learnLinkHandle)];
    [learnLinkImageView addGestureRecognizer:tapG];
    [self.view addSubview:learnLinkImageView];
    [learnLinkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guideImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(IMAGE(@"RedSatellite_link").size);
    }];
    
    
    
    
    //下一步 按钮
    UIButton *nextStepButton = [[UIButton alloc] init];
    nextStepButton.layer.masksToBounds = YES;
    nextStepButton.layer.cornerRadius = 5;
    [nextStepButton setTitle:@"下一步" andTitleColor:[UIColor whiteColor] andTitleFont:16];
    nextStepButton.backgroundColor = UIColorFromRGB(0xff6868);
    [nextStepButton addTarget:self action:@selector(nextStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
    [nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(learnLinkImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 40));
    }];
    
    //取消 按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [cancelButton setTitle:@"取消添加" andTitleColor:UIColorFromRGB(0x666666) andTitleFont:16];
    [cancelButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextStepButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 40));
    }];
    
}

-(void)nextStop{
    
    AddRedSatelliteViewController *addRedSatelliteVC = [[AddRedSatelliteViewController alloc] init];
    addRedSatelliteVC.roomID = self.roomID;
    [self.navigationController pushViewController:addRedSatelliteVC animated:YES];
    
    
}
-(void)clickCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)learnLinkHandle{
    
    JSWebViewController *webVC = [[JSWebViewController alloc] init];
    webVC.urlStr = @"http://v.youku.com/v_show/id_XMTQ1MTM4MjAyNA==.html";
    webVC.titleStr = @"如何添加红卫星";
    webVC.isHandleURL = NO;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma  mark - leftItemClicked
- (void)leftItemClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
