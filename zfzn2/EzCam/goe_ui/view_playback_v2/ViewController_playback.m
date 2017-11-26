//
//  ViewController_playback.m
//  pano360
//
//  Created by zxy on 2017/1/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController_playback.h"
#import "time_item.h"
#import "NSDate+convenience.h"
#import "OMGToast.h"

@interface ViewController_playback ()

@end

@implementation ViewController_playback
@synthesize view_calendar;
@synthesize m_calendar;
@synthesize query_record_spinner;
@synthesize m_rulerview;
@synthesize button_date_minute;
@synthesize label_ruler_value;
@synthesize view_main;
@synthesize view_container;
@synthesize video_indicator_back;
@synthesize video_cache_label;

@synthesize view_top_tool;
@synthesize button_audio_play;
@synthesize button_snap;

@synthesize label_top_tool;
@synthesize bottom_toolbar;

@synthesize view_jpg;
@synthesize imgview_jpg;
@synthesize button_save_to_lib;
@synthesize button_delete_pic;

@synthesize view_small_slider;
@synthesize label_small_slider;
@synthesize img_left_slider_small;
@synthesize img_right_slider_small;

@synthesize view_small_slider_fish_back;
@synthesize view_small_slider_fish;
@synthesize img_left_sldier_small_fish;
@synthesize img_right_slider_small_fish;
@synthesize label_small_slider_fish;

@synthesize button_ctrl_small_slider_fish;
@synthesize panGestur;

@synthesize Constraint_playcontainer_ratio;
@synthesize view_par_top_space;
@synthesize constraint_playcontainer_offset_center;
@synthesize glview_play;
@synthesize view_rooler_container;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self init_view_value];
    get_timezone=[self get_timezone];
    m_display_point=[display_point new];
    m_display_point_change=[display_point new];
    [[recordlist_manager getInstance] clear];
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    m_share_item=[share_item getInstance];
    goe_Http=[ppview_cli getInstance];
    m_file_manager=[pic_file_manager getInstance];
    //m_voice_talk=[CVoiceTalk getInstance];
    [m_file_manager init_file_path];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    _isZoomed=false;
    m_maximumZoomScale=3;
    m_last_Scale=1;
    
    m_record_manager= [recordlist_manager getInstance];
    
    
    m_audio_button_state=-1;
    m_snap_button_state=-1;
    
    m_view_player = [[view_player_playback_v2 alloc]init:0];
    m_view_player.m_cam_item = m_share_item.cur_cam_list_item;
    
   
    m_fish0_portrait_ratio_constant=self.view.bounds.size.width/4;
    if (m_share_item.cur_cam_list_item.m_fisheyetype==0)
    {
        Constraint_playcontainer_ratio.constant=m_fish0_portrait_ratio_constant;
        
    }
    m_fish0_landscape_ratio_constant=MyShareData.screen_height-MyShareData.screen_width;
    
    m_view_player.bSelected=true;
    if (m_share_item.cur_cam_list_item.is_stream_process==false) {
        [m_share_item.cur_cam_list_item process_stream];
    }
    [m_view_player initview:view_container with_indicator_back:video_indicator_back with_cachelabel:video_cache_label with_playview:glview_play];
    
    if (m_share_item.cur_cam_list_item.m_fisheyetype==0) {
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
    }
    else{
        self.panGestur = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(zxy_panhandle_fish:)];
        [self.panGestur setMinimumNumberOfTouches:1];
        [self.panGestur setMaximumNumberOfTouches:1];
        self.panGestur.delegate=self;
        [view_small_slider_fish_back addGestureRecognizer:self.panGestur];
        
    }
    
    [view_main bringSubviewToFront:view_small_slider];
    
    m_view_player.delegate=self;
    
   
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyyMMdd"];
    m_date_str=[nsdf2 stringFromDate:[NSDate date]];
    //NSLog(@"m_date_str=%@",m_date_str);
    
    [nsdf2 setDateFormat:@"yyyy-MM-dd"];
    m_date_display=[nsdf2 stringFromDate:[NSDate date]];
    //NSLog(@"m_date_str=%@",m_date_str);
    
    
    [nsdf2 setDateFormat:@"yyyyMM"];
    m_date_month_str=[nsdf2 stringFromDate:[NSDate date]];
    
    m_calendar.delegate=self;
    
    bDefaultRecord=true;
    
    h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"zxy_playbackViewController"];
    if (h_connector>0) {
        query_record_result=-1;
        b_query_record=true;
        [query_record_spinner startAnimating];
        goe_Http.cli_devconnect_single_delegate=self;
        goe_Http.cli_c2d_query_record_delegate=self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willenteredBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    m_rulerview.delegate=self;
    
}

