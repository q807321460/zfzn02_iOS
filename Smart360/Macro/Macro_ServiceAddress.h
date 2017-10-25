//
//  Macro_ServiceAddress.h
//  Smart360
//
//  Created by nimo on 15/10/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_ServiceAddress_h
#define Smart360_Macro_ServiceAddress_h

////定义是否测试环境
//
//#define Smart360_Test 1        //1：测试环境； 0：正式环境
//#define Smart360_Contain_Ass 0  //1: 包含设备助手端； 0：不包含设备助手端
//
//
//#if Smart360_Test
///********************************测试环境****************************************/
////网络请求基址
////#define BASE_URL @"http://192.168.19.205:8080/smart"
//#define BASE_URL @"http://192.168.20.18:8026/smart"
////XMPP服务器地址
//#define XMPP_HOST_NAME @"192.168.20.212"
//#define XMPP_SERVER_PORT 8222
//
////微信支付的异步通知地址
//#define WeiXin_SP_URL  @"http://116.228.90.94:8080/PaySystem/wxpay/callback"
////支付宝的异步通知地址
//#define Alipay_App_Url @"http://116.228.90.94:8080/PaySystem/pay/callback"
//
////ftp地址
//#define FtpServer @"ftp://file.360iii.net"
//#define FtpAccount @"smart360"
//#define FtpPassword @"pVLLeyGI"
//#define FtpDownloadBasePath @"http://file.360iii.net/smart360"
//
////助手端
//#define Assistant_Server_url @"http://192.168.20.89:8080"
//
//
//#else
///********************************正式环境****************************************/
////网络请求基址
//#define BASE_URL @"http://smart.smallzhi.com/smart"
//
////XMPP服务器地址
//#define XMPP_HOST_NAME @"msg.360iii.com"
//#define XMPP_SERVER_PORT 5222
//
////微信支付的异步通知地址
//#define WeiXin_SP_URL  @"http://yyy.smallzhi.com:8081/PaySystem/wxpay/callback"
////支付宝的异步通知地址
//#define Alipay_App_Url @"http://yyy.smallzhi.com:8081/PaySystem/pay/callback"
//
////ftp地址
//#define FtpServer @"ftp://file.360iii.com"
//#define FtpAccount @"smart360up"
//#define FtpPassword @"smartMiVh"
//#define FtpDownloadBasePath @"http://file.360iii.com/smart360"
//
////助手端
//#define Assistant_Server_url @"http://box.360iii.com:8680"
//
//#endif

#endif
