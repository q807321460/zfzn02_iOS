//
//  NSString+Addition.h
//  Smart360
//
//  Created by nimo on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

+ (BOOL)isEmptyString:(NSString *)str;

- (NSString *)trimString;
- (BOOL)isEmptyOrNull;
- (NSString *)trim;

//
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode ;
+ (CGFloat)heightForText:(NSString *)text fontOfSize:(CGFloat)size;
//根据label宽度计算文字宽度
+ (CGFloat)widthForText:(NSString *)text fontOfSize:(CGFloat)size width:(CGFloat)width;
//+ (NSString *) md5:(NSString *)str;
+ (BOOL)checkStringEmpty:(NSString *)string;

@end
