//
//  ViewController_recordset.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "vv_strings.h"
#import "OMGToast.h"
#import "share_item.h"
#import "InsetsTextField.h"
#import "cam_list_manager_local.h"
#import "vv_req_info.h"
#import "zxy_share_data.h"

@interface ViewController_recordset : UIViewController<c2s_sdcard_interface,c2s_record_config_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    share_item* m_share_item;
    
    float f_picker_height;
    float f_picker_item_height;
    
    BOOL b_sdcard_info_get;
    int m_sdcard_status;
    int m_sdcard_totalsize;
    int m_sdcard_freesize;
    int m_sdcard_format_progress;
    BOOL m_in_formatting;
    
    int m_querty_record_type;//0:定时 1：报警
    
    NSMutableDictionary* g_rec_dictionary;
    NSMutableDictionary* g_rec_dictionary_type0;
    NSMutableDictionary* g_rec_dictionary_type1;
    BOOL b_record_info_get;
    
    int m_record_enable_type0;
    NSString* str_timing_type0;
    NSString* m_start_time_record_type0;
    NSString* m_end_time_record_type0;
    int m_is_sun_type0;
    int m_is_mon_type0;
    int m_is_tue_type0;
    int m_is_wed_type0;
    int m_is_thu_type0;
    int m_is_fri_type0;
    int m_is_sat_type0;
    
    int m_record_enable_type0_new;
    NSString* str_timing_type0_new;
    NSString* m_start_time_record_type0_new;
    NSString* m_end_time_record_type0_new;
    int m_is_sun_type0_new;
    int m_is_mon_type0_new;
    int m_is_tue_type0_new;
    int m_is_wed_type0_new;
    int m_is_thu_type0_new;
    int m_is_fri_type0_new;
    int m_is_sat_type0_new;
    
    int m_record_enable_type1;
    NSString* str_timing_type1;
    NSString* m_start_time_record_type1;
    NSString* m_end_time_record_type1;
    int m_is_sun_type1;
    int m_is_mon_type1;
    int m_is_tue_type1;
    int m_is_wed_type1;
    int m_is_thu_type1;
    int m_is_fri_type1;
    int m_is_sat_type1;
    
    int m_record_enable_type1_new;
    NSString* str_timing_type1_new;
    NSString* m_start_time_record_type1_new;
    NSString* m_end_time_record_type1_new;
    int m_is_sun_type1_new;
    int m_is_mon_type1_new;
    int m_is_tue_type1_new;
    int m_is_wed_type1_new;
    int m_is_thu_type1_new;
    int m_is_fri_type1_new;
    int m_is_sat_type1_new;
    
    NSDate *currentDate;
    NSDate* date_date;
    NSDate* start_date_type0;
    NSDate* end_date_type0;
    NSDate* start_date_type1;
    NSDate* end_date_type1;
    
    NSString* str_date_type0;
    NSString* str_start_time_type0;
    NSString* str_end_time_type0;
    NSString* str_date_type1;
    NSString* str_start_time_type1;
    NSString* str_end_time_type1;
    
    NSDateFormatter *dateFormat;
    NSDateFormatter *timeFormat;
    int cur_record_time_type;//0=定时 1=报警
    int cur_date_type;//0 =无 2=开始  3=结束
    
    int m_config_type;//2 定时录像是否开启 3
}
@property (weak, nonatomic) IBOutlet UIView *view_spinner;
@property (weak, nonatomic) IBOutlet UILabel *label_spinner_hint;
//////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_recordset;
@property (weak, nonatomic) IBOutlet UIView *view_recordset_top;
@property (weak, nonatomic) IBOutlet UILabel *label_recordset;

@property (weak, nonatomic) IBOutlet UIView *view_item_sdcard;
@property (weak, nonatomic) IBOutlet UILabel *label_item_sdcard_title;
@property (weak, nonatomic) IBOutlet UIButton *button_item_sdcard_format;
@property (weak, nonatomic) IBOutlet UILabel *lable_item_sdcard_info;


