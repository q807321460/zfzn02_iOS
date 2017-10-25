//
//  UIBarButtonItem+CustomStyle.m
//  Smart360
//
//  Created by nimo on 15/7/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "UIBarButtonItem+CustomStyle.h"

@implementation UIBarButtonItem (CustomStyle)

+ (UIBarButtonItem *)barButtonItemWithObject:(id)obj target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    //offset
    //    float offset = isLeft ? kOffset : -kOffset;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80, 44)];
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//
    //是title还是image
    if ([obj isKindOfClass:[UIImage class]]) {
        [btn setImage:(UIImage *)obj forState:UIControlStateNormal];
    } else {
        NSString *aString = (NSString *)obj;
        [btn setTitle:aString forState:UIControlStateNormal];
        
        //控制BBI“标题”的长度
        UIFont *aFont = [UIFont boldSystemFontOfSize:16];
//        CGSize aSize = [aString sizeWithAttributes:@{ NSFontAttributeName : aFont}];
        btn.titleLabel.font = aFont;
        CGRect aRect = btn.frame;
        
//        if (aSize.width > aRect.size.width) {
//            aRect.size.width = aSize.width;
//        }
        aRect.size.height = 44.f;
        aRect.origin.y = 0.f;
//        aRect.origin.x = 61.f - aRect.size.width;
        
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        if (isLeft) {
            [btn setImageNormal:@"btn_back_normal.png" hightLighted:@"btn_back_pressed.png"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 10);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
        } else {
//            btn.backgroundColor = [UIColor cyanColor];
             btn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -20);
            aRect.size.width = 80;
        }
        btn.frame = aRect;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    return [self barButtonItemWithObject:image target:target action:action isLeft:isLeft];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    return [self barButtonItemWithObject:title target:target action:action isLeft:isLeft];
}

+ (UIBarButtonItem *)barButtonItemNoImageWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    return [self barButtonItemNoimageWithObject:title target:target action:action isLeft:isLeft];
}



+ (UIBarButtonItem *)barButtonItemNoimageWithObject:(id)obj target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 12, 100, 20)];
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //
    //是title还是image
    if ([obj isKindOfClass:[UIImage class]]) {
        [btn setImage:(UIImage *)obj forState:UIControlStateNormal];
    } else {
        NSString *aString = (NSString *)obj;
        [btn setTitle:aString forState:UIControlStateNormal];
        
        //控制BBI“标题”的长度
        UIFont *aFont = [UIFont boldSystemFontOfSize:16];
        //        CGSize aSize = [aString sizeWithAttributes:@{ NSFontAttributeName : aFont}];
        btn.titleLabel.font = aFont;
        CGRect aRect = btn.frame;
        
        //        if (aSize.width > aRect.size.width) {
        //            aRect.size.width = aSize.width;
        //        }
        aRect.size.height = 44.f;
        aRect.origin.y = 0.f;
        //        aRect.origin.x = 61.f - aRect.size.width;
        
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        if (isLeft) {
//            [btn setImageNormal:@"btn_back_normal.png" hightLighted:@"btn_back_pressed.png"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 10);
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
        } else {
            //            btn.backgroundColor = [UIColor cyanColor];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -20);
            aRect.size.width = 80;
        }
        btn.frame = aRect;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];

}

@end
