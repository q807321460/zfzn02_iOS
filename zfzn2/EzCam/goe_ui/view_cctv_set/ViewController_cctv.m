//
//  ViewController_cctv.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController_cctv.h"
#define TAG_SENSOR_NAME    1;
#define TAG_SENSOR_PRESET      2;
#define TAG_SENSOR_ALARM      4;
@interface ViewController_cctv ()

@end

@implementation ViewController_cctv

@synthesize view_spinner;
@synthesize label_spinner_hint;

@synthesize view_cctv_main;
@synthesize view_cctv_main_top;
@synthesize label_cctv_main;

@synthesize view_item_schedule_alert;
@synthesize img_item_schedule_alert_right;
@synthesize label_item_schedule_alert_title;

@synthesize view_schedule_alert_info;
@synthesize NC_scheduleinfo_scheduletop_spaceing;
@synthesize NC_item_motion_scheduletop_spaceing;
@synthesize label_alert_start_time_title;
@synthesize label_alert_start_time;
@synthesize label_alert_end_time_title;
@synthesize label_alert_end_time;
@synthesize label_repeatday_title;
@synthesize button_day7;
@synthesize button_day1;
@synthesize button_day2;
@synthesize button_day3;
@synthesize button_day4;
@synthesize button_day5;
@synthesize button_day6;

@synthesize view_item_motion;
@synthesize label_item_motion_title;
@synthesize img_item_motion_switch;

@synthesize view_item_devalert_sound;
@synthesize label_item_devalert_sound_title;
@synthesize img_item_devalert_sound_switch;
@synthesize button_item_devalert_sound;

@synthesize view_item_snapnum;
@synthesize label_item_snapnum_title;
@synthesize label_item_snapnum;

@synthesize view_item_recordlong;
@synthesize label_item_recordlong_title;
@synthesize label_item_recordlong;

@synthesize view_item_liandong;
@synthesize label_item_liandong_title;
@synthesize label_item_liandong;

@synthesize view_item_sensors;
@synthesize label_item_sensors_title;
////////////////////
@synthesize view_record_picker;
@synthesize view_record_picker_top;
@synthesize lable_record_picker;
@synthesize button_record_picker_ensure;

@synthesize view_record_start_time;
@synthesize label_record_start_time;
@synthesize label_record_start_timeinfo;

@synthesize view_record_end_time;
@synthesize label_record_end_time_title;
@synthesize label_record_end_time_info;

@synthesize view_record_datepicker;
@synthesize datepicker_recordtime;

@synthesize NC_viewend_viewtop_topspace;
@synthesize NC_viewpick_viewtop_topspace;
///////////////////////////////
@synthesize view_alarm_set_bg;
@synthesize view_alarm_snap;
@synthesize label_alarm_snap;
@synthesize button_alarm_snap1;
@synthesize button_alarm_snap2;
@synthesize button_alarm_snap3;

@synthesize view_alarm_recordlong;
@synthesize label_alarm_recordlong;
@synthesize button_alarm_recordlong1;
@synthesize button_alarm_recordlong2;
@synthesize button_alarm_recordlong3;
@synthesize button_alarm_recordlong4;
@synthesize button_alarm_recordlong5;
@synthesize button_alarm_recordlong6;

@synthesize view_alarm_ptz;
@synthesize label_alarm_ptz;
@synthesize button_alarm_ptz1;
@synthesize button_alarm_ptz2;
@synthesize button_alarm_ptz3;
@synthesize button_alarm_ptz4;
//////////////////////////////
@synthesize view_sensors;
@synthesize view_sensors_top;
@synthesize label_sensors_top;
@synthesize button_sensor_codding;
@synthesize tableview_sensors;
//---------------
@synthesize view_sensor_edit;
@synthesize view_sensor_edit_top;
@synthesize label_sensor_edit_top;

@synthesize view_sensor_name;
@synthesize label_sensor_name_title;
@synthesize label_sensor_name;

@synthesize view_sensor_id;
@synthesize label_sensor_id_title;
@synthesize label_sensor_id;

@synthesize view_sensor_mode;
@synthesize label_sensor_mode_title;
@synthesize label_sensor_mode;

@synthesize view_sensor_alert;
@synthesize label_sensor_alert_title;
@synthesize img_sensor_alert_switch;
@synthesize button_sensor_delete;
//-----------------------------------
@synthesize view_rename;
@synthesize view_rename_top;
@synthesize button_rename_cancel;
@synthesize button_rename_ensure;
@synthesize label_rename_title;
@synthesize tv_rename;
//-----------------------------------
@synthesize view_delete;
@synthesize button_delete_cancel;
@synthesize button_delete_ensure;
@synthesize label_delete_hint;

