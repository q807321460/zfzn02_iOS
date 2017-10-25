//
//  CustomFreePaymentsView.h
//  Smart360
//
//  Created by sun on 15/8/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Change)

+ (id)firstDateFormatterWithDate:(NSDate *)date;
+ (id)secondDateFormatterWithDate:(NSDate *)date;
+ (NSString *)dataStrForAliPayWithData:(NSDate *)date;
+ (NSString *)dataStrForWeiXinPayWithData:(NSDate *)date;
+ (id)firstFtpFileDateFormatterWithDate:(NSDate *)date;
+ (id)secondFtpFileDateFormatterWithDate:(NSDate *)date;
//是否是同一天
- (BOOL)isToday;

//是否是同一天的同一分钟
- (BOOL)isMintute:(NSDate *)anotherDate;

@end
