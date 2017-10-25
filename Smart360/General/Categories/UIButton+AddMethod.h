//
//  UIButton+AddMethod.h
//  Smart360
//
//  Created by sun on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIButton (AddMethod)

- (void)setImageNormal:(NSString*)normal hightLighted:(NSString*)hightLighted;

- (void)setImageWithNormal:(NSString*)normal andHightLighted:(NSString*)hightLighted;

- (void)setBackGroundImageWithNormal:(NSString*)normal andHightLighted:(NSString*)hightLighted;

- (void)setOnClickSelector:(SEL)selector target:(id)target;

- (void)setTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleFont:(NSInteger)titleFont;
- (void)setTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleFont:(NSInteger)titleFont state:(UIControlState)state;

@end
