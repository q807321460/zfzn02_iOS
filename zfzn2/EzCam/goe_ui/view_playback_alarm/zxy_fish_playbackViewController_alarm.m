//
//  zxy_playbackViewController.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "zxy_fish_playbackViewController_alarm.h"
#import "OMGToast.h"
#define YDIMG(__name) [UIImage imageNamed:__name]


#pragma mark - UIImage (YDSlider)

@interface UIImage (ViewController_playback_local)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@implementation UIImage (ViewController_playback_local)
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
@interface zxy_fish_playbackViewController_alarm ()


@end

@implementation zxy_fish_playbackViewController_alarm
@synthesize view_main;
@synthesize view_top_tool;
@synthesize button_top_tool;
@synthesize label_top_tool;
@synthesize bottom_toolbar;

@synthesize button_audio_play;
@synthesize button_snap;

@synthesize view_jpg;
@synthesize imgview_jpg;
@synthesize button_save_to_lib;
@synthesize button_delete_pic;

@synthesize view_slider;
@synthesize slider_play;
@synthesize label_cur_time;
@synthesize label_end_time;

@synthesize view_container;
@synthesize glview_play;
@synthesize video_indicator_back;
@synthesize video_cache_label;
@synthesize button_replay;
@synthesize indicator_play;

@synthesize Constraint_playcontainer_ratio;
@synthesize view_par_top_space;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    is_portrait=true;
    bFullScreen=true;
    bManualDrag=false;
    bSteping=false;
    b_slider_inited=false;
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    m_share_item=[share_item getInstance];
    m_start_play_time=m_share_item.cur_alarm_item.m_play_time;
    m_total_time=m_share_item.cur_alarm_item.m_video_long-1;
    formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyyMMddHHmmss"];
    //m_total_time=120;
    goe_Http=[ppview_cli getInstance];
    m_file_manager=[pic_file_manager getInstance];
    [m_file_manager init_file_path];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
    label_top_tool.text=m_share_item.cur_cam_list_item.m_title;//NSLocalizedString(@"m_playback", @"");
    
    
    
    [button_snap setEnabled:false];
    [button_audio_play setEnabled:false];
    m_audio_button_state=-1;
    m_snap_button_state=-1;
    
    
    
    
    if([m_share_item.cur_cam_list_item is_stream_process]==false){
       [m_share_item.cur_cam_list_item process_stream];
    }
    
    m_view_player = [[view_player_playback_alarm_fish alloc]init:0 fisheye_type:m_share_item.cur_cam_list_item.m_fisheyetype top:m_share_item.cur_cam_list_item.main_stream.m_fish_top bottom:m_share_item.cur_cam_list_item.main_stream.m_fish_bottom left:m_share_item.cur_cam_list_item.main_stream.m_fish_left right:m_share_item.cur_cam_list_item.main_stream.m_fish_right];
    m_view_player.m_cam_item = m_share_item.cur_cam_list_item;
  
    [m_view_player initview:view_container with_indicator_back:video_indicator_back with_replay_button:button_replay with_indicator:indicator_play with_cachelabel:video_cache_label with_playview:glview_play];
   
    m_view_player.bSelected=true;
    
   
    [view_main bringSubviewToFront:view_slider];


    m_view_player.delegate=self;
    [m_view_player startplay:m_start_play_time];
    
    [slider_play setThumbImage:[UIImage imageNamed:@"player-progress-point"] forState:UIControlStateNormal];
    [slider_play setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateHighlighted];
    [slider_play setMinimumTrackImage:[YDIMG(@"player-progress-h") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [slider_play setMaximumTrackImage:[YDIMG(@"player-progress") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    slider_play.userInteractionEnabled = NO;
    //slider_play.continuous = NO;
    slider_play.value = 0;
    [self.slider_play addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willenteredBackground:) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    [slider_play setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor] size:maximumTrackImage.size] forState:UIControlStateNormal];
}

-(void)tmp_start_play
{
    int curvalue=(int)slider_play.value;
    if(curvalue>m_total_time)
        return;
    [self stop_play];
    //[m_view_player stopplay];
    NSString* m_cur_playtime=[self get_cur_playtime:curvalue];
    [m_view_player startplay:m_cur_playtime];
}
-(NSString*)get_cur_playtime:(int)interval
{
    NSDate *start_date = [formatter dateFromString:m_start_play_time];
    NSDate *cur_date = [start_date dateByAddingTimeInterval:interval];
    NSString *strDate = [formatter stringFromDate:cur_date];
    NSLog(@"%@", strDate);
    return strDate;
}
- (IBAction)slider_begin_drag:(id)sender {
    //NSLog(@"slider_begin_drag......");
    bManualDrag=true;
}

- (IBAction)slider_end_drag:(id)sender {
    //NSLog(@"slider_end_drag......");
    bManualDrag=false;
    [self tmp_start_play];
}

- (IBAction)slider_end_drag_out:(id)sender {
    //NSLog(@"slider_end_drag_out......");
    bManualDrag=false;
    [self tmp_start_play];
}

-(void)sliderChanged:(id)sender
{
    int curvalue=(int)slider_play.value;
    NSString* str_cur_time=[self getCurStr:curvalue];
    label_cur_time.text=str_cur_time;
    
}


-(void)willenteredBackground:(NSNotification*) notification{
    [self self_release];
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

- (IBAction)button_snap_onclick:(id)sender {
    [button_snap setEnabled:false];
    [m_view_player snap_picture:1];
}

-(NSString*)format_str:(int)i
{
    
    NSString* s=[NSString stringWithFormat:@"%d",i];
    if(s.length==1){
        s=[NSString stringWithFormat:@"0%d",i];
    }
    return s;
}
-(NSString*)getCurStr:(int)value with_prefix:(NSString*)prefix_str
{
    NSString* tmp=nil;
    int nHour=(int) (value/60);
    int nMinute=(int) (value%60);
    NSString* strHour=[self format_str:nHour];
    NSString* strMinute=[self format_str:nMinute];
    tmp=[NSString stringWithFormat:@"%@%@%@00",prefix_str,strHour, strMinute];
    return tmp;
}
-(void)self_release
{
    [_playTimer invalidate];
    MyShareData=nil;
    m_strings=nil;
    
    goe_Http=nil;
    m_file_manager=nil;
    [m_view_player release_self];
    m_view_player=nil;
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
    }];

}
-(void)stop_play
{
    [_playTimer invalidate];
    [m_view_player stopplay];
}
- (IBAction)button_return_click:(id)sender {
    
    [self self_release];
    
}