-(void)init_view_value
{
    m_date_str=nil;
    b_query_record=false;
    is_portrait=true;
    bFullScreen=false;
    is_zoom_mode=false;
    is_in_dragging=false;
    
    label_ruler_value.layer.cornerRadius=5;
    label_ruler_value.layer.masksToBounds=YES;
    f_small_slider_view_width=80;
    f_small_slider_view_height=60;
    
    [button_snap setEnabled:false];
    [button_audio_play setEnabled:false];
    [button_date_minute setEnabled:false];
    
    [view_small_slider_fish_back setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    label_top_tool.text=NSLocalizedString(@"m_playback", @"");
    
    [button_save_to_lib setTitle:NSLocalizedString(@"m_save_tolib", @"") forState:UIControlStateNormal];
    [button_delete_pic setTitle:NSLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
}

-(void)willenteredBackground:(NSNotification*) notification{
    [self self_release];
}
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate*)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyyMM"];
    NSString* month_str=[nsdf2 stringFromDate:month];
    //NSLog(@"switchedToMonth month_str=%@",month_str);
    if([m_record_manager is_month_exist:m_share_item.cur_cam_list_item.m_devid chldid:m_share_item.cur_cam_list_item.m_chlid date_month:month_str]==false)
    {
        if (b_query_record==true) {
            return;
        }
        [self start_query_month_record_list:month_str];
    }
}
-(NSMutableArray*)calendarView:(VRGCalendarView *)calendarView getDaysFlag:(NSDate*)date;
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyyMM"];
    NSString* month_str=[nsdf2 stringFromDate:date];
    //NSLog(@"month_str=%@",month_str);
    return [m_record_manager get_date_array:m_share_item.cur_cam_list_item.m_devid chldid:m_share_item.cur_cam_list_item.m_chlid date_month:month_str];
}
-(void)stopplay
{
    [self stop_flow_timer];
    if([m_view_player stopplay]==true){
        
        m_audio_button_state=-1;
        m_snap_button_state=-1;
        [self set_audio_button_state];
        [self set_snap_button_state];
    }
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    //NSLog(@"Selected date = %@",date);
    if (b_query_record==true) {
        return;
    }
    b_query_record=true;
    [button_date_minute setEnabled:false];
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyyMMdd"];
    m_date_str=[nsdf2 stringFromDate:date];
    //NSLog(@"m_date_str=%@",m_date_str);
    
    [nsdf2 setDateFormat:@"yyyy-MM-dd"];
    m_date_display=[nsdf2 stringFromDate:date];
    view_calendar.hidden=true;
    
    query_record_result=-1;
    m_date=date;
    
    [self stopplay];
    if (h_connector==0) {
        h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:nil];
        if (h_connector>0) {
            [query_record_spinner startAnimating];
        }
    }
    
    else{
        [query_record_spinner startAnimating];
        [goe_Http cli_lib_record_get_min_list:h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_rec_type:1 with_date:m_date_str];
    }
    
}

