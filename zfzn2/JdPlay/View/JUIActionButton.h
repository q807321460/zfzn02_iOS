//
//  JLActionButton.h
//  JLActionSheet
//
//  Created by Jason Loewy on 1/31/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface JUIActionButton : UIButton

//+ (id) buttonWithStyle:(JLActionSheetStyle*)style andTitle:(NSString *)buttonTitle isCancel:(BOOL) isCancel;

- (void) configureForTitle;

/// Data Flags
@property BOOL isCancelButton;

@property (nonatomic, strong) UIColor* bgColor;
@property (nonatomic, strong) UIColor* highlightedColor;

@property (nonatomic, strong) CALayer* topBorder;
@property (nonatomic, strong) CALayer* bottomBorder;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIImageView* titleIcon;

-(void)addSubButton:(UIButton*)button;

-(id)initWithTitle:(NSString*)title withImage:(UIImage*)image isCancel:(BOOL)cancel;

-(void)setDividerBackgroundColor:(UIColor*)color;

@end