-(NSString*)get_err_msg:(int)res
{
    
    NSString* err_msg=nil;
    switch (res) {
        case -98:
            err_msg=NSLocalizedString(@"err_connect_dev", @"");
            break;
        case -6:
            err_msg=NSLocalizedString(@"err_6_record", @"");
            break;
        case 0:
            err_msg=NSLocalizedString(@"err_0", @"");
            break;
        case 199:
            err_msg=NSLocalizedString(@"err_199", @"");
            break;
        case 400:
            err_msg=NSLocalizedString(@"err_400", @"");
            break;
        case 410:
            err_msg=NSLocalizedString(@"err_410", @"");
            break;
        case 203:
            err_msg=NSLocalizedString(@"err_203", @"");
            break;
        case 412:
            err_msg=NSLocalizedString(@"err_412", @"");
            break;
            
        default:
            err_msg=NSLocalizedString(@"err_else", @"");
            break;
    }
    return err_msg;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self setNeedsStatusBarAppearanceUpdate];
        view_top_tool.hidden = YES;
        bottom_toolbar.hidden = YES;
        view_top_tool.alpha = 0.6;
        bottom_toolbar.alpha = 0.6;
        [view_main bringSubviewToFront:view_top_tool];
        [view_main bringSubviewToFront:bottom_toolbar];
       
        view_par_top_space.constant=0;
        //slider_play_bottom_offset.constant=(-31-(MyShareData.screen_height-MyShareData.screen_width)-44);
     
        view_slider.alpha=0.6;
        view_slider.hidden=YES;

        
    }
    
    else if((fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown)){
        //NSLog(@"竖屏");
        is_portrait=true;
       [self setNeedsStatusBarAppearanceUpdate];
       
        view_par_top_space.constant=20;
        view_top_tool.hidden = NO;
        bottom_toolbar.hidden = NO;
        view_top_tool.alpha = 1;
        bottom_toolbar.alpha = 1;
        
        view_slider.alpha=1.0;
        view_slider.hidden=NO;
        
    }
}

