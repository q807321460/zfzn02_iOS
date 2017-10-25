//
//  SelecteSinatvView.h
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelecteSinatvViewDelegate <NSObject>

- (void)selectedSinatv:(NSString *)sinatv;

@end

@interface SelecteSinatvView : UIView

@property (nonatomic, weak)id<SelecteSinatvViewDelegate>sinagvDelegate;

- (instancetype)initWithSinatvDataArray:(NSArray *)sinatvArray;

//关闭视图
- (void)closeSinatvView;

//展示视图
- (void)showSinatvView;



@end
