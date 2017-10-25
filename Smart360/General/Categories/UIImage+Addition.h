//
//  UIImage+Addition.h
//  Smart360
//
//  Created by nimo on 15/7/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)captureWithView:(UIView *)view;

//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;
    
@end
