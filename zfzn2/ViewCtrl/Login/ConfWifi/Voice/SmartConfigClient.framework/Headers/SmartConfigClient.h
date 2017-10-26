//
//  SmartConfigClient.h
//  SmartConfigClient
//
//  Created by JzProl.m.Qiezi on 2017/4/5.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SmartConfigReciverDelegate;


/**
 SmartConfig 客户端主接口
 提供评估板发送、接收消息功能
 */
@interface SmartConfigClient : NSObject


/**
 发送配置信息

 @param ssid wifi ssid
 @param password wifi password
 @param ip device ip of this wifi
 @return 发送结果
 */
+(int)sendWithSSID:(NSString*)ssid password:(NSString*)password ip:(UInt32)ip;



/**
 发送配置信息

 @param ssid ssid wifi ssid
 @param password wifi password
 @param ip device ip of this wifi
 @param port device port of this wifi
 @return 发送结果
 */
+(int)sendWithSSID:(NSString*)ssid password:(NSString*)password ip:(UInt32)ip port:(UInt32)port;



/**
 开启接收UDP广播

 @param delegate 回调委托
 */
+(void)startReciver:(id<SmartConfigReciverDelegate>)delegate;



/**
 关闭接收UDP广播
 */
+(void)stopReciver;


/**
 设置接收UDP广播超时时间

 @param timeout 超时时间 S
 */
+(void)setRecvTimeout:(UInt32)timeout;


/**
 获取SDK版本号
 
 @return 版本号信息
 */
+(NSString*)version;


/**
 设置日志调试模式
 
 @param isEnable 是否启用
 */
+(void)enableDebugMode:(BOOL)isEnable;

@end
