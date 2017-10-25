//
//  NSString+Addition.m
//  Smart360
//
//  Created by nimo on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString
(Addition)

#pragma mark 是否空字符串
+ (BOOL)isEmptyString:(NSString *)str {
    return (!str || str.length == 0 ||
            [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) isEmptyOrNull {
    
    if ((!self)||(nil == self)||(NULL == self)) {
        return YES;
    } else if ([self isEqual:[NSNull null]]) {
        return YES;
    } else {
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSString *)trim {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *string = [temp mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    NSString *result = [string copy];
    return result;
}


#pragma mark md5加密
//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    
    const char *cStr = [srcString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
//    const char *cStr = [srcString UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
//    
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02X", digest[i]];
//    
//    return output;

}


#pragma mark 根据文字计算宽高
//
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop0
}

#pragma  mark - 单独计算文本的高度
//单独计算文本的高度
+ (CGFloat)heightForText:(NSString *)text fontOfSize:(CGFloat)size {
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
    
    //        return [NSString sizeForString:text font:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(SCREEN_WIDTH * 0.7, 1000) lineBreakMode:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading].height;
    
}

//根据label宽度计算文字宽度
+ (CGFloat)widthForText:(NSString *)text fontOfSize:(CGFloat)size width:(CGFloat)width {
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    return [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.width;
}


//检查字符串是否为空
+ (BOOL)checkStringEmpty:(NSString *)string {
    if ((NSNull *)string == [NSNull null]) {
        return YES;
    }
    if (string == nil || [string length] == 0) {
        return YES;
    } else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
    
}
@end
