//
//  CustomFreePaymentsView.h
//  Smart360
//
//  Created by sun on 15/8/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "NSDate+Change.h"

@implementation NSDate (Change)



+ (id)firstDateFormatterWithDate:(NSDate *)date
{
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    //创建日期格式化对象
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];

}


+ (id)secondDateFormatterWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    //创建日期格式化对象
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"yyyy-MM-dd H:mm"];
    //    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];
    
}

+ (NSString *)dataStrForAliPayWithData:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    //创建日期格式化对象2014-06-13 16:00:00
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];
    
}

+ (NSString *)dataStrForWeiXinPayWithData:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    //创建日期格式化对象
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    //    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];
    
}



+ (id)firstFtpFileDateFormatterWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    //创建日期格式化对象
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"yyyyMMdd"];
    //    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];
    
}


+ (id)secondFtpFileDateFormatterWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    //创建日期格式化对象
    //设置日期格式(一定要和日期格式串中的日期格式保持一致)
    [formatter setDateFormat:@"ddHmmss"];
    //    //将格式串转换为日期对象
    //NSDate *date = [formatter dateFromString:dateString];
    return [formatter stringFromDate:date];
    
}


- (BOOL)isSameDay:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

- (BOOL)isMintute:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay
                                                          | NSCalendarUnitHour
                                                          | NSCalendarUnitMinute)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay
                                                          | NSCalendarUnitHour
                                                          | NSCalendarUnitMinute)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]
            && [components1 hour] == [components2 hour]
            && [components1 minute] == [components2 minute]
            );
}

- (BOOL)isToday {
    return [self isSameDay:[NSDate date]];
}



















@end
