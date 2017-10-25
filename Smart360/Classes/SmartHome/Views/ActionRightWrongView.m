//
//  ActionRightWrongView.m
//  Smart360
//
//  Created by michael on 15/12/29.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "ActionRightWrongView.h"


@interface ActionRightWrongView ()

@property (nonatomic, strong) UILabel *showLabel;

@end


@implementation ActionRightWrongView


-(instancetype)initWithAction:(NSString *)actionStr{
    
    if (self = [super init]) {
        [self createSubContentView:actionStr];
    }
    return self;
}


-(void)createSubContentView:(NSString *)actionStr{

    self.backgroundColor = [UIColor clearColor];
    
    
    __weak typeof(self) weakSelf = self;
    
    
    self.showLabel = [[UILabel alloc] init];
    [self addSubview:self.showLabel];
    self.showLabel.text = @"设备正确响应了么？";
//    self.showLabel.text = [NSString stringWithFormat:@"设备%@了么？",actionStr];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.font = [UIFont systemFontOfSize:16];
    self.showLabel.numberOfLines = 0;
    self.showLabel.textColor = UIColorFromRGB(0x999999);
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_equalTo(20);
    }];
    
    
    UIButton *rightButton = [[UIButton alloc] init];
    [self addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = UIColorFromRGB(0xff6868);
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 8;
    [rightButton setTitle:@"是" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    
    
    UIButton *wrongButton = [[UIButton alloc] init];
    [self addSubview:wrongButton];
    [wrongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightButton.mas_bottom).offset(20);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    
    [wrongButton addTarget:self action:@selector(wrongClick:) forControlEvents:UIControlEventTouchUpInside];
    wrongButton.backgroundColor = [UIColor whiteColor];
    wrongButton.layer.masksToBounds = YES;
    wrongButton.layer.cornerRadius = 8;
    [wrongButton setTitle:@"否" forState:UIControlStateNormal];
    [wrongButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wrongButton.titleLabel.font=[UIFont systemFontOfSize:15];
}

-(void)updateActionStr:(NSString *)actionStr{
    
    self.showLabel.text = [NSString stringWithFormat:@"设备%@了么？",actionStr];
    
}

-(void)rightClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(actionRightClick)]) {
        [self.delegate actionRightClick];
    }
    
}

-(void)wrongClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(actionWrongClick)]) {
        [self.delegate actionWrongClick];
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