- (IBAction)button_stop_play_click:(id)sender {
    if([m_view_player stopplay]==true){
       
        m_audio_button_state=-1;
        m_snap_button_state=-1;
        [self set_audio_button_state];
        [self set_snap_button_state];
    }
}

-(void)process_play_ok_mainthread
{
    [self set_snap_button_state];

    [self init_slider_info];
}
-(void)on_play_ok_callback:(int)index
{
    m_snap_button_state=1;
    [self performSelectorOnMainThread:@selector(process_play_ok_mainthread) withObject:nil waitUntilDone:NO];
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    
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


-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data
{
    jpgdata=data;
    jpg_res=res;
    [self performSelectorOnMainThread:@selector(show_jpg_data) withObject:nil waitUntilDone:NO];
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
    if(bManualDrag==true )
        return;
    m_cur_sec =[m_view_player get_cur_sec];
    if (m_cur_sec>=m_total_time) {
        m_cur_sec=m_total_time;
        slider_play.value=m_cur_sec;
        NSString* str_cur_time=[self getCurStr:m_cur_sec];
        label_cur_time.text=str_cur_time;
        [self stop_play];
        return;
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
    if (b_slider_inited==false) {
        slider_play.userInteractionEnabled = YES;
        slider_play.value = 0;
        slider_play.maximumValue=m_total_time;
        NSString* str_end_time=[self getCurStr:m_total_time];
        label_end_time.text=str_end_time;
        m_cur_sec=0;
        b_slider_inited=true;
    }
    
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setsliderPos) userInfo:nil repeats:YES];
}

-(void)set_snap_button_state
{
    //-1 灰显  0 关闭 1 打开
    switch (m_snap_button_state) {
        case -1:
            button_snap.enabled=false;
            break;
        case 0:
            button_snap.enabled=false;
            break;
        case 1:
            button_snap.enabled=true;
            break;
        default:
            break;
    }
}
-(void)on_audiostatus_callback:(int)exist play_id:(int)index
{
    if (exist==1) {
        m_audio_button_state=1;
        [m_view_player Setaudiostatus:1];
    }
    else
    {
        m_audio_button_state=-1;
    }
    [self performSelectorOnMainThread:@selector(set_audio_button_state) withObject:nil waitUntilDone:YES];
}
-(void)show_jpg_data
{
    if (jpg_res>0) {
        view_jpg.hidden=false;
        [imgview_jpg setImage:[UIImage imageWithData:jpgdata]];
        [view_main bringSubviewToFront:view_jpg];
    }
    else{
        [button_snap setEnabled:true];
        //NSLog(@"snap failed....%d",jpg_res);
    }
}
- (IBAction)button_save_pic_onclick:(id)sender {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    //[formater setDateFormat:@"yyyy.MM.dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    [formater setDateFormat:@"yyyyMMdd"];//这里去掉 具体时间 保留日期
    NSString * curFolderTime = [formater stringFromDate:curDate];
    [formater setDateFormat:@"yyyyMMddHHmmss"];//这里去掉 具体时间 保留日期
    NSString * curFileTime = [formater stringFromDate:curDate];
    //NSLog(@"folder==%@,  file==%@",curFolderTime,curFileTime);
    NSString *mytag=[NSString stringWithFormat:@"type=%dleft=%fright=%ftop=%fbottom=%f",m_share_item.cur_cam_list_item.m_fisheyetype,m_share_item.cur_cam_list_item.main_stream.m_fish_left,m_share_item.cur_cam_list_item.main_stream.m_fish_right,m_share_item.cur_cam_list_item.main_stream.m_fish_top,m_share_item.cur_cam_list_item.main_stream.m_fish_bottom];

    NSString * curFileName = [NSString stringWithFormat:@"%@%@%@",@"fish_",curFileTime,mytag];
    
    [m_file_manager save_jpg_file:jpgdata with_date:curFolderTime with_name:curFileName];
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

- (IBAction)button_delete_pic_onclick:(id)sender {
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

@end