-(void)query_next_day:(int)days
{
    NSDate *nextDat = [NSDate dateWithTimeInterval:days*24*60*60 sinceDate:m_date];
    if (b_query_record==true) {
        return;
    }
    b_query_record=true;
    [button_date_minute setEnabled:false];
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyyMMdd"];
    m_date_str=[nsdf2 stringFromDate:nextDat];
    //NSLog(@"m_date_str=%@",m_date_str);
    
    [nsdf2 setDateFormat:@"yyyy-MM-dd"];
    m_date_display=[nsdf2 stringFromDate:nextDat];
    view_calendar.hidden=true;
    
    query_record_result=-1;
    m_date=nextDat;
    
    if (h_connector==0) {
        h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"zxy_playbackViewController"];
        if (h_connector>0) {
            [query_record_spinner startAnimating];
        }
    }
    else{
        [query_record_spinner startAnimating];
        [goe_Http cli_lib_record_get_min_list:h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_rec_type:1 with_date:m_date_str];
    }
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
    m_view_width=glview_play.frame.size.width;
    m_view_height=glview_play.frame.size.height;
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
    is_zoom_mode = !is_zoom_mode;
}
-(void)hiddentoolbar{
    if (is_portrait==false) {
        view_top_tool.hidden = true;
        bottom_toolbar.hidden = true;
    }
    [hiddenTimer invalidate];
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

    if (is_portrait==false) {
        view_top_tool.hidden = !view_top_tool.hidden;
        bottom_toolbar.hidden = !bottom_toolbar.hidden;
        view_rooler_container.hidden= !view_rooler_container.hidden;
        
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

- (void)zxy_panhandle_fish:(UIPanGestureRecognizer*)recognizer{
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:view_small_slider_fish_back];
        x1 = point.x;
        is_in_dragging=true;
        
    }
    else if (recognizer.state==UIGestureRecognizerStateEnded){

        img_left_sldier_small_fish.hidden=false;
        img_right_slider_small_fish.hidden=false;
        int cur_value=m_cur_small_value;
        if(cur_value>[m_record_manager getlastmin]*60)
        {
            is_in_dragging=false;
            return;
        }
        [self stop_flow_timer];
        
        [m_rulerview updateCurrentValue:(float)(cur_value/60)];
        
        [m_view_player stopplay];
        is_in_dragging=false;

        m_start_play_time= [self getCurStr_sec_play:(int)cur_value with_prefix:m_date_str];
 
        [m_view_player startplay:m_start_play_time];
        
        
        
    }
    else{
        
        CGPoint point = [recognizer locationInView:view_small_slider_fish_back];
        float x2 = point.x;
        float x_offset=x2-x1;
        int m_count=0;
        if (x_offset !=0) {
            m_count=fabs(x_offset);
        }
        //NSLog(@"m_count==%d",m_count);
        if (x_offset>0)//右滑动
        {
            m_cur_small_value=m_cur_small_value+m_count;
            if (m_cur_small_value>1440*60) {
                m_cur_small_value=1440*60;
            }
            if(img_left_sldier_small_fish.hidden==false)
                img_left_sldier_small_fish.hidden=true;
            if (img_right_slider_small_fish.hidden==true) {
                img_right_slider_small_fish.hidden=false;
            }
            label_small_slider_fish.text=[self getCurStr_sec_display:m_cur_small_value];
        }
        else if(x_offset<0){//左滑动
            m_cur_small_value=m_cur_small_value-m_count;
            if (m_cur_small_value<0) {
                m_cur_small_value=0;
            }
            if(img_left_sldier_small_fish.hidden==true)
                img_left_sldier_small_fish.hidden=false;
            if (img_right_slider_small_fish.hidden==false) {
                img_right_slider_small_fish.hidden=true;
            }
            label_small_slider_fish.text=[self getCurStr_sec_display:m_cur_small_value];;
        }
        else{
            
        }
        x1=x2;
    }
    return;
}

