//
//  view_player_playback_alarm_fish.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "view_player_playback_alarm_fish.h"

@implementation view_player_playback_alarm_fish
@synthesize  m_index;
@synthesize m_cam_item;
@synthesize m_play_view;
@synthesize m_player;
@synthesize videoIndicator;
@synthesize cachelabel;
@synthesize playing_state;
@synthesize bSelected;
@synthesize bAudioExist;
@synthesize replayButton;
@synthesize touchView;
@synthesize timer;
@synthesize delegate;
@synthesize indicator_back;

-(id)init:(int)index fisheye_type:(int)type top:(float)top bottom:(float)bottom left:(float)left right:(float)right
{
    self=[super init];
    m_index=index;
    
    playing_state = -1;//-1:未播放 0：请求播放中  1：播放中
    b_released=false;
    m_first_frame_utc_time=0;
    goe_Http=[ppview_cli getInstance];
    m_strings=[vv_strings getInstance];
    MyShareData=[zxy_share_data getInstance];
    m_fisheye_type=type;
    m_video_space_left=left;
    m_video_space_right=right;
    m_video_space_top=top;
    m_video_space_bottom=bottom;
    return self;
}

-(void)initview:(UIView*)touchview_in with_indicator_back:(UIView*)indicator_back_in with_replay_button:(UIButton*)replaybutton_in with_indicator:(UIActivityIndicatorView*)videoIndicator_in with_cachelabel:(UILabel*)cachelabel_in with_playview:(VideoWnd*)playview_in
{
    self.touchView=touchview_in;
    self.indicator_back=indicator_back_in;
    self.replayButton=replaybutton_in;
    self.videoIndicator=videoIndicator_in;
    self.cachelabel=cachelabel_in;
    self.m_play_view=playview_in;
    
    [self.indicator_back setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.indicator_back.layer setCornerRadius:5.0];
    
    replayButton.hidden = YES;
    [replayButton addTarget:self action:@selector(replayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cachelabel.text=@"0%";
    cachelabel.textColor=[UIColor redColor];
    cachelabel.hidden=true;
    m_player=[[vv_playback_player alloc]init:m_index fisheyetype:m_fisheye_type left:m_video_space_left right:m_video_space_right top:m_video_space_top bottom:m_video_space_bottom];
    [m_player set_surfaceview:m_play_view];
    m_player.delegate=self;
    playing_state=-1;
    
    
}

-(void)Setaudiostatus:(int)status
{
    if (bAudioExist==0|| bAudioStatus==status) {
        return;
    }
    bAudioStatus=status;
    [m_player set_audio_status:bAudioStatus];
}
-(int)getaudiostatus
{
    if (bAudioExist==0) {
        return -1;
    }
    return bAudioStatus;
}

-(void)check_playresult:(id)sender{
    if (timer == sender) {
        [self stopplay];
        [self performSelectorOnMainThread:@selector(indicatorStop_fail) withObject:nil waitUntilDone:YES];
    }
}
-(void)indicatorStop_fail{
    NSLog(@"indicator fail...");
    [timer invalidate];
     indicator_back.hidden=true;
    replayButton.hidden = NO;
    m_play_view.hidden = YES;
    [touchView bringSubviewToFront:replayButton];
}
-(void)indicatorStop_success{
    NSLog(@"indicator ok...");
    
    [timer invalidate];
    indicator_back.hidden=true;
    
    m_play_view.hidden = NO;
    replayButton.hidden = YES;
}
-(void)indicatorStart{
    
    cachelabel.hidden=true;
    indicator_back.hidden=false;
    [touchView bringSubviewToFront:indicator_back];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(check_playresult:) userInfo:nil repeats:NO];
}
-(void)indicatorStart_label{

    
    if ([timer isValid]==true) {
        [timer invalidate];
    }
    if (m_cache_progress==100) {
        indicator_back.hidden=true;
        
        m_play_view.hidden = NO;
        cachelabel.hidden=true;
    }
    else{
        m_play_view.hidden = false;
        indicator_back.hidden=false;
        cachelabel.hidden=false;
        cachelabel.text=[NSString stringWithFormat:@"%d%%",m_cache_progress];
    }
}
-(void)replayButtonOnClick:(id)sender{
    replayButton.hidden = YES;
    [self stopplay];
    [self startplay:m_playtime];
}
-(void)startplay:(NSString*)playtime
{
    if (m_cam_item==nil || m_player==nil) {
        return;
    }
    if (playing_state>=0) {
        return;
    }
    m_playtime=playtime;
    //NSLog(@"view_player, m_cam_item.m_play_type=%d, playtime=%@",m_cam_item.m_play_type,playtime);
    if (m_cam_item.is_stream_process==false) {
        [m_cam_item process_stream];
    }
    playing_state=0;
    [self performSelectorOnMainThread:@selector(indicatorStart) withObject:nil waitUntilDone:YES];
    [m_player start_play:m_cam_item.m_chlid devid:m_cam_item.m_devid user:m_cam_item.m_dev_user pass:m_cam_item.m_dev_pass start_time:playtime ];
}


-(BOOL)stopplay
{
    playing_state=-1;
    [timer invalidate];
    return[m_player stop_play];
}
-(void)release_self
{
    b_released=true;
    
    [m_player set_audio_status:0];
    m_player.delegate=nil;
    [m_player stop_play];
}

-(void)on_play_audio_cap_callback:(int)exist play_id:(int)index
{
    //NSLog(@"view_player, on_play_audiostatus_callback");
    if (b_released==true) {
        return;
    }
    bAudioExist=exist;
    
    if ([delegate respondsToSelector:@selector(on_audiostatus_callback:play_id:)]) {
        [delegate on_audiostatus_callback:bAudioExist play_id:index];
        
    }
    if (bAudioExist==1) {
        [m_player set_audio_status:bAudioStatus];
        
    }
}
-(void)showdialog404{
    [timer invalidate];
    [videoIndicator stopAnimating];
    replayButton.hidden = NO;
    m_play_view.hidden = YES;
    [OMGToast showWithText:NSLocalizedString(@"m_max_connect", @"")];
}
-(void)on_play_status_callback:(int)status progress:(int)progress play_id:(int)index
{
    //NSLog(@"view_player, on_play_status_callback, status=%d",status);
    if (b_released==true) {
        return;
    }
    [timer invalidate];
    if (status==-1) {
        playing_state = -1;
        //NSLog(@"view_player, stop-------------3");
        //[m_player stop_play];
        [self performSelectorOnMainThread:@selector(indicatorStop_fail) withObject:nil waitUntilDone:YES];
    }
    else if(status==1 && progress==-1)
    {
        playing_state = 1;
        if (m_first_frame_utc_time==0) {
            m_first_frame_utc_time=[m_player get_first_frame_utctime];
        }
        
        [self performSelectorOnMainThread:@selector(indicatorStop_success) withObject:nil waitUntilDone:YES];
        if ([delegate respondsToSelector:@selector(on_play_ok_callback:)]) {
            [delegate on_play_ok_callback:index];
            
        }
    }
    else if(status==1 && progress>=0){
        m_cache_progress=progress;
        [self performSelectorOnMainThread:@selector(indicatorStart_label) withObject:nil waitUntilDone:YES];
        
    }
    else if(status==404)
    {
        [self performSelectorOnMainThread:@selector(showdialog404) withObject:nil waitUntilDone:YES];
    }
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    if ([delegate respondsToSelector:@selector(on_resolution_changed_callback:height:index:)]) {
        [delegate on_resolution_changed_callback:width height:height index:index];
    }
}

- (UIImage *)thumbnailWithImage:(UIImage *)image with_size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}

