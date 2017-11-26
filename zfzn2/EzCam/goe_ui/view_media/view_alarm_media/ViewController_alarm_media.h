//
//  ViewController_alarm_media.h
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMGToast.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TableViewCell_pic_day.h"
#import "TableViewCell_pic_info.h"
#import "zx_alarm_manager.h"
#import "zx_alarm_item.h"
#import "share_item.h"
#import "vv_req_info.h"
#import "pic_file_item.h"
//#import "pic_cache_list_manager.h"
#import "zxy_playbackViewController_alarm.h"
#import "ViewController_gallery.h"
#import "gallery_photo_manager.h"
@interface ViewController_alarm_media : UIViewController<UITableViewDataSource,UITableViewDelegate,c2s_arm_events_interface,dev_connect_interface>
{
    zxy_share_data* MyShareData;
    ppview_cli* goe_Http;
    vv_strings* m_strings;
    zx_alarm_manager* m_alarm_manager;
    share_item* m_share_item;
    pic_cache_list_manager *m_pic_manager;
    gallery_photo_manager* m_photo_manager;
    
    float m_width;
    float m_height;
    float m_y_offset;
    
    BOOL b_events_get;
    long h_connector;
    int m_connect_state;
    
    NSMutableArray* m_file_array;
    //FGalleryViewController *m_Gallery;
}
@property (weak, nonatomic) IBOutlet UIView *view_main_pic;
@property (weak, nonatomic) IBOutlet UIView *view_top_pic;
@property (weak, nonatomic) IBOutlet UIButton *button_return_pic;
@property (weak, nonatomic) IBOutlet UILabel *label_title_pic;
@property (weak, nonatomic) IBOutlet UIButton *button_pic_video;
@property (weak, nonatomic) IBOutlet UITableView *tableview_pic;


@property (weak, nonatomic) IBOutlet UIView *view_main_video;
@property (weak, nonatomic) IBOutlet UIView *view_top_video;
@property (weak, nonatomic) IBOutlet UIButton *button_return_video;
@property (weak, nonatomic) IBOutlet UILabel *label_title_video;
@property (weak, nonatomic) IBOutlet UITableView *tableview_video;


@property (weak, nonatomic) IBOutlet UIView *view_spinner_bg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_spinner;

- (IBAction)button_return_click:(id)sender;
- (IBAction)button_display_video_click:(id)sender;
- (IBAction)button_video_return:(id)sender;
@end
