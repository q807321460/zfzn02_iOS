//
//  view_player_playbacklocal.m
//  ppview_zx
//
//  Created by zxy on 15-2-9.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "view_player_playbacklocal.h"

@implementation view_player_playbacklocal

@synthesize  m_index;
@synthesize m_file_item;
@synthesize m_play_view;
@synthesize m_player;
@synthesize videoIndicator;
@synthesize singleTap;
@synthesize doubleTap;
@synthesize pinchiGestur;
@synthesize panGestur;
@synthesize playing_state;
@synthesize bSelected;
@synthesize bAudioExist;
@synthesize replayButton;
@synthesize touchView;
@synthesize delegate;

-(id)init:(int)index
{
    self=[super init];
    m_index=index;
    replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replayButton setImage:[UIImage imageNamed:@"png_again.png"] forState:UIControlStateNormal];
    playing_state = -1;//-1:未播放 0：请求播放中  1：播放中
    b_released=false;
    goe_Http=[ppview_cli getInstance];
    m_strings=[vv_strings getInstance];
    MyShareData=[zxy_share_data getInstance];
    return self;
}
-(void)initview:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height
{
    touchView = [[UIView alloc]initWithFrame:CGRectMake(bg_x, bg_y, bg_widht, bg_height)];
    touchView.backgroundColor = [UIColor darkGrayColor];

    touchView.layer.borderWidth = 1.0f;
    replayButton.frame = CGRectMake(0, 0, 40, 40);
    replayButton.center = CGPointMake(bg_widht/2, bg_height/2);
    //[replayButton addTarget:self action:@selector(replayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [touchView addSubview:replayButton];
    replayButton.hidden = YES;
    
    m_play_view = [[VideoWnd alloc]initWithFrame:CGRectMake(0, 0, bg_widht,bg_height)];
    [touchView addSubview:m_play_view];
    videoIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    videoIndicator.center = CGPointMake(bg_widht/2, bg_height/2);
    videoIndicator.hidesWhenStopped = YES;
    m_play_view.backgroundColor = [UIColor darkGrayColor];
    [m_play_view addSubview:videoIndicator];
    //m_player=[[CPlayer alloc]init:m_index with_contentscale:MyShareData.content_scale];
    m_player=[[vv_local_player alloc]init:m_index fisheye_type:0 left:0 right:0 top:0 bottom:0];
    [m_player set_surfaceview:m_play_view];
    m_player.delegate=self;
    playing_state=-1;
}
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height
{
    
    touchView.frame = CGRectMake(bg_x, bg_y, bg_widht, bg_height);
    //touchView.backgroundColor = [UIColor blackColor];
    
    replayButton.frame = CGRectMake(0, 0, 40, 40);
    replayButton.center = CGPointMake(bg_widht/2, bg_height/2);
    
    m_play_view.frame= CGRectMake(0, 0, bg_widht,bg_height) ;
    videoIndicator.center = CGPointMake(bg_widht/2, bg_height/2);
    /*
    if (bSelected==true) {
        touchView.layer.borderColor = UIColorFromRGB(m_strings.background_blue).CGColor;
    }
    else
        touchView.layer.borderColor = [UIColor whiteColor].CGColor;
     */
    if (playing_state>0) {
        //[m_player onSurfaceChanged:m_play_view];
    }
}
-(void)resizeview_by_screentype:(float)bg_x bg_y:(float)bg_y bg_widht:(float)bg_widht bg_height:(float)bg_height view_x:(float)view_x
                         view_y:(float)view_y view_width:(float)view_width view_height:(float)view_height
{
    
    touchView.frame = CGRectMake(bg_x, bg_y, bg_widht, bg_height);
    //touchView.backgroundColor = [UIColor blackColor];
    
    replayButton.frame = CGRectMake(0, 0, 40, 40);
    replayButton.center = CGPointMake(bg_widht/2, bg_height/2);
    
    m_play_view.frame= CGRectMake(view_x, view_y, view_width,view_height) ;
    videoIndicator.center = CGPointMake(view_width/2, view_height/2);
    /*
    if (bSelected==true) {
        touchView.layer.borderColor = UIColorFromRGB(m_strings.background_blue).CGColor;
    }
    else
        touchView.layer.borderColor = [UIColor whiteColor].CGColor;
     */
    if (playing_state>0) {
        //[m_player onSurfaceChanged:m_play_view];
    }
    
}

