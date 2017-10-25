//
//  JSConfigureApp.h
//  Smart360
//
//  Created by sun on 15/11/23.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern  BOOL Smart360_Test;

//网络请求基址
extern  NSString *BASE_URL;
//XMPP服务器地址
extern  NSString *XMPP_HOST_NAME;
extern  NSInteger XMPP_SERVER_PORT;
//微信支付的异步通知地址
extern  NSString *WeiXin_SP_URL;
//支付宝的异步通知地址
extern  NSString *Alipay_App_Url;
//ftp地址
extern  NSString *FtpServer;
extern  NSString *FtpAccount;
extern  NSString *FtpPassword;
extern  NSString *FtpDownloadBasePath;
//助手端
extern  NSString *Assistant_Server_url;
extern  BOOL isContainAssistant;
extern  BOOL isTest;
//插排设备开关
#define enable_plug_dev 1

@interface JSConfigureApp : NSObject

+ (void)configureApp;
    
@end
