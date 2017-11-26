//
//  ViewController_fishplay.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController_fishplay.h"

@interface ViewController_fishplay ()
-(void)Setaudiostatus:(int)status;
-(int)getaudiostatus;
-(int)get_video_width;
-(int)get_video_height;
-(void)referesh_uuid;
-(void)startplay;
-(void)stopplay;
-(void)release_self;
-(void)release_connect_talk;
//-(void)snap_picture:(int)type;
-(long)get_playhandle;
-(BOOL)startrecord;
-(BOOL)stoprecord;
-(int)get_stream_flow_info:(long long*)total avg:(int*)avg curr:(int*)curr;

@end

@implementation ViewController_fishplay
@synthesize view_main;
@synthesize delegate;
@synthesize m_cam_item;
@synthesize m_play_view;
@synthesize m_player;
@synthesize videoIndicator;
@synthesize playing_state;
@synthesize m_bReording;
@synthesize bAudioExist;
@synthesize bAudioP2PExist;
@synthesize bAudioP2PSize;
@synthesize replayButton;
@synthesize touchView;


@synthesize hConnector_arm;
@synthesize connect_status_arm;

@synthesize hConnector_talk;
@synthesize connect_status_talk;
@synthesize cur_stream_type;
@synthesize img_record;
@synthesize button_stream_select;
@synthesize view_top_tool;

@synthesize view_mediainfo;
@synthesize label_flow;
@synthesize label_speed;
@synthesize button_snap;
@synthesize view_jpg;
@synthesize imgview_jpg;
@synthesize button_video_record;
@synthesize button_audio_play;

@synthesize view_p2p_talk;
@synthesize label_p2p_talk;
@synthesize button_p2p_stop;
@synthesize view_talk_spinner;
@synthesize talk_spinner;
@synthesize img_logo_talk;

@synthesize view_p2p_talk_type4;
@synthesize button_p2p_talk_type4;
@synthesize button_p2p_stop_type4;
@synthesize view_talk_spinner_type4;
@synthesize talk_spinner_type4;
@synthesize img_logo_talk_type4;

@synthesize button_mic;

@synthesize view_par_top_space;
@synthesize view_container_ratio;
@synthesize label_frame_date;
@synthesize view_mode_select;


@synthesize button_playmode;
@synthesize button_playmode0;
@synthesize button_playmode1;
@synthesize button_playmode2;
@synthesize button_playmode3;

@synthesize constraint_button_playmode0_height;
@synthesize constraint_button_playmode1_height;
@synthesize constraint_button_playmode2_height;
@synthesize constraint_button_playmode3_height;