@synthesize view_liandong_height;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    f_schedule_alert_info_height=127;
    f_group_spaceing=10;
    m_timing_arm_enable=0;
    f_picker_height=162;
    f_picker_item_height=40;
    
    m_timing_arm_enable=0;
    str_timing_arm=@"0000000";
    m_start_time_alert=@"00:00";
    m_end_time_alert=@"00:00";
    m_is_sun=0;
    m_is_mon=0;
    m_is_tue=0;
    m_is_wed=0;
    m_is_thu=0;
    m_is_fri=0;
    m_is_sat=0;
    m_snap_num=3;
    m_alert_act=0;
    m_alert_time=15;
    m_alarm_delay=0;
    m_devalert_sound=0;
    
    tableview_sensors.delegate = self;
    tableview_sensors.dataSource = self;
    
    tv_rename.delegate=self;
    
    
   
    cur_date_type=0;//0 =无 2=开始  3=结束
    str_start_time=@"";
    str_end_time=@"";
    timeFormat= [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    [datepicker_recordtime addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    b_arm_config_get=false;
    
    m_share_item=[share_item getInstance];
    m_strings=[vv_strings getInstance];
    m_sensor_manager=[sensors_manager getInstance];
    goe_Http=[ppview_cli getInstance];
    goe_Http.cli_c2s_sensors_delegate=self;
    [self init_view_value];
    
    if(m_share_item.cur_cam_list_item.m_ptz==0)
    {
        view_liandong_height.constant=0;
        view_item_liandong.hidden=true;
    }
    else{
        view_liandong_height.constant=40;
        view_item_liandong.hidden=false;
    }

    
    if (m_share_item.m_connect_state==1 && b_arm_config_get==false) {
        view_spinner.hidden=false;
        [self.view bringSubviewToFront:view_spinner];
        goe_Http.cli_c2s_arm_config_delegate=self;
        //goe_Http.cli_c2d_timezone_delegate=self;
        [goe_Http cli_lib_get_arm_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid];
        //[goe_Http cli_lib_cli_get_timezone:m_share_item.h_connector];
    }
}
-(void)cli_lib_timezone_get_callback:(int)res
{
    NSLog(@"cli_lib_timezone_get_callback, res=%d",res);
}
-(void)cli_lib_timezone_set_callback:(int)res timezone:(int)timezone
{
    NSLog(@"cli_lib_timezone_set_callback, res=%d",res);
}
-(void)init_view_value
{
    [view_spinner setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_alarm_set_bg setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_delete setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    [view_cctv_main setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_record_picker setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_sensors_top setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_sensor_edit setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_rename_top setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_record_datepicker setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    
    label_cctv_main.text=NSLocalizedString(@"m_cctv_set", @"");
    view_schedule_alert_info.hidden=true;
    NC_item_motion_scheduletop_spaceing.constant=f_group_spaceing;
    label_alert_start_time.text=@"";
    label_alert_end_time.text=@"";
    button_day7.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day1.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day2.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day3.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day4.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day5.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    button_day6.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
    label_item_snapnum.text=@"";
    label_item_recordlong.text=@"";
    label_item_liandong.text=@"";
    label_item_schedule_alert_title.text=NSLocalizedString(@"m_alert_schedule_title", @"");
    label_alert_start_time_title.text=NSLocalizedString(@"m_start_time", @"");
    label_alert_end_time_title.text=NSLocalizedString(@"m_end_time", @"");
    label_repeatday_title.text=NSLocalizedString(@"m_repeat", @"");
    [button_day7 setTitle:NSLocalizedString(@"m_day7", @"") forState:UIControlStateNormal];
    [button_day1 setTitle:NSLocalizedString(@"m_day1", @"") forState:UIControlStateNormal];
    [button_day2 setTitle:NSLocalizedString(@"m_day2", @"") forState:UIControlStateNormal];
    [button_day3 setTitle:NSLocalizedString(@"m_day3", @"") forState:UIControlStateNormal];
    [button_day4 setTitle:NSLocalizedString(@"m_day4", @"") forState:UIControlStateNormal];
    [button_day5 setTitle:NSLocalizedString(@"m_day5", @"") forState:UIControlStateNormal];
    [button_day6 setTitle:NSLocalizedString(@"m_day6", @"") forState:UIControlStateNormal];
    
    label_item_motion_title.text=NSLocalizedString(@"m_event_type_10001", @"");
    label_item_devalert_sound_title.text=NSLocalizedString(@"m_dev_alertsound", @"");
    label_item_snapnum_title.text=NSLocalizedString(@"m_alarm_cap_num", @"");
    label_item_recordlong_title.text=NSLocalizedString(@"m_alarm_duration", @"");
    label_item_liandong_title.text=NSLocalizedString(@"m_alarm_mode", @"");
    label_item_sensors_title.text=NSLocalizedString(@"m_sensor_set", @"");
    
    lable_record_picker.text=NSLocalizedString(@"m_time_select", @"");
    [button_record_picker_ensure setTitle:NSLocalizedString(@"m_ensure", @"") forState:UIControlStateNormal];
    
    label_record_start_time.text=NSLocalizedString(@"m_start_time", @"");
    label_record_end_time_title.text=NSLocalizedString(@"m_end_time", @"");
    
    label_alarm_snap.text=NSLocalizedString(@"m_alarm_cap_num", @"");
    [button_alarm_snap1 setTitle:[NSString stringWithFormat:@"1%@",NSLocalizedString(@"m_alarm_cap_num_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_snap2 setTitle:[NSString stringWithFormat:@"2%@",NSLocalizedString(@"m_alarm_cap_num_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_snap3 setTitle:[NSString stringWithFormat:@"3%@",NSLocalizedString(@"m_alarm_cap_num_unit", @"")] forState:UIControlStateNormal];
    
    label_alarm_recordlong.text=NSLocalizedString(@"m_alarm_duration", @"");
    [button_alarm_recordlong1 setTitle:[NSString stringWithFormat:@"15%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_recordlong2 setTitle:[NSString stringWithFormat:@"30%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_recordlong3 setTitle:[NSString stringWithFormat:@"45%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_recordlong4 setTitle:[NSString stringWithFormat:@"60%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_recordlong5 setTitle:[NSString stringWithFormat:@"120%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    [button_alarm_recordlong6 setTitle:[NSString stringWithFormat:@"180%@",NSLocalizedString(@"m_alarm_duration_unit", @"")] forState:UIControlStateNormal];
    
    label_alarm_ptz.text=NSLocalizedString(@"m_alarm_mode", @"");
    [button_alarm_ptz1 setTitle:NSLocalizedString(@"m_ptz_mode1", @"") forState:UIControlStateNormal];
    [button_alarm_ptz2 setTitle:NSLocalizedString(@"m_ptz_mode2", @"") forState:UIControlStateNormal];
    [button_alarm_ptz3 setTitle:NSLocalizedString(@"m_ptz_mode3", @"") forState:UIControlStateNormal];
    [button_alarm_ptz4 setTitle:NSLocalizedString(@"m_ptz_mode4", @"") forState:UIControlStateNormal];
    
    label_sensors_top.text=NSLocalizedString(@"m_sensor_set", @"");
    [button_sensor_codding setTitle:NSLocalizedString(@"m_sensor_codding", @"") forState:UIControlStateNormal];
    
    label_sensor_edit_top.text=NSLocalizedString(@"m_sensor_edit", @"");
    label_sensor_name_title.text=NSLocalizedString(@"m_sensor_name", @"");
    label_sensor_id_title.text=NSLocalizedString(@"m_sensor_id", @"");
    label_sensor_mode_title.text=NSLocalizedString(@"m_sensor_mode", @"");
    label_sensor_alert_title.text=NSLocalizedString(@"m_sensor_is_alert", @"");
    
    [button_rename_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_rename_ensure setTitle:NSLocalizedString(@"m_save", @"") forState:UIControlStateNormal];
    
    [button_delete_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_delete_ensure setTitle:NSLocalizedString(@"m_sensor_delete", @"") forState:UIControlStateNormal];
    label_delete_hint.text=NSLocalizedString(@"m_sensor_delete_hint", @"");
    
    [button_sensor_delete setTitle:NSLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
    label_rename_title.text=NSLocalizedString(@"m_rename", @"");
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellheight = 51;
    return cellheight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [m_sensor_manager getCount];
    return count;
}
-(void)on_sensor_item_button_click:(NSString*)item_id pos:(int)pos
{
    NSLog(@"on_sensor_item_button_click.....");
    cur_sensor_item=[m_sensor_manager getItem:pos];
    cur_sensor_item.b_new=false;
    label_sensor_id.text=cur_sensor_item.m_sensor_id;
    label_sensor_mode.text=cur_sensor_item.m_sensor_type;
    label_sensor_name.text=cur_sensor_item.m_sensor_name;
    
    if (cur_sensor_item.b_alarm==0) {
        img_sensor_alert_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
    }
    else{
        img_sensor_alert_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
    }
    view_sensor_edit.hidden=false;
    /*
    if(cur_sensor_item.m_type==10004)
    {
        view_sensor_alert.hidden=true;
    }
    else{
        view_sensor_alert.hidden=false;
    }
    */
    [view_sensors bringSubviewToFront:view_sensor_edit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableview_sensors==tableView){
        item_sensor* cur_item=[m_sensor_manager getItem:indexPath.row];
        static NSString *CellIdentifier = @"TableViewCell_sensor";
        TableViewCell_sensor* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (Cell==nil) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_sensor" owner:self options:nil] lastObject];
        }
        //(void)config_cell:(NSString*)item_name item_model:(NSString*)item_model item_id:(NSString*)item_id mode:(int)mode with_tag:(NSString*)tag with_pos:(int)pos
        [Cell config_cell:cur_item.m_sensor_name item_model:cur_item.m_sensor_type item_id:cur_item.m_sensor_id sensor_type:cur_item.m_type isnew:cur_item.b_new with_tag:cur_item.m_sensor_id with_pos:indexPath.row];
        Cell.delegate=self;
        return Cell;
    }
    else
        return nil;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)get_err_msg:(int)res type:(int)type
{
    NSString* msg_prefix=@"";
    if(type==0)
        msg_prefix=NSLocalizedString(@"m_get_sensors_fail", @"");
    else if(type==1)
        msg_prefix=NSLocalizedString(@"m_sensorset_fail", @"");
    else if(type==2)
        msg_prefix=NSLocalizedString(@"m_sensorcodding_fail", @"");
    else if(type==3)
        msg_prefix=NSLocalizedString(@"m_sensordelete_fail", @"");
    else if(type==4)
        msg_prefix=NSLocalizedString(@"m_get_arm_config_fail", @"");
    else if(type==5)
        msg_prefix=NSLocalizedString(@"m_set_arm_config_fail", @"");
    NSString* msg=@"";
    switch (res) {
        case 203:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"err_203", @"")];
            break;
        case 204:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sensor_err_204", @"")];
            break;
        case 205:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sensor_err_205", @"")];
            break;
        case 409:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sensor_err_409", @"")];
            break;
        case 500:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sensor_err_500", @"")];
            break;
        case 501:
            msg= [NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sensor_err_501", @"")];
            break;
        default:
            msg=msg_prefix;
            break;
    }
    return msg;
}

-(void)parse_week_day:(NSString*)str_days
{
    if (str_days==nil || str_days.length<=0) {
        return;
    }
    char* pCharsTimes=(char*)[str_days UTF8String];
    int nValue;
    for (int i=0; i<7; i++) {
        char ivalue=pCharsTimes[i];
        if (ivalue=='0'){
            nValue=0;
        }
        else{
            nValue=1;
        }
        switch (i) {
            case 0:
                m_is_sun=nValue;
                m_is_sun_new=m_is_sun;
                break;
            case 1:
                m_is_mon=nValue;
                m_is_mon_new=m_is_mon;
                break;
            case 2:
                m_is_tue=nValue;
                m_is_tue_new=m_is_tue;
                break;
            case 3:
                m_is_wed=nValue;
                m_is_wed_new=m_is_wed;
                break;
            case 4:
                m_is_thu=nValue;
                m_is_thu_new=m_is_thu;
                break;
            case 5:
                m_is_fri=nValue;
                m_is_fri_new=m_is_fri;
                break;
            case 6:
                m_is_sat=nValue;
                m_is_sat_new=m_is_sat;
                break;
            default:
                break;
        }
        
    }
}
-(BOOL)parse_arm_config:(NSData*)data
{
    if (data==nil) {
        return  false;
    }
    NSError* reserr;
    g_arm_dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reserr];
    if (g_arm_dictionary==nil) {
        return false;
    }
    m_timing_arm_enable=[[g_arm_dictionary objectForKey:@"timing_arm_enabled"]intValue];
    m_snap_num=[[g_arm_dictionary objectForKey:@"arm_snap"]intValue];
    m_alarm_delay=[[g_arm_dictionary objectForKey:@"delay_with_motion_sec"]intValue];
    m_alert_act=[[g_arm_dictionary objectForKey:@"alert_act"]intValue];
    m_alert_time=[[g_arm_dictionary objectForKey:@"alert_time"]intValue];
    m_motion_enable=[[g_arm_dictionary objectForKey:@"motion_enabled"]intValue];
    m_devalert_sound=[[g_arm_dictionary objectForKey:@"alert_sound"]intValue];
    str_timing_arm=[g_arm_dictionary objectForKey:@"timing_arm"];
    [self parse_week_day:str_timing_arm];
    m_start_time_alert=@"";
    m_end_time_alert=@"";
    NSString* m_str_time=[g_arm_dictionary objectForKey:@"sun"];
    if (m_str_time!=nil && m_str_time.length>0) {
        NSArray *chunks = [m_str_time componentsSeparatedByString: @"-"];
        if (chunks.count>=2) {
            m_start_time_alert=chunks[0];
            m_end_time_alert=chunks[1];
        }
        
    }
    return true;
}
-(void)on_arm_config_get_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    if (req.int_tag1==200) {
        b_arm_config_get=true;
        //NSString *aString = [[NSString alloc] initWithData:req.data_tag1 encoding:NSUTF8StringEncoding];
        //NSLog(@"on_arm_config_get_mainthread=%@",aString);
        if ([self parse_arm_config:req.data_tag1]==true) {
            [self update_cctv_main_info:-1];
        }
    }
    else{
        b_arm_config_get=false;
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:4]];
    }
}


-(void)cli_lib_arm_config_get_callback:(int)res  with_config:(NSData*)config_json
{
    NSLog(@"cli_lib_arm_config_get_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.data_tag1=config_json;
    [self performSelectorOnMainThread:@selector(on_arm_config_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}


-(void)on_arm_config_set_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    if (req.int_tag1==200) {
        switch (m_config_type) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                m_timing_arm_enable=m_timing_arm_enable_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 3:
                m_start_time_alert=m_start_time_alert_new;
                m_end_time_alert=m_end_time_alert_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 4:
                str_timing_arm=str_timing_arm_new;
                [self parse_week_day:str_timing_arm];
                [self update_cctv_main_info:m_config_type];
                break;
            case 6:
                m_snap_num=m_snap_num_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 7:
                m_alert_act=m_alert_act_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 8:
                m_alert_time=m_alert_time_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 9:
                m_alarm_delay=m_alarm_delay_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 10:
                m_motion_enable=m_motion_enable_new;
                [self update_cctv_main_info:m_config_type];
                break;
            case 11:
                m_devalert_sound=m_devalert_sound_new;
                [self update_cctv_main_info:m_config_type];
                break;
            default:
                break;
        }
    }
    else{
        NSString* tmp_time=nil;
        switch (m_config_type) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_timing_arm_enable] forKey:@"timing_arm_enabled"];
                break;
            case 3:
                tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_alert,m_end_time_alert];
                [g_arm_dictionary setObject:tmp_time forKey:@"thu"];
                [g_arm_dictionary setObject:tmp_time forKey:@"mon"];
                [g_arm_dictionary setObject:tmp_time forKey:@"sun"];
                [g_arm_dictionary setObject:tmp_time forKey:@"fri"];
                [g_arm_dictionary setObject:tmp_time forKey:@"wed"];
                [g_arm_dictionary setObject:tmp_time forKey:@"sat"];
                [g_arm_dictionary setObject:tmp_time forKey:@"tue"];
                break;
            case 4:
                [g_arm_dictionary setObject:str_timing_arm forKey:@"timing_arm"];
                break;
            case 6:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_snap_num] forKey:@"arm_snap"];
                break;
            case 7:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alert_act] forKey:@"alert_act"];
                break;
            case 8:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alert_time] forKey:@"alert_time"];
                break;
            case 9:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alarm_delay] forKey:@"delay_with_motion_sec"];
                break;
            case 10:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_motion_enable] forKey:@"motion_enabled"];
            case 11:
                [g_arm_dictionary setObject:[NSNumber numberWithInt:m_devalert_sound] forKey:@"alert_sound"];
                break;
            default:
                break;
        }
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:5]];
    }
}
-(void)cli_lib_arm_config_set_callback:(int)res
{
    NSLog(@"cli_lib_arm_config_set_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_arm_config_set_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)start_arm_config{
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (g_arm_dictionary==nil) {
        return;
    }
    if (m_config_type==0)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_is_door_bell_new] forKey:@"door_bell"];
        
    }
    else if (m_config_type==1)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_is_push_new] forKey:@"is_push"];
    }
    else if (m_config_type==2)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_timing_arm_enable_new] forKey:@"timing_arm_enabled"];
    }
    else if(m_config_type==3)
    {
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_alert_new,m_end_time_alert_new];
        [g_arm_dictionary setObject:tmp_time forKey:@"thu"];
        [g_arm_dictionary setObject:tmp_time forKey:@"mon"];
        [g_arm_dictionary setObject:tmp_time forKey:@"sun"];
        [g_arm_dictionary setObject:tmp_time forKey:@"fri"];
        [g_arm_dictionary setObject:tmp_time forKey:@"wed"];
        [g_arm_dictionary setObject:tmp_time forKey:@"sat"];
        [g_arm_dictionary setObject:tmp_time forKey:@"tue"];
    }
    else if (m_config_type==4)
    {
        str_timing_arm_new=[NSString stringWithFormat:@"%d%d%d%d%d%d%d",m_is_sun_new,m_is_mon_new,m_is_tue_new,m_is_wed_new,m_is_thu_new,m_is_fri_new,m_is_sat_new];
        [g_arm_dictionary setObject:str_timing_arm_new forKey:@"timing_arm"];
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_alert,m_end_time_alert];
        [g_arm_dictionary setObject:tmp_time forKey:@"thu"];
        [g_arm_dictionary setObject:tmp_time forKey:@"mon"];
        [g_arm_dictionary setObject:tmp_time forKey:@"sun"];
        [g_arm_dictionary setObject:tmp_time forKey:@"fri"];
        [g_arm_dictionary setObject:tmp_time forKey:@"wed"];
        [g_arm_dictionary setObject:tmp_time forKey:@"sat"];
        [g_arm_dictionary setObject:tmp_time forKey:@"tue"];
    }
    else if (m_config_type==6)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_snap_num_new] forKey:@"arm_snap"];
    }
    else if (m_config_type==7)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alert_act_new] forKey:@"alert_act"];
    }
    else if (m_config_type==8)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alert_time_new] forKey:@"alert_time"];
    }
    else if(m_config_type==9)
    {
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_alarm_delay_new] forKey:@"delay_with_motion_sec"];
    }
    else if(m_config_type==10){
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_motion_enable_new] forKey:@"motion_enabled"];
    }
    else if(m_config_type==11){
        [g_arm_dictionary setObject:[NSNumber numberWithInt:m_devalert_sound_new] forKey:@"alert_sound"];
    }
    else{
        return;
    }
    NSData* senddata = [NSJSONSerialization dataWithJSONObject:g_arm_dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString* poststring = [[NSString alloc]initWithData:senddata encoding:NSUTF8StringEncoding];
    //NSLog(@"start_arm_config, poststring=%@",poststring);
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_set_arm_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid config:poststring];
    
}

