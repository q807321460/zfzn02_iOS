//
//  view_player_playback.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 14-11-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vv_playback_player.h"
#import "cam_list_item.h"
#import "VideoWnd.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "OMGToast.h"
@protocol view_player_playback_alarm_interface <NSObject>
@optional
-(void)on_play_ok_callback:(int)index;
-(void)on_audiostatus_callback:(int)exist play_id:(int)index;
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end

@interface view_player_playback_alarm : NSObject<vv_playback_player_interface>
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
}
@property (assign) id<view_player_playback_alarm_interface>delegate;
@property (assign) int m_index;
@property (retain) cam_list_item* m_cam_item;
@property (retain) VideoWnd* m_play_view;
@property (retain) vv_playback_player* m_player;
@property (strong, nonatomic) UIActivityIndicatorView* videoIndicator;
@property (strong, nonatomic) UILabel* cachelabel;
@property (strong, nonatomic) UITapGestureRecognizer* singleTap;
@property (strong, nonatomic) UITapGestureRecognizer* doubleTap;
@property (strong, nonatomic) UIPinchGestureRecognizer* pinchiGestur;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestur;
@property (assign) int playing_state;
@property (assign) BOOL bSelected;
@property (assign) int bAudioExist;
@property (strong, nonatomic) UIButton* replayButton;
@property (strong, nonatomic) UIView* touchView;
@property (strong, nonatomic) NSTimer* timer;

-(id)init:(int)index fisheye_type:(int)type;
-(void)initview:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_streamtype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_streamtype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height view_x:(float)view_x
                         view_y:(float)view_y view_width:(float)view_width view_height:(float)view_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height view_x:(float)view_x
                         view_y:(float)view_y view_width:(float)view_width view_height:(float)view_height;
-(void)setSelected:(BOOL)bselect;
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(void)startplay:(NSString*)playtime;
-(BOOL)stopplay;
-(void)release_self;
-(void)snap_picture:(int)type;
-(long)get_playhandle;

-(float)getMaxXoffset;
-(void)DisplayChange:(display_point*)points;
-(int)get_video_width;
-(int)get_video_height;
-(NSString*)getCurStr:(int)value;
-(int)get_cur_sec;
@end
