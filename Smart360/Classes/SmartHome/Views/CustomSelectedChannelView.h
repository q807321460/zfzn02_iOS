//
//  CustomSelectedChannelView.h
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelModel;

@protocol CustomSelectedChannelViewDelegate <NSObject>

- (void)clickChannelNameBtn:(NSInteger)viewTag;

@end

@interface CustomSelectedChannelView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *channelNumberTextField;
@property (nonatomic, strong) UIButton *channelNameBtn;
@property (nonatomic, strong) ChannelModel *selectedChannelModel;
@property (nonatomic, weak) id<CustomSelectedChannelViewDelegate>selectedChannelViewDelegate;

- (instancetype)initWithChannelModel:(ChannelModel *)channelModel andImageName:(NSString *)imageName;


@end
