//
//  SmartConfigNotifyMessage.h
//
//
//  Created by JzProl.m.Qiezi on 2017/4/5.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 UDP 广播 返回的消息
 */
@interface SmartConfigNotifyMessage : NSObject


/**
 设备IP地址
 */
@property(nonatomic,retain) NSString* ip;

/**
 设备端口
 */
@property(nonatomic,retain) NSString* port;

/**
 设备HOTS名称
 */
@property(nonatomic,retain) NSString* hostName;

/**
 设备MAC地址
 */
@property(nonatomic,retain) NSString* mac;


/**
 创建一个UDP通知消息

 @param ip 设备IP地址
 @param port 设备端口
 @param hostName 设备HOST名称
 @param mac 设备MAC地址
 @return 返回UDP通知消息
 */
- (instancetype)initWithIp:(NSString*)ip port:(NSString*)port host:(NSString*)hostName mac:(NSString*)mac;

/**
 通过一个字典创建一个UDP通知消息
 字典Key参见 SmartConfigConstant.h

 @param dic 设置字典
 @return 返回UDP通知消息
 */
+ (instancetype)messageWithDictionary:(NSDictionary*)dic;


@end
