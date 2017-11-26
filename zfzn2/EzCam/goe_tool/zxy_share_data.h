//
//  zxy_share_data.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-4-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface zxy_share_data : NSObject
{
    
}


@property (assign) int cur_device_version;
@property (assign) int screen_y_offset;
@property (assign) int screen_height;
@property (assign) int screen_width;
@property (assign) int m_cur_device;
@property (assign) int net_status;
@property (retain, nonatomic) NSString* svr_url;
@property (retain, nonatomic) NSString* default_url;
@property (retain, nonatomic) NSString* cli_url;
@property (retain, nonatomic) NSString* dev_url;
@property (retain, nonatomic) NSString* event_url;
@property (retain, nonatomic) NSString* m_app_key;
@property (retain, nonatomic) NSString* m_vendor_pass;

@property (retain, nonatomic) NSString* push_svr;
@property (assign) int push_svr_port;
@property (retain, nonatomic) NSString* m_push_key;
@property (retain, nonatomic) NSString* m_push_pass;

@property (retain, nonatomic) NSMutableArray* playarray;
@property (retain, nonatomic) NSString* m_playing_devid;
@property (assign) BOOL bPlaying;
@property (assign) int status_bar_height;
@property (assign) float content_scale;
@property (assign) float m_sys_version;
@property (retain, nonatomic) NSString* p2p_server;
@property (assign) int p2p_port;
@property (retain, nonatomic) NSString* p2p_secret;

@property (retain, nonatomic) NSString* m_language;


+(zxy_share_data*)getInstance;

@end
