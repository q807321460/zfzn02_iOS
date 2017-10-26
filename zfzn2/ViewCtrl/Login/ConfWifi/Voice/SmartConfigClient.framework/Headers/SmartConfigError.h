//
//  SmartConfigError.h
//  SmartConfigClient
//
//  Created by JzProl.m.Qiezi on 2017/4/18.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 SmartConfig客户端错误码
 */
@interface SmartConfigError : NSObject


/**
 根据错误码获取错误描述

 @param errorCode 错误码
 @return 错误描述
 */
+(NSString*)errorDescription:(int)errorCode;

@end
