//
//  JSDateHelper.m
//  Smart360
//
//  Created by michael on 16/4/5.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "JSDateHelper.h"

@implementation JSDateHelper

/*
 
2016,03,29,18,59,00,Tue,0*1  ->  2016年3月29日 18:59:00 + Event
*,*,*,10,00,00,*,0*1  ->  每天 10:00:00 + Event
*,*,01,10,00,00,*,0*1  ->  每月1日 10:00:00 + Event
*,*,01|03,10,00,00,*,0*1  ->  每月1日、3日 10:00:00 + Event
*,*,01-03,10,00,00,*,0*1  ->  每月1日到3日 10:00:00 + Event
*,01,01,10,00,00,*,0*1  ->  每年1月1日 10:00:00 + Event
*,01|03,01,10,00,00,*,0*1  ->  每年1月1日、3月1日 10:00:00 + Event
*,01-03,01,10,00,00,*,0*1  ->  每年1月到3月1日 10:00:00 + Event
2016,*,01,10,00,00,*,0*1  ->  2016年每月1日 10:00:00 + Event
2016|2017,*,01,10,00,00,*,0*1  ->  2016年、2017年每月1日 10:00:00 + Event
2016-2018,*,01,10,00,00,*,0*1  ->  2016年到2018年每月1日 10:00:00 + Event
*,*,*,10|13,00,00,*,0*1  ->  每天 10:00:00、13:00,00+ Event
*,*,*,10-13,00,00,*,0*1  ->  每天 10:00:00、11:00:00、12:00:00、13:00:00+ Event
*,*,*,10,00,00,Mon,0*1  ->  周一 10:00:00 + Event
*,*,*,10,00,00,Mon|Fri,0*1  ->  周一、周五 10:00:00 + Event
*,*,*,10,00,00,Mon-Fri,0*1  ->  周一到周五 10:00:00 + Event
*,*,*,06,00,00,Mon-Fri,300*3  ->  周一到周五 06:00:00起每隔5分钟1次，共3次

 */
/*
0 年
1 月
2 日
3 时
4 分
5 秒
6 周
7 间隔
*/

+(NSString *)getMemoString:(NSString *)dateString{
    JSDebug(@"", @"memo date string :%@",dateString);
    NSString * yearStr;
    
    NSString * headStr; //年月日周
    NSString * behindStr; //时分秒间隔
    
    NSArray * dateArray = [dateString componentsSeparatedByString:@","];
    
    if ([dateArray[0] isEqualToString:@"*"]) {
        //年 *
        if ([dateArray[1] isEqualToString:@"*"]) {
            //月 *
            if ([dateArray[2] isEqualToString:@"*"]) {
                //日 *
                if ([dateArray[6] isEqualToString:@"*"]) {
                    //周 *
                    headStr = @"每天";
                }else{
                    //周 有
                    headStr = [self weekChange:dateArray[6]];
                }
                
            }else{
                //日 有 周随便
                headStr = [@"每月" stringByAppendingString:[self singleYearMonDayChange:dateArray[2] unit:@"日"]];
            }
            
        }else{
            //月 有
            if ([dateArray[2] isEqualToString:@"*"]) {
                //日 *
                if ([dateArray[6] isEqualToString:@"*"]) {
                    //周 *
                    headStr = [@"每年" stringByAppendingFormat:@"%@每天",[self singleYearMonDayChange:dateArray[1] unit:@"月"]];
                }else{
                    //周 有
                    headStr = [@"每年" stringByAppendingFormat:@"%@%@",[self singleYearMonDayChange:dateArray[1] unit:@"月"],[self weekChange:dateArray[6]]];
                }
                
            }else{
                //日 有 周随便
                headStr = [@"每年" stringByAppendingFormat:@"%@%@",[self singleYearMonDayChange:dateArray[1] unit:@"月"],[self singleYearMonDayChange:dateArray[2] unit:@"日"]];
            }
            
        }
        
    }else{
        //年 有
        yearStr = [self singleYearMonDayChange:dateArray[0] unit:@"年"];
        
        if ([dateArray[1] isEqualToString:@"*"]) {
            //月 *
            if ([dateArray[2] isEqualToString:@"*"]) {
                //日 *
                if ([dateArray[6] isEqualToString:@"*"]) {
                    //周 *
                    headStr = [yearStr stringByAppendingString:@"每天"];
                }else{
                    //周 有
                    headStr = [yearStr stringByAppendingString:[self weekChange:dateArray[6]]];
                }
                
            }else{
                //日 有 周随便
                headStr = [yearStr stringByAppendingFormat:@"每月%@",[self singleYearMonDayChange:dateArray[2] unit:@"日"]];
            }

            
        }else{
            //月 有
            if ([dateArray[2] isEqualToString:@"*"]) {
                //日 *
                if ([dateArray[6] isEqualToString:@"*"]) {
                    //周 *
                    headStr = [yearStr stringByAppendingFormat:@"%@每天",[self singleYearMonDayChange:dateArray[1] unit:@"月"]];
                }else{
                    //周 有
                    headStr = [yearStr stringByAppendingFormat:@"%@%@",[self singleYearMonDayChange:dateArray[1] unit:@"月"],[self weekChange:dateArray[6]]];
                }
                
            }else{
                //日 有 周随便
                headStr = [yearStr stringByAppendingFormat:@"%@%@",[self singleYearMonDayChange:dateArray[1] unit:@"月"],[self singleYearMonDayChange:dateArray[2] unit:@"日"]];
            }
            
        }
        
    }
    
    behindStr = [self getBehindStrWithHour:dateArray[3] minute:dateArray[4] second:dateArray[5] intervalStr:dateArray[7]];
    
    return [NSString stringWithFormat:@"%@ %@",headStr,behindStr];
}

