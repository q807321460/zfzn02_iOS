//
//  JsonUtils.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JsonUtils.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation JsonUtils

+(NSString *)dataToJsonString:(id)object
{
    if (![NSJSONSerialization isValidJSONObject:object]) {
        return @"";
    }
    NSString * jsonStr = @"";
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+(NSDictionary *)jsonStrToDictionary:(NSString *)str
{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

+(NSArray *)jsonStrToArray:(NSString *)str
{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return arr;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
