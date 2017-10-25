//
//  StepView.m
//  Smart360
//
//  Created by michael on 15/11/11.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "StepView.h"

@implementation StepView


-(instancetype)initWithStepNameArray:(NSArray *)array stepNumber:(int)number{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 79);
        [self configureSubViewsWithStepNameArray:array stepNumber:number];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



//内容页子视图
- (void)configureSubViewsWithStepNameArray:(NSArray *)array stepNumber:(int)number{
    
    
    UIImage *image = IMAGE(@"Home_Ico_Step01_Current"); //红色
    
    if (2 == array.count) {
        
        UIImageView *imageView1 = [UIImageView new];
        [self addSubview:imageView1];
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(18);
//            make.size.mas_equalTo(CGSizeMake(53, 53));
            make.size.mas_equalTo(image.size);
            make.left.equalTo(self).offset(20);
        }];
        
        
        UILabel *label1 = [UILabel new];
        [self addSubview:label1];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:11];
        label1.text=array[0];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView1.mas_bottom).offset(6);
            make.centerX.mas_equalTo(imageView1);
            make.height.mas_equalTo(@11);
            make.width.mas_equalTo(@90);
        }];
        
        
        UIImageView *imageView2 = [UIImageView new];
        [self addSubview:imageView2];
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1);
            make.right.equalTo(self).offset(-20);
//            make.size.mas_equalTo(CGSizeMake(53, 53));
            make.size.mas_equalTo(image.size);
        }];
        
        
        UILabel *label2 = [UILabel new];
        [self addSubview:label2];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:11];
        label2.text=array[1];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView2.mas_bottom).offset(6);
            make.centerX.mas_equalTo(imageView2);
            make.height.mas_equalTo(@11);
            make.width.mas_equalTo(@90);
        }];
        
        
        UIView *line = [UIView new];
        [self addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xcecece);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1);
            make.left.equalTo(imageView1.mas_right).offset(18);
            make.right.equalTo(imageView2.mas_left).offset(-18);
            make.height.mas_equalTo(@1);
        }];
        
        if (1 == number) {
            imageView1.image = IMAGE(@"Home_Ico_Step01_Current");
            imageView2.image = IMAGE(@"Home_Ico_Step02");
            label1.textColor=UIColorFromRGB(0xff6868);
            label2.textColor=UIColorFromRGB(0x999999);
        }else{
            imageView1.image = IMAGE(@"Home_Ico_Step01");
            imageView2.image = IMAGE(@"Home_Ico_Step02_Current");
            label1.textColor=UIColorFromRGB(0x999999);
            label2.textColor=UIColorFromRGB(0xff6868);
        }
        
    }
    
    
    if (3 == array.count) {
        
        UIImageView *imageView1 = [UIImageView new];
        [self addSubview:imageView1];
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(18);
            make.size.mas_equalTo(CGSizeMake(53, 53));
            //            make.size.mas_equalTo(image.size);
            make.left.equalTo(self).offset(20);
        }];
        
        
        UILabel *label1 = [UILabel new];
        [self addSubview:label1];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:11];
        label1.text=array[0];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView1.mas_bottom).offset(6);
            make.centerX.mas_equalTo(imageView1);
            make.height.mas_equalTo(@11);
            make.width.mas_equalTo(@90);
        }];
        
        
        UIImageView *imageView2 = [UIImageView new];
        [self addSubview:imageView2];
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(53, 53));
//            make.size.mas_equalTo(image.size);
        }];
        
        
        UILabel *label2 = [UILabel new];
        [self addSubview:label2];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:11];
        label2.text=array[1];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView2.mas_bottom).offset(6);
            make.centerX.mas_equalTo(imageView2);
            make.height.mas_equalTo(@11);
            make.width.mas_equalTo(@90);
        }];
        
        
        UIImageView *imageView3 = [UIImageView new];
        [self addSubview:imageView3];
        [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(53, 53));
            //            make.size.mas_equalTo(image.size);
        }];
        
        
        UILabel *label3 = [UILabel new];
        [self addSubview:label3];
        label3.textAlignment=NSTextAlignmentCenter;
        label3.font=[UIFont systemFontOfSize:11];
        label3.text=array[2];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView3.mas_bottom).offset(6);
            make.centerX.mas_equalTo(imageView3);
            make.height.mas_equalTo(@11);
            make.width.mas_equalTo(@90);
        }];
        
        
        UIView *line1 = [UIView new];
        [self addSubview:line1];
        line1.backgroundColor = UIColorFromRGB(0xcecece);
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1.mas_centerY);
            make.left.equalTo(imageView1.mas_right).offset(18);
            make.right.equalTo(imageView2.mas_left).offset(-18);
            make.height.mas_equalTo(@1);
        }];
        
        UIView *line2 = [UIView new];
        [self addSubview:line2];
        line2.backgroundColor = UIColorFromRGB(0xcecece);
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView1.mas_centerY);
            make.left.equalTo(imageView2.mas_right).offset(18);
            make.right.equalTo(imageView3.mas_left).offset(-18);
            make.height.mas_equalTo(@1);
        }];
        
        if (1 == number) {
            imageView1.image = IMAGE(@"Home_Ico_Step01_Current");
            imageView2.image = IMAGE(@"Home_Ico_Step02");
            imageView3.image = IMAGE(@"Home_Ico_Step03");
            label1.textColor=UIColorFromRGB(0xff6868);
            label2.textColor=UIColorFromRGB(0x999999);
            label3.textColor=UIColorFromRGB(0x999999);
            
        }else if (2 == number){
            imageView1.image = IMAGE(@"Home_Ico_Step01");
            imageView2.image = IMAGE(@"Home_Ico_Step02_Current");
            imageView3.image = IMAGE(@"Home_Ico_Step03");
            label1.textColor=UIColorFromRGB(0x999999);
            label2.textColor=UIColorFromRGB(0xff6868);
            label3.textColor=UIColorFromRGB(0x999999);
            
        }else if (3 == number){
            imageView1.image = IMAGE(@"Home_Ico_Step01");
            imageView2.image = IMAGE(@"Home_Ico_Step02");
            imageView3.image = IMAGE(@"Home_Ico_Step03_Current");
            label1.textColor=UIColorFromRGB(0x999999);
            label2.textColor=UIColorFromRGB(0x999999);
            label3.textColor=UIColorFromRGB(0xff6868);
        }
        
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
