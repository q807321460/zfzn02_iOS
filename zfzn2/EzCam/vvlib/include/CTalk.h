//
//  CTalk.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTalk_interface <NSObject>
@optional
-(void)on_voicetalk_status_callback:(int)status;
@end

@interface CTalk : NSObject
@property (assign) id<CTalk_interface>delgate;

+(CTalk*) getInstance;

-(void)vv_voicetalk_stop;
-(int)vv_voicetalk_start:(long)connector chlid:(int)chlid user:(NSString*)user pass:(NSString*)pass talk_type:(int)talk_type;
-(void)voice_switch:(int)direction;

-(void)record_pause;
-(void)record_resume;
-(void)play_pause;
-(void)play_resume;
@end
