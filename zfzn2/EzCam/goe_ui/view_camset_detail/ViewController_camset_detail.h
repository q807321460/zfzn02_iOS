//
//  ViewController_camset_detail.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "vv_strings.h"
#import "OMGToast.h"
#import "share_item.h"
#import "InsetsTextField.h"
#import "cam_list_manager_local.h"

#import "wired_net_info.h"
#import "wifi_manager.h"
#import "TableViewCell_wifi.h"
#import "vv_req_info.h"
#import "zxy_share_data.h"
#import "ViewController_recordset.h"
#import "ViewController_cctv.h"
#import "zxy_FolderViewController.h"

@protocol ViewController_camset_detail_interface <NSObject>
@optional
-(void)on_ViewController_camset_detail_release;
@end
@interface ViewController_camset_detail : UIViewController<UITextFieldDelegate,dev_connect_interface,dev_set_interface,UITableViewDataSource,UITableViewDelegate,dev_netif_interface,TableViewCell_wifi_interface,c2s_dev_wifi_interface,c2s_mirror_config_interface>
{
    vv_strings* m_strings;
    ppview_cli* goe_Http;
    share_item* m_share_item;
    cam_list_manager_local *m_list_manager;
    wifi_manager* m_wifi_manager;
    
    NSString* m_dev_newpass;
    int edit_pass_res;

    
    NSTimer* m_wifiupdate_Timer;
    
    BOOL bEditUping;
    UITextField *m_curText;
    
    
    //网络设置
    int m_get_netif_res;
    int m_set_netif_res;
    int add_dev_result_code;
    NSData* m_netinfo_data;
    
    int set_type;//0:设置有线  1：设置无线
    int net_type;//0 有线 1 无线 2都支持
    int wired_type;//1:手动设置  2：自动获取
    int wireless_type;//3:手动设置 4：自动获取
    wired_net_info* m_wired_net_info;
    
    BOOL b_setting_wifi;
    NSString* m_new_ssid;
    NSString* m_new_ssidpass;
    int is_new_ssidpass;
    int m_new_ssid_signal;
    
    BOOL b_to_display_wired;
    
    int m_mirror_state;
    int m_mirror_state_new;
    
    BOOL bFirstHideSpinner;
    
    NSString* m_cur_ssid;
}

@property (assign, nonatomic) id<ViewController_camset_detail_interface> delegate;

@property (weak, nonatomic) IBOutlet UIView *view_camset;
@property (weak, nonatomic) IBOutlet UIButton *button_return_camset;
@property (weak, nonatomic) IBOutlet UILabel *label_camset;

@property (weak, nonatomic) IBOutlet UIView *view_system;
@property (weak, nonatomic) IBOutlet UIButton *button_view_system_bg;
@property (weak, nonatomic) IBOutlet UIImageView *img_system_right;
@property (weak, nonatomic) IBOutlet UILabel *label_system_title;

@property (weak, nonatomic) IBOutlet UIView *view_netset;
@property (weak, nonatomic) IBOutlet UIButton *button_view_netset_bg;
@property (weak, nonatomic) IBOutlet UIImageView *img_netset_right;
@property (weak, nonatomic) IBOutlet UILabel *label_netset_title;

@property (weak, nonatomic) IBOutlet UIView *view_recordset;
@property (weak, nonatomic) IBOutlet UIButton *button_view_recordset_bg;
@property (weak, nonatomic) IBOutlet UIImageView *img_recordset_right;
@property (weak, nonatomic) IBOutlet UILabel *label_recordset_title;

@property (weak, nonatomic) IBOutlet UIView *view_cctvset;
@property (weak, nonatomic) IBOutlet UIButton *button_view_cctvset_bg;
@property (weak, nonatomic) IBOutlet UIImageView *img_cctvset_right;
@property (weak, nonatomic) IBOutlet UILabel *label_cctvset_title;


@property (weak, nonatomic) IBOutlet UIView *view_pic;
@property (weak, nonatomic) IBOutlet UILabel *label_pic_title;

@property (weak, nonatomic) IBOutlet UIView *view_devinfo_set;
@property (weak, nonatomic) IBOutlet UILabel *label_devinfo_set_title;


/////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_system_fun;
@property (weak, nonatomic) IBOutlet UIView *view_system_fun_top;
@property (weak, nonatomic) IBOutlet UIButton *button_system_fun_return;
@property (weak, nonatomic) IBOutlet UILabel *label_system_fun;

@property (weak, nonatomic) IBOutlet UIView *view_editpass;
@property (weak, nonatomic) IBOutlet UIImageView *img_editpass_right;
@property (weak, nonatomic) IBOutlet UILabel *label_editpass;
@property (weak, nonatomic) IBOutlet UIButton *button_editpass_bg;

