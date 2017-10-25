//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "DeviceViewController.h"
#import "UserBindModeViewController.h"
#import "UserModeViewController.h"
#import "openApiService.h"
#import <Foundation/Foundation.h>

@interface UserModeViewController ()
@end

@implementation UserModeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.m_textPhone.delegate = self;

    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];
    [self.view bringSubviewToFront:m_progressInd];

    self.m_lblHint.lineBreakMode = UIControlStateNormal;
    self.m_lblHint.numberOfLines = 0;

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* infoPath = [libraryDirectory stringByAppendingPathComponent:@"lechange/openSDK/userAccount.txt"];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    if (YES == [fileManage fileExistsAtPath:infoPath isDirectory:&isDir]) {
        NSLog(@"%@ exists,isdir[%d]", infoPath, isDir);
        NSString* content = [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:nil];
        char textPhone[255] = { 0 };
        NSLog(@"content %s", [content UTF8String]);
        sscanf([content UTF8String], "[%[^]]]%*s", textPhone);

        self.m_textPhone.text = [NSString stringWithUTF8String:textPhone];
        NSLog(@"textPhone[%@]", self.m_textPhone.text);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)onSendSms:(UIButton *)sender {
//}

- (void)saveUserInfo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"openSDK"];

    NSString* infoPath = [davDirectory stringByAppendingPathComponent:@"userAccount"];
    NSString* realPath = [infoPath stringByAppendingString:@".txt"];

    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:davDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }

    NSString* textTmp = [NSString stringWithFormat:@"[%@]", self.m_textPhone.text];
    [textTmp writeToFile:realPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)onBindUser:(id)sender
{
    [self hideHint:YES];

    if (nil == self.m_textPhone.text || 0 == self.m_textPhone.text.length || [self.m_textPhone.text isEqualToString:@"请输入您的手机号码"]) {
        self.m_lblHint.text = @"该号码为空";
        [self hideHint:NO];
        return;
    }
    [self saveUserInfo];
    [self showLoading];

    dispatch_queue_t get_userToken = dispatch_queue_create("get_userToken", nil);
    dispatch_async(get_userToken, ^{
        NSString* acessTok;
        NSString* errCode;
        NSString* errMsg;
        OpenApiService* openApi = [[OpenApiService alloc] init];
        NSInteger ret = [openApi getUserToken:@"openapi.lechange.cn" port:443 appId:@"lc20a926a947164e8b" appSecret:@"40d5ab272665474895ed5548a8bca0" phone:self.m_textPhone.text token:&acessTok errcode:&errCode errmsg:&errMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];

            if (0 == ret) {
                m_strUserTok = [acessTok mutableCopy];
                NSLog(@"userToken=%@", m_strUserTok);
                self.m_lblHint.text = @"该手机号已绑定此应用，请点击\"进入设备列表\"进行设备管理";
                [self hideHint:NO];
                return;
            }
            if (nil == errCode && nil == errMsg) {
                self.m_lblHint.text = @"网络超时，请重试";
                [self hideHint:NO];
                return;
            }
            if (![errCode isEqualToString:@"TK1004"]) {
                self.m_lblHint.text = [NSString stringWithString:errMsg];
                [self hideHint:NO];
                return;
            }

            [self textFieldShouldReturn:self.m_textPhone];
            UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            UserBindModeViewController* userBindView = [currentBoard instantiateViewControllerWithIdentifier:@"UserBindModeView"];
            [userBindView setUserInfo:@"lc20a926a947164e8b" appsecret:@"40d5ab272665474895ed5548a8bca0" svrIp:@"openapi.lechange.cn" port:443 phone:self.m_textPhone.text];
            [self.navigationController pushViewController:userBindView animated:NO];
        });
    });
}
- (void)onEnterDevice:(id)sender
{
    [self hideHint:YES];

    if (nil == self.m_textPhone.text || 0 == self.m_textPhone.text.length || [self.m_textPhone.text isEqualToString:@"请输入您的手机号码"]) {
        self.m_lblHint.text = @"该号码为空";
        [self hideHint:NO];
        return;
    }
    [self saveUserInfo];
    [self showLoading];
    dispatch_queue_t enter_device = dispatch_queue_create("enter_device", nil);
    dispatch_async(enter_device, ^{
        NSString* acessTok;
        NSString* errCode;
        NSString* errMsg;
        OpenApiService* openApi = [[OpenApiService alloc] init];
        NSInteger ret = [openApi getUserToken:@"openapi.lechange.cn" port:443 appId:@"lc20a926a947164e8b" appSecret:@"40d5ab272665474895ed5548a8bca0" phone:self.m_textPhone.text token:&acessTok errcode:&errCode errmsg:&errMsg];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (ret < 0) {
                if (![errCode isEqualToString:@"TK1004"]) {
                    self.m_lblHint.text = @"当前手机号未与您的应用绑定，请点击\"用户绑定\"按扭进行用户绑定操作。";
                    [self hideHint:NO];
                    return;
                }
                if (nil != errMsg) {
                    self.m_lblHint.text = [errMsg mutableCopy];
                    [self hideHint:NO];
                    return;
                }
            }
            else {
                m_strUserTok = [acessTok mutableCopy];
                NSLog(@"userToken=%@", m_strUserTok);
                [self hideHint:YES];
            }
            UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            DeviceViewController* devView = [currentBoard instantiateViewControllerWithIdentifier:@"deviceViewController"];
            ;
            [self.navigationController pushViewController:devView animated:NO];

            [devView setAdminInfo:m_strUserTok address:@"openapi.lechange.cn" port:443 appId:@"lc20a926a947164e8b" appSecret:@"40d5ab272665474895ed5548a8bca0"];
        });

    });
}
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    [self hideHint:YES];
    self.m_textPhone.textColor = [UIColor blackColor];
    self.m_textPhone.text = @"";

    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideHint:(BOOL)bFlag
{
    self.m_lblHint.hidden = bFlag;
//    self.m_imgRemind.hidden = bFlag;
}
- (void)updateText:(NSString*)text
{
    self.m_textPhone.textColor = [UIColor blackColor];
    self.m_textPhone.text = text;
}

- (void)setAppIdAndSecret:(NSString*)appId appSecret:(NSString*)appSecret svr:(NSString*)svr port:(NSInteger)port
{
    m_strAppId = [NSString stringWithString:appId];
    m_strAppSecret = [NSString stringWithString:appSecret];
    m_strSrv = [NSString stringWithString:svr];
    m_iPort = port;
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
