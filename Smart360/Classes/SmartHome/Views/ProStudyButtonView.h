//
//  ProStudyButtonView.h
//  Smart360
//
//  Created by michael on 16/1/24.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProStudyButtonViewDelegate <NSObject>

-(void)funcClickDelegate:(NSInteger)markTag button:(UIButton *)btn;

@end



@interface ProStudyButtonView : UIView

@property (nonatomic, weak) id<ProStudyButtonViewDelegate>proStudyButtonViewDelegate;



-(instancetype)initWithFuncArray:(NSArray *)funcArray;

@end
