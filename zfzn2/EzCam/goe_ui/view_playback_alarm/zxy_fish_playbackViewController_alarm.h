//
//  zxy_playbackViewController.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zxy_share_data.h"
#import "vv_strings.h"
#import "share_item.h"
#import "ppview_cli.h"
#import "view_player_playback_alarm_fish.h"
#import "pic_info.h"
#import "pic_file_manager.h"

//#import "zx_alarm_item.h"
@interface zxy_fish_playbackViewController_alarm : UIViewController<view_player_fish_playback_alarm_interface,UIGestureRecognizerDelegate>
{
    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    share_item* m_share_item;
    ppview_cli* goe_Http;
    pic_file_manager* m_file_manager;
    int m_audio_button_state;//-1 禁用  0 关闭 1 打开
    int m_snap_button_state;//-1 禁用  0 关闭 1 打开
    
   

    
    int cur_device_version;
    UIInterfaceOrientation toOrientation;
    
    
    view_player_playback_alarm_fish* m_view_player;
    
    NSString* m_start_play_time;
    
   
    
    
    BOOL is_portrait;
    NSTimer* _playTimer;
    
    float x1;// 点下的x
    float y1;// 点下的y
    NSData* jpgdata;
    int jpg_res;
    BOOL bMove;
    
    BOOL bFullScreen;
    int video_width;
    int video_height;
    
    int m_cur_sec;
    int m_total_time;
    BOOL bManualDrag;
    BOOL bSteping;
    
    NSDateFormatter *formatter;
    BOOL b_slider_inited;

}

@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIView *view_top_tool;
@property (weak, nonatomic) IBOutlet UIButton *button_top_tool;
@property (weak, nonatomic) IBOutlet UILabel *label_top_tool;
@property (weak, nonatomic) IBOutlet UIToolbar *bottom_toolbar;

@property (weak, nonatomic) IBOutlet UIButton *button_audio_play;
@property (weak, nonatomic) IBOutlet UIButton *button_snap;


@property (weak, nonatomic) IBOutlet UIView *view_jpg;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_jpg;
@property (weak, nonatomic) IBOutlet UIButton *button_save_to_lib;
@property (weak, nonatomic) IBOutlet UIButton *button_delete_pic;

@property (weak, nonatomic) IBOutlet UIView *view_slider;
@property (weak, nonatomic) IBOutlet UISlider *slider_play;
@property (weak, nonatomic) IBOutlet UILabel *label_cur_time;
@property (weak, nonatomic) IBOutlet UILabel *label_end_time;

@property (weak, nonatomic) IBOutlet UIView *view_container;
@property (weak, nonatomic) IBOutlet VideoWnd *glview_play;
@property (weak, nonatomic) IBOutlet UIView *video_indicator_back;
@property (weak, nonatomic) IBOutlet UILabel *video_cache_label;
@property (weak, nonatomic) IBOutlet UIButton *button_replay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_play;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_playcontainer_ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_par_top_space;


- (IBAction)button_return_click:(id)sender;
- (void)hiddentoolbar;
- (IBAction)button_audio_play_onclick:(id)sender;
- (IBAction)button_snap_onclick:(id)sender;
- (IBAction)button_save_pic_onclick:(id)sender;
- (IBAction)button_delete_pic_onclick:(id)sender;
- (IBAction)slider_begin_drag:(id)sender;
- (IBAction)slider_end_drag:(id)sender;
- (IBAction)slider_end_drag_out:(id)sender;

@end