-(void)update_cctv_main_info:(int)type
{
    if (type==-1) {
        if (m_timing_arm_enable==0) {
            img_item_schedule_alert_right.image=[UIImage imageNamed:@"zx_switch_off.png"];
            view_schedule_alert_info.hidden=true;
            NC_item_motion_scheduletop_spaceing.constant=f_group_spaceing;
        }
        else{
            img_item_schedule_alert_right.image=[UIImage imageNamed:@"zx_switch_on.png"];
            view_schedule_alert_info.hidden=false;
            NC_item_motion_scheduletop_spaceing.constant=f_schedule_alert_info_height+5+f_group_spaceing;
            
        }
        label_alert_start_time.text=m_start_time_alert;
        label_alert_end_time.text=m_end_time_alert;
        if (m_is_sun==0) {
            button_day7.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day7.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_mon==0) {
            button_day1.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day1.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_tue==0) {
            button_day2.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day2.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_wed==0) {
            button_day3.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day3.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_thu==0) {
            button_day4.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day4.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_fri==0) {
            button_day5.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day5.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_sat==0) {
            button_day6.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day6.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        label_item_snapnum.text=[NSString stringWithFormat:@"%d%@",m_snap_num,NSLocalizedString(@"m_alarm_cap_num_unit", @"")];
        label_item_recordlong.text=[NSString stringWithFormat:@"%d%@",m_alert_time,NSLocalizedString(@"m_alarm_duration_unit", @"")];
        if (m_alert_act==0) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode1", @"");
        }
        else if (m_alert_act==2) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode2", @"");
        }
        else if (m_alert_act==1) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode3", @"");
        }
        else if (m_alert_act==3) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode4", @"");
        }
        if (m_motion_enable==0) {
            img_item_motion_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
        }
        else{
            img_item_motion_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
        }
        if (m_devalert_sound==2) {
            img_item_devalert_sound_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
        }
        else if(m_devalert_sound==0){
            button_item_devalert_sound.enabled=false;
            [view_item_devalert_sound setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
            
        }
        else{
            img_item_devalert_sound_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
        }
    }
    else if(type==2){
        if (m_timing_arm_enable==0) {
            img_item_schedule_alert_right.image=[UIImage imageNamed:@"zx_switch_off.png"];
            view_schedule_alert_info.hidden=true;
            NC_item_motion_scheduletop_spaceing.constant=f_group_spaceing;
        }
        else{
            img_item_schedule_alert_right.image=[UIImage imageNamed:@"zx_switch_on.png"];
            view_schedule_alert_info.hidden=false;
            NC_item_motion_scheduletop_spaceing.constant=f_schedule_alert_info_height+5+f_group_spaceing;
            
        }
    }
    else if(type==3){
        label_alert_start_time.text=m_start_time_alert;
        label_alert_end_time.text=m_end_time_alert;
    }
    else if(type==4){
        if (m_is_sun==0) {
            button_day7.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day7.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_mon==0) {
            button_day1.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day1.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_tue==0) {
            button_day2.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day2.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_wed==0) {
            button_day3.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day3.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_thu==0) {
            button_day4.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day4.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_fri==0) {
            button_day5.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day5.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
        if (m_is_sat==0) {
            button_day6.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
        }
        else{
            button_day6.backgroundColor=UIColorFromRGB(m_strings.background_blue);
        }
    }
    else if(type==6){
        label_item_snapnum.text=[NSString stringWithFormat:@"%d%@",m_snap_num,NSLocalizedString(@"m_alarm_cap_num_unit", @"")];
    }
    else if(type==7){
        if (m_alert_act==0) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode1", @"");
        }
        else if (m_alert_act==2) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode2", @"");
        }
        else if (m_alert_act==1) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode3", @"");
        }
        else if (m_alert_act==3) {
            label_item_liandong.text=NSLocalizedString(@"m_ptz_mode4", @"");
        }
    }
    else if(type==8){
        label_item_recordlong.text=[NSString stringWithFormat:@"%d%@",m_alert_time,NSLocalizedString(@"m_alarm_duration_unit", @"")];
    }
    else if(type==10){
        if (m_motion_enable==0) {
            img_item_motion_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
        }
        else{
            img_item_motion_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
        }
    }
    else if(type==11){
        if (m_devalert_sound==2) {
            img_item_devalert_sound_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
        }
        else{
            img_item_devalert_sound_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
        }
    }
    else{
    }
    
}