@synthesize button_arm;
@synthesize view_arm_spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    playing_state = -1;//-1:未播放 0：请求播放中  1：播放中
    m_cur_playmode=0;
    m_arm_button_state=-1;
    bFirstGetArmstatus=false;
    b_idle=true;
    b_released=false;
    if_snap_for_list=false;
    is_p2ptalk_mode=false;
    m_bReording=false;
    hConnector_talk=0;
    hConnector_arm=0;
    cur_stream_type=0;
    connect_status_talk=-1;
    connect_status_arm=-1;
    goe_Http=[ppview_cli getInstance];
    m_strings=[vv_strings getInstance];
    MyShareData=[zxy_share_data getInstance];
    m_file_manager=[pic_file_manager getInstance];
    
    [m_file_manager init_file_path];
   [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    m_voice_talk=[CTalk getInstance];
    m_voice_talk.delgate=self;
    
   
    m_cam_item = [MyShareData.playarray firstObject];
    MyShareData.m_playing_devid=m_cam_item.m_devid;
     MyShareData.bPlaying=true;
    if (m_cam_item.is_stream_process==false) {
        [m_cam_item process_stream];
    }
    m_player=[[vv_real_player alloc]init:0 fisheyetype:m_cam_item.m_fisheyetype left:m_cam_item.main_stream.m_fish_left right:m_cam_item.main_stream.m_fish_right top:m_cam_item.main_stream.m_fish_top bottom:m_cam_item.main_stream.m_fish_bottom];
    [m_player set_surfaceview:m_play_view];
    m_player.delegate=self;
    playing_state=-1;
    
    
    cur_stream_type=1;
    [self draw_stream_select_view];
    
    goe_Http.cli_devconnect_single_delegate=self;
    goe_Http.cli_c2d_armstatus_delegate=self;
    
    [button_p2p_talk_type4 addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
    [button_p2p_talk_type4 addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [button_p2p_talk_type4 addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willenteredBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play_release) name:@"stop_play" object:nil];
}
-(void)enteredBackground:(NSNotification*) notification{
    //进入后台
    NSLog(@"main__enterBackground");
    
    //[self play_release];
    
}

-(void)willenteredBackground:(NSNotification*) notification{

    [self play_release];
}
-(void) offsetButtonTouchBegin:(id)sender{
    //NSLog(@"开始计时");
    [m_voice_talk record_resume];
    [m_voice_talk play_pause];
    [button_p2p_talk_type4 setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    [img_logo_talk_type4 setImage:[UIImage imageNamed:@"vv_talk.png"]];
    [button_p2p_talk_type4 setTitle:NSLocalizedString(@"m_press_endtalk", @"") forState:UIControlStateNormal];
    
}

-(void) offsetButtonTouchEnd:(id)sender{
    //NSLog(@"计时结束");
    [m_voice_talk record_pause];
    [m_voice_talk play_resume];
    [button_p2p_talk_type4 setBackgroundColor:UIColorFromRGB(m_strings.text_gray)];
    [img_logo_talk_type4 setImage:[UIImage imageNamed:@"vv_volumnOn.png"]];
    [button_p2p_talk_type4 setTitle:NSLocalizedString(@"m_press_totalk", @"") forState:UIControlStateNormal];
}
-(void)draw_stream_select_view
{
    float f_stream_view_width=100;
    float f_stream_title_width=f_stream_view_width-40;
    streamselectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, f_stream_view_width, 81)];
    
    item_stream1_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, f_stream_view_width, 40)];
    [item_stream1_view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    img_stream1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    img_stream1.contentMode = UIViewContentModeScaleAspectFit;
    img_stream1.image=[UIImage imageNamed:@"png_check_black.png"];
    [item_stream1_view addSubview:img_stream1];
    label_stream1=[[UILabel alloc] initWithFrame:CGRectMake(40, 0 , f_stream_title_width, 40)];
    label_stream1.font=[UIFont systemFontOfSize: 13.0];
    label_stream1.textColor=[UIColor whiteColor];
    label_stream1.text=NSLocalizedString(@"m_main_stream_first", @"");
    [item_stream1_view addSubview:label_stream1];
    button_item_stream1_bg = [UIButton buttonWithType:UIButtonTypeCustom];
    button_item_stream1_bg.frame = CGRectMake(0, 0, f_stream_view_width, 40);
    [button_item_stream1_bg addTarget:self action:@selector(streamButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button_item_stream1_bg setBackgroundColor:[UIColor clearColor]];
    [item_stream1_view addSubview:button_item_stream1_bg];
    [streamselectView addSubview:item_stream1_view];
    
    item_stream2_view=[[UIView alloc]initWithFrame:CGRectMake(0, 41, f_stream_view_width, 40)];
    [item_stream2_view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    img_stream2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    img_stream2.contentMode = UIViewContentModeScaleAspectFit;
    img_stream2.image=[UIImage imageNamed:@"png_check_black.png"];
    [item_stream2_view addSubview:img_stream2];
    label_stream2=[[UILabel alloc] initWithFrame:CGRectMake(40, 0 , f_stream_title_width, 40)];
    label_stream2.font=[UIFont systemFontOfSize: 13.0];
    label_stream2.textColor=[UIColor whiteColor];
    label_stream2.text=NSLocalizedString(@"m_sub_stream_first", @"");
    [item_stream2_view addSubview:label_stream2];
    button_item_stream2_bg = [UIButton buttonWithType:UIButtonTypeCustom];
    button_item_stream2_bg.frame = CGRectMake(0, 0, f_stream_view_width, 40);
    [button_item_stream2_bg addTarget:self action:@selector(streamButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button_item_stream2_bg setBackgroundColor:[UIColor clearColor]];
    [item_stream2_view addSubview:button_item_stream2_bg];
    [streamselectView addSubview:item_stream2_view];
}
-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"viewDidAppear");
    
    [self startplay];
    [self start_flow_timeer];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    
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
    [self stopplay];
    [self performSelectorOnMainThread:@selector(indicatorStop_fail) withObject:nil waitUntilDone:YES];
}
-(void)indicator_restart
{
    if(is_p2ptalk_mode==true)
    {
        if (m_cam_item.voicetalk_type ==2){
            view_p2p_talk.hidden=true;
        }
        else if (m_cam_item.voicetalk_type ==4){
            view_p2p_talk_type4.hidden=true;
        }
        is_p2ptalk_mode=false;
        
        [m_voice_talk vv_voicetalk_stop];
        
    }
    [timer invalidate];
    [self stopplay];
    [self startplay];
    //bAudioStatus
}
-(void)indicatorStop_fail{
    //NSLog(@"indicator stop fial");
    [timer invalidate];
    [videoIndicator stopAnimating];
    replayButton.hidden = NO;
    m_play_view.hidden = YES;
}

-(void)indicatorStop_fail_errusr{
    //NSLog(@"indicator stop fial");
    [timer invalidate];
    [videoIndicator stopAnimating];
    replayButton.hidden = NO;
    m_play_view.hidden = YES;
    [OMGToast showWithText:NSLocalizedString(@"err_414", @"")];
}
-(void)indicatorStop_success{
    //NSLog(@"indicator stop ok");
    [timer invalidate];
    if(m_cam_item.m_fisheyetype==1)
        self.button_playmode.hidden=NO;
    m_play_view.hidden = NO;
    [self.touchView bringSubviewToFront:label_frame_date];
    replayButton.hidden = YES;
    button_snap.enabled=true;
    button_video_record.enabled=true;
    button_audio_play.enabled=true;
    [videoIndicator stopAnimating];
}
-(void)indicatorStart{
    //NSLog(@"indicator start........");
    [videoIndicator startAnimating];
    m_play_view.hidden = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(check_playresult:) userInfo:nil repeats:NO];
}
-(int)get_video_width
{
    if (m_cam_item==Nil) {
        return -1;
    }
    if (cur_stream_type==0) {
        //子码流
        return m_cam_item.sub_stream.width;
    }
    else//主码流
    {
        return m_cam_item.main_stream.width;
    }
}
-(int)get_video_height
{
    if (m_cam_item==Nil) {
        return -1;
    }
    if (cur_stream_type==0) {
        //子码流
        return m_cam_item.sub_stream.height;
    }
    else//主码流
    {
        return m_cam_item.main_stream.height;
    }
}
-(NSString*)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}
-(void)referesh_uuid
{
    cur_uuid=[self stringWithUUID];
}
-(void)startplay
{
    
    if (playing_state>=0) {
        return;
    }
    //NSLog(@"view_playercontroller, m_cam_item.m_play_type=%d",m_cam_item.m_play_type);
    button_snap.enabled=false;
    button_video_record.enabled=false;
    button_audio_play.enabled=false;
    bFirstGetArmstatus=false;
    replayButton.hidden=true;
    playing_state=0;
    cur_uuid=[self stringWithUUID];
    [self performSelectorOnMainThread:@selector(indicatorStart) withObject:nil waitUntilDone:YES];
    m_play_type=m_cam_item.m_play_type;
    NSString* thumbil_filename=[m_file_manager get_cam_thumbil_filename:m_cam_item.m_id];
    if (thumbil_filename != nil) {
        [m_player set_cam_thumbil_filename:thumbil_filename];
    }
    int stream_id=m_cam_item.main_stream.stream_id;
    [m_player start_play:m_cam_item.m_chlid stream_id:stream_id devid:m_cam_item.m_devid user:m_cam_item.m_dev_user pass:m_cam_item.m_dev_pass];
}
-(void)stopplay
{
    playing_state=-1;
    [timer invalidate];
    //NSLog(@"view_player, stop-------------1");
    if(m_play_type==0)
        [m_player stop_play];
    else
        [m_player stop_play];
}
-(void)release_self
{
    b_released=true;

    m_player.delegate=nil;
    
   [m_player stop_play];
    if (hConnector_talk!=0) {
        //NSLog(@"view_player, stop-------------4");
        [goe_Http cli_lib_releaseconnect:hConnector_talk];
        hConnector_talk=0;
    }
    if (hConnector_arm!=0) {
        //NSLog(@"view_player, stop hConnector_arm-------------4");
        [goe_Http cli_lib_releaseconnect:hConnector_arm];
        hConnector_arm=0;
    }

}



