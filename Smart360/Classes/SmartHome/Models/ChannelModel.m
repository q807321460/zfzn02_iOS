//
//  ChannelModel.m
//  Smart360
//
//  Created by michael on 15/11/6.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

- (instancetype)initWithChannelNumber:(NSString *)channelNumber channelName:(NSString *)channelName {
    self = [super init];
    if (self) {
        self.name = channelName;
        self.channel = channelNumber;
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.channel = dic[@"channel"];
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"channelName == %@, channelNumber ==  %@",_name,_channel];
}

@end
