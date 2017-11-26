//
//  share_item.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "share_item.h"

@implementation share_item
@synthesize cur_cam_list_item;
@synthesize cur_foler_item;
@synthesize cur_alarm_item;
@synthesize cur_type;
@synthesize cur_playpic_src;


@synthesize cur_devid;
@synthesize cur_eventid;
@synthesize cur_devpass;
@synthesize h_connector;
@synthesize m_connect_state;
@synthesize h_update_connector;
@synthesize m_update_connect_state;



@synthesize cur_fish_jpgname;

static share_item* instance = nil;

- (id)init
{
    @synchronized(self) {
        self = [super init];
        return self;
    }
}

+(share_item*)getInstance{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}
@end
