//
//  ViewController_fishplay.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoWnd_fish.h"

#import "cam_list_item.h"

#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "pic_file_manager.h"
#import "PopoverView.h"
#import "CTalk.h"
#import "vv_real_player.h"
#import "OMGToast.h"
@protocol playviewcontroller_fish_interface <NSObject>
@optional
-(void)on_tableview_needreferesh;
@end

@interface ViewController_fishplay : UIViewController<vv_real_play_interface,PopoverViewDelegate,dev_connect_interface,CTalk_interface,c2d_arm_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    zxy_share_data* MyShareData;
    pic_file_manager* m_file_manager;
    int cur_stream_type;
    BOOL b_idle;
    int bAudioStatus;
    BOOL b_released;
    int snap_src;//0=self  1=other
    
    int jpg_res;
    NSData* jpgdata;
    //int m_frame_rate;
    
    int m_play_type;
    NSString* cur_uuid;
    
    NSTimer* timer;
    NSString* filename_video;
    NSString* filename_pic;
    
    int m_mode;
    
    NSTimer* m_flow_Timer;
    
    BOOL m_bReording;
    BOOL is_p2ptalk_mode;
    
    
    PopoverView* m_popover_view_stream;
    UIView* streamselectView;
    UIView* item_stream1_view;
    UIImageView* img_stream1;
    UILabel* label_stream1;
    UIButton* button_item_stream1_bg;
    
    UIView* item_stream2_view;
    UIImageView* img_stream2;
    UILabel* label_stream2;
    UIButton* button_item_stream2_bg;
    
    BOOL if_snap_for_list;
    
    CTalk* m_voice_talk;
    int m_audio_button_state;//-1 禁用  0 关闭 1 打开
    int m_mic_button_state;
    
    int talk_res;
    UIInterfaceOrientation toOrientation;
    
    int m_cur_playmode;
    
    int m_arm_button_state;
    
    int to_arm_status;
    int m_arm_res;
    BOOL bFirstGetArmstatus;
}

@property (assign, nonatomic) id<playviewcontroller_fish_interface> delegate;
@property (retain) cam_list_item* m_cam_item;
@property (retain) vv_real_player* m_player;
@property (assign) int playing_state;
@property (assign) BOOL m_bReording;
@property (assign) int bAudioExist;
@property (assign) int bAudioP2PExist;
@property (assign) int bAudioP2PSize;
@property (assign) long hConnector_talk;
@property (assign) int connect_status_talk;
@property (assign) int cur_stream_type;
@property (assign) long hConnector_arm;
@property (assign) int connect_status_arm;
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet VideoWnd_fish *m_play_view;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *videoIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *img_record;
@property (weak, nonatomic) IBOutlet UIButton *button_stream_select;
@property (weak, nonatomic) IBOutlet UIView *view_top_tool;
@property (weak, nonatomic) IBOutlet UIView *view_mediainfo;
@property (weak, nonatomic) IBOutlet UILabel *label_flow;
@property (weak, nonatomic) IBOutlet UILabel *label_speed;
@property (weak, nonatomic) IBOutlet UIButton *button_snap;
@property (weak, nonatomic) IBOutlet UIView *view_jpg;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_jpg;
@property (weak, nonatomic) IBOutlet UIButton *button_video_record;
@property (weak, nonatomic) IBOutlet UIButton *button_audio_play;

@property (weak, nonatomic) IBOutlet UIView *view_p2p_talk;
@property (weak, nonatomic) IBOutlet UILabel *label_p2p_talk;
@property (weak, nonatomic) IBOutlet UIButton *button_p2p_stop;
@property (weak, nonatomic) IBOutlet UIView *view_talk_spinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *talk_spinner;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo_talk;

@property (weak, nonatomic) IBOutlet UIView *view_p2p_talk_type4;
@property (weak, nonatomic) IBOutlet UIButton *button_p2p_talk_type4;
@property (weak, nonatomic) IBOutlet UIButton *button_p2p_stop_type4;
@property (weak, nonatomic) IBOutlet UIView *view_talk_spinner_type4;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *talk_spinner_type4;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo_talk_type4;
@property (weak, nonatomic) IBOutlet UIButton *button_mic;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *label_frame_date;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_par_top_space;//0 heng  20 shu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_container_ratio;//x heng  1:1 shu
@property (weak, nonatomic) IBOutlet UIButton *button_playmode;
@property (weak, nonatomic) IBOutlet UIView *view_mode_select;

@property (weak, nonatomic) IBOutlet UIButton *button_playmode0;
@property (weak, nonatomic) IBOutlet UIButton *button_playmode1;
@property (weak, nonatomic) IBOutlet UIButton *button_playmode2;
@property (weak, nonatomic) IBOutlet UIButton *button_playmode3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_button_playmode0_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_button_playmode1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_button_playmode2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_button_playmode3_height;
@property (weak, nonatomic) IBOutlet UIButton *button_arm;
@property (weak, nonatomic) IBOutlet UIView *view_arm_spinner;



- (IBAction)button_return_click:(id)sender;
- (IBAction)button_stream_select_click:(id)sender;
- (IBAction)replayButtonOnClick:(id)sender;
- (IBAction)button_snap_onclick:(id)sender;
- (IBAction)button_save_pic_onclick:(id)sender;
- (IBAction)button_delete_pic_onclick:(id)sender;
- (IBAction)button_record_onclick:(id)sender;
- (IBAction)button_audio_play_onclick:(id)sender;
- (IBAction)button_stop_p2ptalk_onclick:(id)sender;
- (IBAction)button_mic_onclick:(id)sender;
- (IBAction)button_devid_onclick:(id)sender;
- (IBAction)button_change_playmode_onclick:(id)sender;

- (IBAction)button_playmode_onclick:(id)sender;

- (IBAction)button_arm_click:(id)sender;

@end
