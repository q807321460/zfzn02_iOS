//
//  view_player_playfish_local.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "VideoWnd.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "vv_local_player.h"
#import "foler_item.h"

@protocol view_playerfish_local_interface <NSObject>
@optional
-(void)on_play_ok_callback:(int)index total_sec:(int)total_sec;
-(void)on_audiostatus_callback:(int)exist play_id:(int)index;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end

@interface view_player_playfish_local : NSObject<vv_local_player_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    zxy_share_data* MyShareData;
    NSString* m_playfile;
    int bAudioStatus;
    BOOL b_released;
    int m_frame_rate;
    
    float m_video_fishtype;
    float m_video_space_left;
    float m_video_space_right;
    float m_video_space_top;
    float m_video_space_bottom;
    
}

@property (assign) id<view_playerfish_local_interface>delegate;
@property (assign) int m_index;
@property (retain) foler_item* m_file_item;
@property (retain) VideoWnd* m_play_view;
@property (retain) vv_local_player* m_player;
@property (strong, nonatomic) UIActivityIndicatorView* videoIndicator;
@property (assign) int playing_state;
@property (assign) BOOL bSelected;
@property (assign) int bAudioExist;
@property (strong, nonatomic) UIButton* replayButton;
@property (strong, nonatomic) UIView* touchView;


-(id)init:(int)index fisheye_type:(int)type top:(float)top bottom:(float)bottom left:(float)left right:(float)right;
-(void)initview:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height view_x:(float)view_x
                         view_y:(float)view_y view_width:(float)view_width view_height:(float)view_height;
-(void)setSelected:(BOOL)bselect;
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(int)start_play:(NSString*)filename;
-(int)set_seek:(int)pos;
-(void)set_pause:(BOOL)pause;
-(int)get_cur_sec;
-(BOOL)stopplay;
-(void)release_self;
-(long)get_playhandle;

-(int)get_video_width;
-(int)get_video_height;

@end