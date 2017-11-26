//
//  view_player_playback_alarm_fish.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vv_playback_player.h"
#import "cam_list_item.h"
#import "VideoWnd.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "OMGToast.h"
@protocol view_player_fish_playback_alarm_interface <NSObject>
@optional
-(void)on_play_ok_callback:(int)index;
-(void)on_audiostatus_callback:(int)exist play_id:(int)index;
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end
@interface view_player_playback_alarm_fish : NSObject<vv_playback_player_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    zxy_share_data* MyShareData;
    NSString* m_playtime;
    int bAudioStatus;
    BOOL b_released;
    int snap_src;//0=self  1=other
    
    NSData* jpgdata;
    int m_frame_rate;
    
    int m_first_frame_utc_time;
    int m_cur_frame_utc_time;
    int m_cache_progress;
    
    int m_fisheye_type;
    float m_video_space_left;
    float m_video_space_right;
    float m_video_space_top;
    float m_video_space_bottom;
}
@property (assign) id<view_player_fish_playback_alarm_interface>delegate;
@property (assign) int m_index;
@property (retain) cam_list_item* m_cam_item;
@property (retain) VideoWnd* m_play_view;
@property (retain) vv_playback_player* m_player;

@property (assign) int playing_state;
@property (assign) BOOL bSelected;
@property (assign) int bAudioExist;
@property (retain) UIButton* replayButton;
@property (retain) UIView* touchView;
@property (strong, nonatomic) NSTimer* timer;
@property (retain) UIView* indicator_back;
@property (retain) UIActivityIndicatorView* videoIndicator;
@property (retain) UILabel* cachelabel;

-(id)init:(int)index fisheye_type:(int)type top:(float)top bottom:(float)bottom left:(float)left right:(float)right;
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(void)startplay:(NSString*)playtime;
-(BOOL)stopplay;
-(void)release_self;
-(void)snap_picture:(int)type;
-(long)get_playhandle;
-(int)get_video_width;
-(int)get_video_height;
-(NSString*)getCurStr:(int)value;
-(int)get_cur_sec;

-(void)initview:(UIView*)touchview_in with_indicator_back:(UIView*)indicator_back_in with_replay_button:(UIButton*)replaybutton_in with_indicator:(UIActivityIndicatorView*)videoIndicator_in with_cachelabel:(UILabel*)cachelabel_in with_playview:(VideoWnd*)playview_in;
@end
