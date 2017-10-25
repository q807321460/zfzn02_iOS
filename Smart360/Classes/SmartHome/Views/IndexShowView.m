//
//  IndexShowView.m
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "IndexShowView.h"

@interface IndexShowView ()


@property (nonatomic, strong) UILabel *showLabel;

@end


@implementation IndexShowView


-(instancetype)initCustom{
    
    if (self = [super init]) {
        [self createSubContentView];
    }
    
    return self;
}


-(void)createSubContentView{
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 20)];
    [self addSubview:self.showLabel];
    
    self.showLabel.backgroundColor = [UIColor clearColor];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.numberOfLines=0;
    self.showLabel.font = [UIFont systemFontOfSize:16];
    
}

-(void)updateCurrentIndex:(int)currentIndex totalIndex:(int)totalIndex{
    
    NSString *explanStr = [NSString stringWithFormat:@"测试按键(%d/%d)",currentIndex,totalIndex];
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:explanStr];
    
    //    [AttributedStr addAttribute:NSFontAttributeName
    //
    //                          value:[UIFont systemFontOfSize:16.0]
    //
    //                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kBindCode_Describ_Color
                          range:NSMakeRange(0, 5)];
    
    
    NSString *currentIndexStr = [NSString stringWithFormat:@"%d",currentIndex];
    
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(5, currentIndexStr.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kBindCode_Describ_Color
                          range:NSMakeRange(5+currentIndexStr.length, explanStr.length-5-currentIndexStr.length)];
    
    self.showLabel.attributedText = AttributedStr;
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
