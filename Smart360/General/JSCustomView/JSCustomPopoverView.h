//
//  JSCustomPopoverView.h
//  Smart360
//
//  Created by sun on 15/8/5.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCustomPopoverView : UIView

//初始化下拉框要显示的文字,位置和图片
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images isOnNav:(BOOL)isOnNav;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, assign) BOOL isOnNav;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSIndexPath *selectIndexPath);


@end
