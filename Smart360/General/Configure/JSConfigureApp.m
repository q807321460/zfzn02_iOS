//
//  JSConfigureApp.m
//  Smart360
//
//  Created by sun on 15/11/23.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSConfigureApp.h"

BOOL Smart360_Test;
//网络请求基址
NSString *BASE_URL;
//XMPP服务器地址
NSString *XMPP_HOST_NAME;
NSInteger XMPP_SERVER_PORT;
//微信支付的异步通知地址
NSString *WeiXin_SP_URL;
//支付宝的异步通知地址
NSString *Alipay_App_Url;
//ftp地址
NSString *FtpServer;
NSString *FtpAccount;
NSString *FtpPassword;
NSString *FtpDownloadBasePath;
//助手端
NSString *Assistant_Server_url;
BOOL isContainAssistant;
BOOL isTest;

@implementation JSConfigureApp

+ (void)configureApp {
    Smart360_Test = [[NSUserDefaults standardUserDefaults] boolForKey:@"LAN"];

    if (Smart360_Test) {
    /********************************测试环境****************************************/
        BASE_URL = @"http://192.168.20.18:8026/smart";
//        BASE_URL = @"http://192.168.16.55:8080";
        XMPP_HOST_NAME = @"192.168.20.212";
        XMPP_SERVER_PORT = 8222;
        
        WeiXin_SP_URL = @"http://116.228.90.94:8080/PaySystem/wxpay/callback";
        Alipay_App_Url = @"http://116.228.90.94:8080/PaySystem/pay/callback";
        
        FtpServer = @"ftp://file.360iii.net";
        FtpAccount = @"smart360";
        FtpPassword = @"pVLLeyGI";
        FtpDownloadBasePath = @"http://file.360iii.net/smart360";
        
        Assistant_Server_url = @"http://192.168.16.9:8180";////louis服务器

    
    } else {
        /********************************正式环境****************************************/
        BASE_URL = @"http://smart.smallzhi.com/smart";
//        XMPP_HOST_NAME  = @"msg.360iii.com";
//        XMPP_SERVER_PORT = 5222;
        XMPP_HOST_NAME  = @"cluster.msg.360iii.com";
        XMPP_SERVER_PORT = 8222;

        
        WeiXin_SP_URL  = @"http://pay.smallzhi.com:8081/PaySystem/wxpay/callback";
        Alipay_App_Url = @"http://pay.smallzhi.com:8081/PaySystem/pay/callback";
        
        FtpServer = @"ftp://file.360iii.com";
        FtpAccount = @"smart360up";
        FtpPassword = @"smartMiVh";
        FtpDownloadBasePath = @"http://file.360iii.com/smart360";
        //测试
        //Assistant_Server_url = @"http://192.168.16.17:8180";
        Assistant_Server_url = @"http://box.360iii.com:8680";
    }
    
    isContainAssistant = [[NSUserDefaults standardUserDefaults] boolForKey:@"containAssistant"];
}

@end
