//
//  UIBarButtonItem+CustomStyle.h
//  Smart360
//
//  Created by nimo on 15/7/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOffset             5 //BBI contenView.bounds 左右偏移的距离

@interface UIBarButtonItem (CustomStyle)
//use image
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
//use title
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

+ (UIBarButtonItem *)barButtonItemNoImageWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

@end
