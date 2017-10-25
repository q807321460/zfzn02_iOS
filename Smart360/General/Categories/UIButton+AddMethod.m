//
//  UIButton+AddMethod.m
//  Smart360
//
//  Created by sun on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "UIButton+AddMethod.h"

@implementation UIButton (AddMethod)
- (void)setImageNormal:(NSString*)normal hightLighted:(NSString*)hightLighted
{
    UIImage *imageNormal = IMAGE(normal);
    UIImage *imagePressed = IMAGE(hightLighted);
    [self setImage:imageNormal forState:UIControlStateNormal];
    [self setImage:imagePressed forState:UIControlStateHighlighted];
    self.frame = CGRectMake(0, 0, 80, 44);
}

- (void)setImageWithNormal:(NSString*)normal andHightLighted:(NSString*)hightLighted {
    UIImage *imageNormal = IMAGE(normal);
    UIImage *imagePressed = IMAGE(hightLighted);
    [self setImage:imageNormal forState:UIControlStateNormal];
    [self setImage:imagePressed forState:UIControlStateHighlighted];
}

- (void)setBackGroundImageWithNormal:(NSString*)normal andHightLighted:(NSString*)hightLighted {
    UIImage *imageNormal = IMAGE(normal);
    UIImage *imagePressed = IMAGE(hightLighted);
    [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
}


- (void)setOnClickSelector:(SEL)selector target:(id)target
{
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}


- (void)setTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleFont:(NSInteger)titleFont
{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    [self setTitleColor:titleColor forState:UIControlStateNormal];

}
- (void)setTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleFont:(NSInteger)titleFont state:(UIControlState)state
{
    [self setTitle:title forState:state];
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    [self setTitleColor:titleColor forState:state];
    
}



@end