-(long)get_playhandle
{
    return [m_player get_playhandle];
}


-(int)get_stream_flow_info:(long long*)total avg:(int*)avg curr:(int*)curr
{
    if (m_player==nil) {
        return -1;
    }
    return [m_player get_stream_flow_info:total avg:avg curr:curr];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:confromTimesp];
    return dateString;
}

-(void)get_flow_info
{
    
    long long m_total=0;
    int m_avg=0;
    int m_curr=0;
    int res= [self get_stream_flow_info:&m_total avg:&m_avg curr:&m_curr];
    if (res==0) {
        //NSLog(@"get_stream_flow_info, res=%d, total=%lld  avg=%d  curr=%d",res, m_total, m_avg, m_curr);
        NSString* str_total=[NSString stringWithFormat:@"%@:%.2fMB" ,NSLocalizedString(@"m_flow", @""),(float)m_total/(1024*1024)];
        NSString* str_avg=[NSString stringWithFormat:@"%@:%.2fKB/s" ,NSLocalizedString(@"m_speed", @""),(float)m_avg/1024];
        label_flow.text=str_total;
        label_speed.text=str_avg;

    }
    int cur_frame_utctime=[m_player get_cur_frame_utctime];
    if(cur_frame_utctime==0)
        return;
    NSString* label_frame_time=[self getLocalDateFormateUTCStamp:cur_frame_utctime];
    label_frame_date.text=label_frame_time;
    
}
-(void)start_flow_timeer
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