-(void)on_sensors_get_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    //[self.view bringSubviewToFront:view_spinner_bg];
    if (req.int_tag1==200) {
        if([m_sensor_manager setJsonData:req.data_tag1]==true)
        {
            [tableview_sensors reloadData];
            view_sensors.hidden=false;
            [self.view bringSubviewToFront:view_sensors];
        }
    }
    else{
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:0]];
    }
}
-(void)cli_lib_get_sensors_callback:(int)res data:(NSData*)data
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.data_tag1=data;
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_sensors_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)stop_codding
{
    if (bCodding==false) {
        return;
    }
    m_share_item.m_connect_state=-1;
    [goe_Http cli_lib_releaseconnect:m_share_item.h_connector];
    m_share_item.h_connector=0;
    m_share_item.h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"view controller_cctv"];
}
-(void)on_sensors_codding_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    label_spinner_hint.text=@"";
    //[self.view bringSubviewToFront:view_spinner_bg];
    if (req.int_tag1==200) {
        int res=[m_sensor_manager setJsonData_codding:req.data_tag1];
        if (res==1) {
            [tableview_sensors reloadData];
        }
        else if(res==2){
            NSString* msg=NSLocalizedString(@"m_sensor_exist", @"");
            [OMGToast showWithText:msg];
        }
    }
    else{
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:2]];
    }
    button_sensor_codding.enabled=true;
}
-(void)cli_lib_sensor_codding_callback:(int)res data:(NSData*)data
{
    //NSLog(@"cli_lib_sensor_codding_callback, res=%d",res);
    bCodding=false;
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.data_tag1=data;
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_sensors_codding_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)on_sensor_set_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    //[self.view bringSubviewToFront:view_spinner_bg];
    if (req.int_tag1==200) {
        switch (req.int_tag2) {
            case 1://改名
                label_sensor_name.text=m_cur_set_value_str;
                cur_sensor_item.m_sensor_name=m_cur_set_value_str;
                break;
            case 2://预置位绑定
                //label_sensor_item4_hint.text=[self get_preset_name:req.int_tag3];
                //cur_sensor_item.m_sensor_preset=m_cur_set_value_int;
                break;
                
            case 4://报警
                cur_sensor_item.b_alarm=m_cur_set_value_int;
                if (cur_sensor_item.b_alarm==0) {
                    img_sensor_alert_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
                }
                else{
                    img_sensor_alert_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
                }
                break;
            default:
                break;
        }
    }
    else{
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:1]];
    }
}
-(void)cli_lib_sensor_set_callback:(int)res tag:(int)tag sensorid:(NSString*)sensorid name:(NSString*)name preset:(int)preset isalarm:(int)isalarm
{
    NSLog(@"cli_lib_sensor_set_callback, res=%d",res);
    //spinner_view_main_sensor_item
    if (m_cur_set_tag!=tag) {
        return;
    }
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.int_tag2=tag;
    cur_req.str_tag1=name;
    cur_req.int_tag3=preset;
    cur_req.int_tag4=isalarm;
    [self performSelectorOnMainThread:@selector(on_sensor_set_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)on_sensor_delete_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    //[self.view bringSubviewToFront:view_spinner_bg];
    if (req.int_tag1==200) {
        if([m_sensor_manager sensor_delete:req.str_tag1]==true)
        {
            [tableview_sensors reloadData];
        }
        view_sensor_edit.hidden=true;
    }
    else{
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:3]];
    }
}
-(void)cli_lib_sensor_delete_callback:(int)res sensor_id:(NSString*)sensor_id
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.str_tag1=sensor_id;
    [self performSelectorOnMainThread:@selector(on_sensor_delete_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    
    switch (cur_date_type) {
        case 2:
            start_date=paramDatePicker.date;
            str_start_time= [self get_date_string:start_date with_format:timeFormat];
            label_record_start_timeinfo.text=str_start_time;
            break;
        case 3:
            end_date=paramDatePicker.date;
            str_end_time= [self get_date_string:end_date with_format:timeFormat];
            label_record_end_time_info.text=str_end_time;            
            break;
            
        default:
            break;
    }
    
}
-(NSString*)get_date_string:(NSDate*)date with_format:(NSDateFormatter*)format
{
    NSString *DateStr = [format stringFromDate:date];
    return DateStr;
}
- (IBAction)cctv_main_return:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^(){
        if (view_spinner.hidden==false) {
            view_spinner.hidden=true;
        }
    }];
}

