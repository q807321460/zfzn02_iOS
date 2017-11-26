//
//  view_player_playback_v2.m
//  pano360
//
//  Created by zxy on 2017/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "view_player_playback_v2.h"

@implementation view_player_playback_v2
@synthesize  m_index;
@synthesize m_cam_item;
@synthesize m_play_view;
@synthesize m_player;
@synthesize cachelabel;
@synthesize singleTap;
@synthesize doubleTap;
@synthesize pinchiGestur;
@synthesize panGestur;
@synthesize playing_state;
@synthesize bSelected;
@synthesize bAudioExist;
@synthesize touchView;
@synthesize timer;
@synthesize delegate;
@synthesize indicator_back;

-(id)init:(int)index
{
    self=[super init];
    m_index=index;
    playing_state = -1;//-1:未播放 0：请求播放中  1：播放中
    b_released=false;
    goe_Http=[ppview_cli getInstance];
    m_strings=[vv_strings getInstance];
    MyShareData=[zxy_share_data getInstance];
    m_fisheye_type=0;
    //bAudioExist=1;
    return self;
}
-(void)initview:(UIView*)touchview_in with_indicator_back:(UIView*)indicator_back_in with_cachelabel:(UILabel*)cachelabel_in with_playview:(VideoWnd*)playview_in
{
    self.touchView=touchview_in;
    self.indicator_back=indicator_back_in;
    self.cachelabel=cachelabel_in;
    self.m_play_view=playview_in;
    
    [indicator_back setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [indicator_back.layer setCornerRadius:5.0];
    //[videoIndicator startAnimating];

    m_play_view.backgroundColor = [UIColor blackColor];

    indicator_back.hidden=true;
    
    cachelabel.text=@"0%";
    cachelabel.hidden=true;

    m_fisheye_type=m_cam_item.m_fisheyetype;
    if (m_cam_item.is_stream_process==false) {
        [m_cam_item process_stream];
    }
    
    m_player=[[vv_playback_player alloc] init:m_index fisheyetype:m_fisheye_type left:m_cam_item.main_stream.m_fish_left right:m_cam_item.main_stream.m_fish_right top:m_cam_item.main_stream.m_fish_top bottom:m_cam_item.main_stream.m_fish_bottom];
    
    [m_player set_surfaceview:m_play_view];
    m_player.delegate=self;
    playing_state=-1;
}

-(void) Setaudiostatus:(int)status
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
-(void)setSelected:(BOOL)bselect
{
    if (bSelected==bselect) {
        return;
    }
    bSelected=bselect;
    
}
-(void)check_playresult:(id)sender{
    if (timer == sender) {
        [self stopplay];
        [self performSelectorOnMainThread:@selector(indicatorStop_fail) withObject:nil waitUntilDone:YES];
    }
}
-(void)indicatorStop_fail{
    //NSLog(@"indicator fail...");
    [timer invalidate];
    indicator_back.hidden=true;
    
    //replayButton.hidden = NO;
    m_play_view.hidden = YES;
}
-(void)indicatorStop_success{
    //NSLog(@"indicator ok...");
    [timer invalidate];
    indicator_back.hidden=true;
    
    m_play_view.hidden = NO;
    //replayButton.hidden = YES;
}
-(void)indicatorStart{
    cachelabel.hidden=true;
    indicator_back.hidden=false;
    [touchView bringSubviewToFront:indicator_back];
    timer = [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(check_playresult:) userInfo:nil repeats:NO];
}
-(void)indicatorStart_label{
    //NSLog(@"indicator ok...");
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
        // [videoIndicator startAnimating];
        cachelabel.hidden=false;
        cachelabel.text=[NSString stringWithFormat:@"%d%%",m_cache_progress];
    }
}
-(void)indicatorStop_label{
    NSLog(@"indicator ok...");
    indicator_back.hidden=true;
    // [videoIndicator stopAnimating];
    m_play_view.hidden = NO;
    cachelabel.hidden=true;
    //replayButton.hidden = YES;
}
-(void)replayButtonOnClick:(id)sender{
    [self stopplay];
    // [self startplay];
}
-(void)startplay:(NSString*)playtime
{
    
    if (m_cam_item==nil) {
        return;
    }
    if (playing_state>=0) {
        return;
    }
    //NSLog(@"view_player, m_cam_item.m_play_type=%d",m_cam_item.m_play_type);
    playing_state=0;
    m_fisheye_type=m_cam_item.m_fisheyetype;
    [self performSelectorOnMainThread:@selector(indicatorStart) withObject:nil waitUntilDone:YES];
    [m_player start_play:m_cam_item.m_chlid devid:m_cam_item.m_devid user:m_cam_item.m_dev_user pass:m_cam_item.m_dev_pass start_time:playtime];
}

