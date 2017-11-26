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
#import "FGalleryViewController.h"
#import "FGalleryShared.h"
#import "ViewController_playback_local.h"
#import "ViewController_playfish_local.h"
#import "share_item.h"
@interface zxy_FolderViewController : UIViewController<UIGridViewDelegate,FGalleryViewControllerDelegate>
{

    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    pic_file_manager* m_file_manager;
    FGalleryShared* f_shared;
    share_item* m_share_item;
    
    NSMutableArray* m_folder_array;
    NSMutableArray* m_file_array;
    NSMutableArray* m_file_jpg_array;
    
    NSString* my_path;
    FGalleryViewController *m_localGallery;
   // NSMutableArray *m_localCaptions;
   // NSMutableArray *m_localImages;
    int m_folder_cur_mode;//0 列表模式  1 删除
    int m_file_cur_mode;//0 列表模式  1 删除
    
    NSMutableArray* m_folder_delete_array;
    NSMutableArray* m_file_delete_array;
    
    float m_width;
    float m_height;
    float m_y_offset;
    
    float m_cellwidht;
    
}
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIView *view_folder;
@property (weak, nonatomic) IBOutlet UIView *mode_folder_tool;
@property (weak, nonatomic) IBOutlet UIButton *mode_folder_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_folder_button_delete;
@property (weak, nonatomic) IBOutlet UILabel *mode_folder_label;

@property (weak, nonatomic) IBOutlet UIView *view_file;
@property (weak, nonatomic) IBOutlet UIView *mode_file_tool;
@property (weak, nonatomic) IBOutlet UILabel *mode_file_label;
@property (weak, nonatomic) IBOutlet UIButton *mode_file_button_edit;
@property (weak, nonatomic) IBOutlet UIButton *mode_file_button_delete;
@property (weak, nonatomic) IBOutlet UIGridView *m_file_tableview;

@property (nonatomic, retain) IBOutlet UIGridView *m_tableview;

- (IBAction)mode_folder_button_return_click:(id)sender;
- (IBAction)mode_folder_button_edit_click:(id)sender;
- (IBAction)mode_folder_button_delete:(id)sender;

- (IBAction)mode_file_button_return_click:(id)sender;
- (IBAction)mode_file_button_edit_click:(id)sender;
- (IBAction)mode_file_button_delete_click:(id)sender;

@end
