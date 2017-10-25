//
//  NSString+Util.h
//  ting
//
//  Created by mario on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Util)

// 可能有问题，最好使用下面 stringByURLEncoded
- (NSString *)URLEncodedString;

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

+ (NSString*)URLQueryStringByDictionnary:(NSDictionary*)params;


@end
