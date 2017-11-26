//
//  share_item.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cam_list_item.h"
#import "foler_item.h"
#import "zx_alarm_item.h"
//#import "item_cloud_msg.h"
@interface share_item : NSObject
{

}


@property (assign) int cur_type;  //0=摄像头移动 1=分组移动
@property (assign) int cur_playpic_src;//0 本地抓图播放 1报警下载播放
@property (retain, nonatomic) cam_list_item* cur_cam_list_item;
@property (retain, nonatomic) foler_item* cur_foler_item;
@property (retain, nonatomic) zx_alarm_item* cur_alarm_item;

@property (retain, nonatomic) NSString* cur_devid;
@property (retain, nonatomic) NSString* cur_devpass;
@property (retain, nonatomic) NSString* cur_eventid;
@property (retain, nonatomic) NSString* cur_fish_jpgname;


@property (assign) long h_connector;
@property (assign) int m_connect_state;

@property (assign) long h_update_connector;
@property (assign) int m_update_connect_state;

+(share_item*)getInstance;
@end
