//
//  CHLoadingView.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/15.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHLoadingView : UIView

@property (nonatomic,strong) UIActivityIndicatorView * activity;

@property (nonatomic,strong) UILabel * textL;

+ (CHLoadingView *)showWithView:(UIView *)view;
- (void)dismiss;

@end
