//
//  ViewController_adddev.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetsTextField.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>


#import "ppview_cli.h"
#import "OMGToast.h"
//#import "item_search_dev_cell.h"


#import "ScanViewController.h"
#import "TableViewCell_search_dev.h"
//#import "vv_req_info.h"
#import "vv_strings.h"
#import "cam_list_manager_local.h"
#import "cam_list_manager_req.h"
#import <SystemConfiguration/CaptiveNetwork.h> 

#import "ViewController_apmode.h"
@interface ViewController_adddev : UIViewController<TableViewCell_search_dev_interface,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,add_dev_interface,dev_connect_interface,ScanViewController_interface,ViewController_apmode_delegate>
{

    ppview_cli* goe_Http;
    cam_list_manager_local* m_cams_manager;
    vv_strings* m_strings;
    
    
    NSString* m_search_sess;
    NSString* m_bind_sess;
    
    BOOL bSearching;
    NSMutableArray* m_search_list;
    int res_type;//0 :搜索  1绑定
    
    NSTimer* pauseTimer;

    NSString* new_devid;
    NSString* new_devname;
    NSString* new_devuser;
    NSString* new_devpass;
    NSString* new_devip;

    long h_connector;
    int add_dev_result_code;//-98 连接失败
    
    int m_ctrl_mode;//0：请求分享  1：添加设备
    
    
    
    
    BOOL bRunning;
    BOOL bMulCast;
    
    NSString* wireless_ssid;
    NSString* wireless_pass;
    
    int m_ui_mode;
    BOOL bRemoteBind;
    
    ViewController_apmode *destview_apmode;
    
    BOOL bToMainVIew;
    BOOL is_in_qrcode_ui;
    
    float m_src_screen_bright;
    int m_search_count;
}




@property (weak, nonatomic) IBOutlet UIView *view_add_main_v1;
@property (weak, nonatomic) IBOutlet UITextField *tv_devname_v1;
@property (weak, nonatomic) IBOutlet UITextField *tv_devid_v1;
@property (weak, nonatomic) IBOutlet UITextField *tv_devpass_v1;

///////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_add_main;
@property (weak, nonatomic) IBOutlet UIView *view_add_main_top;
@property (weak, nonatomic) IBOutlet UIButton *button_add_main_return;
@property (weak, nonatomic) IBOutlet UIButton *button_add_ensure;
@property (weak, nonatomic) IBOutlet UILabel *label_add_main;
@property (weak, nonatomic) IBOutlet InsetsTextField *tv_devid;
@property (weak, nonatomic) IBOutlet InsetsTextField *tv_devpass;
@property (weak, nonatomic) IBOutlet UILabel *label_wireless_title;
////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_spinner;
@property (weak, nonatomic) IBOutlet UILabel *label_spinner_hint;
///////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_devs;
@property (weak, nonatomic) IBOutlet UIView *view_devs_top;
@property (weak, nonatomic) IBOutlet UIButton *button_devs_return;
@property (weak, nonatomic) IBOutlet UILabel *label_devs;
@property (weak, nonatomic) IBOutlet UITableView *tablevew_devs;
////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_add_fail;
@property (weak, nonatomic) IBOutlet UILabel *label_err_code;
@property (weak, nonatomic) IBOutlet UILabel *label_err_reason;
@property (weak, nonatomic) IBOutlet UIButton *button_add_fail;
//////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_set_wireless;
@property (weak, nonatomic) IBOutlet UILabel *label_set_wireless;
@property (weak, nonatomic) IBOutlet UIButton *button_set_wireless_next;

@property (weak, nonatomic) IBOutlet UIView *view_wireless_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_wireless_name;
@property (weak, nonatomic) IBOutlet UILabel *lable_wireless_name;
@property (weak, nonatomic) IBOutlet UIView *view_wireless_pass;
@property (weak, nonatomic) IBOutlet UITextField *text_wireless_pass;
@property (weak, nonatomic) IBOutlet UILabel *label_dev_qrcode;
@property (weak, nonatomic) IBOutlet UILabel *label_ap_title;
//////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_wifi_qrcode;
@property (weak, nonatomic) IBOutlet UIView *view1_wifi_qrcode_wifiinfo;
@property (weak, nonatomic) IBOutlet UIButton *button_view1_next_step;
@property (weak, nonatomic) IBOutlet UILabel *label_view1_title;
@property (weak, nonatomic) IBOutlet UILabel *label_view1_ssid;
@property (weak, nonatomic) IBOutlet UITextField *tv_view1_ssidpass;
@property (weak, nonatomic) IBOutlet UIButton *button_view1_skip;

@property (weak, nonatomic) IBOutlet UIView *view_wifi_qrcode_create;
@property (weak, nonatomic) IBOutlet UILabel *label_view2_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_view2_qrcode;
@property (weak, nonatomic) IBOutlet UITextView *textview_view2_hint;
@property (weak, nonatomic) IBOutlet UIButton *button_wifiqrcode_nexttosearch;

@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
/////////////////////
@property (weak, nonatomic) IBOutlet UILabel *jsw_label_devname;
@property (weak, nonatomic) IBOutlet UITextField *jsw_tf_devname;
@property (weak, nonatomic) IBOutlet UITextField *jsw_tf_devid;
@property (weak, nonatomic) IBOutlet UILabel *jsw_label_devpass;
@property (weak, nonatomic) IBOutlet UITextField *jsw_tf_devpass;
@property (weak, nonatomic) IBOutlet UIButton *jsw_button_search;
@property (weak, nonatomic) IBOutlet UIButton *jsw_button_cancel;
@property (weak, nonatomic) IBOutlet UIButton *jsw_button_save;
@property (weak, nonatomic) IBOutlet UIButton *jsw_button_scan_devqrcode;
@property (weak, nonatomic) IBOutlet UIButton *jsw_button_qrcode_add;
@property (weak, nonatomic) IBOutlet UIButton *jsw_apmode_add;


- (IBAction)button_devs_return_click:(id)sender;
- (IBAction)button_add_fail_click:(id)sender;
- (IBAction)button_wireless_set_return_click:(id)sender;
- (IBAction)button_wireless_set_next_click:(id)sender;
- (IBAction)button_return_click:(id)sender;
- (IBAction)button_add_dev_ensure:(id)sender;
- (IBAction)button_search_click:(id)sender;
- (IBAction)button_barcode_click:(id)sender;
- (IBAction)button_ap_mode_click:(id)sender;
- (IBAction)button_wifiqrcode_click:(id)sender;

- (IBAction)button_qrcodewifi_return_click:(id)sender;
- (IBAction)button_qrcodewifi_view1_nextstep:(id)sender;
- (IBAction)button_sqcodewifi_view1_skip:(id)sender;
- (IBAction)button_qrcodewifi_view2_return_click:(id)sender;
- (IBAction)button_qrcodewifi_tosearch_click:(id)sender;



@end
