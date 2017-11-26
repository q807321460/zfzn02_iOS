//
//  ViewController_main.h
//  easycam
//
//  Created by zxy on 2017/8/8.
//  Copyright © 2017年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell_cam.h"
#import "cam_list_manager_local.h"
#import "ViewController_fishplay.h"
#import "ViewController_playback.h"
#import "ViewController_alarm_media.h"
#import "ViewController_camset_detail.h"
#import "ViewController_adddev.h"
#import "zxy_FolderViewController.h"


#import "zxy_share_data.h"
#import "cam_list_item.h"
#import "pic_file_manager.h"
#import "share_item.h"
#import "ppview_cli.h"


@interface ViewController_main : UIViewController<TableViewCell_cam_interface,UITableViewDataSource,UITableViewDelegate,camlist_interface,playviewcontroller_fish_interface>
{
    cam_list_manager_local* m_vv_camlist_manager;
    zxy_share_data* MyShareData;
    pic_file_manager *gPicCache;
    share_item* m_share_item;
    ppview_cli* goe_Http;
    BOOL m_hidden;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview_cam;
- (IBAction)button_add_click:(id)sender;
- (IBAction)button_piclib_click:(id)sender;
- (IBAction)button_referesh_click:(id)sender;
- (IBAction)button_hidden_click:(id)sender;

@end