- (IBAction)cctv_main_item_schedule_alert_click:(id)sender {
    if (m_timing_arm_enable==0) {
        m_timing_arm_enable_new=1;
    }
    else{
        m_timing_arm_enable_new=0;
    }
    m_config_type=2;
    [self start_arm_config];
}

-(void)view_main_picker_referesh
{
    if (cur_date_type==0) {
        view_record_datepicker.hidden=true;
        NC_viewend_viewtop_topspace.constant=1;
    }
    else if(cur_date_type==2){
        view_record_datepicker.hidden=false;
        NC_viewpick_viewtop_topspace.constant=1;
        NC_viewend_viewtop_topspace.constant=f_picker_height+1;
    }
    else if(cur_date_type==3){
        view_record_datepicker.hidden=false;
        NC_viewend_viewtop_topspace.constant=1;
        NC_viewpick_viewtop_topspace.constant=f_picker_item_height+1;
    }
}

- (IBAction)cctv_main_item_schedule_starttime_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_arm_config_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    cur_date_type=2;
    str_start_time=m_start_time_alert;
    str_end_time=m_end_time_alert;
    label_record_start_timeinfo.text=str_start_time;
    label_record_end_time_info.text=str_end_time;
    [self view_main_picker_referesh];
    view_record_picker.hidden=false;
    [self.view bringSubviewToFront:view_record_picker];
}

