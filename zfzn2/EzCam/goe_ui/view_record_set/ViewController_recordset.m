//
//  ViewController_recordset.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController_recordset.h"

@interface ViewController_recordset ()

@end

@implementation ViewController_recordset

@synthesize view_spinner;
@synthesize label_spinner_hint;
//////////////////////
@synthesize view_recordset;
@synthesize view_recordset_top;
@synthesize label_recordset;

@synthesize view_item_sdcard;
@synthesize label_item_sdcard_title;
@synthesize button_item_sdcard_format;
@synthesize lable_item_sdcard_info;


/////////////////////
@synthesize view_record_schedule;
@synthesize view_record_schedule_top;
@synthesize label_record_schedule;
@synthesize view_schedule_switch;
@synthesize img_schedule_switch_right;
@synthesize label_schedule_switch;
@synthesize view_schedule_info;
@synthesize view_schedule_starttime;
@synthesize label_schedule_starttime;
@synthesize label_schedule_starttime_info;

@synthesize view_schedule_endtime;
@synthesize label_schedule_endtime;
@synthesize label_schedule_endtime_info;

@synthesize button_type0_day7;
@synthesize button_type0_day1;
@synthesize button_type0_day2;
@synthesize button_type0_day3;
@synthesize button_type0_day4;
@synthesize button_type0_day5;
@synthesize button_type0_day6;
/////////////////////

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
/////////////////////////////////
@synthesize view_format_bg;
@synthesize button_format_cancel;
@synthesize button_format_ensure;
@synthesize label_format_hint;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    b_sdcard_info_get=false;
    m_record_enable_type0=0;
    m_record_enable_type1=0;
    b_record_info_get=0;
    m_sdcard_status=-1;
    f_picker_height=162;
    f_picker_item_height=40;
    cur_date_type=0;
    cur_record_time_type=0;//0=定时 1=报警
    cur_date_type=0;//0 =无 2=开始  3=结束
    str_start_time_type0=@"";
    str_end_time_type0=@"";
    m_in_formatting=false;
    timeFormat= [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    m_strings=[vv_strings getInstance];
    m_share_item=[share_item getInstance];
    m_strings=[vv_strings getInstance];
    goe_Http=[ppview_cli getInstance];
    goe_Http.cli_c2s_sdcard_delegate=self;
    
    
    cur_record_time_type=0;
    m_querty_record_type=0;
    goe_Http.cli_c2s_record_config_delegate=self;
    
    [self init_view_value];
    lable_item_sdcard_info.text=@"";
    button_item_sdcard_format.hidden=true;
    [datepicker_recordtime addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    if (m_share_item.m_connect_state==1 && b_sdcard_info_get==false) {
        view_spinner.hidden=false;
        [self.view bringSubviewToFront:view_spinner];
        [goe_Http cli_lib_get_sdcard_info:m_share_item.h_connector];
    }
}
-(void)init_view_value
{
     [view_spinner setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
     [view_format_bg setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    [view_recordset setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_record_schedule setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_record_picker setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_record_datepicker setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    [button_item_sdcard_format setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    
    
    label_recordset.text=NSLocalizedString(@"m_record_set", @"");
    label_item_sdcard_title.text=NSLocalizedString(@"m_sdcard", @"");
    [button_item_sdcard_format setTitle:NSLocalizedString(@"m_format", @"") forState:UIControlStateNormal];
    
    label_record_schedule.text=NSLocalizedString(@"m_record_schedule_set", @"");
    label_schedule_switch.text=NSLocalizedString(@"m_record_schedule", @"");
    
    label_schedule_starttime.text=NSLocalizedString(@"m_start_time", @"");
    label_schedule_endtime.text=NSLocalizedString(@"m_end_time", @"");
    
    _label_repeat_day.text=NSLocalizedString(@"m_repeat", @"");
    [button_type0_day7 setTitle:NSLocalizedString(@"m_day7", @"") forState:UIControlStateNormal];
    [button_type0_day1 setTitle:NSLocalizedString(@"m_day1", @"") forState:UIControlStateNormal];
    [button_type0_day2 setTitle:NSLocalizedString(@"m_day2", @"") forState:UIControlStateNormal];
    [button_type0_day3 setTitle:NSLocalizedString(@"m_day3", @"") forState:UIControlStateNormal];
    [button_type0_day4 setTitle:NSLocalizedString(@"m_day4", @"") forState:UIControlStateNormal];
    [button_type0_day5 setTitle:NSLocalizedString(@"m_day5", @"") forState:UIControlStateNormal];
    [button_type0_day6 setTitle:NSLocalizedString(@"m_day6", @"") forState:UIControlStateNormal];
    
    
    
    lable_record_picker.text=NSLocalizedString(@"m_time_select", @"");
    [button_record_picker_ensure setTitle:NSLocalizedString(@"m_ensure", @"") forState:UIControlStateNormal];
    label_record_start_time.text=NSLocalizedString(@"m_start_time", @"");
    label_record_end_time_title.text=NSLocalizedString(@"m_end_time", @"");
    
    [button_format_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_format_ensure setTitle:NSLocalizedString(@"m_format", @"") forState:UIControlStateNormal];
    label_format_hint.text=NSLocalizedString(@"m_format_sdcard_hint", @"");
     
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


-(NSString*)get_err_msg:(int)res type:(int)type
{
    NSString* msg_prefix=@"";
    if (type==0) {
        msg_prefix=NSLocalizedString(@"m_format_err", @"");
    }
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
        case 404:
            msg=[NSString stringWithFormat:@"%@:%@",msg_prefix,NSLocalizedString(@"m_sdcard_err_404", @"")];
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
-(void)on_sdcardinfo_get_mainthread:(vv_req_info *)req
{
    //view_spinner.hidden=true;
    if (req.int_tag1==200) {
        //"status":整型，SD卡状态，（0=未格式化 1=正常 2=出错）
        if(m_sdcard_status==0){
            lable_item_sdcard_info.text=NSLocalizedString(@"m_sdcard_not_format", @"");
            button_item_sdcard_format.hidden=false;
        }
        else if(m_sdcard_status==1){
            lable_item_sdcard_info.text=[NSString stringWithFormat:@"%@%dM %@%dM",NSLocalizedString(@"m_sdcard_total", @""),m_sdcard_totalsize,NSLocalizedString(@"m_adcard_remain", @""),m_sdcard_freesize];
            button_item_sdcard_format.hidden=false;
        }
        else if(m_sdcard_status==2){
            lable_item_sdcard_info.text=NSLocalizedString(@"m_sdcard_err", @"");
            button_item_sdcard_format.hidden=false;
        }
        else if(m_sdcard_status==404){
            lable_item_sdcard_info.text=NSLocalizedString(@"m_sdcard_no", @"");
            button_item_sdcard_format.hidden=true;
        }
    }
    else if(req.int_tag1==404){
        m_sdcard_status=404;
        lable_item_sdcard_info.text=NSLocalizedString(@"m_sdcard_no", @"");
        button_item_sdcard_format.hidden=true;
    }
    
   
    [goe_Http cli_lib_get_record_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid];
}
-(void)cli_lib_sdcard_info_get_callback:(int)res status:(int)status total_space:(int)total_space free_space:(int)free_space
{
    NSLog(@"cli_lib_sdcard_info_get_callback,res=%d， free_space=%d",res,free_space);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    if (res==200) {
        m_sdcard_status=status;
        m_sdcard_totalsize=total_space;
        m_sdcard_freesize=free_space;
    }
    [self performSelectorOnMainThread:@selector(on_sdcardinfo_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}



-(void)parse_week_day:(NSString*)str_days rec_type:(int)rec_type
{
    if (str_days==nil) {
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
                if (rec_type==0) {
                    m_is_sun_type0=nValue;
                    m_is_sun_type0_new=m_is_sun_type0;
                }
                else{
                    m_is_sun_type1=nValue;
                    m_is_sun_type1_new=m_is_sun_type1;
                }
                break;
            case 1:
                if (rec_type==0) {
                    m_is_mon_type0=nValue;
                    m_is_mon_type0_new=m_is_mon_type0;
                }
                else{
                    m_is_mon_type1=nValue;
                    m_is_mon_type1_new=m_is_mon_type1;
                }
                break;
            case 2:
                if (rec_type==0) {
                    m_is_tue_type0=nValue;
                    m_is_tue_type0_new=m_is_tue_type0;
                }
                else{
                    m_is_tue_type1=nValue;
                    m_is_tue_type1_new=m_is_tue_type1;
                }
                break;
            case 3:
                if (rec_type==0) {
                    m_is_wed_type0=nValue;
                    m_is_wed_type0_new=m_is_wed_type0;
                }
                else{
                    m_is_wed_type1=nValue;
                    m_is_wed_type1_new=m_is_wed_type1;
                }
                break;
            case 4:
                if (rec_type==0) {
                    m_is_thu_type0=nValue;
                    m_is_thu_type0_new=m_is_thu_type0;
                }
                else{
                    m_is_thu_type1=nValue;
                    m_is_thu_type1_new=m_is_thu_type1;
                }
                break;
            case 5:
                if (rec_type==0) {
                    m_is_fri_type0=nValue;
                    m_is_fri_type0_new=m_is_fri_type0;
                }
                else{
                    m_is_fri_type1=nValue;
                    m_is_fri_type1_new=m_is_fri_type1;
                }
                break;
            case 6:
                if (rec_type==0) {
                    m_is_sat_type0=nValue;
                    m_is_sat_type0_new=m_is_sat_type0;
                }
                else{
                    m_is_sat_type1=nValue;
                    m_is_sat_type1_new=m_is_sat_type1;
                }
                break;
            default:
                break;
        }
        
    }
}
-(BOOL)parse_record_config:(NSData*)data
{
    if (data==nil) {
        return  false;
    }
    NSError* reserr;
    g_rec_dictionary= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reserr];
    if (g_rec_dictionary==nil) {
        return false;
    }
    //NSLog(@"parse_record_config, %@",g_rec_dictionary);
    if (m_querty_record_type==0) {
        g_rec_dictionary_type0= [g_rec_dictionary objectForKey:@"timing_schedule"];
        if (g_rec_dictionary_type0==nil) {
            return false;
        }
        m_record_enable_type0=[[g_rec_dictionary_type0 objectForKey:@"enabled"]intValue];
        str_timing_type0=[g_rec_dictionary_type0 objectForKey:@"day_of_week_enabled"];
        if(str_timing_type0==nil || str_timing_type0.length<=0){
            str_timing_type0=@"0000000";
        }
        [self parse_week_day:str_timing_type0 rec_type:m_querty_record_type];
        NSString* m_str_time=[g_rec_dictionary_type0 objectForKey:@"sun"];
        if (m_str_time != nil && m_str_time.length>0) {
            NSArray *chunks = [m_str_time componentsSeparatedByString: @"-"];
            m_start_time_record_type0=chunks[0];
            m_end_time_record_type0=chunks[1];
        }
    }
    else{
        g_rec_dictionary_type1= [g_rec_dictionary objectForKey:@"alert_schedule"];
        if (g_rec_dictionary_type1==nil) {
            return false;
        }
        m_record_enable_type1=[[g_rec_dictionary_type1 objectForKey:@"enabled"]intValue];
        str_timing_type1=[g_rec_dictionary_type1 objectForKey:@"day_of_week_enabled"];
        if(str_timing_type1==nil || str_timing_type1.length<=0){
            str_timing_type1=@"0000000";
        }
        [self parse_week_day:str_timing_type1 rec_type:m_querty_record_type];
        NSString* m_str_time=[g_rec_dictionary_type1 objectForKey:@"sun"];
        if (m_str_time != nil && m_str_time.length>0) {
            NSArray *chunks = [m_str_time componentsSeparatedByString: @"-"];
            m_start_time_record_type1=chunks[0];
            m_end_time_record_type1=chunks[1];
        }
    }
    return true;
}
-(void)on_record_config_get_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    if (req.int_tag1==200) {
        b_record_info_get=true;
        if ([self parse_record_config:req.data_tag1]==true) {
            if (m_querty_record_type==0) {
                [self update_record_view_type:0];
                view_record_schedule.hidden=false;
                [self.view bringSubviewToFront:view_record_schedule];
            }
        }
    }
    else{
        b_record_info_get=false;
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:1]];
    }
}


-(void)cli_lib_record_config_get_callback:(int)res  with_config:(NSData*)config_json
{
    NSLog(@"cli_lib_record_config_get_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.data_tag1=config_json;
    [self performSelectorOnMainThread:@selector(on_record_config_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}
-(void)update_record_view_type:(int)type
{
    if (type==0) {
        if (m_record_enable_type0==0) {
            img_schedule_switch_right.image=[UIImage imageNamed:@"zx_switch_off.png"];
            view_schedule_info.hidden=true;
        }
        else{
            img_schedule_switch_right.image=[UIImage imageNamed:@"zx_switch_on.png"];
            view_schedule_info.hidden=false;
            label_schedule_starttime_info.text=m_start_time_record_type0;
            label_schedule_endtime_info.text=m_end_time_record_type0;

            if (m_is_sun_type0==0) {
                button_type0_day7.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day7.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_mon_type0==0) {
                button_type0_day1.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day1.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_tue_type0==0) {
                button_type0_day2.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day2.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_wed_type0==0) {
                button_type0_day3.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day3.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_thu_type0==0) {
                button_type0_day4.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day4.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_fri_type0==0) {
                button_type0_day5.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day5.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
            if (m_is_sat_type0==0) {
                button_type0_day6.backgroundColor=UIColorFromRGB(m_strings.background_gray1);
            }
            else{
                button_type0_day6.backgroundColor=UIColorFromRGB(m_strings.background_blue);
            }
        }
    }
}
-(NSString*)get_date_string:(NSDate*)date with_format:(NSDateFormatter*)format
{
    NSString *DateStr = [format stringFromDate:date];
    return DateStr;
}

-(void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    
    switch (cur_date_type) {
        case 2:
            if (cur_record_time_type==0) {
                start_date_type0=paramDatePicker.date;
                str_start_time_type0= [self get_date_string:start_date_type0 with_format:timeFormat];
                label_record_start_timeinfo.text=str_start_time_type0;
            }
            else if (cur_record_time_type==1) {
                start_date_type1=paramDatePicker.date;
                str_start_time_type1= [self get_date_string:start_date_type1 with_format:timeFormat];
                label_record_start_timeinfo.text=str_start_time_type1;
            }

            break;
        case 3:
            if (cur_record_time_type==0) {
                end_date_type0=paramDatePicker.date;
                str_end_time_type0= [self get_date_string:end_date_type0 with_format:timeFormat];
                label_record_end_time_info.text=str_end_time_type0;
            }
            else if (cur_record_time_type==1) {
                end_date_type1=paramDatePicker.date;
                str_end_time_type1= [self get_date_string:end_date_type1 with_format:timeFormat];
                label_record_end_time_info.text=str_end_time_type1;
            }
            break;
            
        default:
            break;
    }
    
}
- (IBAction)button_return_click:(id)sender {
    if (m_in_formatting==true) {
        [OMGToast showWithText:NSLocalizedString(@"m_formatting_exit", @"")];
        return;
    }
    goe_Http.cli_c2s_sdcard_delegate=nil;
    [self dismissViewControllerAnimated:NO completion:^(){
        
    }];
}

- (IBAction)button_formatcard_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
        
    }
    view_format_bg.hidden=false;
    [self.view bringSubviewToFront:view_format_bg];
}


///////////


- (IBAction)button_record_schedule_switch_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    
    if (m_record_enable_type0==0) {
        m_record_enable_type0_new=1;
    }
    else{
        m_record_enable_type0_new=0;
    }
    m_config_type=2;
    [self start_record_config];
}

- (IBAction)button_record_schedule_starttime_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    cur_date_type=2;
    str_start_time_type0=m_start_time_record_type0;
    str_end_time_type0=m_end_time_record_type0;
    label_record_start_timeinfo.text=str_start_time_type0;
    label_record_end_time_info.text=str_end_time_type0;
    [self view_main_picker_referesh];
    view_record_picker.hidden=false;
    [self.view bringSubviewToFront:view_record_picker];
}

- (IBAction)button_record_schedule_endtime_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    cur_date_type=3;
    str_start_time_type0=m_start_time_record_type0;
    str_end_time_type0=m_end_time_record_type0;
    label_record_start_timeinfo.text=str_start_time_type0;
    label_record_end_time_info.text=str_end_time_type0;
    [self view_main_picker_referesh];
    view_record_picker.hidden=false;
    [self.view bringSubviewToFront:view_record_picker];
}

- (IBAction)button_schedule_day7_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_sun_type0==0) {
        m_is_sun_type0_new=1;
    }
    else{
        m_is_sun_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day7_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_sun_type1==0) {
        m_is_sun_type1_new=1;
    }
    else{
        m_is_sun_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}
- (IBAction)button_schedule_day1_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_mon_type0==0) {
        m_is_mon_type0_new=1;
    }
    else{
        m_is_mon_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day1_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_mon_type1==0) {
        m_is_mon_type1_new=1;
    }
    else{
        m_is_mon_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}

- (IBAction)button_schedule_day2_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_tue_type0==0) {
        m_is_tue_type0_new=1;
    }
    else{
        m_is_tue_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day2_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_tue_type1==0) {
        m_is_tue_type1_new=1;
    }
    else{
        m_is_tue_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}