-(void) Setaudiostatus:(int)status
{
    if (bAudioExist==0|| bAudioStatus==status) {
        return;
    }
    bAudioStatus=status;
    [m_player set_audio_status:bAudioStatus];
    
}
-(int)set_seek:(int)pos
{
    return[m_player set_seek:pos];
}
-(int)get_cur_sec
{
    return [m_player get_cur_sec];
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
    /*
    if (bSelected==true) {
        touchView.layer.borderColor = UIColorFromRGB(m_strings.background_blue).CGColor;
    }
    else
        touchView.layer.borderColor = [UIColor whiteColor].CGColor;
    */
}

-(void)indicatorStop_fail{
    //NSLog(@"indicator fail...");
    [videoIndicator stopAnimating];
    replayButton.hidden = NO;
    m_play_view.hidden = YES;
}
-(void)indicatorStop_success{
    //NSLog(@"indicator ok...");
    [videoIndicator stopAnimating];
    m_play_view.hidden = NO;
    replayButton.hidden = YES;
}
-(void)indicatorLabel_referesh{
    //NSLog(@"indicator ok...");
    [videoIndicator stopAnimating];
    m_play_view.hidden = NO;
    replayButton.hidden = YES;
}
-(void)indicatorStart{
    [videoIndicator startAnimating];
    m_play_view.hidden = NO;
}

-(void)replayButtonOnClick:(id)sender{
    [self stopplay];
    [self startplay:m_playfile];
}
-(void)startplay:(NSString*)filename
{
    
    if (filename==nil || m_player==nil) {
        return;
    }
    if (playing_state>=0) {
        return;
    }
    m_playfile=filename;
    playing_state=0;
    [self performSelectorOnMainThread:@selector(indicatorStart) withObject:nil waitUntilDone:YES];
    [m_player start_play:m_playfile];
}
-(void)set_pause:(BOOL)pause
{
    [m_player set_pause:pause];
}
-(float)getMaxXoffset
{
    return [m_player get_maxX_offset];
}
- (void)DisplayChange:(display_point*)points
{
    [m_player display_change:points];
}

-(long)get_playhandle
{
    return [m_player get_playhandle];
}
-(BOOL)stopplay
{
    
    //NSLog(@"view_player, stop-------------0");
    playing_state=-1;
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

-(void)on_play_status_callback:(int)status play_id:(int)index total_sec:(long)total_sec
{
    NSLog(@"view_player, on_play_status_callback, status=%d",status);
    if (b_released==true) {
        return;
    }
    if (status==-1) {
        playing_state = -1;
        //NSLog(@"view_player, stop-------------3");
        //[m_player stop_play];
        [self performSelectorOnMainThread:@selector(indicatorStop_fail) withObject:nil waitUntilDone:YES];
    }
    else
    {
        playing_state = 1;
        [self performSelectorOnMainThread:@selector(indicatorStop_success) withObject:nil waitUntilDone:YES];
        
        if ([delegate respondsToSelector:@selector(on_play_ok_callback:total_sec:)]) {
            [delegate on_play_ok_callback:index total_sec:total_sec];
            
        }
    }
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    if ([delegate respondsToSelector:@selector(on_resolution_changed_callback:height:index:)]) {
        [delegate on_resolution_changed_callback:width height:height index:index];
    }
}
-(int)get_video_width
{
    return [m_player get_video_width];
}
-(int)get_video_height
{
    return [m_player get_video_height];
}
@end