- (IBAction)cctv_main_item_schedule_endtime_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_arm_config_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    cur_date_type=3;
    str_start_time=m_start_time_alert;
    str_end_time=m_end_time_alert;
    label_record_start_timeinfo.text=str_start_time;
    label_record_end_time_info.text=str_end_time;
    [self view_main_picker_referesh];
    view_record_picker.hidden=false;
    [self.view bringSubviewToFront:view_record_picker];
}

- (IBAction)cctv_main_item_day_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (sender==button_day7) {
        if (m_is_sun==0) {
            m_is_sun_new=1;
        }
        else{
            m_is_sun_new=0;
        }
    }
    else if (sender==button_day1) {
        if (m_is_mon==0) {
            m_is_mon_new=1;
        }
        else{
            m_is_mon_new=0;
        }
        
    }
    else if (sender==button_day2) {
        if (m_is_tue==0) {
            m_is_tue_new=1;
        }
        else{
            m_is_tue_new=0;
        }
        
    }
    else if (sender==button_day3) {
        if (m_is_wed==0) {
            m_is_wed_new=1;
        }
        else{
            m_is_wed_new=0;
        }
        
    }
    else if (sender==button_day4) {
        if (m_is_thu==0) {
            m_is_thu_new=1;
        }
        else{
            m_is_thu_new=0;
        }
        
    }
    else if (sender==button_day5) {
        if (m_is_fri==0) {
            m_is_fri_new=1;
        }
        else{
            m_is_fri_new=0;
        }
        
    }
    else if (sender==button_day6) {
        if (m_is_sat==0) {
            m_is_sat_new=1;
        }
        else{
            m_is_sat_new=0;
        }
        
    }
    m_config_type=4;
    [self start_arm_config];
}

