//
//  JsonUtils.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+(NSString *)dataToJsonString:(id)object;

+(NSDictionary *)jsonStrToDictionary:(NSString *)str;

+(NSArray *)jsonStrToArray:(NSString *)str;

+ (NSString *)md5:(NSString *)str;

@end
