//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#import "AddDeviceViewController.h"
#import "LCOpenSDK_ConfigWifi.h"
#import "RestApiService.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "zfzn2-Swift.h"


@interface AddDeviceViewController () {
    LCOpenSDK_ConfigWIfi* m_configWifi;
    id info;
}
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.m_lblHint.layer.masksToBounds = YES;
    self.m_lblHint.lineBreakMode = UIControlStateNormal;
    self.m_lblHint.numberOfLines = 0;

    CFArrayRef __nullable interface = CNCopySupportedInterfaces();
    for (NSString* interf in (__bridge id)interface) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interf));
        if (info && [info count]) {
            break;
        }
    }
    CFRelease(interface);
    NSString* sID = @"SSID:";
    if (nil == info[@"SSID"] || 0 == [info[@"SSID"] length]) {
        return;
    }
    self.m_lblSsid.text = [sID stringByAppendingString:info[@"SSID"]];

    m_configWifi = [[LCOpenSDK_ConfigWIfi alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TouchDown:(UIControl *)sender {
//    self.view.endEditing(true)
    [[self view] endEditing:YES];
}

- (IBAction)onBack:(id)sender
{
//    if (HasChanged == deviceListState) {
//        [(DeviceViewController*)devView refreshDevList];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token areaFoot:(NSInteger)areaFoot
{
//    m_hc = hc;
    m_nAreaListFoot = areaFoot;
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    self->m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    m_strAccessToken = [NSString stringWithString:token];
//    devView = view;
    RestApiService* restApiService = [RestApiService shareMyInstance];
    if (nil != self->m_hc) {
        [restApiService initComponent:self->m_hc Token:m_strAccessToken];
    }
}

- (IBAction)onWifi:(id)sender
{
    if (nil == self.m_textSerial.text || 0 == self.m_textSerial.text.length || [self.m_textSerial.text isEqualToString:@"请输入设备序列号"]) {
        self.m_lblHint.text = @"请输入设备序列号";
        return;
    }
    if (nil == self.m_textName.text || 0 == self.m_textName.text.length) {
        self.m_lblHint.text = @"请输入设备名称";
        return;
    }
    if (nil == self.m_textPasswd.text || 0 == self.m_textPasswd.text.length || [self.m_textPasswd.text isEqualToString:@"请输入WiFi密码"]) {
        self.m_textPasswd.text = @"";
    }
    RestApiService* restApiService = [RestApiService shareMyInstance];
    if ([restApiService checkDeviceBindOrNot:self.m_textSerial.text]) {
        self.m_lblHint.text = @"设备已被绑定";
        return;
    }
    
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"hint" message:@"请根据说明书开启设备配对键" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];

    self.m_lblHint.text = @"开始无线配网，该过程可能较慢，请耐心等待";

    NSLog(@"[%@][%@][%@]", self.m_textSerial.text, info[@"SSID"], self.m_textPasswd.text);
    NSInteger iRet = [m_configWifi configWifiStart:self.m_textSerial.text
                                              ssid:info[@"SSID"]
                                          password:self.m_textPasswd.text
                                            secure:@""
                                          callback:^(LC_ConfigWifi_Event event, void* userData) {
                                              printf("smartconfig result[%ld]\n", (long)event);
                                              AddDeviceViewController* pCont = (__bridge AddDeviceViewController*)userData;
                                              [pCont notify:event];
                                          }
                                          userData:self
                                           timeout:8];//konnn
    if (iRet < 0) {
        NSLog(@"smartconfig failed\n");
        return;
    }
}

- (void)notify:(NSInteger)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RestApiService* restApiService = [RestApiService shareMyInstance];
        if (LC_ConfigWifi_Event_Success == event) {
            //配网成功后，等待设备上线，超时时间...秒。
            time_t lBegin, lCur;
            NSInteger lLeftTime = 8;//konnn
            time(&lBegin);
            lCur = lBegin;
            BOOL bOnline = NO;
            self.m_lblHint.text = @"准备绑定";

            [m_configWifi configWifiStop];
            if ([restApiService checkDeviceBindOrNot:self.m_textSerial.text]) {
                self.m_lblHint.text = @"设备已被绑定";
                return;
            }
            while (lCur >= lBegin && lCur - lBegin < lLeftTime) {
                if (![restApiService checkDeviceOnline:self.m_textSerial.text]) {
                    self.m_lblHint.text = [NSString stringWithFormat:@"等待时间%ld秒", lCur - lBegin];
                    usleep(5 * 1000 * 1000);
                    time(&lCur);
                    continue;
                }
                bOnline = YES;
                break;
            }
            if (NO == bOnline) {
                self.m_lblHint.text = @"设备未上线";
                return;
            }
            NSString* destOut;
            bool bRet = [restApiService bindDevice:self.m_textSerial.text Desc:&destOut];
            if (true == bRet) {
                //这里需要用到电器添加的部分代码，将添加过的摄像头保存在本地和远程的数据库中，但是不能在该线程中调用，需要再设置一个定时器
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(OnTimer) userInfo:nil repeats:false];
            }
            else {
                self.m_lblHint.text = destOut;
            }
        }
        else {
            [m_configWifi configWifiStop];
            if (LC_ConfigWifi_Event_Timeout == event) {
                //超时后再检测一次是否上线，若上线则绑定
                if (true == [restApiService checkDeviceOnline:self.m_textSerial.text]) {
                    NSString* destOut;
                    bool bRet = [restApiService bindDevice:self.m_textSerial.text Desc:&destOut];
                    if (true == bRet) {
                        //这里需要用到电器添加的部分代码，将添加过的摄像头保存在本地和远程的数据库中
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(OnTimer) userInfo:nil repeats:false];
                    }
                    else {
                        self.m_lblHint.text = destOut;
                    }
                }
                else {
                    self.m_lblHint.text = @"配网超时";
                }
            }else {
//                self.m_lblHint.text = @"未知的错误";
            }
        }
    });
}

////////////////////////////////////////////////////////////////////////////////////
-(void)OnTimer
{
//    NSLog(@"测试");
    DataControl *gDC = [DataControl sharedInstance];
    gDC.m_sCameraID = _m_textSerial.text;
    NSString *sRe = [gDC.mElectricData AddElectricToWeb:gDC.mUserInfo.m_sMasterCode areaFoot:self->m_nAreaListFoot electricCode:gDC.m_sCameraToken electricName:self.m_textName.text electricType:8 extra:gDC.mAccountInfo.m_sAccountCode];
    if ([sRe  isEqual: @"WebError"]) {
        self.m_lblHint.text = @"网络错误";
    }else if ([sRe  isEqual: @"1"]){
        self.m_lblHint.text = @"绑定成功";
        gDC.m_bRefreshAreaList = YES;
    }else {
        self.m_lblHint.text = @"向兆峰服务器添加失败";
    }
}


@end
