//
//  JLActionButton.m
//  JLActionSheet
//
//  Created by Jason Loewy on 1/31/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "JUIActionButton.h"

@implementation JUIActionButton

-(id)initWithTitle:(NSString*)title withImage:(UIImage*)image isCancel:(BOOL)cancel
{
    self = [self init];
    if (self)
    {
        if (title != nil)
        {
            _label  = [[UILabel alloc]init];
            _label.text = title;
            [self addSubview:_label];
        }
        _isCancelButton = cancel;
        if (image != nil)
        {
            _titleIcon = [[UIImageView alloc]init];
            _titleIcon.image = image;
            [self addSubview:_titleIcon];
        }
        self.topBorder = [[CALayer alloc] init];
        [self.layer addSublayer:self.topBorder];
//        self.bottomBorder = [[CALayer alloc] init];
//        [self.layer addSublayer:self.bottomBorder];
    }
    return self;
}

-(void)setDividerBackgroundColor:(UIColor*)color
{
    [self.topBorder setBackgroundColor:color.CGColor];
    [self.bottomBorder setBackgroundColor:color.CGColor];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [_topBorder setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
//    [_bottomBorder setFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.bounds), 1)];
    if (_titleIcon != nil)
    {
        [_titleIcon setFrame:CGRectMake(10, 6, 32, 32)];
    }
    if (_label != nil)
    {
        if (_isCancelButton)
        {
            [_label setFrame:CGRectMake(0, CGRectGetHeight(self.bounds)/2-10, CGRectGetWidth(self.bounds)*3/4, 20)];
            _label.textAlignment = NSTextAlignmentCenter;
            _label.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        }
        else
        {
            if (_titleIcon)
            {
                 [_label setFrame:CGRectMake(44, CGRectGetHeight(self.bounds)/2-10, CGRectGetWidth(self.bounds)*3/4, 20)];
            }
            else
            {
                [_label setFrame:CGRectMake(12, CGRectGetHeight(self.bounds)/2-10, CGRectGetWidth(self.bounds)*3/4, 20)];
            }
            
        }
       
    }
}

@end
