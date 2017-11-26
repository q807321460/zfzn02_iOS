//
//  vv_playback_player.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/9/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "display_point.h"

@protocol vv_playback_player_interface <NSObject>
@optional
-(void)on_play_audio_cap_callback:(int)exist play_id:(int)index;
-(void)on_play_status_callback:(int)status progress:(int)progress play_id:(int)index;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data;
@end


@interface vv_playback_player : NSObject
@property (assign) id<vv_playback_player_interface>delegate;

-(id)init:(int)playindex fisheyetype:(int)fisheyetype left:(float)left right:(float)right top:(float)top bottom:(float)bottom;
-(void)set_surfaceview:(UIView*)view;
-(BOOL)stop_play;
-(int)start_play:(int)chlid  devid:(NSString*)dev_id  user:(NSString*)user pass:(NSString*)pass start_time:(NSString*)start_time;
-(int)get_cur_frame_utctime;
-(int)get_first_frame_utctime;
-(int)get_index;
-(int)set_audio_status:(int)status;
-(int)get_audio_status;
-(void)snap_picture;
-(long)get_playhandle;
-(float)get_maxX_offset;
-(void)display_change:(display_point*)points;
-(int)get_video_width;
-(int)get_video_height;
-(BOOL)change_playmode:(int)mode_to;
@end
