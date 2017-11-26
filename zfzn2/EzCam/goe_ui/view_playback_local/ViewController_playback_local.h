//
//  ViewController_playback_local.h
//  ppview_zx
//
//  Created by zxy on 15-2-7.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zxy_share_data.h"
#import "vv_strings.h"
#import "share_item.h"
#import "ppview_cli.h"
#import "view_player_playbacklocal.h"
#import "CTalk.h"

@interface ViewController_playback_local : UIViewController<view_player_local_interface,UIGestureRecognizerDelegate>
{
    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    share_item* m_share_item;
    ppview_cli* goe_Http;

    //CVoiceTalk* m_voice_talk;
    int m_audio_button_state;//-1 禁用  0 关闭 1 打开
    
    
    float m_portrait_playview_width;
    float m_portrait_playview_height;
    float m_portrait_width;
    float m_portrait_height;
    float m_landscape_width;
    float m_landscape_height;
    float m_y_offset;
    float f_view_top_tool_height;
    float f_slider_view_height;
    
    
    int cur_device_version;
    UIInterfaceOrientation toOrientation;
    
    float m_view_width;
    float m_view_height;
    view_player_playbacklocal* m_view_player;
    
    NSString* m_start_play_file;
    
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
    NSTimer* _playTimer;
    
    float x1;// 点下的x
    float y1;// 点下的y

    BOOL bMove;
    
    BOOL bFullScreen;
    int m_cur_sec;
    int m_total_time;
    BOOL bManualDrag;
    BOOL bSteping;
    
    int video_width;
    int video_height;
    
    BOOL bPause;
}

@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIView *view_top_tool;
@property (weak, nonatomic) IBOutlet UIButton *button_top_tool;
@property (weak, nonatomic) IBOutlet UILabel *label_top_tool;
@property (weak, nonatomic) IBOutlet UIToolbar *bottom_toolbar;
@property (weak, nonatomic) IBOutlet UIButton *button_audio_play;
@property (weak, nonatomic) IBOutlet UIButton *button_play_ctrl;

@property (weak, nonatomic) IBOutlet UIView *view_slider;
@property (weak, nonatomic) IBOutlet UISlider *slider_play;
@property (weak, nonatomic) IBOutlet UILabel *label_cur_time;
@property (weak, nonatomic) IBOutlet UILabel *label_end_time;


- (IBAction)button_return_click:(id)sender;
- (void)hiddentoolbar;
- (IBAction)button_audio_play_onclick:(id)sender;
- (IBAction)button_play_ctrl_onclick:(id)sender;

- (IBAction)slider_begin_drag:(id)sender;
- (IBAction)slider_end_drag:(id)sender;
- (IBAction)slider_end_drag_out:(id)sender;



@end
