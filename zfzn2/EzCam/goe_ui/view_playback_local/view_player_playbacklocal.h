//
//  view_player_playbacklocal.h
//  ppview_zx
//
//  Created by zxy on 15-2-9.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoWnd.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
//#import "CPlayer_local.h"
#import "foler_item.h"
#import "vv_local_player.h"

@protocol view_player_local_interface <NSObject>
@optional
-(void)on_play_ok_callback:(int)index total_sec:(int)total_sec;
-(void)on_audiostatus_callback:(int)exist play_id:(int)index;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end

@interface view_player_playbacklocal : NSObject<vv_local_player_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    zxy_share_data* MyShareData;
    NSString* m_playfile;
    int bAudioStatus;
    BOOL b_released;
    int m_frame_rate;
}

@property (assign) id<view_player_local_interface>delegate;
@property (assign) int m_index;
@property (retain) foler_item* m_file_item;
@property (retain) VideoWnd* m_play_view;
@property (retain) vv_local_player* m_player;
@property (strong, nonatomic) UIActivityIndicatorView* videoIndicator;
@property (strong, nonatomic) UITapGestureRecognizer* singleTap;
@property (strong, nonatomic) UITapGestureRecognizer* doubleTap;
@property (strong, nonatomic) UIPinchGestureRecognizer* pinchiGestur;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestur;
@property (assign) int playing_state;
@property (assign) BOOL bSelected;
@property (assign) int bAudioExist;
@property (strong, nonatomic) UIButton* replayButton;
@property (strong, nonatomic) UIView* touchView;


-(id)init:(int)index;
-(void)initview:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height;
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height view_x:(float)view_x
                         view_y:(float)view_y view_width:(float)view_width view_height:(float)view_height;
-(void)setSelected:(BOOL)bselect;
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(void)startplay:(NSString*)filename;
-(int)set_seek:(int)pos;
-(void)set_pause:(BOOL)pause;
-(int)get_cur_sec;
-(BOOL)stopplay;
-(void)release_self;
-(long)get_playhandle;

-(float)getMaxXoffset;
-(void)DisplayChange:(display_point*)points;
-(int)get_video_width;
-(int)get_video_height;

@end