@property (weak, nonatomic) IBOutlet UIView *view_cam_mirror;
@property (weak, nonatomic) IBOutlet UILabel *label_cam_mirror_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_cam_mirror_switch;

@property (weak, nonatomic) IBOutlet UIView *view_cam_private;
@property (weak, nonatomic) IBOutlet UILabel *label_cam_private_hint;
@property (weak, nonatomic) IBOutlet UILabel *label_cam_private_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_cam_private_switch;


@property (weak, nonatomic) IBOutlet UIView *view_reboot_item;
@property (weak, nonatomic) IBOutlet UIImageView *img_reboot_item_right;
@property (weak, nonatomic) IBOutlet UILabel *label_reboot_item;
@property (weak, nonatomic) IBOutlet UIButton *button_reboot_item_bg;

@property (weak, nonatomic) IBOutlet UIView *view_reboot_bg;
@property (weak, nonatomic) IBOutlet UIView *view_reboot_container;
@property (weak, nonatomic) IBOutlet UIButton *button_reboot_cancel;
@property (weak, nonatomic) IBOutlet UIButton *button_reboot_ensure;
@property (weak, nonatomic) IBOutlet UIView *view_reboot_hint_p;
@property (weak, nonatomic) IBOutlet UITextView *tv_reboot_hint;

@property (weak, nonatomic) IBOutlet UIView *view_editpass_bg;
@property (weak, nonatomic) IBOutlet UIView *view_editpass_top;
@property (weak, nonatomic) IBOutlet UIButton *button_editpass_cancel;
@property (weak, nonatomic) IBOutlet UIButton *button_editpass_ensure;
@property (weak, nonatomic) IBOutlet UILabel *label_editpass_bg;
@property (weak, nonatomic) IBOutlet UIView *view_editpass_p;
@property (weak, nonatomic) IBOutlet UILabel *label_edpass1_title;
@property (weak, nonatomic) IBOutlet UITextField *tv_editpass1;
@property (weak, nonatomic) IBOutlet UILabel *label_editpass2_title;
@property (weak, nonatomic) IBOutlet UITextField *tv_editpass2;
@property (weak, nonatomic) IBOutlet UILabel *label_editpass3_title;
@property (weak, nonatomic) IBOutlet UITextField *tv_editpass3;
///////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_spinner;
@property (weak, nonatomic) IBOutlet UILabel *label_spinner_hint;

/////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_main_netset;
@property (weak, nonatomic) IBOutlet UIView *view_main_net1;

@property (weak, nonatomic) IBOutlet UIView *view_main_net_top;
@property (weak, nonatomic) IBOutlet UILabel *label_main_net;

@property (weak, nonatomic) IBOutlet UIView *item_wanlan_set;
@property (weak, nonatomic) IBOutlet UILabel *label_item_wanlan_set;
@property (weak, nonatomic) IBOutlet UIButton *button_item_wirednet_bg;

@property (weak, nonatomic) IBOutlet UIView *item_wireless_set;
@property (weak, nonatomic) IBOutlet UILabel *label_wireless_set;
@property (weak, nonatomic) IBOutlet UIButton *button_item_wireless_bg;

//--------------------
@property (weak, nonatomic) IBOutlet UIView *view_wanlan;
@property (weak, nonatomic) IBOutlet UIView *view_wanlan_top;
@property (weak, nonatomic) IBOutlet UIButton *button_wanlan_return;
@property (weak, nonatomic) IBOutlet UILabel *label_wanlan;
@property (weak, nonatomic) IBOutlet UIButton *button_wanlan_ensure;

@property (weak, nonatomic) IBOutlet UIView *item_view_dhcp;
@property (weak, nonatomic) IBOutlet UILabel *item_label_dhcp;
@property (weak, nonatomic) IBOutlet UISwitch *item_switch_dhcp;

@property (weak, nonatomic) IBOutlet UIView *item_view_ip;
@property (weak, nonatomic) IBOutlet UILabel *item_label_ip;
@property (weak, nonatomic) IBOutlet UITextField *item_tv_ip;

@property (weak, nonatomic) IBOutlet UIView *item_view_netmask;
@property (weak, nonatomic) IBOutlet UILabel *item_label_netmask;
@property (weak, nonatomic) IBOutlet UITextField *item_tv_netmask;

@property (weak, nonatomic) IBOutlet UIView *item_view_netgate;
@property (weak, nonatomic) IBOutlet UILabel *item_label_netgate;
@property (weak, nonatomic) IBOutlet UITextField *item_tv_netgate;

@property (weak, nonatomic) IBOutlet UIView *item_view_dns1;
@property (weak, nonatomic) IBOutlet UILabel *item_label_dns1;
@property (weak, nonatomic) IBOutlet UITextField *item_tv_dns1;

