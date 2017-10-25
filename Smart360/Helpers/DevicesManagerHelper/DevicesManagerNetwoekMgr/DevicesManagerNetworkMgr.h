//
//  DevicesManagerNetworkMgr.h
//  Smart360
//
//  Created by michael on 15/10/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DevicesManagerNetworkMgr : NSObject


+ (kResult)createSBEngine;

/**
 * @brief   Destroy smart box engine
 * @param   account
 * @return  error code
 */
+ (kResult)destroySBEngine;

/**
 * @brief   update box info
 * @param   void
 * @return  error code
 */



+ (kResult)getBoxList;

+ (kResult)bindBoxWithUserId:(NSString *)pcUserId SN:(NSString *)pcSn;

+ (kResult)unBindBoxWithUserId:(NSString *)pcUserId SN:(NSString *)pcSn;


+ (kResult)assistantOnline;


+ (kResult)assistantOffline;

+ (kResult)setDeviceParamWithSN:(NSString *)sn nickName:(NSString *)nickName isBlueToothEnable:(long)isBlueToothEnable wakeupName:(NSString *)wakeupName environment:(NSString *)environment;


+ (kResult)getDeviceVersionInfo:(NSString *)sn;


+ (kResult)updateDeviceVersion:(NSString *)sn;

+ (kResult)getDeviceWifiInfo:(NSString *)sn;
+ (kResult)setDefaultBox:(NSString *)boxSN;

+ (kResult)setDeviceWifi:(NSString *)sn ssid:(NSString *)ssid password:(NSString *)password cryptoType:(NSString *)cryptoType;

+ (kResult)receiveXMPPMsg:(NSString *)msg;

+ (kResult)wifiStatusChange:(BOOL)isWiFi;

+ (kResult)getMemosWithSN:(NSString *)boxSN;

+ (kResult)updateMemoWithSN:(NSString *)boxSN memoAray:(NSArray *)memoArray;
+ (kResult)deleteMemoWithSN:(NSString *)boxSN memoAray:(NSArray *)memoArray;

//得到加密后的SN
+ (NSString *)getEncryptSN:(NSString *)orignSN;

//得到解密后的SN
+ (NSString *)getDecryptSN:(NSString *)encryptSN;

/*
回调没数据
case EVENT_BOXINFO_BIND:
case EVENT_BOXINFO_UNBIND:
case EVENT_BOXINFO_ASSISTANTONLIEN:
case EVENT_BOXINFO_ASSISTANTOFFLIEN:
case EVENT_BOXINFO_SETPARAM:
case EVENT_BOXINFO_UPDATEVERSION:
case EVENT_BOXINFO_SETDEFAULTBOX:
case EVENT_BOXINFO_SETDEVICEWLAN:

*/


//设置音箱参数
#pragma mark - 设置音箱参数
+ (void)setDeviceParamWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;


//获取备忘
+ (void)fetchMemosWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

+ (void)updateMemosWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

@end
