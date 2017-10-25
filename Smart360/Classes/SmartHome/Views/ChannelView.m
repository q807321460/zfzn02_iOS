//
//  ChannelView.m
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "ChannelView.h"
#import "CustomSelectedChannelView.h"
#import "ChannelModel.h"

#define kChannelViewWidth (SCREEN_WIDTH / 3)

@interface ChannelView () <CustomSelectedChannelViewDelegate>
{
    NSArray *imageNameArray;
    CGFloat descriptionLabelHeight;
}

@end

@implementation ChannelView

- (instancetype)initWithChanndelArray:(NSArray *)channelModelArray {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        _channelModelArray = channelModelArray;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        CGFloat contentSizeHeight = [self channelViewHeight];
        self.contentSize = CGSizeMake(SCREEN_WIDTH, contentSizeHeight + 64);
        [self createChannelView];
    }
    return self;
}

- (void)createChannelView {
    
    NSString *description = @"我们提供18组常用频道设置，比如你可以将55频道设定为湖南卫视，通过语音输入湖南卫视，我们就会将电视自动切换到湖南卫视台";
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.textColor = UIColorFromRGB(0x999999);
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = description;
//    descriptionLabel.lineBreakMode
    [self addSubview:descriptionLabel];
    
    descriptionLabelHeight = [JSUtility heightForText:description labelWidth:SCREEN_WIDTH - 20 fontOfSize:16];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, descriptionLabelHeight));
        make.centerX.equalTo(self);
    }];
    
    int j = 0;
//    CGFloat selecChannelViewTop = descriptionLabel.bottom;
    for (int i = 0; i < kChannelCount; i ++) {
        j ++;
        if (j == 7) {
            j = 1;
        }
        NSString *imageName = [NSString stringWithFormat:@"Home_PDnum_bg0%d",j];
        
        CustomSelectedChannelView *selectChannelView = [[CustomSelectedChannelView alloc] initWithChannelModel:self.channelModelArray[i] andImageName:imageName];
        selectChannelView.tag = 300 + i;
        selectChannelView.selectedChannelViewDelegate = self;
        [self addSubview:selectChannelView];
        
        [selectChannelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descriptionLabel.mas_bottom).with.offset((i / 3) * kChannelViewHeight + 24);
            make.size.mas_equalTo(CGSizeMake(kChannelViewWidth, kChannelViewHeight));
            make.left.equalTo(self).with.offset((i % 3) * kChannelViewWidth);
        }];
        
    
    }
}

- (CGFloat)channelViewHeight {
    NSInteger channleViewRow = (kChannelCount % 3 == 0) ? (kChannelCount / 3):(kChannelCount / 3 + 1);

    return kChannelViewHeight * channleViewRow + descriptionLabelHeight + kChannelViewTop;
}


#pragma mark - CustomSelectedChannelViewDelegate
- (void)clickChannelNameBtn:(NSInteger)viewTag {
    NSLog(@"当前的tag值为: tag == %ld",(long)viewTag);
    
    if ([self.channelViewDelegate respondsToSelector:@selector(clickChangeViewWithMarkTag:)]) {
        [self.channelViewDelegate clickChangeViewWithMarkTag:viewTag];
    }
}

@end
