//
//  JSBaseView.m
//  Smart360
//
//  Created by sun on 16/5/18.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "JSBaseView.h"

#define ViewContent_Width SCREEN_WIDTH - (SCREEN_WIDTH * (60.0000 / 320.0000))

@interface JSBaseView ()


@end


@implementation JSBaseView

-(id)initWithViewTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.350];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [self addGestureRecognizer:tapG];

        [self addSubview:self.viewContent];
        [self createButton];
        
    }
    return self;
}

- (void)createButton {
    
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = (ViewContent_Width - 40 - 15) / 2 ;
    
    self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ensureButton setTitle:@"确定" andTitleColor:UIColorFromRGB(0xffffff) andTitleFont:14];
    self.ensureButton.layer.borderColor = UIColorFromRGB(0xff6868).CGColor;
    self.ensureButton.layer.borderWidth = 1.f;
    self.ensureButton.layer.cornerRadius = 5;
    self.ensureButton.layer.masksToBounds = YES;
    self.ensureButton.backgroundColor = UIColorFromRGB(0xff6868);
//    [_ensureButton setOnClickSelector:@selector(update:) target:self];
    //    self.ensureButton.hidden = YES;
    [self.viewContent addSubview:_ensureButton];
    
    [_ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewContent).with.offset(20);
        make.bottom.equalTo(_viewContent).with.offset(-40);
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(buttonWidth);
    }];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.cancelButton setTitle:@"取消" andTitleColor:UIColorFromRGB(0xff6868) andTitleFont:14];
    self.cancelButton.layer.borderColor = UIColorFromRGB(0xd5d5d5).CGColor;
    self.cancelButton.layer.borderWidth = 1.f;
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
//    [_cancelButton setOnClickSelector:@selector(update:) target:self];
    [self.viewContent addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_viewContent).with.offset(-20);
        make.bottom.equalTo(_ensureButton);
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(buttonWidth);
    }];

}

//内容视图
- (UIView *)viewContent {
    if (!_viewContent) {
        _viewContent = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, 0)];
        _viewContent.backgroundColor = [UIColor whiteColor];
        _viewContent.layer.masksToBounds = YES;
        _viewContent.layer.cornerRadius = 5;
    }
    return _viewContent;
}

//展示视图
- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewContent.frame = CGRectMake(30, (SCREEN_HEIGHT - _contentViewHeight - 64) / 2, SCREEN_WIDTH - 60, _contentViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

//关闭视图
- (void)closeView {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewContent.frame = CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




@end
