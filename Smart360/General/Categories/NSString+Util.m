//
//  NSString+Util.m
//  ting
//
//  Created by mario on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

//#import "XMUIConfig.h"

@implementation NSString (Util)

- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}



- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),encoding));
    return result;
}

+ (NSString*)URLQueryStringByDictionnary:(NSDictionary*)params {
    
    NSMutableString *requeryStr = [NSMutableString string];
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSInteger index = 0;
    for(id key in sortedArray){
        if(index != 0){
            [requeryStr appendString:@"&"];
        }
        if([[params objectForKey:key] isKindOfClass:[NSString class]])
        {
            [requeryStr appendString:[NSString stringWithFormat:@"%@=%@",key,[[params objectForKey:key]URLEncodedString]]];
        }
        else
        {
            NSString *str = [[params objectForKey:key] stringValue];
            [requeryStr appendString:[NSString stringWithFormat:@"%@=%@",key,[str URLEncodedString]]];
            
        }
        
        index++;
    }
    return requeryStr;
}

@end