-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data
{
    //NSLog(@"view_player, on_snap_jpg_callback res=%d",res);
    if (snap_src==1){
        if ([delegate respondsToSelector:@selector(on_snap_jpg_callback:jpgdata:)]) {
            [delegate on_snap_jpg_callback:res jpgdata:data];
        }
    }
}

-(void)snap_picture:(int)type
{
    snap_src=type;
    [m_player snap_picture];
}
-(long)get_playhandle
{
    return 0;
}
-(int)get_video_width
{
    return [m_player get_video_width];
}
-(int)get_video_height
{
    return [m_player get_video_height];
}

-(NSString*)format_str:(int)i
{
    
    NSString* s=[NSString stringWithFormat:@"%d",i];
    if(s.length==1){
        s=[NSString stringWithFormat:@"0%d",i];
    }
    return s;
}
-(NSString*)getCurStr:(int)value
{
    NSString* tmp=nil;
    int m_total_min=(int)(value/60);
    //int nHour=(int) (m_total_min/60);
    int nMinute=(int) (m_total_min%60);
    int nSecond=(int)(value%60);
    //NSString* strHour=[self format_str:nHour];
    NSString* strMinute=[self format_str:nMinute];
    NSString* strSec=[self format_str:nSecond];
    tmp=[NSString stringWithFormat:@"%@:%@",strMinute,strSec];
    return tmp;
}
-(int)get_cur_sec
{
    m_cur_frame_utc_time=[m_player get_cur_frame_utctime];
    int m_offset=m_cur_frame_utc_time-m_first_frame_utc_time;
    //NSLog(@"m_offset====%d",m_offset);
    return m_offset;
}

@end
