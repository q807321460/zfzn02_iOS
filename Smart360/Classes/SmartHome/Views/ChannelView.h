//
//  ChannelView.h
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChannelModel;

@protocol ChannelViewDelegate <NSObject>

- (void)clickChangeViewWithMarkTag:(NSInteger)markTag;

@end

@interface ChannelView : UIScrollView

@property (nonatomic, strong) NSArray *channelModelArray;
@property (nonatomic, strong) NSNumber *currentChannelView;
@property (nonatomic, weak) id<ChannelViewDelegate>channelViewDelegate;

- (instancetype)initWithChanndelArray:(NSArray *)channelModelArray;

- (CGFloat)channelViewHeight;

@end
