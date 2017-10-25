//
//  AddRedSatelliteGuideView.m
//  Smart360
//
//  Created by michael on 15/11/18.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "AddRedSatelliteGuideView.h"

@implementation AddRedSatelliteGuideView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createGuideUI];
    }
    return self;
}

-(void)createGuideUI{
    
    UIImage *guideImage = IMAGE(@"Home_hwx_tips_bg");
    CGFloat backImageViewHeight = SCREEN_WIDTH*guideImage.size.height/guideImage.size.width;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, backImageViewHeight)];
    [self addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = guideImage;
    
    
    UIButton *againBtn = [UIButton new];
    [self addSubview:againBtn];
    
    CGFloat h_againBtn = 340*SCREEN_WIDTH/480.0;
    CGFloat left_againBtn = 190*SCREEN_WIDTH/480.0;
    
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(h_againBtn);
        make.left.equalTo(self).offset(left_againBtn);
        //        make.height.mas_equalTo(@11);
        //        make.width.mas_equalTo(@90);
        make.size.mas_equalTo(IMAGE(@"Chat_Radio_normal").size);
    }];
    [againBtn setBackgroundImage:IMAGE(@"Chat_Radio_normal") forState:UIControlStateNormal];
    [againBtn setBackgroundImage:IMAGE(@"Chat_Radio_pressed") forState:UIControlStateSelected];
    
    [againBtn addTarget:self action:@selector(againBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *againLabel = [UILabel new];
    [self addSubview:againLabel];
    [againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(againBtn.mas_right).offset(10);
        make.height.mas_equalTo(againBtn);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(againBtn);
    }];
    againLabel.text = @"不再提示";
    againLabel.font = [UIFont systemFontOfSize:12];
    againLabel.textColor = UIColorFromRGB(0x999999);
    againLabel.textAlignment = NSTextAlignmentLeft;
    
    
    UIButton *knowButton = [UIButton new];
    [self addSubview:knowButton];
    CGFloat h_knowBtn = 666*h_againBtn/458;
    [knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(h_knowBtn);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    [knowButton addTarget:self action:@selector(knowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [knowButton setTitle:@"知道了" forState:UIControlStateNormal];
    [knowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    knowButton.titleLabel.font=[UIFont systemFontOfSize:15];
    knowButton.backgroundColor = [UIColor clearColor];
    
    knowButton.layer.masksToBounds = YES;
    knowButton.layer.cornerRadius = 8;
    knowButton.layer.borderWidth = 1;
    knowButton.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){ 1, 1, 1, 1 });
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    
    
}
-(void)knowBtnClick:(UIButton *)btn{
    
    [self removeFromSuperview];
}

-(void)againBtnClick:(UIButton *)btn{
    
    if (btn.isSelected == NO) {
        [btn setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddRedSatelliteGuideViewPromptAgain"];
        
    }else{
        [btn setSelected:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AddRedSatelliteGuideViewPromptAgain"];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