- (IBAction)button_schedule_day3_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_wed_type0==0) {
        m_is_wed_type0_new=1;
    }
    else{
        m_is_wed_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day3_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_wed_type1==0) {
        m_is_wed_type1_new=1;
    }
    else{
        m_is_wed_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}
- (IBAction)button_schedule_day4_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_thu_type0==0) {
        m_is_thu_type0_new=1;
    }
    else{
        m_is_thu_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day4_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_thu_type1==0) {
        m_is_thu_type1_new=1;
    }
    else{
        m_is_thu_type1_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}

- (IBAction)button_schedule_day5_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_fri_type0==0) {
        m_is_fri_type0_new=1;
    }
    else{
        m_is_fri_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day5_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_fri_type1==0) {
        m_is_fri_type1_new=1;
    }
    else{
        m_is_fri_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}
- (IBAction)button_schedule_day6_click:(id)sender {
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_sat_type0==0) {
        m_is_sat_type0_new=1;
    }
    else{
        m_is_sat_type0_new=0;
    }
    m_config_type=4;
    [self start_record_config];
}
- (IBAction)button_alarm_day6_click:(id)sender
{
    if (m_share_item.m_connect_state!=1 || b_record_info_get!=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_is_sat_type1==0) {
        m_is_sat_type1_new=1;
    }
    else{
        m_is_sat_type1_new=0;
    }
    m_config_type=41;
    [self start_record_config];
}
-(void)view_main_picker_referesh
{
    
    if (cur_date_type==0) {
        view_record_datepicker.hidden=true;
        NC_viewend_viewtop_topspace.constant=1;
    }
    else if(cur_date_type==2){
        NSString* strStartTime=label_record_start_timeinfo.text;
        if (strStartTime==nil || strStartTime.length<=0) {
            strStartTime=@"00:00";
        }
        [datepicker_recordtime setDate:[timeFormat dateFromString:strStartTime]];
        view_record_datepicker.hidden=false;
        NC_viewpick_viewtop_topspace.constant=1;
        NC_viewend_viewtop_topspace.constant=f_picker_height+1;
    }
    else if(cur_date_type==3){
        
        //[datepicker_recordtime setDate:[timeFormat dateFromString:label_alarm_starttime_info.text]];
        NSString* strEndTime=label_record_end_time_info.text;
        if (strEndTime==nil || strEndTime.length<=0) {
            strEndTime=@"23:59";
        }
        [datepicker_recordtime setDate:[timeFormat dateFromString:strEndTime]];
        view_record_datepicker.hidden=false;
        NC_viewend_viewtop_topspace.constant=1;
        NC_viewpick_viewtop_topspace.constant=f_picker_item_height+1;
    }
}
- (IBAction)button_record_starttime_bg_click:(id)sender {
    //cur_record_time_type=0//0=定时 1=报警
    //cur_date_type=0//0 =无 2=开始  3=结束
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

- (IBAction)button_record_endtime_bg_click:(id)sender {
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

-(void)on_record_config_set_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    if (req.int_tag1==200) {
        switch (m_config_type) {
            case 2:
                m_record_enable_type0=m_record_enable_type0_new;
                [self update_record_view_type:0];
                break;
            case 3:
                m_start_time_record_type0=m_start_time_record_type0_new;
                m_end_time_record_type0=m_end_time_record_type0_new;
                [self update_record_view_type:0];
                break;
            case 4:
                str_timing_type0=str_timing_type0_new;
                [self parse_week_day:str_timing_type0 rec_type:0];
                [self update_record_view_type:0];
                break;
            case 21:
                m_record_enable_type1=m_record_enable_type1_new;
                [self update_record_view_type:1];
                break;
            case 31:
                m_start_time_record_type1=m_start_time_record_type1_new;
                m_end_time_record_type1=m_end_time_record_type1_new;
                [self update_record_view_type:1];
                break;
            case 41:
                str_timing_type1=str_timing_type1_new;
                [self parse_week_day:str_timing_type1 rec_type:1];
                [self update_record_view_type:1];
                break;
            default:
                break;
        }
    }
    else{
        NSString* tmp_time=nil;
        switch (m_config_type) {
            case 2:
                [g_rec_dictionary_type0 setObject:[NSNumber numberWithInt:m_record_enable_type0] forKey:@"enabled"];
                break;
            case 3:
                tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_record_type0,m_end_time_record_type0];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"thu"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"mon"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sun"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"fri"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"wed"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sat"];
                [g_rec_dictionary_type0 setObject:tmp_time forKey:@"tue"];
                break;
            case 4:
                [g_rec_dictionary_type0 setObject:str_timing_type0 forKey:@"day_of_week_enabled"];
                break;
            default:
                break;
        }
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:1]];
    }
}
-(void)cli_lib_record_config_set_callback:(int)res
{
    NSLog(@"cli_lib_record_config_set_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_record_config_set_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)start_record_config{
    if (g_rec_dictionary==nil) {
        return;
    }
    if (m_config_type==2)
    {
        [g_rec_dictionary_type0 setObject:[NSNumber numberWithInt:m_record_enable_type0_new] forKey:@"enabled"];
    }
    else if(m_config_type==3)
    {
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_record_type0_new,m_end_time_record_type0_new];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"thu"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"mon"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sun"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"fri"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"wed"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sat"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"tue"];
    }
    else if (m_config_type==4)
    {
        
        str_timing_type0_new=[NSString stringWithFormat:@"%d%d%d%d%d%d%d",m_is_sun_type0_new,m_is_mon_type0_new,m_is_tue_type0_new,m_is_wed_type0_new,m_is_thu_type0_new,m_is_fri_type0_new,m_is_sat_type0_new];
        [g_rec_dictionary_type0 setObject:str_timing_type0_new forKey:@"day_of_week_enabled"];
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_record_type0,m_end_time_record_type0];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"thu"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"mon"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sun"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"fri"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"wed"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"sat"];
        [g_rec_dictionary_type0 setObject:tmp_time forKey:@"tue"];
    }
    else if (m_config_type==21)
    {
        [g_rec_dictionary_type1 setObject:[NSNumber numberWithInt:m_record_enable_type1_new] forKey:@"enabled"];
    }
    else if(m_config_type==31)
    {
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_record_type1_new,m_end_time_record_type1_new];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"thu"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"mon"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"sun"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"fri"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"wed"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"sat"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"tue"];
    }
    else if (m_config_type==41)
    {
        str_timing_type1_new=[NSString stringWithFormat:@"%d%d%d%d%d%d%d",m_is_sun_type1_new,m_is_mon_type1_new,m_is_tue_type1_new,m_is_wed_type1_new,m_is_thu_type1_new,m_is_fri_type1_new,m_is_sat_type1_new];
        [g_rec_dictionary_type1 setObject:str_timing_type1_new forKey:@"day_of_week_enabled"];
        NSString* tmp_time=[NSString stringWithFormat:@"%@-%@",m_start_time_record_type1,m_end_time_record_type1];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"thu"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"mon"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"sun"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"fri"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"wed"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"sat"];
        [g_rec_dictionary_type1 setObject:tmp_time forKey:@"tue"];
    }
    else{
        return;
    }
    NSData* senddata = [NSJSONSerialization dataWithJSONObject:g_rec_dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString* poststring = [[NSString alloc]initWithData:senddata encoding:NSUTF8StringEncoding];
    //NSLog(@"start_record_config, poststring=%@",poststring);
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_set_record_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid config:poststring];
    
}

