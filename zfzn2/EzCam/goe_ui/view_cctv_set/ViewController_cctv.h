//
//  ViewController_cctv.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "vv_strings.h"
#import "OMGToast.h"
#import "share_item.h"
#import "InsetsTextField.h"
#import "vv_req_info.h"
#import "zxy_share_data.h"
#import "TableViewCell_sensor.h"
#import "sensors_manager.h"
@interface ViewController_cctv : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,c2s_sensors_interface,c2s_arm_config_interface,TableViewCell_sensor_interface,c2s_sensors_interface,c2d_timezone_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    share_item* m_share_item;
    sensors_manager* m_sensor_manager;
     NSString* m_exist_sensor_name;
    
    float f_picker_height;
    float f_picker_item_height;
    
    
    float f_schedule_alert_info_height;
    float f_group_spaceing;
    
    int cur_date_type;//0 =无 2=开始  3=结束
    NSDate *currentDate;
    
    NSDate* date_date;
    NSDate* start_date;
    NSDate* end_date;
    
    NSString* str_date;
    NSString* str_start_time;
    NSString* str_end_time;
    NSDateFormatter *dateFormat;
    NSDateFormatter *timeFormat;
    BOOL b_arm_config_get;
    
    int m_timing_arm_enable;
    NSString* str_timing_arm;
    NSString* m_start_time_alert;
    NSString* m_end_time_alert;
    int m_is_sun;
    int m_is_mon;
    int m_is_tue;
    int m_is_wed;
    int m_is_thu;
    int m_is_fri;
    int m_is_sat;
    int m_snap_num;
    int m_alert_act;
    int m_alert_time;
    int m_alarm_delay;
    int m_motion_enable;
    int m_devalert_sound;
    
    int m_is_push_new;
    int m_is_door_bell_new;
    int m_timing_arm_enable_new;
    NSString* str_timing_arm_new;
    NSString* m_start_time_alert_new;
    NSString* m_end_time_alert_new;
    int m_is_sun_new;
    int m_is_mon_new;
    int m_is_tue_new;
    int m_is_wed_new;
    int m_is_thu_new;
    int m_is_fri_new;
    int m_is_sat_new;
    int m_snap_num_new;
    int m_alarm_delay_new;
    int m_alert_act_new;
    int m_alert_time_new;
    int m_motion_enable_new;
    int m_devalert_sound_new;
    
    int m_config_type;//-2=初始化 -1=全部 0=门铃 1=推送开关 2=定时布撤防 3=布防时间 4=重复日期 5=延迟时间 6=报警拍图 7=云台方式 8=持续时间 9=motion enable 10=alertsound
    
    NSMutableDictionary* g_arm_dictionary;
    
    
    item_sensor* cur_sensor_item;
    NSString* m_sensor_new_name;
    NSString* m_cur_set_name;
    NSString* m_cur_set_value_str;
    int m_cur_set_value_int;
    int m_cur_set_tag;
    BOOL bCodding;
}
@property (weak, nonatomic) IBOutlet UIView *view_spinner;
@property (weak, nonatomic) IBOutlet UILabel *label_spinner_hint;
//////////////////////

@property (weak, nonatomic) IBOutlet UIView *view_cctv_main;
@property (weak, nonatomic) IBOutlet UIView *view_cctv_main_top;
@property (weak, nonatomic) IBOutlet UILabel *label_cctv_main;

@property (weak, nonatomic) IBOutlet UIView *view_item_schedule_alert;
@property (weak, nonatomic) IBOutlet UIImageView *img_item_schedule_alert_right;
@property (weak, nonatomic) IBOutlet UILabel *label_item_schedule_alert_title;

@property (weak, nonatomic) IBOutlet UIView *view_schedule_alert_info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NC_scheduleinfo_scheduletop_spaceing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NC_item_motion_scheduletop_spaceing;
@property (weak, nonatomic) IBOutlet UILabel *label_alert_start_time_title;
@property (weak, nonatomic) IBOutlet UILabel *label_alert_start_time;
@property (weak, nonatomic) IBOutlet UILabel *label_alert_end_time_title;
@property (weak, nonatomic) IBOutlet UILabel *label_alert_end_time;
@property (weak, nonatomic) IBOutlet UILabel *label_repeatday_title;
@property (weak, nonatomic) IBOutlet UIButton *button_day7;
@property (weak, nonatomic) IBOutlet UIButton *button_day1;
@property (weak, nonatomic) IBOutlet UIButton *button_day2;
@property (weak, nonatomic) IBOutlet UIButton *button_day3;
@property (weak, nonatomic) IBOutlet UIButton *button_day4;
@property (weak, nonatomic) IBOutlet UIButton *button_day5;
@property (weak, nonatomic) IBOutlet UIButton *button_day6;

@property (weak, nonatomic) IBOutlet UIView *view_item_motion;
@property (weak, nonatomic) IBOutlet UILabel *label_item_motion_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_item_motion_switch;

@property (weak, nonatomic) IBOutlet UIView *view_item_devalert_sound;
@property (weak, nonatomic) IBOutlet UILabel *label_item_devalert_sound_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_item_devalert_sound_switch;
@property (weak, nonatomic) IBOutlet UIButton *button_item_devalert_sound;

@property (weak, nonatomic) IBOutlet UIView *view_item_snapnum;
@property (weak, nonatomic) IBOutlet UILabel *label_item_snapnum_title;
@property (weak, nonatomic) IBOutlet UILabel *label_item_snapnum;

