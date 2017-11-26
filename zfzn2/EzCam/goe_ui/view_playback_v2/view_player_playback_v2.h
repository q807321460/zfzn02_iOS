//
//  view_player_playback_v2.h
//  pano360
//
//  Created by zxy on 2017/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vv_playback_player.h"
#import "cam_list_item.h"
#import "VideoWnd.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "OMGToast.h"

@protocol view_player_playback_v2_interface <NSObject>
@optional
-(void)on_play_ok_callback:(int)index;
-(void)on_play_status_callback:(int)status play_id:(int)index tag:(NSString*)tag;
-(void)on_audiostatus_callback:(int)exist play_id:(int)index;
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end

@interface view_player_playback_v2 : NSObject<vv_playback_player_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    zxy_share_data* MyShareData;
    int bAudioStatus;
    BOOL b_released;
    int snap_src;//0=self  1=other
    
    NSData* jpgdata;
    int m_frame_rate;
    int m_cache_progress;
    int m_fisheye_type;
}
@property (assign) id<view_player_playback_v2_interface>delegate;
@property (assign) int m_index;
@property (retain) cam_list_item* m_cam_item;

@property (retain) vv_playback_player* m_player;


@property (strong, nonatomic) UITapGestureRecognizer* singleTap;
@property (strong, nonatomic) UITapGestureRecognizer* doubleTap;
@property (strong, nonatomic) UIPinchGestureRecognizer* pinchiGestur;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestur;
@property (assign) int playing_state;
@property (assign) BOOL bSelected;
@property (assign) int bAudioExist;

@property (retain) UIView* touchView;
@property (retain) UIView* indicator_back;
@property (retain) UILabel* cachelabel;
@property (retain) VideoWnd* m_play_view;


@property (strong, nonatomic) NSTimer* timer;

-(id)init:(int)index;
-(void)initview:(UIView*)touchview_in with_indicator_back:(UIView*)indicator_back_in with_cachelabel:(UILabel*)cachelabel_in with_playview:(VideoWnd*)playview_in;
-(void)setSelected:(BOOL)bselect;
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(void)startplay:(NSString*)playtime;
-(int)get_cur_frame_utctime;
-(BOOL)stopplay;
-(void)release_self;
-(void)snap_picture:(int)type;
-(long)get_playhandle;

-(float)getMaxXoffset;
-(void)DisplayChange:(display_point*)points;
-(int)get_video_width;
-(int)get_video_height;
@end