- (IBAction)cctv_main_item_motion_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_arm_config_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_motion_enable==0) {
        m_motion_enable_new=1;
    }
    else{
        m_motion_enable_new=0;
    }
    m_config_type=10;
    [self start_arm_config];
}

- (IBAction)cctv_main_item_devalert_sound_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_arm_config_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_devalert_sound==1) {
        m_devalert_sound_new=2;
    }
    else{
        m_devalert_sound_new=1;
    }
    m_config_type=11;
    [self start_arm_config];
}

- (IBAction)cctv_main_item_snapnum_click:(id)sender {
    view_alarm_snap.hidden=false;
    view_alarm_set_bg.hidden=false;
    [view_alarm_set_bg bringSubviewToFront:view_alarm_snap];
    [self.view bringSubviewToFront:view_alarm_set_bg];
}

- (IBAction)cctv_main_item_recordlong_click:(id)sender {
    view_alarm_recordlong.hidden=false;
    view_alarm_set_bg.hidden=false;
    [view_alarm_set_bg bringSubviewToFront:view_alarm_recordlong];
    [self.view bringSubviewToFront:view_alarm_set_bg];
}

- (IBAction)cctv_main_item_liandong_click:(id)sender {
    view_alarm_ptz.hidden=false;
    view_alarm_set_bg.hidden=false;
    [view_alarm_set_bg bringSubviewToFront:view_alarm_ptz];
    [self.view bringSubviewToFront:view_alarm_set_bg];
}

- (IBAction)cctv_main_item_sensors_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_get_sensors:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid sensor_type:0];
}

- (IBAction)button_picker_starttime_bg_click:(id)sender
{
    if (cur_date_type==0) {
        cur_date_type=2;
    }
    else if(cur_date_type==2){
        cur_date_type=0;
    }
    else if(cur_date_type==3){
        cur_date_type=2;
    }
    [self view_main_picker_referesh];
}
- (IBAction)button_picker_endtime_bg_click:(id)sender
{
    if (cur_date_type==0) {
        cur_date_type=3;
    }
    else if(cur_date_type==2){
        cur_date_type=3;
    }
    else if(cur_date_type==3){
        cur_date_type=0;
    }
    [self view_main_picker_referesh];

}
- (IBAction)button_alert_time_ensure_click:(id)sender
{
    view_record_picker.hidden=true;
    m_start_time_alert_new=str_start_time;
    m_end_time_alert_new=str_end_time;
    m_config_type=3;
    [self start_arm_config];
}
- (IBAction)button_alert_time_return_click:(id)sender
{
    view_record_picker.hidden=true;
}

