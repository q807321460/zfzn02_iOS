//
//  CustomSelectedChannelView.m
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "CustomSelectedChannelView.h"
#import "ChannelModel.h"

@implementation CustomSelectedChannelView


- (instancetype)initWithChannelModel:(ChannelModel *)channelModel andImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createSelectedChannelViewWithChannelModel:channelModel andImageName:imageName];
    }
    return self;
}

- (void)createSelectedChannelViewWithChannelModel:(ChannelModel *)channelModel andImageName:(NSString *)imageName{
    
    UIImageView *channelNumberBackImageView = [UIImageView new];
    channelNumberBackImageView.image = IMAGE(imageName);
    [self addSubview:channelNumberBackImageView];
    
    UIColor *textColor = [self machViewTextColorWithImageName:imageName];
    self.channelNumberTextField = [UITextField new];
    self.channelNumberTextField.textColor = textColor;
    self.channelNumberTextField.font = [UIFont systemFontOfSize:16];
    self.channelNumberTextField.tag = 200;
    self.channelNumberTextField.textAlignment = NSTextAlignmentCenter;
//    self.channelNumberTextField.motionEffects
    self.channelNumberTextField.delegate = self;
    [self addSubview:_channelNumberTextField];
    
    UIImageView *downImageView = [UIImageView new];
    downImageView.image = IMAGE(@"Home_Ico_ArrowDown");
    [self addSubview:downImageView];
    
    UIImageView *btnBacImage = [UIImageView new];
    btnBacImage.image = [JSUtility stretcheImage:IMAGE(@"Home_pd_bg")];
    [self addSubview:btnBacImage];
    
    self.channelNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.channelNameBtn.tag = 201;
//    [self.channelNameBtn setBackgroundImage:[JSUtility stretcheImage:IMAGE(@"Home_pd_bg")] forState:UIControlStateNormal];
    [self.channelNameBtn setOnClickSelector:@selector(selecteChannelName:) target:self];
//    self.channelNameBtn.backgroundColor = [UIColor yellowColor];
    self.channelNameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSString *titles = @"央视一套";
    CGFloat height = [NSString widthForText:titles fontOfSize:14 width:(SCREEN_WIDTH / 3)];
    height = [JSUtility heightForText:titles labelWidth:(SCREEN_WIDTH / 3) fontOfSize:14];
//    CGFloat width?
    self.channelNameBtn.titleEdgeInsets = UIEdgeInsetsMake((28 - height) / 2, 0,(kChannelNameBtnHeight - (28 - height) / 2 - height ), 0);
    if (channelModel) {
        [self.channelNameBtn setTitle:channelModel.name andTitleColor:textColor andTitleFont:14];
        self.channelNumberTextField.text = channelModel.channel;

    }
    
    [self addSubview:_channelNameBtn];
    
    
    [channelNumberBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.size.mas_equalTo(IMAGE(imageName).size);
        make.centerX.equalTo(self);
    }];
    
    [_channelNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.size.mas_equalTo(IMAGE(imageName).size);
        make.centerX.equalTo(self);
    }];
    
    [downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(channelNumberBackImageView.mas_bottom).with.offset(kChannelImageViewGap);
        make.size.mas_equalTo(IMAGE(@"Home_Ico_ArrowDown").size);
        make.centerX.equalTo(self);
    }];
    
    [btnBacImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downImageView.mas_bottom).with.offset(kChannelImageViewGap);
        make.size.mas_equalTo(CGSizeMake(90, 28));
        make.centerX.equalTo(self);
    }];

    
    [_channelNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downImageView.mas_bottom).with.offset(kChannelImageViewGap);
        make.height.mas_equalTo(kChannelNameBtnHeight);
        make.left.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
//    _channelNameBtn.backgroundColor = [UIColor cyanColor];
    
}

- (void)selecteChannelName:(UIButton *)btn {
    NSLog(@"点击了buttn");
    if ([self.selectedChannelViewDelegate respondsToSelector:@selector(clickChannelNameBtn:)]) {
        [self.selectedChannelViewDelegate clickChannelNameBtn:self.tag];
    }
}



- (UIColor *)machViewTextColorWithImageName:(NSString *)imageName {
    if ([imageName isEqualToString:@"Home_PDnum_bg01"]) {
        return UIColorFromRGB(0xecb408);
    } else if ([imageName isEqualToString:@"Home_PDnum_bg02"]) {
        return UIColorFromRGB(0x0dbec5);
    } else if ([imageName isEqualToString:@"Home_PDnum_bg03"]) {
        return UIColorFromRGB(0x80c119);
    } else if ([imageName isEqualToString:@"Home_PDnum_bg04"]) {
        return UIColorFromRGB(0x5f9bed);
    } else if ([imageName isEqualToString:@"Home_PDnum_bg05"]) {
        return UIColorFromRGB(0xbdc311);
    } else {
        return UIColorFromRGB(0xf37733);
    }
}


//当输入框结束编辑时触发(键盘收回之后触发)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"当输入框结束编辑时触发(键盘收回之后触发)");
}

//当输入框文字通过键盘发生变化时就会触发
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length == 3 && string.length > 0) {
        return NO;
    }
    NSString *canInputCharacter = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:canInputCharacter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (!canChange && string.length == 0) {
        return YES;
    }
    return canChange;

}



@end