-(CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.2];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
-(BOOL)startrecord
{
    
    if (m_bReording==true || playing_state<0) {
        return false;
    }
    m_bReording=true;
    img_record.hidden=false;
    [img_record.layer addAnimation:[self opacityForever_Animation:0.5] forKey:@"animateOpacity"];
    NSString *mytag=[NSString stringWithFormat:@"type=%dleft=%fright=%ftop=%fbottom=%f",m_cam_item.m_fisheyetype,m_cam_item.main_stream.m_fish_left,m_cam_item.main_stream.m_fish_right,m_cam_item.main_stream.m_fish_top,m_cam_item.main_stream.m_fish_bottom];
    filename_video=[m_file_manager get_filename_video:true fishtag:mytag];
    filename_pic=@"";
    if (filename_video !=nil) {
        filename_pic=[filename_video stringByReplacingOccurrencesOfString:@".fishvvi" withString:@"_video.jpg"];
        NSLog(@"startrecord,  filename_pic=%@",filename_pic);
    }
    int res=[goe_Http cli_lib_start_record:[m_player get_playhandle] rec_file:filename_video thumbil_file:filename_pic max_sec:0];
    NSLog(@"cli_lib_start_record=%d",res);
    return true;
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
-(BOOL)stoprecord
{
    if (m_bReording==false) {
        return true;
    }
    m_bReording=false;
    img_record.hidden=true;
    [img_record.layer removeAllAnimations];
    int res=[goe_Http cli_lib_stop_record:[m_player get_playhandle]];
    NSLog(@"cli_lib_stop_record=%d",res);
    if (filename_pic != nil && filename_pic.length>0) {
        UIImage* src_img=[UIImage imageWithContentsOfFile:filename_pic];
        if(src_img != nil){
            UIImage* new_img=[self thumbnailWithImage:src_img with_size:CGSizeMake(80, 60)];
            [UIImageJPEGRepresentation(new_img, 0.3) writeToFile:filename_pic atomically:YES];
            new_img=nil;
        }
        src_img=nil;
    }
    return true;
}



-(void)play_release
{
    
    [self stop_flow_timer];
    
    if(is_p2ptalk_mode==true){
        [m_voice_talk vv_voicetalk_stop];
    }
    m_voice_talk.delgate=nil;
    goe_Http.cli_devconnect_single_delegate=nil;
    if(if_snap_for_list==true) {
        if ([delegate respondsToSelector:@selector(on_tableview_needreferesh)]) {
            [delegate on_tableview_needreferesh];
        }
    }
    MyShareData.bPlaying=false;
    MyShareData=nil;
    m_strings=nil;
    goe_Http=nil;
    m_file_manager=nil;
    jpgdata=nil;
    
    [self stoprecord];
    [self release_self];
    [m_voice_talk vv_voicetalk_stop];
    
    [self dismissViewControllerAnimated:NO completion:^(){
        
    }];
}
- (IBAction)button_return_click:(id)sender {
    [self play_release];
}
-(void)streamButtonOnClick:(id)sender{
    NSLog(@"streamButtonOnClick....");
    [m_popover_view_stream performSelector:@selector(dismiss) withObject:nil afterDelay:0.0f];
    if (sender==button_item_stream1_bg) {
        if(cur_stream_type==0){
            [self stream_switch];
        }
    }
    else if(sender==button_item_stream2_bg){
        if(cur_stream_type==1){
            [self stream_switch];
        }
    }
}
-(void)stream_switch
{
    
    [self referesh_uuid];
    [self stopplay];
    if(cur_stream_type==0)
    {
        cur_stream_type=1;
    }
    else if(cur_stream_type==1)
    {
        cur_stream_type=0;
    }
    [self startplay];
}
- (IBAction)button_stream_select_click:(id)sender {
    /*
    if(cur_stream_type==0)//子
    {
        img_stream1.hidden=true;
        img_stream2.hidden=false;
    }
    else{
        img_stream1.hidden=false;
        img_stream2.hidden=true;
    }
    streamselectView.hidden=false;
    CGPoint point = button_stream_select.center;
    point.y=point.y+18;
    m_popover_view_stream=[PopoverView showPopoverAtPoint:point inView:view_top_tool withContentView:streamselectView delegate:self];
     */
    [OMGToast showWithText:m_cam_item.m_devid];
}

- (IBAction)replayButtonOnClick:(id)sender {
    [self stopplay];
    [self startplay];
}

- (IBAction)button_snap_onclick:(id)sender {
    [button_snap setEnabled:false];
    snap_src=1;
    [m_player snap_picture];
}

- (IBAction)button_save_pic_onclick:(id)sender {
    NSString *mytag=[NSString stringWithFormat:@"type=%dleft=%fright=%ftop=%fbottom=%f",m_cam_item.m_fisheyetype,m_cam_item.main_stream.m_fish_left,m_cam_item.main_stream.m_fish_right,m_cam_item.main_stream.m_fish_top,m_cam_item.main_stream.m_fish_bottom];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    //[formater setDateFormat:@"yyyy.MM.dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    [formater setDateFormat:@"yyyyMMdd"];//这里去掉 具体时间 保留日期
    NSString * curFolderTime = [formater stringFromDate:curDate];
    [formater setDateFormat:@"yyyyMMddHHmmss"];//这里去掉 具体时间 保留日期
    NSString * curFileTime = [formater stringFromDate:curDate];
    NSString * curFileName = [NSString stringWithFormat:@"%@%@%@",@"fish_",curFileTime,mytag];
    [m_file_manager save_jpg_file:jpgdata with_date:curFolderTime with_name:curFileName];
    [button_snap setEnabled:true];
    view_jpg.hidden=true;

}

- (IBAction)button_delete_pic_onclick:(id)sender {
    [button_snap setEnabled:true];
    view_jpg.hidden=true;
}

- (IBAction)button_record_onclick:(id)sender {
    if (m_bReording==true) {
        [self stoprecord];
        [button_video_record setBackgroundImage:[UIImage imageNamed:@"vv_recStart.png"] forState:UIControlStateNormal];
    }
    else{
        [self startrecord];
        [button_video_record setBackgroundImage:[UIImage imageNamed:@"vv_rec_start_2.png"] forState:UIControlStateNormal];
        
    }
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
- (IBAction)button_audio_play_onclick:(id)sender {
    if (bAudioExist==0) {
        return;
    }
    int cur_status=[self getaudiostatus];
    if (cur_status==0) {
        cur_status=1;
    }
    else{
        cur_status=0;
    }
    if (cur_status==1) {
        //[m_voice_talk vv_audio_start_type0];
    }
    [self Setaudiostatus:cur_status];
    m_audio_button_state=cur_status;
    [self set_audio_button_state];
}

- (IBAction)button_stop_p2ptalk_onclick:(id)sender {
    if (m_cam_item.voicetalk_type ==2){
        view_p2p_talk.hidden=true;
    }
    else if (m_cam_item.voicetalk_type ==4){
        view_p2p_talk_type4.hidden=true;
    }
    is_p2ptalk_mode=false;
    
    [m_voice_talk vv_voicetalk_stop];
    if (m_audio_button_state==1) {
        //[m_voice_talk vv_audio_start_type0];
        [self Setaudiostatus:m_audio_button_state];
    }
}
-(void)set_mic_button_state
{
    switch (m_mic_button_state) {
        case -1:
            button_mic.enabled=false;
            //[button_mic setBackgroundImage:[UIImage imageNamed:@"png_sound1.png"] forState:UIControlStateNormal];
            break;
        case 0:
        case 1:
            button_mic.enabled=true;
            //[button_mic setBackgroundImage:[UIImage imageNamed:@"png_sound1_orange.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
-(void)set_arm_button_state_err
{
    if (view_arm_spinner.hidden==false) {
        view_arm_spinner.hidden=true;
    }
    //[OMGToast showWithText:NSLocalizedString(@"err_414", @"")];
    [OMGToast showWithText:[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_fail", @""),m_arm_res]];
}
-(void)set_arm_button_state
{
    if (view_arm_spinner.hidden==false) {
        view_arm_spinner.hidden=true;
    }
    
    switch (m_arm_button_state) {
        case -1:
            button_arm.enabled=false;
            button_arm.hidden=true;
            //[button_mic setBackgroundImage:[UIImage imageNamed:@"png_sound1.png"] forState:UIControlStateNormal];
            break;
        case 0:
            button_arm.enabled=true;
            button_arm.hidden=false;
            [button_arm setBackgroundImage:[UIImage imageNamed:@"img_animate_disarm01_setting.png"] forState:UIControlStateNormal];
            break;
        case 1:
            button_arm.enabled=true;
            button_arm.hidden=false;
            [button_arm setBackgroundImage:[UIImage imageNamed:@"img_animate_disarm05_setting.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (IBAction)button_mic_onclick:(id)sender {
   
    if (m_cam_item.voicetalk_type ==0 || connect_status_talk !=1)
    {
        return;
    }
    if (m_cam_item.voicetalk_type ==2) {
        label_p2p_talk.text=NSLocalizedString(@"m_start_voice_talk", @"");
        
        view_talk_spinner.hidden=false;
        view_p2p_talk.hidden=false;
        is_p2ptalk_mode=true;
        
        [view_main bringSubviewToFront:view_p2p_talk];
        int cur_status=[self getaudiostatus];
        if (cur_status==1) {
            cur_status=0;
            [self Setaudiostatus:cur_status];
        }
        //[m_voice_talk vv_audio_stop_type0];
        
        [m_voice_talk vv_voicetalk_start:hConnector_talk chlid:m_cam_item.m_chlid user:m_cam_item.m_dev_user pass:m_cam_item.m_dev_pass talk_type:m_cam_item.voicetalk_type];
    }
    else if(m_cam_item.voicetalk_type ==4){
        
        button_p2p_talk_type4.enabled=false;
        [button_p2p_talk_type4 setTitle:NSLocalizedString(@"m_start_voice_talk", @"") forState:UIControlStateNormal];
        view_talk_spinner_type4.hidden=false;
        view_p2p_talk_type4.hidden=false;
        is_p2ptalk_mode=true;
        
        [view_main bringSubviewToFront:view_p2p_talk_type4];
        int cur_status=[self getaudiostatus];
        if (cur_status==1) {
            cur_status=0;
            [self Setaudiostatus:cur_status];
        }
        //[m_voice_talk vv_audio_stop_type0];
        [m_voice_talk vv_voicetalk_start:hConnector_talk chlid:m_cam_item.m_chlid user:m_cam_item.m_dev_user pass:m_cam_item.m_dev_pass talk_type:m_cam_item.voicetalk_type];
    }
}

- (IBAction)button_devid_onclick:(id)sender {
    [OMGToast showWithText:m_cam_item.m_devid];
}

- (IBAction)button_change_playmode_onclick:(id)sender {
    
   // [m_player  change_playmode:-1];
    view_mode_select.hidden= !view_mode_select.hidden;
}

- (IBAction)button_playmode_onclick:(id)sender {
    int iToMode=-1;
    if (sender==button_playmode0) {
        iToMode=0;
    }
    else if(sender==button_playmode1) {
        iToMode=1;
    }
    else if(sender==button_playmode2) {
        iToMode=2;
    }
    else if(sender==button_playmode3) {
        iToMode=3;
    }
    if (m_cur_playmode==iToMode) {
        return;
    }
    switch (m_cur_playmode) {
        case 0:
            constraint_button_playmode0_height.constant=44;
            break;
        case 1:
            constraint_button_playmode1_height.constant=44;
            break;
        case 2:
            constraint_button_playmode2_height.constant=44;
            break;
        case 3:
            constraint_button_playmode3_height.constant=44;
            break;
        default:
            break;
    }
    [m_player change_playmode:iToMode];
    m_cur_playmode=iToMode;
    switch (m_cur_playmode) {
        case 0:
            [button_playmode setBackgroundImage:[UIImage imageNamed:@"updown_1.png"] forState:UIControlStateNormal];
            constraint_button_playmode0_height.constant=0;
            break;
        case 1:
            [button_playmode setBackgroundImage:[UIImage imageNamed:@"half_ball_1.png"] forState:UIControlStateNormal];
            constraint_button_playmode1_height.constant=0;
            break;
        case 2:
            [button_playmode setBackgroundImage:[UIImage imageNamed:@"cylinder_1.png"] forState:UIControlStateNormal];
            constraint_button_playmode2_height.constant=0;
            break;
        case 3:
            [button_playmode setBackgroundImage:[UIImage imageNamed:@"tow_divide_1.png"] forState:UIControlStateNormal];
            constraint_button_playmode3_height.constant=0;
            break;
        default:
            break;
    }
    view_mode_select.hidden=true;
}

- (IBAction)button_arm_click:(id)sender {
    if (connect_status_arm!=1) {
        [OMGToast showWithText:NSLocalizedString(@"Disconnected with the device", @"")];
        return;
    }
    to_arm_status=-1;
    if (m_arm_button_state==0) {
        to_arm_status=1;
    }
    else if(m_arm_button_state==1)
        to_arm_status=0;
    else
        return;
    view_arm_spinner.hidden=false;
    [goe_Http cli_lib_cli_c2d_set_arm_status:hConnector_arm status:to_arm_status];
}
-(void)thread_save_png
{
    UIImage* src_img=[UIImage imageWithData:jpgdata];
    UIImage* new_img=[self thumbnailWithImage:src_img with_size:CGSizeMake(240, 180)];
    pic_file_manager* m_manager=[pic_file_manager getInstance];
    if (new_img!=nil) {
        [m_manager save_img_file:new_img with_name:m_cam_item.m_id];
        m_cam_item.b_snap=true;
        if_snap_for_list=true;
    }
    src_img=nil;
    new_img=nil;
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
-(void)on_snap_jpg_callback:(int)res jpgdata:(NSData*)data
{
    if (snap_src==1){
        jpgdata=data;
        jpg_res=res;
        [self performSelectorOnMainThread:@selector(show_jpg_data) withObject:nil waitUntilDone:NO];
    }
    else if(snap_src==0 && res>0){
        
        jpgdata=data;
        [NSThread detachNewThreadSelector:@selector(thread_save_png) toTarget:self withObject:nil];
    }
}

-(void)on_play_audio_cap_callback:(int)exist play_id:(int)index
{
    if (b_released==true) {
        return;
    }
    bAudioExist=exist;
    if (exist==1) {
        m_audio_button_state=bAudioStatus;
        [m_player set_audio_status:bAudioStatus];
    }
    else
    {
        m_audio_button_state=-1;
    }
    [self performSelectorOnMainThread:@selector(set_audio_button_state) withObject:nil waitUntilDone:YES];
}

-(void)on_play_status_callback:(int)status play_id:(int)index tag:(NSString*)tag
{
    // NSLog(@"view_player, on_play_status_callback, status=%d, m_cam_item.voicetalk_type=%d",status,m_cam_item.voicetalk_type);
    //NSLog(@"view_player, on_play_status_callback, status=%d, tag:%@, cur_tag=%@",status,tag,cur_uuid);
    
    if (b_released==true) {
        return;
    }
    [timer invalidate];
    if (status==-1) {
        playing_state = -1;
        [self performSelectorOnMainThread:@selector(indicator_restart) withObject:nil waitUntilDone:YES];
    }
    else if(status==-99)
    {
        playing_state = -1;
        [self performSelectorOnMainThread:@selector(indicator_restart) withObject:nil waitUntilDone:YES];
    }
    else if(status==203 || status==414){
        playing_state = -1;
        [self performSelectorOnMainThread:@selector(indicatorStop_fail_errusr) withObject:nil waitUntilDone:YES];

    }
    else
    {
        playing_state = 1;
        if ((m_cam_item.voicetalk_type==2 || m_cam_item.voicetalk_type==4) && hConnector_talk==0) {
            hConnector_talk=[goe_Http cli_lib_createconnect:m_cam_item.m_devid devuser:m_cam_item.m_dev_user devpass:m_cam_item.m_dev_pass tag:@"view_talk"];
        }
        
        if (hConnector_arm==0) {
            hConnector_arm=[goe_Http cli_lib_createconnect:m_cam_item.m_devid devuser:m_cam_item.m_dev_user devpass:m_cam_item.m_dev_pass tag:@"view_arm"];
        }
         
        [self performSelectorOnMainThread:@selector(indicatorStop_success) withObject:nil waitUntilDone:YES];
        if (playing_state !=-1 && m_cam_item!=nil&&m_cam_item.b_snap==false) {
            snap_src=0;
            [m_player snap_picture];
        }
       
    }
}

-(void)on_talk_result
{
    if (m_cam_item.voicetalk_type ==2) {
        view_talk_spinner.hidden=true;
        if (talk_res==0) {
            
            label_p2p_talk.text=NSLocalizedString(@"m_voice_talk_ok", @"");
            
        }
        else{
            NSString* hintinfo= [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"m_voice_talk_fail", @""),talk_res];
            label_p2p_talk.text=hintinfo;
            
        }
    }
    else if(m_cam_item.voicetalk_type ==4){
        view_talk_spinner_type4.hidden=true;
        if (talk_res==0) {
            [button_p2p_talk_type4 setTitle:NSLocalizedString(@"m_press_totalk", @"") forState:UIControlStateNormal];
            button_p2p_talk_type4.enabled=true;
            
        }
        else{
            
            NSString* hintinfo= [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"m_voice_talk_fail", @""),talk_res];
            [button_p2p_talk_type4 setTitle:hintinfo forState:UIControlStateNormal];
            
        }
    }
    
}
-(void)on_voicetalk_status_callback:(int)status
{
    talk_res=status;
    [self performSelectorOnMainThread:@selector(on_talk_result) withObject:nil waitUntilDone:YES];
}
-(void)release_connect_talk
{
    if (hConnector_talk !=0) {
        [goe_Http cli_lib_releaseconnect:hConnector_talk];
        hConnector_talk=0;
    }
}
-(void)release_connect_arm
{
    if (hConnector_arm !=0) {
        [goe_Http cli_lib_releaseconnect:hConnector_arm];
        hConnector_arm=0;
    }
}
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)h_connector result:(int)res
{
    //NSLog(@"zxy_PlayViewController, cli_lib_devconnect_CALLBACK,  res=%d，  connector=%d",res,h_connector);
    if (h_connector==0) {
        return;
    }
    if (res==1) {
        if(hConnector_talk==h_connector){
            connect_status_talk=1;
            if (m_cam_item.voicetalk_type==2 || m_cam_item.voicetalk_type==4) {
                m_mic_button_state=0;
            }
            else{
                m_mic_button_state=-1;
            }
            [self performSelectorOnMainThread:@selector(set_mic_button_state) withObject:nil waitUntilDone:YES];
        }
        
        else if(hConnector_arm==h_connector){
            connect_status_arm=1;
            m_arm_button_state=-1;
            if (bFirstGetArmstatus==false) {
                [goe_Http cli_lib_cli_c2d_get_arm_status:hConnector_arm];
            }
            
            //[self performSelectorOnMainThread:@selector(set_arm_button_state) withObject:nil waitUntilDone:YES];
        }
    }
    else{
        if(hConnector_talk==h_connector){
            connect_status_talk=-1;
            //[self release_connect_talk];
        }
        else if(hConnector_arm==h_connector){
            connect_status_arm=-1;
            //[self release_connect_arm];
        }
    }
        
   
}
-(void)cli_lib_c2d_armstatus_get_callback:(int)res
{
    if (res==0|| res==1) {
        if (bFirstGetArmstatus==false) {
            bFirstGetArmstatus=true;
        }
        m_arm_button_state=res;
        [self performSelectorOnMainThread:@selector(set_arm_button_state) withObject:nil waitUntilDone:YES];
    }
}
-(void)cli_lib_c2d_armstatus_set_callback:(int)res status:(int)status
{
    if (res==200) {
        m_arm_button_state=to_arm_status;
        [self performSelectorOnMainThread:@selector(set_arm_button_state) withObject:nil waitUntilDone:YES];
    }
    else{
        m_arm_res=res;
        [self performSelectorOnMainThread:@selector(set_arm_button_state_err) withObject:nil waitUntilDone:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    toOrientation = toInterfaceOrientation;
    if (toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight){
        view_top_tool.hidden=true;
        _toolbar.hidden=true;
        
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ((fromInterfaceOrientation == UIDeviceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)&&(toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight)) {
        //变横屏
        
        view_par_top_space.constant=0;
        if (m_cam_item.m_fisheyetype==1) {
            float offset=self.view.bounds.size.width-self.view.bounds.size.height;
            view_container_ratio.constant=offset;
        }
     
    }
    else if((fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown))
    {
        //变竖屏
        _toolbar.hidden=false;
        view_top_tool.hidden=false;
        view_par_top_space.constant=20;
        if(m_cam_item.m_fisheyetype==1)
        {
             view_container_ratio.constant=0;
        }
    }
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