- (IBAction)button_alarm_snap_button_click:(id)sender {
    
    view_alarm_snap.hidden=true;
    view_alarm_set_bg.hidden=true;
    
    if (sender==button_alarm_snap1) {
        m_snap_num_new=1;
    }
    else if (sender==button_alarm_snap2) {
        m_snap_num_new=2;
    }
    else if (sender==button_alarm_snap3) {
        m_snap_num_new=3;
    }
    if (m_snap_num==m_snap_num_new) {
        return;
    }
    m_config_type=6;
    [self start_arm_config];

}

- (IBAction)button_alarm_recordlong_button_click:(id)sender {
    view_alarm_recordlong.hidden=true;
    view_alarm_set_bg.hidden=true;
    
    if (sender==button_alarm_recordlong1) {
        m_alert_time_new=15;
    }
    else if (sender==button_alarm_recordlong2) {
        m_alert_time_new=30;
    }
    else if (sender==button_alarm_recordlong3) {
        m_alert_time_new=45;
    }
    else if (sender==button_alarm_recordlong4) {
        m_alert_time_new=60;
    }
    else if (sender==button_alarm_recordlong5) {
        m_alert_time_new=120;
    }
    else if (sender==button_alarm_recordlong6) {
        m_alert_time_new=180;
    }
    if(m_alert_time==m_alert_time_new)
        return;
    m_config_type=8;
    [self start_arm_config];
}

- (IBAction)button_alarm_ptz_button_click:(id)sender {
    view_alarm_ptz.hidden=true;
    view_alarm_set_bg.hidden=true;
    if (sender==button_alarm_ptz1) {
        m_alert_act_new=0;
    }
    else if (sender==button_alarm_ptz2) {
        m_alert_act_new=2;
    }
    else if (sender==button_alarm_ptz3) {
        m_alert_act_new=1;
    }
    else if (sender==button_alarm_ptz4) {
        m_alert_act_new=3;
    }
    if(m_alert_act==m_alert_act_new)
        return;
    m_config_type=7;
    [self start_arm_config];
}

- (IBAction)button_sensors_return:(id)sender {
     [self stop_codding];
    view_sensors.hidden=true;
    if (view_spinner.hidden==false) {
        view_spinner.hidden=true;
    }
}

- (IBAction)button_start_codding_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (bCodding==true) {
        return;
    }
    bCodding=true;
    button_sensor_codding.enabled=false;
    view_spinner.hidden=false;
    label_spinner_hint.hidden=false;
    label_spinner_hint.text=NSLocalizedString(@"m_sensor_codding_hint", @"");
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_coding_sensors:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid];
}

- (IBAction)button_sensor_edit_return:(id)sender {
    view_sensor_edit.hidden=true;
    if (view_spinner.hidden==false) {
        view_spinner.hidden=true;
    }
}

- (IBAction)button_sensor_editname_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    tv_rename.text=cur_sensor_item.m_sensor_name;
    view_rename.hidden=false;
    [view_sensors bringSubviewToFront:view_rename];
}

- (IBAction)button_sensor_alert_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    m_cur_set_tag=TAG_SENSOR_ALARM;
    m_cur_set_name=@"isalarm";
    if (cur_sensor_item.b_alarm==0) {
        m_cur_set_value_int=1;
    }
    else
        m_cur_set_value_int=0;
    [goe_Http cli_lib_set_sensors:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_id:cur_sensor_item.m_sensor_id name:cur_sensor_item.m_sensor_name preset:cur_sensor_item.m_sensor_preset isalarm:m_cur_set_value_int with_tag:m_cur_set_tag];

}

- (IBAction)button_sensor_delete_click:(id)sender {
    view_delete.hidden=false;
    [view_sensors bringSubviewToFront:view_delete];
}

- (IBAction)button_rename_cancel_click:(id)sender {
    view_rename.hidden=true;
}

- (IBAction)button_rename_ensure_click:(id)sender {
    [tv_rename resignFirstResponder];
    m_sensor_new_name=[tv_rename text];
    if (m_sensor_new_name==nil || m_sensor_new_name.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"m_sensorname_isnull", @"")];
        return;
    }
    else{
        NSData* nameData = [m_sensor_new_name dataUsingEncoding:NSUTF8StringEncoding];
        int length=(int)nameData.length;
        if(length>31){
            [OMGToast showWithText:NSLocalizedString(@"m_sensorname_toolong",@"")];
            return;
        }
        else
            m_sensor_new_name=[m_sensor_new_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    view_rename.hidden=true;
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    
    m_cur_set_tag=TAG_SENSOR_NAME;
    m_cur_set_name=@"name";
    m_cur_set_value_str=m_sensor_new_name;
    [goe_Http cli_lib_set_sensors:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid with_id:cur_sensor_item.m_sensor_id name:m_cur_set_value_str preset:cur_sensor_item.m_sensor_preset isalarm:cur_sensor_item.b_alarm with_tag:m_cur_set_tag];
}

- (IBAction)button_delete_cancel:(id)sender {
    view_delete.hidden=true;
}

- (IBAction)button_delete_ensure_click:(id)sender {
    if (m_share_item.m_connect_state!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_delete.hidden=true;
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_delete_sensor:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid sensorid:cur_sensor_item.m_sensor_id];
}

- (IBAction)alarm_set_cancel:(id)sender {
    view_alarm_snap.hidden=true;
    view_alarm_recordlong.hidden=true;
    view_alarm_ptz.hidden=true;
    view_alarm_set_bg.hidden=true;
}

@end