@property (weak, nonatomic) IBOutlet UIView *item_view_dns2;
@property (weak, nonatomic) IBOutlet UILabel *item_label_dns2;
@property (weak, nonatomic) IBOutlet UITextField *item_tv_dns2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NC_tv_dns2_toppadding;
//--------------------
@property (weak, nonatomic) IBOutlet UIView *view_main_wifi;
@property (weak, nonatomic) IBOutlet UIView *view_main_wifi_top;
@property (weak, nonatomic) IBOutlet UIButton *button_main_wifi_return;
@property (weak, nonatomic) IBOutlet UILabel *label_main_wifi;
@property (weak, nonatomic) IBOutlet UILabel *label_cur_net_hint;
@property (weak, nonatomic) IBOutlet UIView *view_cur_net;
@property (weak, nonatomic) IBOutlet UIImageView *img_left_cur_net;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner_cur_net;
@property (weak, nonatomic) IBOutlet UILabel *label_cur_net;
@property (weak, nonatomic) IBOutlet UIImageView *img_pass_cur_net;
@property (weak, nonatomic) IBOutlet UIImageView *img_signal_cur_net;
@property (weak, nonatomic) IBOutlet UIView *view_wifi_list_hint;
@property (weak, nonatomic) IBOutlet UILabel *label_wifi_list_hint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner_wifi_list;
@property (weak, nonatomic) IBOutlet UITableView *tableview_wifi;
//---------------
@property (weak, nonatomic) IBOutlet UIView *view_join_net_bg;
@property (weak, nonatomic) IBOutlet UIView *view_join_net_top;
@property (weak, nonatomic) IBOutlet UIButton *button_cancel_join_net;
@property (weak, nonatomic) IBOutlet UIButton *button_ensure_join_net;
@property (weak, nonatomic) IBOutlet UILabel *label_joinnet;

@property (weak, nonatomic) IBOutlet UILabel *label_join_net_hint;
@property (weak, nonatomic) IBOutlet UITextField *tv_wifi_pass;
//////////////////////////////////
@property (weak, nonatomic) IBOutlet UIView *view_devinfo;
@property (weak, nonatomic) IBOutlet UILabel *label_devinfo;
@property (weak, nonatomic) IBOutlet UIButton *button_save_devinfo;
@property (weak, nonatomic) IBOutlet UILabel *label_devname;
@property (weak, nonatomic) IBOutlet UITextField *tf_devname;
@property (weak, nonatomic) IBOutlet UITextField *tf_devid;
@property (weak, nonatomic) IBOutlet UILabel *label_devpass;
@property (weak, nonatomic) IBOutlet UITextField *tf_devpass;
@property (weak, nonatomic) IBOutlet UILabel *label_devmodel;
@property (weak, nonatomic) IBOutlet UITextField *tf_devmodel;
@property (weak, nonatomic) IBOutlet UILabel *label_devfirmware;
@property (weak, nonatomic) IBOutlet UITextField *tf_devfirmware;



- (IBAction)button_return_click:(id)sender;
- (IBAction)button_system_set_click:(id)sender;
- (IBAction)button_net_set_click:(id)sender;
- (IBAction)button_record_set_click:(id)sender;
- (IBAction)button_cctv_set_click:(id)sender;
- (IBAction)button_local_pic_click:(id)sender;
- (IBAction)button_devinfo_set_click:(id)sender;

/////////////
- (IBAction)button_system_set_return_click:(id)sender;
- (IBAction)button_system_editpass_click:(id)sender;
- (IBAction)button_system_mirror_click:(id)sender;
- (IBAction)button_system_sleep_click:(id)sender;
- (IBAction)button_system_reboot_click:(id)sender;

- (IBAction)button_system_reboot_cancel_click:(id)sender;
- (IBAction)button_system_reboot_ensure_click:(id)sender;

- (IBAction)button_system_editpass_cancel_click:(id)sender;
- (IBAction)button_system_editpass_ensure_click:(id)sender;
//////////////
- (IBAction)button_net_set_return_click:(id)sender;
- (IBAction)button_net_wired_click:(id)sender;
- (IBAction)button_net_wireless_click:(id)sender;


- (IBAction)button_net_wired_return_click:(id)sender;
- (IBAction)button_net_wireless_return_click:(id)sender;
- (IBAction)button_net_wired_set_ensure_click:(id)sender;
- (IBAction)button_join_net_cancel_click:(id)sender;
- (IBAction)button_join_net_ensure_click:(id)sender;


-(void)on_cam_private_return:(int)res status:(int)status;

- (IBAction)button_devinfo_return_click:(id)sender;
- (IBAction)button_devinfo_save_click:(id)sender;


@end
