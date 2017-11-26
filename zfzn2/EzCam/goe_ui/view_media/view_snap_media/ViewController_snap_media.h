//
//  ViewController_snap_media.h
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMGToast.h"
#import "ppview_cli.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TableViewCell_pic_day.h"
#import "TableViewCell_pic_info.h"
#import "zx_snap_manager.h"
#import "zx_alarm_item.h"
#import "share_item.h"
#import "vv_req_info.h"
#import "pic_file_item.h"
#import "pic_cache_list_manager.h"
#import "gallery_photo_manager.h"
#import "ViewController_gallery.h"
#import "foler_item.h"
#import "pic_file_manager.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "item_file_cell.h"
#import "gallery_photo_manager.h"
#import "TableViewCell_localvideo.h"
#import "ViewController_playback_local.h"

@interface ViewController_snap_media : UIViewController<UITableViewDataSource,UITableViewDelegate,c2s_arm_events_interface,dev_connect_interface,UIGridViewDelegate,TableViewCell_localvideo_interface>
{
    zxy_share_data* MyShareData;
    ppview_cli* goe_Http;
    vv_strings* m_strings;
    zx_snap_manager* m_snap_manager;
    share_item* m_share_item;
    pic_cache_list_manager *m_pic_manager;
    gallery_photo_manager* m_photo_manager;
    pic_file_manager* m_file_manager;
    
    float m_width;
    float m_height;
    float m_y_offset;

    NSString *moviePath;
    
    BOOL b_events_get;
    long h_connector;
    int m_connect_state;
    
    NSMutableArray* m_file_array;
    float f_view_top_tool_height;
    
    NSMutableArray* m_folder_pic_array;
    NSMutableArray* m_folder_video_array;
    NSMutableArray* m_file_delete_array;
    
    int m_pic_cur_mode;
    int m_video_cur_mode;
}
@property (weak, nonatomic) IBOutlet UIView *view_main_pic;
@property (weak, nonatomic) IBOutlet UIView *view_top_pic;
@property (weak, nonatomic) IBOutlet UIButton *button_return_pic;
@property (weak, nonatomic) IBOutlet UILabel *label_title_pic;
@property (weak, nonatomic) IBOutlet UIButton *button_pic_video;
@property (weak, nonatomic) IBOutlet UITableView *tableview_pic;


@property (weak, nonatomic) IBOutlet UIView *view_main_local;
@property (weak, nonatomic) IBOutlet UIView *view_folder;
@property (weak, nonatomic) IBOutlet UIView *view_folder_top;
@property (weak, nonatomic) IBOutlet UIButton *button_return_folder;
@property (weak, nonatomic) IBOutlet UILabel *label_title_folder;

@property (weak, nonatomic) IBOutlet UIView *view_pic_folder;
@property (weak, nonatomic) IBOutlet UILabel *label_pic_folder_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_pic_folder;
@property (weak, nonatomic) IBOutlet UIButton *button_pic_folder_bg;

@property (weak, nonatomic) IBOutlet UIView *view_video_folder;
@property (weak, nonatomic) IBOutlet UILabel *label_video_folder_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_video_folder;
@property (weak, nonatomic) IBOutlet UIButton *button_video_folder_bg;

@property (weak, nonatomic) IBOutlet UIView *view_record_folder;
@property (weak, nonatomic) IBOutlet UILabel *label_record_folder_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_record_folder;
@property (weak, nonatomic) IBOutlet UIButton *button_record_folder_bg;


@property (weak, nonatomic) IBOutlet UIView *view_pic;
@property (weak, nonatomic) IBOutlet UIView *mode_pic_tool;
@property (weak, nonatomic) IBOutlet UILabel *mode_pic_label;
@property (weak, nonatomic) IBOutlet UIButton *mode_pic_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_pic_button_delete;
@property (weak, nonatomic) IBOutlet UIButton *mode_pic_button_return;
@property (weak, nonatomic) IBOutlet UIGridView *m_pic_tableview;

@property (weak, nonatomic) IBOutlet UIView *view_video;
@property (weak, nonatomic) IBOutlet UIView *mode_video_tool;
@property (weak, nonatomic) IBOutlet UILabel *mode_video_label;
@property (weak, nonatomic) IBOutlet UIButton *mode_video_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_video_button_delete;
@property (weak, nonatomic) IBOutlet UIButton *mode_video_button_return;
@property (weak, nonatomic) IBOutlet UITableView *m_video_tableview;


@property (weak, nonatomic) IBOutlet UIView *view_spinner_bg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_spinner;

- (IBAction)button_return_click:(id)sender;
- (IBAction)button_display_video_click:(id)sender;
- (IBAction)button_local_return:(id)sender;

- (IBAction)button_folder_pic_click:(id)sender;
- (IBAction)button_folder_video_click:(id)sender;
- (IBAction)button_folder_record_click:(id)sender;

- (IBAction)button_view_pic_return_click:(id)sender;
- (IBAction)mode_file_button_edit_click:(id)sender;
- (IBAction)mode_file_button_delete_click:(id)sender;

- (IBAction)button_view_video_return_click:(id)sender;
- (IBAction)mode_video_button_edit_click:(id)sender;
- (IBAction)mode_video_button_delete_click:(id)sender;
@end
