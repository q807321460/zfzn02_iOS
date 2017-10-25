//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "UserBindModeViewController.h"
#import "openApiService.h"
#import <Foundation/Foundation.h>
#import "zfzn2-Swift.h"

typedef enum {
    DARK_BIND_BTN = 0,
    BRIGHT_BIND_BTN = 1
} BindBtnColor;

@interface UserBindModeViewController ()
@end

@implementation UserBindModeViewController
//@synthesize m_btnChangeColor, m_btnOldColor;
- (void)viewDidLoad
{
    [super viewDidLoad];

    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];

    self.m_btnSms.layer.cornerRadius = 5.0;
    self.m_btnSms.layer.masksToBounds = true;
    self.m_btnBind.layer.cornerRadius = 5.0;
    self.m_btnBind.layer.masksToBounds = true;
    
//    let m_colorFont = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)//主页label使用的颜色
//    let m_colorPurple = UIColor(red: 139/255, green: 39/255, blue: 114/255, alpha: 1)//紫色，整个app的主色调
    self.m_btnOldColor = [UIColor colorWithRed:139 / 255 green:39 / 255 blue:114 / 255 alpha:1];
//    self.m_btnChangeColor = [UIColor colorWithRed:128 / 255 green:128 / 255 blue:128 / 255 alpha:1];
    self.m_lblHint.lineBreakMode = UIControlStateNormal;
    self.m_lblHint.numberOfLines = 0;

//    [self setBindButtonColor:DARK_BIND_BTN];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBindButtonColor:(BindBtnColor)color
{
//    switch (color) {
//    case DARK_BIND_BTN:
//        [self.m_btnBind setBackgroundColor:[UIColor colorWithRed:138.0 / 255 green:185.0 / 255 blue:225.0 / 255 alpha:1]];
//        [self.m_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        break;
//    case BRIGHT_BIND_BTN:
//        [self.m_btnBind setBackgroundColor:[UIColor colorWithRed:78.0 / 255 green:167.0 / 255 blue:242.0 / 255 alpha:1]];
//        break;
//    default:
//        break;
//    }
}

- (void)setUserInfo:(NSString*)appId appsecret:(NSString*)appSecret svrIp:(NSString*)ip port:(NSInteger)port phone:(NSString*)phoneNum
{
//    m_strAppId = [NSString stringWithString:appId];
//    m_strAppSecret = [NSString stringWithString:appSecret];
//
//    m_strSrv = [NSString stringWithString:ip];
//    m_iPort = port;
//    m_strPhone = [NSString stringWithString:phoneNum];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSmsTimer:(id)sender
{
    m_interval--;
    NSLog(@"onSmsTimer-----[%ld]", (long)m_interval);
    [self.m_btnSms setTitle:[NSString stringWithFormat:@"%ld", (long)m_interval] forState:UIControlStateNormal];
    [self.m_btnSms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (0 >= m_interval) {
        [m_timer invalidate];
        m_interval = 60;
        [self.m_btnSms setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [self.m_btnSms setTitleColor:self.m_btnOldColor forState:UIControlStateNormal];
        self.m_btnSms.enabled = YES;
    }
}
- (void)onBindUser:(id)sender
{
    [self showLoading];
    dispatch_queue_t bind_user = dispatch_queue_create("bind_user", nil);
    dispatch_async(bind_user, ^{
        NSString* errMsg;
        DataControl *gDC = [DataControl sharedInstance];
        NSInteger iret = [[[OpenApiService alloc] init] userBind:@"openapi.lechange.cn" port:443 appId:gDC.m_sLechangeID appSecret:gDC.m_sLechangeSecret phone:gDC.mAccountInfo.m_sAccountCode smscode:self.m_textSms.text errmsg:&errMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (iret < 0) {
                if (nil != errMsg) {
                    self.m_lblHint.text = [NSString stringWithFormat:@"绑定失败[%@]", errMsg];
                }
                else {
                    self.m_lblHint.text = @"绑定超时，请重试";
                    self.m_lblHint.lineBreakMode = UIControlStateNormal;
                    self.m_lblHint.numberOfLines = 0;
                }
                return;
            }
            else {
                self.m_lblHint.text = @"绑定成功";
//                [UIDevice GetLechangeToken:gDC.mAccountInfo.m_sAccountCode];
//                [self.navigationController popViewControllerAnimated:NO];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    });
}
- (void)onSendSms:(id)sender
{
    NSString* errCode;
    NSString* errMsg;
    DataControl *gDC = [DataControl sharedInstance];
    NSInteger iret = [[[OpenApiService alloc] init] userBindSms:@"openapi.lechange.cn" port:443 appId:gDC.m_sLechangeID appSecret:gDC.m_sLechangeSecret phone:gDC.mAccountInfo.m_sAccountCode errcode:&errCode errmsg:&errMsg];
    if (iret < 0) {
        if (nil == errCode || 0 == errCode.length) {
            self.m_lblHint.text = @"发送验证码失败";
        }
        else {
            self.m_lblHint.text = [NSString stringWithString:errMsg];
        }
        return;
    }

    self.m_lblHint.text = [NSString stringWithFormat:@"验证码短信已发送至手机%@", gDC.mAccountInfo.m_sAccountCode];

    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onSmsTimer:) userInfo:self repeats:YES];
    m_interval = 60;
    self.m_btnSms.enabled = NO;
}

// 显示滚动轮指示器
- (void)showLoading
{
    [m_progressInd startAnimating];
}

// 消除滚动轮指示器
- (void)hideLoading
{
    if ([m_progressInd isAnimating]) {
        [m_progressInd stopAnimating];
    }
}
@end