@property (weak, nonatomic) IBOutlet UIView *view_item_recordlong;
@property (weak, nonatomic) IBOutlet UILabel *label_item_recordlong_title;
@property (weak, nonatomic) IBOutlet UILabel *label_item_recordlong;

@property (weak, nonatomic) IBOutlet UIView *view_item_liandong;
@property (weak, nonatomic) IBOutlet UILabel *label_item_liandong_title;
@property (weak, nonatomic) IBOutlet UILabel *label_item_liandong;

@property (weak, nonatomic) IBOutlet UIView *view_item_sensors;
@property (weak, nonatomic) IBOutlet UILabel *label_item_sensors_title;
////////////////////////////////////////////////
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
/////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_alarm_set_bg;
@property (weak, nonatomic) IBOutlet UIView *view_alarm_snap;
@property (weak, nonatomic) IBOutlet UILabel *label_alarm_snap;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_snap1;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_snap2;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_snap3;

@property (weak, nonatomic) IBOutlet UIView *view_alarm_recordlong;
@property (weak, nonatomic) IBOutlet UILabel *label_alarm_recordlong;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong1;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong2;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong3;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong4;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong5;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_recordlong6;

@property (weak, nonatomic) IBOutlet UIView *view_alarm_ptz;
@property (weak, nonatomic) IBOutlet UILabel *label_alarm_ptz;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_ptz1;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_ptz2;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_ptz3;
@property (weak, nonatomic) IBOutlet UIButton *button_alarm_ptz4;
////////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_sensors;
@property (weak, nonatomic) IBOutlet UIView *view_sensors_top;
@property (weak, nonatomic) IBOutlet UILabel *label_sensors_top;
@property (weak, nonatomic) IBOutlet UIButton *button_sensor_codding;
@property (weak, nonatomic) IBOutlet UITableView *tableview_sensors;
//-------------------------------------
@property (weak, nonatomic) IBOutlet UIView *view_sensor_edit;
@property (weak, nonatomic) IBOutlet UIView *view_sensor_edit_top;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_edit_top;

@property (weak, nonatomic) IBOutlet UIView *view_sensor_name;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_name_title;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_name;

@property (weak, nonatomic) IBOutlet UIView *view_sensor_id;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_id_title;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_id;

@property (weak, nonatomic) IBOutlet UIView *view_sensor_mode;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_mode_title;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_mode;

@property (weak, nonatomic) IBOutlet UIView *view_sensor_alert;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_alert_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_sensor_alert_switch;
@property (weak, nonatomic) IBOutlet UIButton *button_sensor_delete;


//-----------------------------------
@property (weak, nonatomic) IBOutlet UIView *view_rename;
@property (weak, nonatomic) IBOutlet UIView *view_rename_top;
@property (weak, nonatomic) IBOutlet UIButton *button_rename_cancel;
@property (weak, nonatomic) IBOutlet UIButton *button_rename_ensure;
@property (weak, nonatomic) IBOutlet UILabel *label_rename_title;
@property (weak, nonatomic) IBOutlet InsetsTextField *tv_rename;
//-----------------------------------
@property (weak, nonatomic) IBOutlet UIView *view_delete;
@property (weak, nonatomic) IBOutlet UIButton *button_delete_cancel;
@property (weak, nonatomic) IBOutlet UIButton *button_delete_ensure;
@property (weak, nonatomic) IBOutlet UITextView *label_delete_hint;

//-----------------------
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_liandong_height;

- (IBAction)cctv_main_return:(id)sender;
- (IBAction)cctv_main_item_schedule_alert_click:(id)sender;
- (IBAction)cctv_main_item_schedule_starttime_click:(id)sender;
- (IBAction)cctv_main_item_schedule_endtime_click:(id)sender;
- (IBAction)cctv_main_item_day_click:(id)sender;
- (IBAction)cctv_main_item_motion_click:(id)sender;
- (IBAction)cctv_main_item_devalert_sound_click:(id)sender;

- (IBAction)cctv_main_item_snapnum_click:(id)sender;
- (IBAction)cctv_main_item_recordlong_click:(id)sender;
- (IBAction)cctv_main_item_liandong_click:(id)sender;
- (IBAction)cctv_main_item_sensors_click:(id)sender;

- (IBAction)button_picker_starttime_bg_click:(id)sender;
- (IBAction)button_picker_endtime_bg_click:(id)sender;
- (IBAction)button_alert_time_ensure_click:(id)sender;
- (IBAction)button_alert_time_return_click:(id)sender;

- (IBAction)button_alarm_snap_button_click:(id)sender;
- (IBAction)button_alarm_recordlong_button_click:(id)sender;
- (IBAction)button_alarm_ptz_button_click:(id)sender;


- (IBAction)button_sensors_return:(id)sender;
- (IBAction)button_start_codding_click:(id)sender;

- (IBAction)button_sensor_edit_return:(id)sender;
- (IBAction)button_sensor_editname_click:(id)sender;
- (IBAction)button_sensor_alert_click:(id)sender;
- (IBAction)button_sensor_delete_click:(id)sender;

- (IBAction)button_rename_cancel_click:(id)sender;
- (IBAction)button_rename_ensure_click:(id)sender;

- (IBAction)button_delete_cancel:(id)sender;
- (IBAction)button_delete_ensure_click:(id)sender;

- (IBAction)alarm_set_cancel:(id)sender;
@end
