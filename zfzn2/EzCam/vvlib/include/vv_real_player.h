//
//  vv_real_player.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/9/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "display_point.h"



@protocol vv_real_play_interface <NSObject>
@optional
-(void)on_play_audio_cap_callback:(int)exist play_id:(int)index;
-(void)on_play_status_callback:(int)status play_id:(int)index tag:(NSString*)tag;
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data;
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index;

@end

@interface vv_real_player : NSObject
@property (assign) id<vv_real_play_interface>delegate;

-(id)init:(int)playindex fisheyetype:(int)fisheyetype left:(float)left right:(float)right top:(float)top bottom:(float)bottom;
-(void)set_fisheye_param:(float)left right:(float)right top:(float)top bottom:(float)bottom;
-(void)set_surfaceview:(UIView*)view;
-(void)stop_play;
-(int)start_play:(int)chlid stream_id:(int)stream_id  devid:(NSString*)dev_id  user:(NSString*)user pass:(NSString*)pass;

-(BOOL)start_record:(NSString*)video_filename thumbil_filename:(NSString*)thumbil_filename;
-(BOOL)stop_record;
-(int)get_stream_flow_info:(long long*)total avg:(int*)avg curr:(int*)curr;
-(int)get_index;
-(int)set_audio_status:(int)status;
-(int)get_audio_status;
-(void)snap_picture;
-(void)set_cam_thumbil_filename:(NSString*)filename;
-(long)get_playhandle;


-(float)get_maxX_offset;
-(void)display_change:(display_point*)points;
-(int)ptz_ctrl:(int)cmd with_speed:(int)speed with_times:(int)times;

-(BOOL)change_playmode:(int)mode_to;
-(int)get_cur_frame_utctime;
@end
