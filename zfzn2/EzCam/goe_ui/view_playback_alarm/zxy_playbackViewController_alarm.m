//
//  zxy_playbackViewController.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "zxy_playbackViewController_alarm.h"
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
@interface zxy_playbackViewController_alarm ()


@end

@implementation zxy_playbackViewController_alarm
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
    m_display_point=[display_point new];
    m_display_point_change=[display_point new];
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
    _isZoomed=false;
    m_maximumZoomScale=3;
    m_last_Scale=1;
  
    m_portrait_width=MyShareData.screen_width;
    m_portrait_height=MyShareData.screen_height-MyShareData.status_bar_height-MyShareData.screen_y_offset;
    
    m_landscape_width=MyShareData.screen_height;
    m_landscape_height=MyShareData.screen_width-MyShareData.status_bar_height;
    
    m_y_offset=MyShareData.screen_y_offset;
    view_main.frame=CGRectMake(0, m_y_offset, m_portrait_width, m_portrait_height);
    
    f_view_top_tool_height=44;
    f_slider_view_height=31;
    view_top_tool.frame=CGRectMake(0, 0, m_portrait_width, f_view_top_tool_height);
    //[view_top_tool setBackgroundColor:UIColorFromRGB(m_strings.background_gray)];
    button_top_tool.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    label_top_tool.frame=CGRectMake(f_view_top_tool_height, 0, (m_portrait_width/2-f_view_top_tool_height)*2, f_view_top_tool_height);
    label_top_tool.text=m_share_item.cur_cam_list_item.m_title;//NSLocalizedString(@"m_playback", @"");
    
    bottom_toolbar.frame = CGRectMake(0, m_portrait_height-44, m_portrait_width, 44);
    
    [button_snap setEnabled:false];
    [button_audio_play setEnabled:false];
    m_audio_button_state=-1;
    m_snap_button_state=-1;
    
    m_portrait_playview_width=m_portrait_width;
    m_portrait_playview_height=m_portrait_height-f_view_top_tool_height*2;
    m_view_player = [[view_player_playback_alarm alloc]init:0 fisheye_type:0];
    m_view_player.m_cam_item = m_share_item.cur_cam_list_item;
  
    video_width=0;
    video_height=0;
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
    float y_pos=((m_portrait_playview_height-m_view_height)/2)+44;
    m_view_player.bSelected=true;
    [m_view_player initview:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
    [view_main addSubview:m_view_player.touchView];
    view_slider.frame=CGRectMake(0, y_pos+m_view_height, m_view_width, f_slider_view_height);
    slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
    label_cur_time.frame=CGRectMake(2, 21, 40, 10);
    label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);
    [view_main bringSubviewToFront:view_slider];

    
    m_view_player.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playback_doubleTapHandle:)];
    m_view_player.doubleTap.numberOfTapsRequired = 2;
    m_view_player.doubleTap.numberOfTouchesRequired = 1;
    [m_view_player.m_play_view addGestureRecognizer:m_view_player.doubleTap];
        
    m_view_player.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playback_singleTapHandle:)];
    m_view_player.singleTap.numberOfTapsRequired = 1;
    m_view_player.singleTap.numberOfTouchesRequired = 1;
    [m_view_player.m_play_view addGestureRecognizer:m_view_player.singleTap];
        
    [m_view_player.singleTap requireGestureRecognizerToFail:m_view_player.doubleTap];
        
        
    m_view_player.pinchiGestur = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zxy_pinchhandle:)];
    m_view_player.pinchiGestur.delegate=self;
    [m_view_player.m_play_view addGestureRecognizer:m_view_player.pinchiGestur];
    m_view_player.panGestur = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(zxy_panhandle:)];
    [m_view_player.panGestur setMinimumNumberOfTouches:1];
    [m_view_player.panGestur setMaximumNumberOfTouches:1];
    m_view_player.panGestur.delegate=self;
    [m_view_player.m_play_view addGestureRecognizer:m_view_player.panGestur];
    
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //NSLog(@"shouldReceiveTouch.....");
    return YES;
    
}

