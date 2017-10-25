//
//  ProStudyButtonView.m
//  Smart360
//
//  Created by michael on 16/1/24.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "ProStudyButtonView.h"
#import "FuncProModel.h"


#define kProStudyButtonView_HorizonSpace (45.0/2)
#define kProStudyButtonView_VerticalSpace (30.0/2)
#define kProStudyButtionView_ImageView_Width (123.0/2)
#define kProStudyButtionView_ImageView_Height (123.0/2)

@interface ProStudyButtonView ()

@property (nonatomic, strong) NSMutableArray *funcArray;
@end


@implementation ProStudyButtonView

-(instancetype)initWithFuncArray:(NSArray *)funcArray{
    if (self = [super init]) {
        self.funcArray = [NSMutableArray arrayWithArray:funcArray];
        [self createContentUIView];
    }
    return self;
    
}

//此View初始化时已有自己的bounds
-(void)createContentUIView{
    
    NSInteger buttonRow = (self.funcArray.count % 4 == 0) ? (self.funcArray.count / 4):(self.funcArray.count / 4 + 1);
    self.bounds = CGRectMake(0, 0, (4*kProStudyButtionView_ImageView_Width+3*kProStudyButtonView_HorizonSpace), buttonRow*(kProStudyButtionView_ImageView_Height+kProStudyButtonView_VerticalSpace));
    
    for (int i=0; i<self.funcArray.count; i++) {
        
        FuncProModel *funcProModel = [[FuncProModel alloc] init];
        funcProModel = self.funcArray[i];
        
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        if (self.funcArray.count == 1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset( ( i/4 )*(kProStudyButtionView_ImageView_Height+kProStudyButtonView_VerticalSpace) );
                make.centerX.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kProStudyButtionView_ImageView_Width, kProStudyButtionView_ImageView_Height));
            }];

        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset( ( i/4 )*(kProStudyButtionView_ImageView_Height+kProStudyButtonView_VerticalSpace) );
                make.left.equalTo(self).offset( ( i%4 )*(kProStudyButtionView_ImageView_Width+kProStudyButtonView_HorizonSpace) );
                make.size.mas_equalTo(CGSizeMake(kProStudyButtionView_ImageView_Width, kProStudyButtionView_ImageView_Height));
            }];

        }
        
        button.tag = i+2000;
        if (funcProModel.isStudyed) {
            //已学习过
            [button setBackgroundImage:IMAGE(@"yk_btn_bg02") forState:UIControlStateNormal];
            [button setTitle:funcProModel.funcName andTitleColor:kProStudy_successStudy_Color andTitleFont:kProStudy_successStudy_TitleFont];
        }else{
            [button setBackgroundImage:IMAGE(@"yk_btn_bg01") forState:UIControlStateNormal];
            [button setTitle:funcProModel.funcName andTitleColor:kProStudy_noStudy_Color andTitleFont:kProStudy_noStudy_TitleFont];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    
    
}

-(void)btnClick:(UIButton *)btn{
    
    if ([self.proStudyButtonViewDelegate respondsToSelector:@selector(funcClickDelegate:button:)]) {
        [self.proStudyButtonViewDelegate funcClickDelegate:(btn.tag-2000) button:btn];
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