- (void)zxy_panhandle:(UIPanGestureRecognizer*)recognizer{
    m_view_width=glview_play.frame.size.width;
    m_view_height=glview_play.frame.size.height;
    if (is_zoom_mode==true)
    {
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
    else
    {
        
        if (recognizer.state==UIGestureRecognizerStateBegan) {
            CGPoint point = [recognizer locationInView:m_view_player.m_play_view];
            x1 = point.x;
            is_in_dragging=true;
            
            view_small_slider.hidden=false;
            [view_main bringSubviewToFront:view_small_slider];
           
            
        }
        else if (recognizer.state==UIGestureRecognizerStateEnded){
           
            
            img_left_slider_small.hidden=false;
            img_right_slider_small.hidden=false;
            view_small_slider.hidden=true;
            int cur_value=m_cur_small_value;
            if(cur_value>[m_record_manager getlastmin]*60)
            {
                is_in_dragging=false;
                return;
            }
            [self stop_flow_timer];
            
            [m_rulerview updateCurrentValue:(float)(cur_value/60)];
            
            [m_view_player stopplay];
            is_in_dragging=false;
            m_start_play_time= [self getCurStr_sec_play:(int)cur_value with_prefix:m_date_str];
            
            [m_view_player startplay:m_start_play_time];
            
        }
        else{
            //NSLog(@"UIGestureRecognizerStateBegan  else...");
            CGPoint point = [recognizer locationInView:m_view_player.m_play_view];
            float x2 = point.x;
            float x_offset=x2-x1;
            int m_count=0;
            if (x_offset !=0) {
                m_count=fabs(x_offset);
            }
            //NSLog(@"m_count==%d",m_count);
            if (x_offset>0)//右滑动
            {
                m_cur_small_value=m_cur_small_value+m_count;
                if (m_cur_small_value>1440*60) {
                    m_cur_small_value=1440*60;
                }
                if(img_left_slider_small.hidden==false)
                    img_left_slider_small.hidden=true;
                if (img_right_slider_small.hidden==true) {
                    img_right_slider_small.hidden=false;
                }
                label_small_slider.text=[self getCurStr_sec_display:m_cur_small_value];
            }
            else if(x_offset<0){//左滑动
                m_cur_small_value=m_cur_small_value-m_count;
                if (m_cur_small_value<0) {
                    m_cur_small_value=0;
                }
                if(img_left_slider_small.hidden==true)
                    img_left_slider_small.hidden=false;
                if (img_right_slider_small.hidden==false) {
                    img_right_slider_small.hidden=true;
                }
                label_small_slider.text=[self getCurStr_sec_display:m_cur_small_value];;
            }
            else{
                
            }
            x1=x2;
            //NSLog(@"UIGestureRecognizerStateBegan  else  end...");
        }
        return;
    }
}

-(NSString*)getCurStr_sec_display:(int)value
{
    NSString* tmp=nil;
    
    int nSec=(int)(value%60);
    int m_total_min=(int)value/60;
    int nHour=(int) (m_total_min/60);
    int nMinute=(int) (m_total_min%60);
    tmp=[NSString stringWithFormat:@"%.2d:%.2d:%.2d",nHour, nMinute,nSec];
    return tmp;
}

-(NSString*)getCurStr_sec_play:(int)value with_prefix:(NSString*)prefix_str
{
    NSString* tmp=nil;
    int nSec=(int)(value%60);
    int m_total_min=(int)value/60;
    int nHour=(int) (m_total_min/60);
    int nMinute=(int) (m_total_min%60);
    tmp=[NSString stringWithFormat:@"%@%.2d%.2d%.2d",prefix_str,nHour, nMinute,nSec];
    return tmp;
}
-(void)self_release
{
    [self stop_flow_timer];
    goe_Http.cli_devconnect_single_delegate=nil;
    if (h_connector!=0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    MyShareData=nil;
    m_strings=nil;
    
    goe_Http=nil;
    m_file_manager=nil;
    [m_view_player release_self];
    //[m_voice_talk vv_audio_stop_anyway];
    m_view_player=nil;
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
    }];
    
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
            err_msg=NSLocalizedString(@"err_6", @"");
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
        case 501:
            err_msg=NSLocalizedString(@"err_record_501", @"");
            break;
        case 502:
            err_msg=NSLocalizedString(@"err_record_502", @"");
            break;
        default:
            err_msg=NSLocalizedString(@"err_else", @"");
            break;
            
            
    }
    return err_msg;
}