// behindStr 时分秒间隔
+(NSString *)getBehindStrWithHour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second intervalStr:(NSString *)intervalStr{
    
    NSString * hmsStr = [self getHourMinuteSecondWithHour:hour minute:minute second:second];
    NSString *intervalTempStr = [self getIntervalStr:intervalStr];
    return [NSString stringWithFormat:@"%@%@",hmsStr,intervalTempStr];
}

// 10,00,00 --> 10:00:00 不支持时分都含-|的情况
+(NSString *)getHourMinuteSecondWithHour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second{
    
    if (NSNotFound != [hour rangeOfString:@"-"].location) {
        // hour 包含 -
        NSArray *array = [hour componentsSeparatedByString:@"-"];
        //第一个时间点
        NSMutableString *resStr = [NSMutableString stringWithFormat:@"%@:%@:%@",array[0],[minute substringToIndex:2],[second substringToIndex:2]];
        
        for (int i = ( [array[0] intValue] +1 ) ; i <= [array[1] intValue]; i++) {
            resStr = [NSMutableString stringWithFormat:@"%@、%d:%@:%@",resStr,i,[minute substringToIndex:2],[second substringToIndex:2]];
        }
        
        return resStr;
    }else if (NSNotFound != [hour rangeOfString:@"|"].location){
        // hour 包含 |
        NSArray *array = [hour componentsSeparatedByString:@"|"];
        return [NSString stringWithFormat:@"%@:%@:%@、%@:%@:%@",array[0],[minute substringToIndex:2],[second substringToIndex:2],array[1],[minute substringToIndex:2],[second substringToIndex:2]];
    }else{
        //hour纯数字
        
        if (NSNotFound != [minute rangeOfString:@"|"].location){
            // minute 包含 |
            NSArray *array = [minute componentsSeparatedByString:@"|"];
            return [NSString stringWithFormat:@"%@:%@:%@、%@:%@:%@",hour,array[0],[second substringToIndex:2],hour,array[1],[second substringToIndex:2]];
        }else{
            // minute 包含 - 或纯数字
            return [NSString stringWithFormat:@"%@:%@:%@",hour,[minute substringToIndex:2],[second substringToIndex:2]];

        }
        
    }
    
    
}