/////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_record_schedule;
@property (weak, nonatomic) IBOutlet UIView *view_record_schedule_top;
@property (weak, nonatomic) IBOutlet UILabel *label_record_schedule;
@property (weak, nonatomic) IBOutlet UIView *view_schedule_switch;
@property (weak, nonatomic) IBOutlet UIImageView *img_schedule_switch_right;
@property (weak, nonatomic) IBOutlet UILabel *label_schedule_switch;
@property (weak, nonatomic) IBOutlet UIView *view_schedule_info;
@property (weak, nonatomic) IBOutlet UIView *view_schedule_starttime;
@property (weak, nonatomic) IBOutlet UILabel *label_schedule_starttime;
@property (weak, nonatomic) IBOutlet UILabel *label_schedule_starttime_info;

@property (weak, nonatomic) IBOutlet UIView *view_schedule_endtime;
@property (weak, nonatomic) IBOutlet UILabel *label_schedule_endtime;
@property (weak, nonatomic) IBOutlet UILabel *label_schedule_endtime_info;


@property (weak, nonatomic) IBOutlet UILabel *label_repeat_day;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day7;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day1;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day2;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day3;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day4;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day5;
@property (weak, nonatomic) IBOutlet UIButton *button_type0_day6;

//////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_record_picker;
@property (weak, nonatomic) IBOutlet UIView *view_record_picker_top;
@property (weak, nonatomic) IBOutlet UILabel *lable_record_picker;
@property (weak, nonatomic) IBOutlet UIButton *button_record_picker_ensure;

@property (weak, nonatomic) IBOutlet UIView *view_record_start_time;
@property (weak, nonatomic) IBOutlet UILabel *label_record_start_time;
@property (weak, nonatomic) IBOutlet UILabel *label_record_start_timeinfo;

@property (weak, nonatomic) IBOutlet UIView *view_record_end_time;
@property (weak, nonatomic) IBOutlet UILabel *label_record_end_time_title;
@property (weak, nonatomic) IBOutlet UILabel *label_record_end_time_info;

@property (weak, nonatomic) IBOutlet UIView *view_record_datepicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker_recordtime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NC_viewend_viewtop_topspace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NC_viewpick_viewtop_topspace;
//////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_format_bg;
@property (weak, nonatomic) IBOutlet UIButton *button_format_cancel;
@property (weak, nonatomic) IBOutlet UIButton *button_format_ensure;
@property (weak, nonatomic) IBOutlet UITextView *label_format_hint;



- (IBAction)button_return_click:(id)sender;
- (IBAction)button_formatcard_click:(id)sender;
- (IBAction)button_record_schedule_bg_click:(id)sender;


- (IBAction)button_record_schedule_return:(id)sender;
- (IBAction)button_record_schedule_switch_click:(id)sender;
- (IBAction)button_record_schedule_starttime_click:(id)sender;
- (IBAction)button_record_schedule_endtime_click:(id)sender;

- (IBAction)button_schedule_day7_click:(id)sender;
- (IBAction)button_schedule_day1_click:(id)sender;
- (IBAction)button_schedule_day2_click:(id)sender;
- (IBAction)button_schedule_day3_click:(id)sender;
- (IBAction)button_schedule_day4_click:(id)sender;
- (IBAction)button_schedule_day5_click:(id)sender;
- (IBAction)button_schedule_day6_click:(id)sender;


- (IBAction)button_record_starttime_bg_click:(id)sender;
- (IBAction)button_record_endtime_bg_click:(id)sender;
- (IBAction)button_record_time_ensure_click:(id)sender;
- (IBAction)button_record_time_return_click:(id)sender;

- (IBAction)button_format_sdcard_cancel_click:(id)sender;
- (IBAction)button_format_sdcard_ensure_click:(id)sender;
@end
