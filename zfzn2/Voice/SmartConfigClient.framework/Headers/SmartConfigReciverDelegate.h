//
//  SmartConfigReciverDelegate.h
//
//
//  Created by JzProl.m.Qiezi on 2017/4/5.
//  Copyright © 2017年 iflytek. All rights reserved.
//


#ifndef SmartConfigReciverDelegate_h
#define SmartConfigReciverDelegate_h


@class SmartConfigNotifyMessage;


/**
 UDP消息回调
 */
@protocol SmartConfigReciverDelegate <NSObject>


/**
 收到消息回调

 @param message 消息
 */
-(void)onReceived:(SmartConfigNotifyMessage*) message;


/**
 超时回调
 */
-(void)onTimeout;


/**
 错误回调

 @param errorCode 错误码
 */
-(void)onError:(int)errorCode;

@end

#endif /* SmartConfigReciverDelegate_h */