// 单个 年 月 日
+(NSString *)singleYearMonDayChange:(NSString *)date unit:(NSString *)unit{
    
    if ([date isEqualToString:@"*"]) {
        return [@"每" stringByAppendingString:unit];
    }else{
        if (NSNotFound != [date rangeOfString:@"-"].location) {
            //包含 -
            return [[date stringByReplacingOccurrencesOfString:@"-" withString:[unit stringByAppendingString:@"到"]] stringByAppendingString:unit];
        }else if (NSNotFound != [date rangeOfString:@"|"].location){
            //包含 |
            return [[date stringByReplacingOccurrencesOfString:@"|" withString:[unit stringByAppendingString:@"、"]] stringByAppendingString:unit];
        }else{
            //纯数字
            return [date stringByAppendingString:unit];
        }
    }
}

//周
+(NSString *)weekChange:(NSString *)date{
    if ([date isEqualToString:@"*"]) {
        return @"";
    }else{
        
        NSDictionary *dict =@{@"MON":@"周一",@"TUE":@"周二",@"WED":@"周三",@"THU":@"周四",@"FRI":@"周五",@"SAT":@"周六",@"SUN":@"周日",@"Mon":@"周一",@"Tue":@"周二",@"Wed":@"周三",@"Thu":@"周四",@"Fri":@"周五",@"Sat":@"周六",@"Sun":@"周日",@"mon":@"周一",@"tue":@"周二",@"wed":@"周三",@"thu":@"周四",@"fri":@"周五",@"sat":@"周六",@"sun":@"周日"};
        
        if (NSNotFound != [date rangeOfString:@"-"].location) {
            //包含 -
            NSArray *array = [date componentsSeparatedByString:@"-"];
            if (array.count>=2) {
                return [NSString stringWithFormat:@"%@到%@",[dict objectForKey:array[0]],[dict objectForKey:array[1]]];
            }else{
                JSError(@"", @"");
                return @"error";
            }
        }else if (NSNotFound != [date rangeOfString:@"|"].location){
            //包含 |
            NSArray *array = [date componentsSeparatedByString:@"|"];
            NSMutableArray *mulArray = [NSMutableArray new];
            for (NSString *subStr in array) {
                if ([dict objectForKey:subStr]) {
                    [mulArray addObject:[dict objectForKey:subStr]];
                }
            }
            return [mulArray componentsJoinedByString:@"、"];
        }else{
            //纯数字
            return ( [dict objectForKey:date] ? : @"error" );
        }
    }
}


//300*3 --> 起每隔5分钟1次，共3次
+(NSString *)getIntervalStr:(NSString *)timeStr{
    
    if ([timeStr isEqualToString:@"0*1"]) {
        return @"";
    }else{
        NSArray *array = [timeStr componentsSeparatedByString:@"*"];
        if (array.count >=2) {
            NSString *resStr = [self timeStrInterval:array[0]];
            return [NSString stringWithFormat:@"起每隔%@1次，共%@次",resStr,array[1]];
        }else{
            JSError(@"", @"");
            return @"";
        }
        
    }
    
    
}

//由 间隔 得到 天时分秒
+(NSString *)timeStrInterval:(NSString *)intervalSecondStr{
    
    unsigned long long intervalSecond = intervalSecondStr.longLongValue;
    unsigned long day = (unsigned long) intervalSecond/(24*60*60);
    int hour = (int) (intervalSecond - day*24*60*60)/(60*60);
    int minute = (int) (intervalSecond - hour*60*60 - day*24*60*60)/60;
    int second = (int) (intervalSecond - hour*60*60 - day*24*60*60 - minute*60);
    
    if (0 == day) {
        if (0 == hour) {
            return [NSString stringWithFormat:@"%d分%d秒",minute,second];
        }else{
            return [NSString stringWithFormat:@"%d小时%d分%d秒",hour,minute,second];
        }
    }else{
        return [NSString stringWithFormat:@"%lu天%d小时%d分%d秒",day,hour,minute,second];

    }
    
}




@end
