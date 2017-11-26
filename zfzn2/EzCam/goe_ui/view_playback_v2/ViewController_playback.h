//
//  ViewController_playback.h
//  pano360
//
//  Created by zxy on 2017/1/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "LXMRulerView.h"
#import "zxy_share_data.h"
#import "vv_strings.h"
#import "share_item.h"
#import "ppview_cli.h"
#import "query_dateViewController.h"
#import "recordlist_manager.h"
#import "view_player_playback_v2.h"
#import "pic_info.h"
#import "pic_file_manager.h"

@interface ViewController_playback : UIViewController<query_dateViewController_interface,dev_connect_interface,c2d_cam_query_record_interface,view_player_playback_v2_interface,UIGestureRecognizerDelegate,VRGCalendarViewDelegate,LXMRulerView_interface>
{
    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    share_item* m_share_item;
    ppview_cli* goe_Http;
    recordlist_manager* m_record_manager;
    pic_file_manager* m_file_manager;
    //CVoiceTalk* m_voice_talk;
    int m_audio_button_state;//-1 禁用  0 关闭 1 打开
    int m_snap_button_state;//-1 禁用  0 关闭 1 打开
    
    NSDate* m_start_date;
    NSDate* m_end_date;
    NSString* m_date_str;
    NSString* m_date_month_str;
    NSDate* m_date;
    long h_connector;
    NSString* m_date_display;
    
    int query_record_result;
    
    
    
    NSString* m_start_play_time;
    BOOL b_query_record;
    
    float m_maximumZoomScale;
    float m_cur_Scale;
    display_point* m_display_point;
    display_point* m_display_point_change;
    BOOL _isZoomed;
    
    CGPoint m_center_point;
    float x_width;
    float y_height;
    
    float m_last_Scale;
    BOOL is_portrait;
    NSTimer* hiddenTimer;
    
    float x1;// 点下的x
    float y1;// 点下的y
    NSData* jpgdata;
    int jpg_res;
    BOOL bMove;
    
    BOOL bFullScreen;
    BOOL bDefaultRecord;
    
    
    NSTimer* m_flow_Timer;
    int m_first_utc_time_zero;
    int get_timezone;
    
    BOOL is_zoom_mode;
    BOOL is_in_dragging;
    int m_cur_small_value;
    float f_small_slider_view_width;
    float f_small_slider_view_height;
    
    
    view_player_playback_v2* m_view_player;
    float m_view_width;
    float m_view_height;
    
    float m_video_ratio;
    UIInterfaceOrientation toOrientation;
    int cur_device_version;
    
    
    NSString* m_date_curday_str;
    
    float m_fish0_portrait_ratio_constant;
    float m_fish0_landscape_ratio_constant;
    
}
@property (weak, nonatomic) IBOutlet UIView *view_main;

@property (weak, nonatomic) IBOutlet UIView *view_calendar;
@property (weak, nonatomic) IBOutlet VRGCalendarView *m_calendar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *query_record_spinner;
@property (weak, nonatomic) IBOutlet LXMRulerView *m_rulerview;
@property (weak, nonatomic) IBOutlet UIButton *button_date_minute;
@property (weak, nonatomic) IBOutlet UILabel *label_ruler_value;
//////
@property (weak, nonatomic) IBOutlet UIView *view_top_tool;
@property (weak, nonatomic) IBOutlet UIButton *button_audio_play;
@property (weak, nonatomic) IBOutlet UIButton *button_snap;

@property (weak, nonatomic) IBOutlet UILabel *label_top_tool;
@property (weak, nonatomic) IBOutlet UIToolbar *bottom_toolbar;

@property (weak, nonatomic) IBOutlet UIView *view_jpg;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_jpg;
@property (weak, nonatomic) IBOutlet UIButton *button_save_to_lib;
@property (weak, nonatomic) IBOutlet UIButton *button_delete_pic;

@property (weak, nonatomic) IBOutlet UIView *view_small_slider;
@property (weak, nonatomic) IBOutlet UILabel *label_small_slider;
@property (weak, nonatomic) IBOutlet UIImageView *img_left_slider_small;
@property (weak, nonatomic) IBOutlet UIImageView *img_right_slider_small;

@property (weak, nonatomic) IBOutlet UIView *view_small_slider_fish_back;
@property (weak, nonatomic) IBOutlet UIView *view_small_slider_fish;
@property (weak, nonatomic) IBOutlet UIImageView *img_left_sldier_small_fish;
@property (weak, nonatomic) IBOutlet UIImageView *img_right_slider_small_fish;
@property (weak, nonatomic) IBOutlet UILabel *label_small_slider_fish;


@property (weak, nonatomic) IBOutlet UIButton *button_ctrl_small_slider_fish;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestur;
@property (weak, nonatomic) IBOutlet UIView *view_container;
@property (weak, nonatomic) IBOutlet VideoWnd *glview_play;
@property (weak, nonatomic) IBOutlet UIView *video_indicator_back;
@property (weak, nonatomic) IBOutlet UILabel *video_cache_label;
@property (weak, nonatomic) IBOutlet UIView *view_rooler_container;

////

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_playcontainer_ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_par_top_space;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_playcontainer_offset_center;


- (IBAction)button_query_record_click:(id)sender;
- (IBAction)button_return_click:(id)sender;
- (void)hiddentoolbar;
- (IBAction)button_audio_play_onclick:(id)sender;
- (IBAction)button_snap_onclick:(id)sender;
- (IBAction)button_save_pic_onclick:(id)sender;
- (IBAction)button_delete_pic_onclick:(id)sender;
- (IBAction)button_ctrl_small_slider_fish_click:(id)sender;

@end
