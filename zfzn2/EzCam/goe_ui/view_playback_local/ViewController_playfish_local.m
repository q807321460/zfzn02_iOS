//
//  ViewController_playfish_local.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController_playfish_local.h"

#define YDIMG(__name) [UIImage imageNamed:__name]


#pragma mark - UIImage (YDSlider)

@interface UIImage (ViewController_playfish_local)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@implementation UIImage (ViewController_playfish_local)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end

#pragma mark - YDSlider

@interface ViewController_playfish_local ()

@end

@implementation ViewController_playfish_local
@synthesize view_main;
@synthesize view_top_tool;
@synthesize button_top_tool;
@synthesize label_top_tool;
@synthesize bottom_toolbar;
@synthesize button_audio_play;
@synthesize button_play_ctrl;
@synthesize view_slider;
@synthesize slider_play;
@synthesize label_cur_time;
@synthesize label_end_time;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    is_portrait=true;
    bManualDrag=false;
    bSteping=false;
    bPause=false;
   
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    m_share_item=[share_item getInstance];
    m_start_play_file=m_share_item.cur_foler_item.m_full_name;
    goe_Http=[ppview_cli getInstance];
    //m_voice_talk=[CVoiceTalk getInstance];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
    m_portrait_width=MyShareData.screen_width;
    m_portrait_height=MyShareData.screen_height-MyShareData.status_bar_height-MyShareData.screen_y_offset;
    
    m_landscape_width=MyShareData.screen_height;
    m_landscape_height=MyShareData.screen_width-MyShareData.status_bar_height;
    
    m_y_offset=MyShareData.screen_y_offset;
    view_main.frame=CGRectMake(0, m_y_offset, m_portrait_width, m_portrait_height);
    //view_main.backgroundColor=UIColorFromRGB(m_strings.background_gray);
    
    f_view_top_tool_height=44;
    f_slider_view_height=31;
    view_top_tool.frame=CGRectMake(0, 0, m_portrait_width, f_view_top_tool_height);
    //[view_top_tool setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    button_top_tool.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    label_top_tool.frame=CGRectMake(f_view_top_tool_height, 0, (m_portrait_width/2-f_view_top_tool_height)*2, f_view_top_tool_height);
    label_top_tool.text=NSLocalizedString(@"m_local_playback", @"");
    
    bottom_toolbar.frame = CGRectMake(0, m_portrait_height-44, m_portrait_width, f_view_top_tool_height);
    
    [button_audio_play setEnabled:false];
    m_audio_button_state=-1;
    
    m_portrait_playview_width=m_portrait_width;
    m_portrait_playview_height=m_portrait_height-f_view_top_tool_height*2;
   
    
    video_width=0;
    video_height=0;
    if (video_width<=0 || video_height<=0) {
        video_width=320;
        video_height=240;
    }
    m_view_width=m_portrait_width;
    m_view_height=(m_view_width*video_height)/video_width;
    if (m_view_height>(m_portrait_playview_height-f_slider_view_height)) {
        m_view_height=(m_portrait_playview_height-f_slider_view_height);
    }
    
   
    //[m_voice_talk vv_audio_start_type0];
    
     NSRange range0 = [m_start_play_file rangeOfString:@"type="];
     NSRange range1 = [m_start_play_file rangeOfString:@"left="];
     NSRange range2 = [m_start_play_file rangeOfString:@"right="];
     NSRange range3 = [m_start_play_file rangeOfString:@"top="];
     NSRange range4 = [m_start_play_file rangeOfString:@"bottom="];
     NSRange range5 = [m_start_play_file rangeOfString:@".fishvvi"];
     
     int location0=(int)(range0.location+range0.length);
     int location1=(int)(range1.location+range1.length);
     int location2=(int)(range2.location+range2.length);
     int location3=(int)(range3.location+range3.length);
     int location4=(int)(range4.location+range4.length);
    if (range0.length==0 || range1.length==0 || range2.length==0 || range3.length==0 || range4.length==0 || range5.length==0) {
        return;
    }
     
     int m_video_fishtype = [[m_start_play_file substringWithRange:NSMakeRange(location0, range1.location-location0)]intValue];
     float m_video_space_left = [[m_start_play_file substringWithRange:NSMakeRange(location1, range2.location-location1)]floatValue];
     float m_video_space_right = [[m_start_play_file substringWithRange:NSMakeRange(location2, range3.location-location2)]floatValue];
     float m_video_space_top = [[m_start_play_file substringWithRange:NSMakeRange(location3, range4.location-location3)]floatValue];
     float m_video_space_bottom = [[m_start_play_file substringWithRange:NSMakeRange(location4, range5.location-location4)]floatValue];
    
    m_view_player = [[view_player_playfish_local alloc]init:0 fisheye_type:m_video_fishtype top:m_video_space_top bottom:m_video_space_bottom left:m_video_space_left right:m_video_space_right];
    m_view_player.m_file_item = m_share_item.cur_foler_item;
    float x_pos=0;
    float y_pos=((m_portrait_playview_height-m_view_height-f_slider_view_height)/2)+44;
    //m_view_player.bSelected=true;
    [m_view_player initview:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
    [view_main addSubview:m_view_player.touchView];
    view_slider.frame=CGRectMake(0, y_pos+m_view_height, m_view_width, f_slider_view_height);
    slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
    label_cur_time.frame=CGRectMake(2, 21, 40, 10);
    label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);
    [view_main bringSubviewToFront:view_slider];
    
    m_view_player.delegate=self;
    
    [m_view_player start_play:m_start_play_file];
    [slider_play setThumbImage:[UIImage imageNamed:@"player-progress-point"] forState:UIControlStateNormal];
    [slider_play setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateHighlighted];
    [slider_play setMinimumTrackImage:[YDIMG(@"player-progress-h") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [slider_play setMaximumTrackImage:[YDIMG(@"player-progress") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    slider_play.userInteractionEnabled = NO;
    //slider_play.continuous = NO;
    slider_play.value = 0;
    [self.slider_play addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}
- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    [slider_play setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor] size:maximumTrackImage.size] forState:UIControlStateNormal];
}

- (IBAction)slider_begin_drag:(id)sender {
    //NSLog(@"slider_begin_drag......");
    bManualDrag=true;
}



- (IBAction)slider_end_drag:(id)sender {
    //NSLog(@"slider_end_drag......");
    int curvalue=(int)slider_play.value;
    [m_view_player set_seek:curvalue];
    bManualDrag=false;
    if (bPause==true) {
        bPause=false;
        [m_view_player set_pause:bPause];
        [button_play_ctrl setBackgroundImage:[UIImage imageNamed:@"png_playback_stop_white.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)slider_end_drag_out:(id)sender {
    //NSLog(@"slider_end_drag_out......");
    int curvalue=(int)slider_play.value;
    [m_view_player set_seek:curvalue];
    bManualDrag=false;
    if (bPause==true) {
        bPause=false;
        [m_view_player set_pause:bPause];
        [button_play_ctrl setBackgroundImage:[UIImage imageNamed:@"png_playback_stop_white.png"] forState:UIControlStateNormal];
    }
}

-(void)sliderChanged:(id)sender
{
    int curvalue=(int)slider_play.value;
    //NSLog(@"sliderChanged:%d",curvalue);
    NSString* str_cur_time=[self getCurStr:curvalue];
    label_cur_time.text=str_cur_time;
}
- (IBAction)button_return_click:(id)sender {
    
    [_playTimer invalidate];
    MyShareData=nil;
    m_strings=nil;
    
    
    [m_view_player release_self];
    //[m_voice_talk vv_audio_stop_anyway];
    m_view_player=nil;
    goe_Http=nil;
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
    }];
    
}
-(void)hiddentoolbar{
    if (is_portrait==false) {
        view_top_tool.hidden = true;
        bottom_toolbar.hidden = true;
    }
    
}
- (IBAction)button_audio_play_onclick:(id)sender {
    
    if (m_view_player.bAudioExist==0) {
        return;
    }
    int cur_status=[m_view_player getaudiostatus];
    if (cur_status==0) {
        cur_status=1;
    }
    else{
        cur_status=0;
    }
    [m_view_player Setaudiostatus:cur_status];
    m_audio_button_state=cur_status;
    [self set_audio_button_state];
}
- (IBAction)button_play_ctrl_onclick:(id)sender {
    if (bPause==false) {
        bPause=true;
    }
    else{
        bPause=false;
    }
    if (bPause==true) {
        [button_play_ctrl setBackgroundImage:[UIImage imageNamed:@"png_playback_play_white.png"] forState:UIControlStateNormal];
    }
    else{
        [button_play_ctrl setBackgroundImage:[UIImage imageNamed:@"png_playback_stop_white.png"] forState:UIControlStateNormal];
    }
    [m_view_player set_pause:bPause];
}
-(void)set_audio_button_state
{
    //-1 灰显  0 关闭 1 打开
    switch (m_audio_button_state) {
        case -1:
            button_audio_play.enabled=false;
            [button_audio_play setBackgroundImage:[UIImage imageNamed:@"vv_volumnOff_disabled.png"] forState:UIControlStateNormal];
            break;
        case 0:
            button_audio_play.enabled=true;
            [button_audio_play setBackgroundImage:[UIImage imageNamed:@"vv_volumnOff_disabled.png"] forState:UIControlStateNormal];
            break;
        case 1:
            button_audio_play.enabled=true;
            [button_audio_play setBackgroundImage:[UIImage imageNamed:@"vv_volumnOn.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
-(void)setsliderPos
{
    if(bManualDrag==true || bPause==true)
        return;
    m_cur_sec=[m_view_player get_cur_sec];
    //NSLog(@"setsliderPos  cur_pos=%d",m_cur_sec);
    if (m_cur_sec==m_total_time && bSteping==true) {
        bSteping=false;
    }
    else
        bSteping=true;
    if (bSteping==true) {
        slider_play.value=m_cur_sec;
        NSString* str_cur_time=[self getCurStr:m_cur_sec];
        label_cur_time.text=str_cur_time;
    }
    
}
-(void)init_slider_info
{
    slider_play.userInteractionEnabled = YES;
    //slider_play.continuous = NO;
    slider_play.value = 0;
    slider_play.maximumValue=m_total_time;
    NSString* str_end_time=[self getCurStr:m_total_time];
    NSLog(@"init_slider_info,  str_end_time=%@",str_end_time);
    label_end_time.text=str_end_time;
    //[self video_size_changed];
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setsliderPos) userInfo:nil repeats:YES];
}
-(void)on_play_ok_callback:(int)index total_sec:(int)total_sec
{
    m_total_time=total_sec;
    [self performSelectorOnMainThread:@selector(init_slider_info) withObject:nil waitUntilDone:YES];
    
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

-(void)on_audiostatus_callback:(int)exist play_id:(int)index
{
     m_audio_button_state=exist;
    
    [self performSelectorOnMainThread:@selector(set_audio_button_state) withObject:nil waitUntilDone:YES];
}


- (BOOL)prefersStatusBarHidden
{
    if (is_portrait==false) {
        return YES;
    }
    else{
        return NO;
    }
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    toOrientation = toInterfaceOrientation;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ((fromInterfaceOrientation == UIDeviceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)&&(toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight)) {
        //NSLog(@"横屏");
        is_portrait=false;
        if (MyShareData.m_sys_version >=7) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        else{
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        }
        view_main.frame=CGRectMake(0, 0, m_landscape_width, m_landscape_height);
        view_top_tool.frame=CGRectMake(0, 0, m_landscape_width, f_view_top_tool_height);
        button_top_tool.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
        label_top_tool.frame=CGRectMake(f_view_top_tool_height, 0, (m_landscape_width/2-f_view_top_tool_height)*2, f_view_top_tool_height);
        
        bottom_toolbar.frame = CGRectMake(0, m_landscape_height-44, m_landscape_width, 44);
        
        
        view_top_tool.hidden = YES;
        bottom_toolbar.hidden = YES;
        view_top_tool.alpha = 0.6;
        bottom_toolbar.alpha = 0.6;
        [view_main bringSubviewToFront:view_top_tool];
        [view_main bringSubviewToFront:bottom_toolbar];
        m_view_height=m_landscape_height;
        m_view_width=m_landscape_width;
        float x_pos=0;
        float y_pos=0;
        [m_view_player resizeview_by_screentype:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
        view_slider.frame=CGRectMake(0, m_landscape_height-f_slider_view_height-f_view_top_tool_height, m_view_width, f_slider_view_height);
        slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
        label_cur_time.frame=CGRectMake(2, 21, 40, 10);
        label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);
        view_slider.alpha=0.6;
        view_slider.hidden=YES;
        
    }
    
    else if((fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown)){
        //NSLog(@"竖屏");
        is_portrait=true;
        if (MyShareData.m_sys_version >=7) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        else{
            //[self setNeedsStatusBarAppearanceUpdate];
            [[UIApplication sharedApplication] setStatusBarHidden:false];
        }
        
        view_main.frame=CGRectMake(0, m_y_offset, m_portrait_width, m_portrait_height);
        
        view_top_tool.frame=CGRectMake(0, 0, m_portrait_width, f_view_top_tool_height);
        button_top_tool.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
        label_top_tool.frame=CGRectMake(f_view_top_tool_height, 0, (m_portrait_width/2-f_view_top_tool_height)*2, f_view_top_tool_height);
        
        
        bottom_toolbar.frame = CGRectMake(0, m_portrait_height-44, m_portrait_width, 44);
        
        
        view_top_tool.hidden = NO;
        bottom_toolbar.hidden = NO;
        view_top_tool.alpha = 1;
        bottom_toolbar.alpha = 1;
        
        if (video_width<=0 || video_height<=0) {
            video_width=320;
            video_height=240;
        }
        m_view_width=m_portrait_width;
        m_view_height=(m_view_width*video_height)/video_width;
        if (m_view_height>m_portrait_playview_height) {
            m_view_height=m_portrait_playview_height;
        }
        float x_pos=0;
        float y_pos=((m_portrait_playview_height-m_view_height-f_slider_view_height)/2)+44;
        [m_view_player resizeview_by_screentype:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
        
        
        view_slider.frame=CGRectMake(0, y_pos+m_view_height, m_view_width, f_slider_view_height);
        slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
        label_cur_time.frame=CGRectMake(2, 21, 40, 10);
        label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);
        view_slider.alpha=1.0;
        view_slider.hidden=NO;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
