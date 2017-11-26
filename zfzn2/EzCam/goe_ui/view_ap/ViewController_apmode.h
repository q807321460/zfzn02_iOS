//
//  ViewController_apmode.h
//  pano360
//
//  Created by zxy on 2017/5/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h> 
#import "Reachability.h"
#import "OMGToast.h"
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "ppview_cli.h"
#import "cam_list_manager_req.h"
#import "cam_list_manager_local.h"
#import "vv_req_info.h"
#import "wifi_manager.h"
#import "TableViewCell_wifi.h"
@protocol ViewController_apmode_delegate <NSObject>
@optional
-(void) ViewController_apmode_quit;
@end

@interface ViewController_apmode : UIViewController<add_dev_interface,dev_connect_interface,UITextFieldDelegate,c2s_dev_wifi_interface,UITableViewDataSource,UITableViewDelegate,TableViewCell_wifi_interface>
{
    
    NSTimer* CheckTimer;
    NSTimer* CheckConnectTimer;
    NSTimer* pauseTimer;
    
    NSString* m_wifi_ssid;
    NSString* m_wifi_pass;
    
    NSString* m_ap_ssid;
    NSString* m_devid;
    NSString* m_devip;
    
    NSString* m_dev_usr;
    NSString* m_dev_pass;
    
    wifi_manager* m_wifi_manager;
    
    zxy_share_data* MyShareData;
    ppview_cli* goe_Http;
    cam_list_manager_local* m_cams_manager;
    
    int m_connect_mode;//0 检查是否连接成功 1绑定过程中
    long h_connector;
    int m_connect_state;
    
    NSData* m_devinfo_data;
    int m_timer_count;
    int m_time_repeatfive_times;
    BOOL bSearching;
    
    int m_ap_res;
    int m_res;
    
    int m_search_count;
    int add_dev_result_code;
    BOOL bAPNet;
    
    int m_ap_connect_count;
    
    BOOL bDevinfo_get;
    NSMutableDictionary* g_dev_dictionary;
    BOOL bRefereshWIFIlist;
}

@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UILabel *label_top0;
@property (weak, nonatomic) IBOutlet UIButton *button_view0_nextstep;
@property (weak, nonatomic) IBOutlet UITextView *tv_view0_hint0;
@property (weak, nonatomic) IBOutlet UITextView *tv_view0_hint1;
@property (weak, nonatomic) IBOutlet UIButton *button_view0_wifi_set;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *label_top2;
@property (weak, nonatomic) IBOutlet UIButton *button_view2_nextstep;

@property (weak, nonatomic) IBOutlet UITextView *tv_view2_hint0;

@property (weak, nonatomic) IBOutlet UILabel *label_view2_wifiname;
@property (weak, nonatomic) IBOutlet UITextField *tv_view2_wifiname;
@property (weak, nonatomic) IBOutlet UILabel *label_view2_wifipass;
@property (weak, nonatomic) IBOutlet UITextField *tv_view2_wifipass;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view_view3_sendok;
@property (weak, nonatomic) IBOutlet UIView *view_view3_sendfail;
@property (weak, nonatomic) IBOutlet UILabel *label_view3;
@property (weak, nonatomic) IBOutlet UITextView *tv_view3_hint0;
@property (weak, nonatomic) IBOutlet UIButton *button_view3_return;


@property (weak, nonatomic) IBOutlet UILabel *label_view3_sendfail;
@property (weak, nonatomic) IBOutlet UIButton *button_view3_sendfail_exit;
@property (weak, nonatomic) IBOutlet UITextView *tv_view3_sendfail_hint;
@property (weak, nonatomic) IBOutlet UIButton *button_view3_sendfail_retry;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *label_view4_top;
@property (weak, nonatomic) IBOutlet UITextView *tv_view4_hint;
@property (weak, nonatomic) IBOutlet UIView *view_view4_bindfail;
@property (weak, nonatomic) IBOutlet UILabel *label_view4_bindfail_top;
@property (weak, nonatomic) IBOutlet UITextView *tv_view4_bindfail_hint;
@property (weak, nonatomic) IBOutlet UIButton *button_view4_bindfail_ensure;
@property (weak, nonatomic) IBOutlet UIButton *button_view4_return;


@property (weak, nonatomic) IBOutlet UIView *view_login;
@property (weak, nonatomic) IBOutlet UILabel *label_login_title;
@property (weak, nonatomic) IBOutlet UIButton *button_login_ensure;
@property (weak, nonatomic) IBOutlet UITextField *tf_dev_usr;
@property (weak, nonatomic) IBOutlet UITextField *tf_dev_pass;
///////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_wifilist;
@property (weak, nonatomic) IBOutlet UITableView *tableview_wifi;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_referesh_wifi;
@property (weak, nonatomic) IBOutlet UILabel *label_wifilist_title;
@property (weak, nonatomic) IBOutlet UIButton *button_wifilist_referesh;
@property (weak, nonatomic) IBOutlet UILabel *label_wifilist_hint;


@property (assign) id<ViewController_apmode_delegate>delegate;

- (IBAction)button_exit_click:(id)sender;
- (IBAction)button_view0_nextstep_click:(id)sender;
- (IBAction)button_view0_wifiset_click:(id)sender;

- (IBAction)button_view2_nextstep_click:(id)sender;
- (IBAction)button_view2_return_click:(id)sender;

- (IBAction)button_view3_return_click:(id)sender;
- (IBAction)button_view3_sendfail_exit_click:(id)sender;
- (IBAction)button_view3_sendfail_retry_click:(id)sender;

- (IBAction)button_view4_bindfail_ensure_click:(id)sender;
- (IBAction)button_login_ensure_click:(id)sender;
- (IBAction)button_login_return_click:(id)sender;
- (IBAction)button_wifi_referesh_click:(id)sender;

@end
