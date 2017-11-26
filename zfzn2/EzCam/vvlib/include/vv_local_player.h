//
//  vv_local_player.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/9/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "display_point.h"

@protocol vv_local_player_interface <NSObject>
@optional
-(void)on_play_audio_cap_callback:(int)exist play_id:(int)index;
-(void)on_play_status_callback:(int)status play_id:(int)index total_sec:(long)total_sec;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
@end

@interface vv_local_player : NSObject
@property (assign) id<vv_local_player_interface>delegate;

-(id)init:(int)playindex fisheye_type:(int)type left:(float)left right:(float)right top:(float)top bottom:(float)bottom;
-(void)set_surfaceview:(UIView*)view;
-(void)set_pause:(BOOL)pause;
-(BOOL)stop_play;
-(int)start_play:(NSString*)filename;
-(int)get_index;
-(int)set_audio_status:(int)status;
-(int)get_audio_status;
-(long)get_playhandle;
-(float)get_maxX_offset;
-(void)display_change:(display_point*)points;
-(int)get_video_width;
-(int)get_video_height;
-(int)get_cur_sec;
-(int)set_seek:(int)pos;
-(int)get_cur_frame_utctime;
-(BOOL)change_playmode:(int)mode_to;
@end
