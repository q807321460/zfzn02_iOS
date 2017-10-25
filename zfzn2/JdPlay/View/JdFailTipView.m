//
//  JdFailTipView.m
//  JDMusic
//
//  Created by 沐阳 on 16/8/9.
//  Copyright © 2016年 henry. All rights reserved.
//

#import "JdFailTipView.h"
#import "UIView+Frame.h"

/** view弹出和收起的动画时间 */
static const CGFloat viewShowAndHideDuration = 0.3;

#define MAINCOLOR [UIColor colorWithRed:215/255.0 green:46/255.0 blue:33/255.0 alpha:1]


@interface JdFailTipView ()

/** 背部的遮盖按钮 */
@property (nonatomic, strong) UIButton *maxCoverBtn;

@end

@implementation JdFailTipView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.backgroundColor = [UIColor whiteColor];
    
    self.ensureBtn.layer.cornerRadius = 3;
    self.ensureBtn.layer.masksToBounds = YES;
    
    //大背景
    _maxCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _maxCoverBtn.frame = [UIScreen mainScreen].bounds;
    [_maxCoverBtn setBackgroundColor:[UIColor blackColor]];
    [_maxCoverBtn setAlpha:0.2];
    [_maxCoverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//遮盖被点击了收回View
-(void)coverBtnClick
{
    [UIView animateWithDuration:viewShowAndHideDuration animations:^{
        
        [self.maxCoverBtn removeFromSuperview];
        [self removeFromSuperview];

    } completion:^(BOOL finished) {
        
    }];
}


+ (JdFailTipView *)viewWithParentView:(UIView*)parentView tip:(NSString *)tip
{
    JdFailTipView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    view.failL.text = tip;
    return view;
}


- (void)showWithparentView:(UIView*)parentView
{
    self.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 160);
    self.centerY = parentView.centerY;
    [parentView addSubview:self.maxCoverBtn];
    [UIView animateWithDuration:viewShowAndHideDuration animations:^{
        
        [parentView addSubview:self];
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)removeFromParentView
{
    [self.maxCoverBtn removeFromSuperview];
    [self removeFromSuperview];
}


- (IBAction)ensureBtnClick:(id)sender {
    
    if (self.ensureBlock) {
         self.ensureBlock();
    }
    [self removeFromParentView];
}


-(void)setEnsureBlock:(ensureBtnBlock)ensureBlock
{
    _ensureBlock = ensureBlock;
}


@end