-(float)getMaxXoffset
{
    if (m_fisheye_type==0) {
        return [m_player get_maxX_offset];
    }
    return 0;
}
- (void)DisplayChange:(display_point*)points
{
    
    if (m_fisheye_type==0) {
        [m_player display_change:points];;
    }
    return;
}

-(long)get_playhandle
{
    return [m_player get_playhandle];
}
-(BOOL)stopplay
{
    
    //NSLog(@"view_player_playback, stop-------------0");
    playing_state=-1;
    [timer invalidate];
    if (m_play_view.hidden==false) {
        m_play_view.hidden=true;
    }
    
    //NSLog(@"view_player_playback, stop-------------1");
    if (m_fisheye_type==0) {
        //NSLog(@"view_player_playback, stop-------------2");
        return[m_player stop_play];
    }
    else if(m_fisheye_type==1 || m_fisheye_type==2){
        //NSLog(@"view_player_playback, stop-------------3");
        return[m_player stop_play];
    }
    //NSLog(@"view_player_playback, stop-------------4");
    return false;
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
    indicator_back.hidden=true;
    //[videoIndicator stopAnimating];
    //replayButton.hidden = NO;
    m_play_view.hidden = YES;
    [OMGToast showWithText:NSLocalizedString(@"m_max_connect", @"")];
}
-(void)indicatorStop_fail_errusr{
    [timer invalidate];
    indicator_back.hidden=true;
    //[videoIndicator stopAnimating];
    //replayButton.hidden = NO;
    m_play_view.hidden = YES;
    [OMGToast showWithText:NSLocalizedString(@"err_414", @"")];
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
    else if(status==203 || status==414){
        playing_state = -1;
        [self performSelectorOnMainThread:@selector(indicatorStop_fail_errusr) withObject:nil waitUntilDone:YES];
        
    }
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    if ([delegate respondsToSelector:@selector(on_resolution_changed_callback:height:index:)]) {
        [delegate on_resolution_changed_callback:index height:height index:width];
    }
}
-(int)get_cur_frame_utctime
{
    if (m_fisheye_type==0) {
        return [m_player get_cur_frame_utctime];
    }
    else if(m_fisheye_type==1 || m_fisheye_type==2){
        return [m_player get_cur_frame_utctime];
    }
    return 0;
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
    
    
    if (m_fisheye_type==0) {
        [m_player snap_picture];
    }
    else if(m_fisheye_type==1 || m_fisheye_type==2){
        [m_player snap_picture];
    }
    
}
-(int)get_video_width
{
    
    if (m_fisheye_type==0) {
        return [m_player get_video_width];
    }
    else if(m_fisheye_type==1 || m_fisheye_type==2){
        return [m_player get_video_width];
    }
    return 0;
}
-(int)get_video_height
{
    
    if (m_fisheye_type==0) {
        return [m_player get_video_height];
    }
    else if(m_fisheye_type==1 || m_fisheye_type==2){
        return [m_player get_video_height];
    }
    return 0;
}
@end