-(void)referesh_calendar
{
    NSLog(@"referesh_calendar..........");
    [m_calendar draw_day_flag];
}
-(void)cli_lib_cam_record_date_callback:(int)res days:(NSString*)days with_date:(NSString*)str_date
{
    b_query_record=false;
    if (res!=200) {
        return;
    }
    if([m_record_manager add_item_date:str_date datelist:days devid:m_share_item.cur_cam_list_item.m_devid chlid:m_share_item.cur_cam_list_item.m_chlid]==true)
    {
        if ([[m_calendar get_cur_month_str] isEqualToString:str_date]==true) {
            [self performSelectorOnMainThread:@selector(referesh_calendar) withObject:nil waitUntilDone:YES];
        }
    }
}

-(void)start_query_month_record_list:(NSString*)str_month
{
    if (b_query_record==true) {
        return;
    }
    b_query_record=true;
    [goe_Http cli_lib_record_get_date_list:h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_rec_type:1 with_date:str_month];
}


-(void)process_query_record_result
{
    
    b_query_record=false;
    [button_date_minute setEnabled:true];
    [query_record_spinner stopAnimating];
    NSLog(@"process_query_record_result--%d",query_record_result);
    if (query_record_result == 200) {
        //[m_playback_rooler setDateStr:m_date_display];
        //[m_playback_rooler setNeedsDisplay];
        m_date_curday_str=m_date_display;
        NSString *str = [self getCurStr_ex:m_rulerview.currentValue];
        label_ruler_value.text = str;
        
        [m_rulerview reloadPlayback];
    }
    else{
        if (query_record_result == 199) {
            //[m_playback_rooler setDateStr:m_date_display];
            //[m_playback_rooler setNeedsDisplay];
            m_date_curday_str=m_date_display;
            NSString *str = [self getCurStr_ex:m_rulerview.currentValue];
            label_ruler_value.text = str;
            [m_rulerview reloadPlayback];
        }
        [OMGToast showWithText:[self get_err_msg:query_record_result]];
    }
}
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
{
    //NSLog(@"zxy_playbackViewController, cli_lib_devconnect_CALLBACK,  res=%d",res);
    
    if (h_connector!=0 && h_connector!=connector) {
        return;
    }
    if (res==1) {
        if(b_query_record==true){
            [goe_Http cli_lib_record_get_min_list:h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_rec_type:1 with_date:m_date_str];
        }
    }
    else{
        query_record_result=-98;
        if (b_query_record==true) {
            [self performSelectorOnMainThread:@selector(process_query_record_result) withObject:nil waitUntilDone:YES];
        }
        
    }
    
}
-(void)cli_lib_cam_record_min_callback:(int)res timelists:(NSMutableArray*)lists
{
    NSLog(@"cli_lib_cam_record_min_callback, res=%d",res);
    b_query_record=false;
    query_record_result=res;
    [m_record_manager clear];
    if (res==200 && lists != nil) {
        for (time_item* cur_item in lists)
        {
            [m_record_manager add_item:cur_item.start_min with_end:cur_item.end_min];
        }
        if (lists.count>0) {
            bMove=true;
            //[m_playback_rooler set_move:true];
        }
        else{
            bMove=false;
            //[m_playback_rooler set_move:false];
            query_record_result=199;
        }
    }
    if (bDefaultRecord==true) {
        [self start_query_month_record_list:m_date_month_str];
    }
    bDefaultRecord=false;
    [self performSelectorOnMainThread:@selector(process_query_record_result) withObject:nil waitUntilDone:YES];
}
-(int)get_timezone
{
    time_t time_utc;
    struct tm tm_local;
    
    // Get the UTC time
    time(&time_utc);
    
    // Get the local time
    // Use localtime_r for threads safe
    localtime_r(&time_utc, &tm_local);
    
    time_t time_local;
    struct tm tm_gmt;
    
    // Change tm to time_t
    time_local = mktime(&tm_local);
    
    // Change it to GMT tm
    gmtime_r(&time_utc, &tm_gmt);
    
    int time_zone = tm_local.tm_hour - tm_gmt.tm_hour;
    if (time_zone < -12) {
        time_zone += 24;
    } else if (time_zone > 12) {
        time_zone -= 24;
    }
    return time_zone;
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

- (IBAction)button_query_record_click:(id)sender {
    BOOL bHidden=view_calendar.hidden;
    view_calendar.hidden=!bHidden;
    if (view_calendar.hidden==false) {
        [view_main bringSubviewToFront:view_calendar];
    }
    
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


- (IBAction)button_save_pic_onclick:(id)sender {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    //[formater setDateFormat:@"yyyy.MM.dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    [formater setDateFormat:@"yyyyMMdd"];//这里去掉 具体时间 保留日期
    NSString * curFolderTime = [formater stringFromDate:curDate];
    [formater setDateFormat:@"yyyyMMddHHmmss"];//这里去掉 具体时间 保留日期
    NSString * curFileTime = [formater stringFromDate:curDate];
    //NSLog(@"folder==%@,  file==%@",curFolderTime,curFileTime);
    if (m_share_item.cur_cam_list_item.m_fisheyetype==0) {
        [m_file_manager save_jpg_file:jpgdata with_date:curFolderTime with_name:curFileTime];
    }
    else{
        NSString *mytag=[NSString stringWithFormat:@"type=%dleft=%fright=%ftop=%fbottom=%f",m_share_item.cur_cam_list_item.m_fisheyetype,m_share_item.cur_cam_list_item.main_stream.m_fish_left,m_share_item.cur_cam_list_item.main_stream.m_fish_right,m_share_item.cur_cam_list_item.main_stream.m_fish_top,m_share_item.cur_cam_list_item.main_stream.m_fish_bottom];
        NSString * curFileTime = [formater stringFromDate:curDate];
        NSString * curFileName = [NSString stringWithFormat:@"%@%@%@",@"fish_",curFileTime,mytag];
        [m_file_manager save_jpg_file:jpgdata with_date:curFolderTime with_name:curFileName];
        
    }
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

- (IBAction)button_delete_pic_onclick:(id)sender {
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

- (IBAction)button_ctrl_small_slider_fish_click:(id)sender {
    if(view_small_slider_fish_back.hidden==true)
    {
        [button_ctrl_small_slider_fish setBackgroundImage:[UIImage imageNamed:@"png_search_on.png"] forState:UIControlStateNormal];
        view_small_slider_fish_back.hidden=false;
        img_left_sldier_small_fish.hidden=false;
        img_right_slider_small_fish.hidden=false;
        
        [view_main bringSubviewToFront:view_small_slider_fish_back];
        
    }
    else{
        view_small_slider_fish_back.hidden=true;
        [button_ctrl_small_slider_fish setBackgroundImage:[UIImage imageNamed:@"png_search.png"] forState:UIControlStateNormal];
    }
    [view_main bringSubviewToFront:button_ctrl_small_slider_fish];
}


-(NSString*)format_str:(int)i
{
    
    NSString* s=[NSString stringWithFormat:@"%d",i];
    if(s.length==1){
        s=[NSString stringWithFormat:@"0%d",i];
    }
    return s;
}
-(NSString*)getCurStr_ex:(int)value
{
    NSString* tmp=nil;
    int nHour=(int) (value/60);
    int nMinute=(int) (value%60);
    //int nSec=(int)(value%(60*60));
    NSString* strHour=[self format_str:nHour];
    NSString* strMinute=[self format_str:nMinute];
    //NSString* strSec= [self format_str:nSec];
    if (m_date_curday_str==nil) {
        tmp=[NSString stringWithFormat:@"%@:%@:00",strHour, strMinute];
    }
    else
        tmp=[NSString stringWithFormat:@"%@ %@:%@:00",m_date_curday_str,strHour, strMinute];
    return tmp;
}
//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
-(NSString *)getLocalDateFormateUTCStamp:(int)utcstamp
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:utcstamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //输出格式
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:confromTimesp];
    return dateString;
}

-(NSString *)getLocalDateFormateUTCStamp2:(int)utcstamp
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:utcstamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:confromTimesp];
    return dateString;
}