-(void)setZoomScale:(float)scale
{
    [m_view_player DisplayChange:m_display_point];
}
-(void)process_rect
{
    x_width=m_view_width/m_cur_Scale;
    y_height=m_view_height/m_cur_Scale;
    
    m_display_point_change.point0_x=(m_center_point.x+x_width/2)/m_view_width;
    m_display_point_change.point0_y=(m_center_point.y+y_height/2)/m_view_height;
    
    m_display_point_change.point1_x=(m_center_point.x+x_width/2)/m_view_width;
    m_display_point_change.point3_y=(m_center_point.y+y_height/2)/m_view_height;
    
    if (m_center_point.y < y_height/2) {
        m_display_point_change.point1_y=0.0;
        m_display_point_change.point2_y=0.0;
    }
    else{
        m_display_point_change.point1_y=(m_center_point.y-y_height/2)/m_view_height;
        m_display_point_change.point2_y=(m_center_point.y-y_height/2)/m_view_height;
    }
    
    if (m_center_point.x < x_width/2) {
        m_display_point_change.point2_x=0.0;
        m_display_point_change.point3_x=0.0;
    }
    else{
        m_display_point_change.point2_x=(m_center_point.x-x_width/2)/m_view_width;
        m_display_point_change.point3_x=(m_center_point.x-x_width/2)/m_view_width;
    }
    if (m_display_point_change.point0_x>m_display_point.point0_x) {
        m_display_point_change.point0_x=m_display_point.point0_x;
        m_display_point_change.point1_x=m_display_point.point0_x;
    }
    if (m_display_point_change.point0_y>m_display_point.point0_y) {
        m_display_point_change.point0_y=m_display_point.point0_y;
        m_display_point_change.point3_y=m_display_point.point0_y;
    }
}
-(void)playback_doubleTapHandle:(id)sender{
    //NSLog(@"doubleTapHandle");
    if( _isZoomed )
    {
        _isZoomed = NO;
        m_cur_Scale=1.0;
        m_last_Scale=1.0;
        [self setZoomScale:m_cur_Scale];
    }
    else {
        
        _isZoomed = YES;
        m_cur_Scale=m_maximumZoomScale;
        m_last_Scale=m_maximumZoomScale;
        m_center_point = [sender locationInView:m_view_player.m_play_view];
        [self process_rect];
        
        [m_view_player DisplayChange:m_display_point_change];
    }
    //is_slider_mode= !is_slider_mode;
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

- (IBAction)button_snap_onclick:(id)sender {
    [button_snap setEnabled:false];
    [m_view_player snap_picture:1];
}
-(void)playback_singleTapHandle:(id)sender{
    NSLog(@"singleTapHandle");
    if (is_portrait==false) {
        view_top_tool.hidden = !view_top_tool.hidden;
        bottom_toolbar.hidden = !bottom_toolbar.hidden;
        view_slider.hidden= !view_slider.hidden;
    }
}
-(void)zxy_pinchhandle:(UIPinchGestureRecognizer*)recognizer
{
        float scale=recognizer.scale;
        //m_last_Scale
        if (scale<=1.0) {
            if (_isZoomed==NO) {
                return;
            }
            m_cur_Scale -= 0.05;
            
            if (m_cur_Scale<=1.0) {
                m_cur_Scale=1.0;
                [self setZoomScale:1.0];
                _isZoomed = NO;
                m_last_Scale=1;
            }
            else{
                [self process_rect];
                [m_view_player DisplayChange:m_display_point_change];
            }
            //return;
        }
        else if(scale>m_maximumZoomScale){
            //return;
        }
        else{
            _isZoomed = YES;
            m_cur_Scale=m_last_Scale*scale;
            
            if (recognizer.state==UIGestureRecognizerStateBegan){
                if (m_last_Scale==1) {
                    m_center_point = [recognizer locationInView:m_view_player.m_play_view];
                    //NSLog(@"zxy_pinchhandle, ...............get m_center_point");
                }
                
            }
            else if(UIGestureRecognizerStateChanged==recognizer.state)
            {
                [self process_rect];
                [m_view_player DisplayChange:m_display_point_change];
            }
            
        }
        if(recognizer.state == UIGestureRecognizerStateEnded)
        {
            
            m_last_Scale=m_cur_Scale;
            //NSLog(@"zxy_pinchhandle, ..............END, m_cur_Scale=%f",m_cur_Scale);
        }
        return;
}

- (void)zxy_panhandle:(UIPanGestureRecognizer*)recognizer{

        if (_isZoomed==NO) {
            return;
        }
        else{
            if (recognizer.state==UIGestureRecognizerStateBegan) {
                CGPoint point = [recognizer locationInView:m_view_player.m_play_view];
                x1 = point.x;
                y1 = point.y;
            }
            else if (recognizer.state==UIGestureRecognizerStateChanged) {
                CGPoint point = [recognizer locationInView:m_view_player.m_play_view];
                float x2 = point.x;
                float y2 = point.y;
                float x_offset=x2-x1;
                float y_offset=y2-y1;
                x1=x2;
                y1=y2;
                float tmp_x=m_center_point.x-x_offset;
                float tmp_y=m_center_point.y-y_offset;
                
                if (((tmp_x-x_width/2)<0 &&  x_offset>0 ) ||((tmp_x+x_width/2)>m_view_width && x_offset<0)) {
                    tmp_x=m_center_point.x;
                }
                if (((tmp_y-y_height/2)<0 &&  y_offset>0 ) ||((tmp_y+y_height/2)>m_view_height && y_offset<0)) {
                    tmp_y=m_center_point.y;
                }
                if (tmp_x==m_center_point.x && tmp_y==m_center_point.y) {
                    return;
                }
                m_center_point.x=tmp_x;
                m_center_point.y=tmp_y;
                
                [self process_rect];
                [m_view_player DisplayChange:m_display_point_change];
            }
        }
        return;
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
        view_jpg.center=view_main.center;
        
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
        float y_pos=((m_portrait_playview_height-m_view_height)/2)+44;
        [m_view_player resizeview_by_screentype:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
        view_slider.frame=CGRectMake(0, y_pos+m_view_height, m_view_width, f_slider_view_height);
        slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
        label_cur_time.frame=CGRectMake(2, 21, 40, 10);
        label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);
        view_slider.alpha=1.0;
        view_slider.hidden=NO;
        view_jpg.center=view_main.center;
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
    //[self video_size_changed];
    [self init_slider_info];
}
-(void)on_play_ok_callback:(int)index
{
    //NSLog(@"on_play_ok_callback.....");
    m_display_point.point0_x=[m_view_player getMaxXoffset];
    m_display_point.point0_y=1.0;
    
    m_display_point.point1_x=[m_view_player getMaxXoffset];
    m_display_point.point1_y=0.0;
    
    m_display_point.point2_x=0.0;
    m_display_point.point2_y=0.0;
    
    m_display_point.point3_x=0.0;
    m_display_point.point3_y=1.0;
    m_snap_button_state=1;
    [self performSelectorOnMainThread:@selector(process_play_ok_mainthread) withObject:nil waitUntilDone:NO];
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    [self performSelectorOnMainThread:@selector(video_size_changed) withObject:nil waitUntilDone:YES];
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

-(void)video_size_changed
{
    if (is_portrait==true) {
        int tmp_video_width=[m_view_player get_video_width];
        int tmp_video_height=[m_view_player get_video_height];
        if (tmp_video_width==video_width && tmp_video_height==video_height) {
            return;
        }
        
        video_width=tmp_video_width;
        video_height=tmp_video_height;
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
        float y_pos=((m_portrait_playview_height-m_view_height)/2)+44;
        m_view_player.bSelected=true;
       [m_view_player resizeview_by_screentype:x_pos bg_y:y_pos bg_widht:m_view_width bg_height:m_view_height];
        view_slider.frame=CGRectMake(0, y_pos+m_view_height, m_view_width, f_slider_view_height);
        slider_play.frame=CGRectMake(0, 0, m_view_width, f_slider_view_height);
        label_cur_time.frame=CGRectMake(2, 21, 40, 10);
        label_end_time.frame=CGRectMake(m_view_width-40-2, 21, 40, 10);

    }
    else{
        int tmp_video_width=[m_view_player get_video_width];
        int tmp_video_height=[m_view_player get_video_height];
        if (tmp_video_width==video_width && tmp_video_height==video_height) {
            return;
        }
        
        video_width=tmp_video_width;
        video_height=tmp_video_height;
        if (video_width<=0 || video_height<=0) {
            video_width=320;
            video_height=240;
        }
        return;
    }
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
    
    [self video_size_changed];
    
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
    [m_file_manager save_jpg_file:jpgdata with_date:curFolderTime with_name:curFileTime];
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

- (IBAction)button_delete_pic_onclick:(id)sender {
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

@end
