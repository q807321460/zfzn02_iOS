//
//  UIView+Frame.h
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

-(void)setX:(CGFloat)x;

-(CGFloat)x;

-(void)setY:(CGFloat)y;

-(CGFloat)y;

-(void)setWidth:(CGFloat)width;

-(CGFloat)width;

-(void)setHeight:(CGFloat)height;

-(CGFloat)height;

-(void)setSize:(CGSize)size;

-(CGSize)size;

-(void)setOrigin:(CGPoint)origin;

-(CGPoint)origin;

@end
