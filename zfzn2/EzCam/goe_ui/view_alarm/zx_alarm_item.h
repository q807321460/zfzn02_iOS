//
//  zx_alarm_item.h
//  ppview_zx
//
//  Created by zxy on 15-1-20.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zx_alarm_item : NSObject

@property (assign) int m_item_level;
@property (retain, nonatomic) NSString* m_parent;
@property (retain, nonatomic) NSString* m_day;
@property (retain, nonatomic) NSString* m_eventid;
@property (retain, nonatomic) NSString* m_time;
@property (retain, nonatomic) NSString* m_play_time;
@property (retain, nonatomic) NSString* m_sensor;
@property (retain, nonatomic) NSString* m_title;
@property (assign) int m_event_type;
@property (assign) int m_item_type;//0:group  1:报警信息
@property (assign) int m_pic_num;
@property (assign) int m_video_long;
@property (assign) int m_bexpand;

@property (assign) int m_video_fishtype;
@property (assign) int m_video_space_left;
@property (assign) int m_video_space_right;
@property (assign) int m_video_space_top;
@property (assign) int m_video_space_bottom;
@end