- (IBAction)button_record_time_ensure_click:(id)sender {
    view_record_picker.hidden=true;
    if (cur_record_time_type==0) {
        m_start_time_record_type0_new=str_start_time_type0;
        m_end_time_record_type0_new=str_end_time_type0;
        m_config_type=3;
    }
    else if (cur_record_time_type==1) {
        m_start_time_record_type1_new=str_start_time_type1;
        m_end_time_record_type1_new=str_end_time_type1;
        m_config_type=31;
    }
    [self start_record_config];
}

- (IBAction)button_record_time_return_click:(id)sender {
    view_record_picker.hidden=true;
}

- (IBAction)button_format_sdcard_cancel_click:(id)sender {
    view_format_bg.hidden=true;
}


-(void)on_sdcardinfo_format_mainthread:(vv_req_info *)req
{
    m_in_formatting=false;
    label_spinner_hint.text=@"";
    if (req.int_tag1==200) {
        NSString* msg=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"m_format", @""),NSLocalizedString(@"m_success", @"")];
        [OMGToast showWithText:msg];
        [goe_Http cli_lib_get_sdcard_info:m_share_item.h_connector];
    }
    else{
        view_spinner.hidden=true;
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:0]];
    }
}

-(void)cli_lib_sdcard_format_callback:(int)res
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_sdcardinfo_format_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)on_sdcar_format_progress_mainthread
{
    label_spinner_hint.text= [NSString stringWithFormat:@"%d%%",m_sdcard_format_progress];
}
-(void)cli_lib_sdcard_format_progress_callback:(int)progress
{
    m_sdcard_format_progress=progress;
    [self performSelectorOnMainThread:@selector(on_sdcar_format_progress_mainthread) withObject:nil waitUntilDone:YES];
}

- (IBAction)button_format_sdcard_ensure_click:(id)sender {
    m_in_formatting=true;
    view_format_bg.hidden=true;
    view_spinner.hidden=false;
    m_sdcard_format_progress=0;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_format_sdcard:m_share_item.h_connector];
}

@end
