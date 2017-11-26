//
//  zxy_FolderViewController.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "pic_file_manager.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "item_folder_cell.h"
#import "item_file_cell.h"

@interface zxy_FolderViewController : UIViewController<UIGridViewDelegate>
{

    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    pic_file_manager* m_file_manager;
    
    NSMutableArray* m_folder_array;
    NSMutableArray* m_file_array;
    
    NSString* my_path;
    int m_video_cur_mode;//0 列表模式  1 删除
    int m_pic_cur_mode;//0 列表模式  1 删除
    
    NSMutableArray* m_video_delete_array;
    NSMutableArray* m_pic_delete_array;
    
    float m_width;
    float m_height;
    float m_y_offset;
    
}
@property (weak, nonatomic) IBOutlet UIView *view_main;

@property (weak, nonatomic) IBOutlet UIView *view_pic;
@property (weak, nonatomic) IBOutlet UIView *mode_pic_tool;
@property (weak, nonatomic) IBOutlet UIButton *mode_pic_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_pic_button_delete;
@property (weak, nonatomic) IBOutlet UILabel *mode_pic_label;
@property (weak, nonatomic) IBOutlet UIGridView *m_tableview_pic;

@property (weak, nonatomic) IBOutlet UIView *view_video;
@property (weak, nonatomic) IBOutlet UIView *mode_video_tool;
@property (weak, nonatomic) IBOutlet UILabel *mode_video_label;
@property (weak, nonatomic) IBOutlet UIButton *mode_video_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_video_button_delete;
@property (weak, nonatomic) IBOutlet UIGridView *m_tableview_video;



- (IBAction)mode_video_button_return_click:(id)sender;
- (IBAction)mode_video_button_edit_click:(id)sender;
- (IBAction)mode_video_button_delete:(id)sender;

- (IBAction)mode_pic_button_return_click:(id)sender;
- (IBAction)mode_pic_button_edit_click:(id)sender;
- (IBAction)mode_pic_button_delete_click:(id)sender;

@end
