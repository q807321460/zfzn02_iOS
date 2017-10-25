//
//  ChannelModel.h
//  Smart360
//
//  Created by michael on 15/11/6.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithChannelNumber:(NSString *)channelNumber channelName:(NSString *)channelName;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