-(NSString*)getCurStr_sec:(int)value
{
    NSString* tmp=nil;
    int nHour=(int) (value/3600);
    int nMinute=(int) ((value/60)%60);
    int nSec=(int)(value%60);
    
    if (m_date_curday_str==nil) {
        tmp=[NSString stringWithFormat:@"%.2d:%.2d:%.2d",nHour, nMinute,nSec];
    }
    else
        tmp=[NSString stringWithFormat:@"%@ %.2d:%.2d:%.2d",m_date_curday_str,nHour, nMinute,nSec];
    
    //NSLog(@"view_playback_rooler, tmp=%@",tmp);
    return tmp;
}

-(void)ruler_set_value_sec:(int)value
{
    NSString *str = [self getCurStr_sec:value];
    label_ruler_value.text = str;
}
-(void)on_pointer_value_change_begin:(int)value
{
    if (is_in_dragging==false) {
        is_in_dragging=true;
        
    }
}
-(void)on_pointer_value_change:(int)value
{
    
    NSString *str = [self getCurStr_ex:value];
    label_ruler_value.text = str;
}
-(void)on_pointer_value_change_end:(int)value
{
    is_in_dragging=false;
    
    int cur_value=value;
    
    if(cur_value>[m_record_manager getlastmin])
        return;
    [self stop_flow_timer];
    [m_view_player stopplay];
    m_start_play_time= [self getCurStr_sec_play:(int)(cur_value*60) with_prefix:m_date_str];
    if (m_share_item.cur_cam_list_item.m_fisheyetype!=0)
    {
        button_ctrl_small_slider_fish.hidden=true;
    }
    [m_view_player startplay:m_start_play_time];
}
-(void)get_flow_info
{
    
    if(m_view_player==nil)
        return;
    int m_cur_utc_time=[m_view_player get_cur_frame_utctime]+get_timezone*60*60;
    int m_cur_utc_time_offset=m_cur_utc_time-m_first_utc_time_zero;
    if (m_cur_utc_time_offset>=1440*60) {
        int days=m_cur_utc_time_offset/(1440*60);
        [self query_next_day:days];
        int m_remainder_sec=m_cur_utc_time%(24*60*60);
        m_first_utc_time_zero=m_cur_utc_time-m_remainder_sec;
        return;
    }
    if (m_cur_utc_time_offset==0) {
        return;
    }
    if (is_in_dragging==true) {
        return;
    }
    int m_minute=m_cur_utc_time_offset/60;
    int m_slidervalue=(int)m_rulerview.currentValue;
    if (m_minute!=m_slidervalue) {
        [m_rulerview updateCurrentValue:(float)m_minute];
    }
    
    [self ruler_set_value_sec:m_cur_utc_time_offset];
    
    m_cur_small_value=m_cur_utc_time_offset;
    int cur_frame_utctime=[m_view_player get_cur_frame_utctime];
    if(cur_frame_utctime==0)
        return;
    label_small_slider_fish.text=[self getLocalDateFormateUTCStamp:cur_frame_utctime];
    label_small_slider.text=[self getLocalDateFormateUTCStamp:cur_frame_utctime];
    
}
-(void)start_flow_timer
{
    m_flow_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(get_flow_info) userInfo:nil repeats:YES];
}
-(void)stop_flow_timer
{
    if ([m_flow_Timer isValid]==true) {
        [m_flow_Timer invalidate];
        //NSLog(@"m_flow_Timer  invalidate...");
    }
}
-(void)playok_mainthread
{
    
    //NSLog(@"my_timezone=%d",my_timezone);
    if (m_share_item.cur_cam_list_item.m_fisheyetype!=0)
    {
        button_ctrl_small_slider_fish.hidden=false;
    }
    int m_cur_utc_time=[m_view_player get_cur_frame_utctime]+get_timezone*60*60;
    int m_remainder_sec=m_cur_utc_time%(24*60*60);
    m_first_utc_time_zero=m_cur_utc_time-m_remainder_sec;
    [self set_snap_button_state];
    [self start_flow_timer];
    
    float video_width=[m_view_player get_video_width];
    float video_height=[m_view_player get_video_height];
    if (video_width<=0 || video_height<=0 || video_width<video_height) {
        return;
    }
    
   
    
    m_fish0_portrait_ratio_constant=MyShareData.screen_width*(video_width-video_height)/video_width;
    if(is_portrait==true && m_share_item.cur_cam_list_item.m_fisheyetype==0){
        Constraint_playcontainer_ratio.constant=m_fish0_portrait_ratio_constant;
        [view_main layoutIfNeeded];
    }
    
}
-(void)on_play_ok_callback:(int)index
{
    //NSLog(@"on_play_ok_callback.....");
    if (m_share_item.cur_cam_list_item.m_fisheyetype==0)
    {
        m_display_point.point0_x=[m_view_player getMaxXoffset];
        m_display_point.point0_y=1.0;
        
        m_display_point.point1_x=[m_view_player getMaxXoffset];
        m_display_point.point1_y=0.0;
        
        m_display_point.point2_x=0.0;
        m_display_point.point2_y=0.0;
        
        m_display_point.point3_x=0.0;
        m_display_point.point3_y=1.0;
    }
    m_snap_button_state=1;
    [self performSelectorOnMainThread:@selector(playok_mainthread) withObject:nil waitUntilDone:NO];
    
}
-(void)resolution_mainthread
{
    float video_width=[m_view_player get_video_width];
    float video_height=[m_view_player get_video_height];
    m_fish0_portrait_ratio_constant=MyShareData.screen_width*(video_width-video_height)/video_width;
    Constraint_playcontainer_ratio.constant=m_fish0_portrait_ratio_constant;
    [view_main layoutIfNeeded];
}
-(void)on_resolution_changed_callback:(int)width height:(int)height index:(int)index
{
    if (m_share_item.cur_cam_list_item.m_fisheyetype!=0)
        return;
   
    if (width<=0 || height<=0 || width<height) {
        return;
    }
    [self performSelectorOnMainThread:@selector(resolution_mainthread) withObject:nil waitUntilDone:NO];
    
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


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    toOrientation = toInterfaceOrientation;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ((fromInterfaceOrientation == UIDeviceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)&&(toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight)) {
        //NSLog(@"横屏");
        is_portrait=false;
        [self setNeedsStatusBarAppearanceUpdate];
        
        
        view_rooler_container.hidden=YES;
        view_top_tool.hidden = YES;
        bottom_toolbar.hidden = YES;
        view_top_tool.alpha = 0.6;
        bottom_toolbar.alpha = 0.6;
        view_rooler_container.alpha=0.6;
        [view_main bringSubviewToFront:view_rooler_container];
        [view_main bringSubviewToFront:view_top_tool];
        [view_main bringSubviewToFront:bottom_toolbar];

        [view_main bringSubviewToFront:button_ctrl_small_slider_fish];
        view_par_top_space.constant=0;
        constraint_playcontainer_offset_center.constant=0;
        if (m_share_item.cur_cam_list_item.m_fisheyetype==0)
        {
            Constraint_playcontainer_ratio.constant=m_fish0_landscape_ratio_constant;
            
        }
        
        
    }
    
    else if((fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown)){
        //NSLog(@"竖屏");
        is_portrait=true;
        [self setNeedsStatusBarAppearanceUpdate];
        
        view_rooler_container.hidden=NO;
        view_top_tool.hidden = NO;
        bottom_toolbar.hidden = NO;
        view_top_tool.alpha = 1;
        bottom_toolbar.alpha = 1;
        view_rooler_container.alpha=1;
        
        view_par_top_space.constant=20;
        constraint_playcontainer_offset_center.constant=-30;
        if (m_share_item.cur_cam_list_item.m_fisheyetype==0)
        {
            Constraint_playcontainer_ratio.constant=m_fish0_portrait_ratio_constant;
           
        }
        
    }
}

/*
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
*/
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
