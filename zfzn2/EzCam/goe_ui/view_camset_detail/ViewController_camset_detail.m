//
//  ViewController_camset_detail.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController_camset_detail.h"

@interface ViewController_camset_detail ()

@end

@implementation ViewController_camset_detail
@synthesize view_camset;
@synthesize button_return_camset;
@synthesize label_camset;

@synthesize view_system;
@synthesize button_view_system_bg;
@synthesize img_system_right;
@synthesize label_system_title;

@synthesize view_netset;
@synthesize button_view_netset_bg;
@synthesize img_netset_right;
@synthesize label_netset_title;

@synthesize view_recordset;
@synthesize button_view_recordset_bg;
@synthesize img_recordset_right;
@synthesize label_recordset_title;

@synthesize view_cctvset;
@synthesize button_view_cctvset_bg;
@synthesize img_cctvset_right;
@synthesize label_cctvset_title;

@synthesize label_pic_title;
/////////////////////////////////////////////////////
@synthesize view_system_fun;
@synthesize view_system_fun_top;
@synthesize button_system_fun_return;
@synthesize label_system_fun;

@synthesize view_editpass;
@synthesize img_editpass_right;
@synthesize label_editpass;
@synthesize button_editpass_bg;

@synthesize view_cam_mirror;
@synthesize label_cam_mirror_title;
@synthesize img_cam_mirror_switch;

@synthesize view_cam_private;
@synthesize label_cam_private_hint;
@synthesize label_cam_private_title;
@synthesize img_cam_private_switch;


@synthesize view_reboot_item;
@synthesize img_reboot_item_right;
@synthesize label_reboot_item;
@synthesize button_reboot_item_bg;

@synthesize view_reboot_bg;
@synthesize view_reboot_container;
@synthesize button_reboot_cancel;
@synthesize button_reboot_ensure;
@synthesize view_reboot_hint_p;
@synthesize tv_reboot_hint;

@synthesize view_editpass_bg;
@synthesize view_editpass_top;
@synthesize button_editpass_cancel;
@synthesize button_editpass_ensure;
@synthesize label_editpass_bg;
@synthesize view_editpass_p;
@synthesize label_edpass1_title;
@synthesize tv_editpass1;
@synthesize label_editpass2_title;
@synthesize tv_editpass2;
@synthesize label_editpass3_title;
@synthesize tv_editpass3;
///////////////////////////////////////////////////
@synthesize view_spinner;
@synthesize label_spinner_hint;


/////////////////////////////////////
@synthesize view_main_netset;
@synthesize view_main_net1;

@synthesize view_main_net_top;
@synthesize label_main_net;

@synthesize item_wanlan_set;
@synthesize label_item_wanlan_set;
@synthesize button_item_wirednet_bg;

@synthesize item_wireless_set;
@synthesize label_wireless_set;
@synthesize button_item_wireless_bg;

//--------------------
@synthesize view_wanlan;
@synthesize view_wanlan_top;
@synthesize button_wanlan_return;
@synthesize label_wanlan;
@synthesize button_wanlan_ensure;

@synthesize item_view_dhcp;
@synthesize item_label_dhcp;
@synthesize item_switch_dhcp;

@synthesize item_view_ip;
@synthesize item_label_ip;
@synthesize item_tv_ip;

@synthesize item_view_netmask;
@synthesize item_label_netmask;
@synthesize item_tv_netmask;

@synthesize item_view_netgate;
@synthesize item_label_netgate;
@synthesize item_tv_netgate;

@synthesize item_view_dns1;
@synthesize item_label_dns1;
@synthesize item_tv_dns1;

@synthesize item_view_dns2;
@synthesize item_label_dns2;
@synthesize item_tv_dns2;
@synthesize NC_tv_dns2_toppadding;
//--------------------
@synthesize view_main_wifi;
@synthesize view_main_wifi_top;
@synthesize button_main_wifi_return;
@synthesize label_main_wifi;
@synthesize label_cur_net_hint;
@synthesize view_cur_net;
@synthesize img_left_cur_net;
@synthesize spinner_cur_net;
@synthesize label_cur_net;
@synthesize img_pass_cur_net;
@synthesize img_signal_cur_net;
@synthesize view_wifi_list_hint;
@synthesize label_wifi_list_hint;
@synthesize spinner_wifi_list;
@synthesize tableview_wifi;
//---------------
@synthesize view_join_net_bg;
@synthesize view_join_net_top;
@synthesize button_cancel_join_net;
@synthesize button_ensure_join_net;
@synthesize label_joinnet;

@synthesize label_join_net_hint;
@synthesize tv_wifi_pass;
@synthesize delegate;
//////////////
@synthesize label_devinfo_set_title;
@synthesize view_devinfo;
@synthesize label_devinfo;
@synthesize button_save_devinfo;
@synthesize label_devname;
@synthesize tf_devname;
@synthesize tf_devid;
@synthesize label_devpass;
@synthesize tf_devpass;
@synthesize label_devmodel;
@synthesize tf_devmodel;
@synthesize label_devfirmware;
@synthesize tf_devfirmware;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bFirstHideSpinner=true;
    m_strings=[vv_strings getInstance];
    goe_Http=[ppview_cli getInstance];
    m_share_item=[share_item getInstance];
    m_list_manager=[cam_list_manager_local getInstance];
    goe_Http.cli_netif_delegate=self;
    
    goe_Http.cli_c2s_dev_wifi_delegate=self;
    m_wifi_manager=[wifi_manager getInstance];
    [self init_view_value];
    m_wired_net_info=nil;
    //&&m_share_item.cur_cam_list_item.m_private_status==0
    
    [item_switch_dhcp setOn:YES animated:YES];
    [self view_dhcp_set:true];
    [item_switch_dhcp addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    if (m_share_item.cur_cam_list_item != nil  && m_share_item.cur_cam_list_item.m_state==1 && m_share_item.cur_cam_list_item.m_type!=1)
    {
        goe_Http.cli_devconnect_single_delegate=self;
        goe_Http.cli_devset_delegate=self;
        //if (m_share_item.m_connect_state !=1)
        {
            m_share_item.h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"viewcontroller_camset_detail"];
            if (m_share_item.h_connector>0) {
                view_spinner.hidden=false;
                [view_camset bringSubviewToFront:view_spinner];
            }
        }
        //NSLog(@"h_connector=%ld",m_share_item.h_connector);
    }
}

-(void)resumeView
{
    
    NC_tv_dns2_toppadding.constant=0;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //NSLog(@"textFieldShouldBeginEditing--0");
    if (textField==item_tv_dns2 || textField==item_tv_dns1){
        m_curText=textField;
        if (bEditUping==true) {
            return YES;
        }
        NC_tv_dns2_toppadding.constant=-80;
        bEditUping=true;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSLog(@"textFieldDidEndEditing--0");
    if (textField==item_tv_dns2 || textField==item_tv_dns1) {
        if (bEditUping==false) {
            return;
        }
        //NSLog(@"textFieldDidEndEditing--1");
        if(m_curText==textField){
            [self resumeView];
            bEditUping=false;
            m_curText=nil;
        }
    }
    [textField resignFirstResponder];
    
}
-(void)init_view_value
{
    [view_spinner setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_reboot_bg setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_system_fun setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_editpass_bg setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [button_editpass_ensure setTitleColor:UIColorFromRGB(m_strings.background_blue) forState:UIControlStateNormal];
    
    label_camset.text=NSLocalizedString(@"m_more_settings", @"");
    label_system_title.text=NSLocalizedString(@"m_system_set", @"");
    label_system_fun.text=NSLocalizedString(@"m_system_set", @"");
    label_editpass.text=NSLocalizedString(@"m_edit_cam_pass", @"");
    
    label_cam_mirror_title.text=NSLocalizedString(@"m_mirror_state", @"");
    label_cam_private_title.text=NSLocalizedString(@"m_private", @"");
    label_cam_private_hint.text=NSLocalizedString(@"m_private_hint", @"");
    
    label_reboot_item.text=NSLocalizedString(@"m_reboot_dev", @"");
    [button_reboot_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_reboot_ensure setTitle:NSLocalizedString(@"m_reboot_dev", @"") forState:UIControlStateNormal];
    tv_reboot_hint.text=NSLocalizedString(@"m_reboot_dev_hint", @"");
    
    label_editpass_bg.text=NSLocalizedString(@"m_edit_cam_pass", @"");
    [button_editpass_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_editpass_ensure setTitle:NSLocalizedString(@"m_save", @"") forState:UIControlStateNormal];
    
    label_edpass1_title.text=NSLocalizedString(@"m_oldpass", @"");
    label_editpass2_title.text=NSLocalizedString(@"m_new_pass", @"");
    label_editpass3_title.text=NSLocalizedString(@"m_ensure_pass", @"");
    
    label_netset_title.text=NSLocalizedString(@"m_net_set", @"");
    label_recordset_title.text=NSLocalizedString(@"m_record_set", @"");
    label_cctvset_title.text=NSLocalizedString(@"m_cctv_set", @"");
    
    [view_main_net1 setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_wanlan setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    //[view_main_wifi setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    
    item_label_ip.textColor=UIColorFromRGB(m_strings.text_gray);
    item_label_netmask.textColor=UIColorFromRGB(m_strings.text_gray);
    item_label_dhcp.textColor=UIColorFromRGB(m_strings.text_gray);
    item_label_netgate.textColor=UIColorFromRGB(m_strings.text_gray);
    item_label_dns1.textColor=UIColorFromRGB(m_strings.text_gray);
    item_label_dns2.textColor=UIColorFromRGB(m_strings.text_gray);
    
    label_main_net.text=NSLocalizedString(@"m_net_set", @"");
    label_item_wanlan_set.text=NSLocalizedString(@"m_net_wired_set", @"");
    label_wireless_set.text=NSLocalizedString(@"m_net_wireless_set", @"");
    
    
    label_wanlan.text=NSLocalizedString(@"m_net_wired_set", @"");
    [button_wanlan_ensure setTitle:NSLocalizedString(@"m_save", @"") forState:UIControlStateNormal];
    
    item_label_dhcp.text=NSLocalizedString(@"m_dhcp", @"");
    item_label_ip.text=[NSString stringWithFormat:@"%@:", NSLocalizedString(@"m_ip", @"")];
    item_label_netmask.text=[NSString stringWithFormat:@"%@:", NSLocalizedString(@"m_net_mask", @"")];
    item_label_netgate.text=[NSString stringWithFormat:@"%@:", NSLocalizedString(@"m_net_gate", @"")];
    item_label_dns1.text=[NSString stringWithFormat:@"%@:", NSLocalizedString(@"m_first_dns", @"")];
    item_label_dns2.text=[NSString stringWithFormat:@"%@:", NSLocalizedString(@"m_second_dns", @"")];
    
    label_main_wifi.text=NSLocalizedString(@"m_net_wireless_set", @"");
    label_cur_net.text=NSLocalizedString(@"m_no_wifi", @"");
    label_cur_net_hint.text=NSLocalizedString(@"m_cur_net", @"");
    label_wifi_list_hint.text=NSLocalizedString(@"m_select_net", @"");
    [button_cancel_join_net setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [button_ensure_join_net setTitle:NSLocalizedString(@"m_join", @"") forState:UIControlStateNormal];
    label_joinnet.text=NSLocalizedString(@"m_join_wifi_title", @"");
    
    label_pic_title.text=NSLocalizedString(@"m_local_pic", @"");
    
    label_devinfo_set_title.text=NSLocalizedString(@"m_devinfo", nil);
    label_devinfo.text=NSLocalizedString(@"m_devinfo", nil);
    [button_save_devinfo setTitle:NSLocalizedString(@"m_save", @"") forState:UIControlStateNormal];
    label_devname.text=NSLocalizedString(@"System Name:", nil);
    label_devpass.text=NSLocalizedString(@"Security Code:", nil);
    
    label_devmodel.text=NSLocalizedString(@"m_dev_model:", nil);
    label_devfirmware.text=NSLocalizedString(@"m_dev_firmware:", nil);


    
    tv_editpass1.delegate=self;
    tv_editpass2.delegate=self;
    tv_editpass3.delegate=self;
    tv_wifi_pass.delegate=self;
    tf_devname.delegate=self;
    tf_devpass.delegate=self;
    
    item_tv_ip.delegate=self;
    item_tv_netmask.delegate=self;
    item_tv_netgate.delegate=self;
    item_tv_dns1.delegate=self;
    item_tv_dns2.delegate=self;
    
    tableview_wifi.delegate = self;
    tableview_wifi.dataSource = self;
}
-(void)switchAction:(id)sender
{
    UISwitch * my_switch = (UISwitch *)sender;
    //NSLog(@"my_switch.isOn==%d",my_switch.isOn);
    if (my_switch.isOn==true) {
        [self view_dhcp_set:true];
    }
    else{
        [self view_dhcp_set:false];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return NULL;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableview_wifi==tableView) {
        return 41;
    }
    else
        return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [m_wifi_manager getCount];
}

-(void)start_wifi_set
{
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    
    label_cur_net.text=m_new_ssid;
    if (is_new_ssidpass==1)
    {
        img_pass_cur_net.hidden=false;
    }
    else{
        img_pass_cur_net.hidden=true;
    }
    img_signal_cur_net.hidden=false;
    img_left_cur_net.hidden=true;
    switch (m_new_ssid_signal)
    {
        case 0:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi1.png"];
            break;
        case 1:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi2.png"];
            break;
        case 2:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi3.png"];
            break;
        case 3:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
        default:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
    }
    
    b_setting_wifi=true;
    [spinner_cur_net startAnimating];
    [goe_Http cli_lib_set_dev_net:m_share_item.h_connector net_type:4 ip:nil net_mask:nil net_gate:nil net_dns:nil ssid:m_new_ssid ssid_pass:m_new_ssidpass];
    
    //m_wifiupdate_Timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(get_wifi_list) userInfo:nil repeats:NO];
    
}

-(BOOL)on_item_wifi_click:(NSString*)cell_id pos:(int)pos
{
    item_wifi* cur_item=[m_wifi_manager getItem:pos];
    if(cur_item==nil)
        return false;
    m_new_ssid=cur_item.m_wifi_name;
    m_new_ssidpass=@"";
    is_new_ssidpass=cur_item.m_pass;
    m_new_ssid_signal=cur_item.m_signal;
    
    if (cur_item.m_pass==1) {
        tv_wifi_pass.text=@"";
        view_join_net_bg.hidden=false;
        label_join_net_hint.text=[NSString stringWithFormat:@"%@\"%@\"%@",NSLocalizedString(@"m_please_input", @""),m_new_ssid,NSLocalizedString(@"m_ssid_pass", @"")];
        [view_main_wifi bringSubviewToFront:view_join_net_bg];
    }
    else{
        [self start_wifi_set];
    }
    return true;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    item_wifi* cur_item=[m_wifi_manager getItem:(int)indexPath.row];
    TableViewCell_wifi *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell_wifi"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_wifi" owner:self
                                            options:nil] lastObject];
    }
    if (cur_item != nil) {
        [cell config_cell:cur_item.m_wifi_name pos:(int)indexPath.row name:cur_item.m_wifi_name ispass:cur_item.m_pass signal:cur_item.m_signal];
    }
    cell.delegate=self;
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}



-(void)quit_viewController
{
    goe_Http.cli_netif_delegate=nil;
    goe_Http.cli_c2s_dev_wifi_delegate=nil;
    goe_Http.cli_devconnect_single_delegate=nil;
    goe_Http.cli_devset_delegate=nil;
    goe_Http.cli_c2s_mirror_config_delegate=nil;
    if (delegate!=nil && [delegate respondsToSelector:@selector(on_ViewController_camset_detail_release)]) {
        [delegate on_ViewController_camset_detail_release];
    }
    if (m_share_item.h_connector !=0) {
        [goe_Http cli_lib_releaseconnect:m_share_item.h_connector];
        m_share_item.h_connector=0;
        m_share_item.m_connect_state =0;
    }

    [self.navigationController popViewControllerAnimated:false];
    /*
    [self dismissViewControllerAnimated:NO completion:^(){
       
        if (m_share_item.h_connector !=0) {
            [goe_Http cli_lib_releaseconnect:m_share_item.h_connector];
            m_share_item.h_connector=0;
            m_share_item.m_connect_state =0;
        }
    }];
     */
}
- (IBAction)button_return_click:(id)sender {
    [self quit_viewController];
}

- (IBAction)button_system_set_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    if (m_share_item.cur_cam_list_item.m_private_status==0) {
        img_cam_private_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
    }
    else{
        img_cam_private_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
    }
    view_system_fun.hidden=false;
    [view_camset bringSubviewToFront:view_system_fun];
    if (m_share_item.m_connect_state ==1) {
        goe_Http.cli_c2s_mirror_config_delegate=self;
        [goe_Http cli_lib_get_mirror_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid];
    }
}

- (IBAction)button_net_set_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_main_netset.hidden=false;
    [view_camset bringSubviewToFront:view_main_netset];
    view_main_wifi.hidden=false;
    [self init_wifi_view];
    //view_spinner.hidden=false;
    //label_spinner_hint.text=NSLocalizedString(@"m_getting_netif", @"");
    //[view_camset bringSubviewToFront:view_spinner];
    [self get_wifi_list];
    /*
    b_to_display_wired=false;
    view_main_netset.hidden=false;
    [view_camset bringSubviewToFront:view_main_netset];
    
    view_spinner.hidden=false;
    label_spinner_hint.text=NSLocalizedString(@"m_getting_netif", @"");
    [view_camset bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_cli_get_netif_settings:m_share_item.h_connector];
     */
}

- (IBAction)button_record_set_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    ViewController_recordset* destview=[[ViewController_recordset alloc]initWithNibName:@"ViewController_recordset" bundle:nil];
    [self presentViewController:destview animated:YES completion:nil];
    destview=nil;
}

- (IBAction)button_cctv_set_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    ViewController_cctv* destview=[[ViewController_cctv alloc]initWithNibName:@"ViewController_cctv" bundle:nil];
    [self presentViewController:destview animated:YES completion:nil];
    destview=nil;
}

- (IBAction)button_local_pic_click:(id)sender {
    zxy_FolderViewController* destview=nil;
    destview = [[zxy_FolderViewController alloc]initWithNibName:@"zxy_FolderViewController" bundle:nil];
    [self.navigationController pushViewController:destview animated:YES];
    //[self presentViewController:destview animated:YES completion:nil];
    destview=nil;
}

- (IBAction)button_devinfo_set_click:(id)sender {
    tf_devname.text=m_share_item.cur_cam_list_item.m_title;
    tf_devid.text=m_share_item.cur_cam_list_item.m_devid;
    tf_devpass.text=m_share_item.cur_cam_list_item.m_dev_pass;
    tf_devmodel.text=m_share_item.cur_cam_list_item.m_model;
    tf_devfirmware.text=m_share_item.cur_cam_list_item.m_firmware;
    view_devinfo.hidden=false;
    [view_camset bringSubviewToFront:view_devinfo];
}

- (IBAction)button_system_set_return_click:(id)sender {
    view_system_fun.hidden=true;
}

- (IBAction)button_system_editpass_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    tv_editpass1.text=@"";
    tv_editpass2.text=@"";
    tv_editpass3.text=@"";
    view_editpass_bg.hidden=false;
    [view_system_fun bringSubviewToFront:view_editpass_bg];
}

- (IBAction)button_system_mirror_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    m_mirror_state_new=0;
    if (m_mirror_state==0) {
        m_mirror_state_new=3;
    }
    else
        m_mirror_state_new=0;
    view_spinner.hidden=false;
    [view_camset bringSubviewToFront:view_spinner];
    goe_Http.cli_c2s_mirror_config_delegate=self;
    [goe_Http cli_lib_set_mirror_config:m_share_item.h_connector with_chlid:m_share_item.cur_cam_list_item.m_chlid state:m_mirror_state_new];
}

- (IBAction)button_system_sleep_click:(id)sender {
    /*
    int to_status=0;
    if (m_share_item.cur_cam_list_item.m_private_status==0) {
        to_status=1;
    }
    else
        to_status=0;
    view_spinner.hidden=false;
    [view_camset bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_ModifyCamPrivateStatus:m_share_item.cur_cam_list_item.m_id devid:m_share_item.cur_cam_list_item.m_devid status:to_status ];
     */
}

- (IBAction)button_system_reboot_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_reboot_bg.hidden=false;
    [view_system_fun bringSubviewToFront:view_reboot_bg];
}

- (IBAction)button_system_reboot_cancel_click:(id)sender {
    view_reboot_bg.hidden=true;
}

- (IBAction)button_system_reboot_ensure_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    view_reboot_bg.hidden=true;
    int res=[goe_Http cli_lib_dev_reboot:m_share_item.h_connector];
    NSLog(@"cli_lib_dev_reboot, res=%d",res);
    if (res !=200) {
        view_spinner.hidden=true;
        [OMGToast showWithText:NSLocalizedString(@"dev_reboot_fail", @"")];
    }
}

- (IBAction)button_system_editpass_cancel_click:(id)sender {
    view_editpass_bg.hidden=true;
}

- (IBAction)button_system_editpass_ensure_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    NSString* oldpass=[tv_editpass1 text];
    m_dev_newpass=[tv_editpass2 text];
    NSString* ensure_newpass=[tv_editpass3 text];
    if ([m_dev_newpass isEqualToString:ensure_newpass]==false) {
        [OMGToast showWithText:NSLocalizedString(@"m_ensure_pass_fail", @"")];
        return;
    }
    if ([oldpass isEqualToString:m_share_item.cur_cam_list_item.m_dev_pass]==false) {
        [OMGToast showWithText:NSLocalizedString(@"m_old_pass_err", @"")];
        return;
    }
    view_editpass_bg.hidden=true;
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_setdevpass:m_share_item.h_connector devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:oldpass devnewpass:m_dev_newpass];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
//////////////////
-(void)hideSpinner
{
    label_spinner_hint.text=@"";
    view_spinner.hidden=true;
}
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
{
    NSLog(@"ViewController_camset_detail cli_lib_devconnect_CALLBACK_dev, res=%d",res);
    if (m_share_item.h_connector<=0) {
        return;
    }
    if (m_share_item.h_connector != connector) {
        return;
    }
    
    if (res==1) {
        m_share_item.m_connect_state=1;
        
    }
    else{
        m_share_item.m_connect_state=-1;
        [goe_Http cli_lib_releaseconnect:m_share_item.h_connector];
        m_share_item.h_connector=0;
        m_share_item.h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"viewcontroller_camset_detail"];
        NSLog(@"m_share_item.h_connector===%ld",m_share_item.h_connector);
         
    }
    
    if (bFirstHideSpinner==true && view_spinner.hidden==false) {
        bFirstHideSpinner=false;
        NSLog(@"to hideSpinner.....");
        [self performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:YES];
    }
}
//-----------------------------------------
-(NSString*)get_fail_reason:(int)res
{
    NSString* msg=nil;
    switch (res) {
            
        case -2:
            msg=NSLocalizedString(@"err_2", @"");
            break;
        case -3:
            msg=NSLocalizedString(@"err_3", @"");
            break;
        case -4:
            msg=NSLocalizedString(@"err_4", @"");
            break;
        case -5:
            msg=NSLocalizedString(@"err_5", @"");
            break;
        case -6:
            msg=NSLocalizedString(@"err_6", @"");
            break;
        case 400:
            msg=NSLocalizedString(@"err_400", @"");
            break;
        case 409:
            msg=NSLocalizedString(@"err_409", @"");
            break;
        case 410:
            msg=NSLocalizedString(@"err_410", @"");
            break;
        case 203:
            msg=NSLocalizedString(@"err_203", @"");
            break;
        case 412:
            msg=NSLocalizedString(@"err_412", @"");
            break;
        case 413:
            msg=NSLocalizedString(@"err_413", @"");
            break;
        case 414:
            msg=NSLocalizedString(@"err_414", @"");
            break;
        case 500:
            msg=NSLocalizedString(@"err_500", @"");
            break;
        case 501:
            msg=NSLocalizedString(@"err_501", @"");
            break;
        case 502:
            msg=NSLocalizedString(@"err_502", @"");
            break;
        default:
            msg=NSLocalizedString(@"err_else", @"");
            break;
    }
    return msg;
}

-(void)update_mirror_state
{
    if (m_mirror_state==0) {
        img_cam_mirror_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
    }
    else{
        img_cam_mirror_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
    }
}
-(void)on_mirror_config_get_mainthread:(vv_req_info *)req
{
    if (req.int_tag1==200) {
        m_mirror_state=req.int_tag2;
        [self update_mirror_state];
    }
}
-(void)cli_lib_mirror_config_get_callback:(int)res  with_config:(int)config
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.int_tag2=config;
    [self performSelectorOnMainThread:@selector(on_mirror_config_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)on_mirror_config_set_mainthread:(vv_req_info *)req
{
    view_spinner.hidden=true;
    if (req.int_tag1==200) {
        m_mirror_state=m_mirror_state_new;
        [self update_mirror_state];
    }
    else{
        [OMGToast showWithText:[self get_fail_reason:req.int_tag1]];
    }
}
-(void)cli_lib_mirror_config_set_callback:(int)res
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_mirror_config_set_mainthread:) withObject:cur_req waitUntilDone:YES];
}
//---------------------------------------
- (IBAction)button_net_set_return_click:(id)sender {
    view_main_netset.hidden=true;
}

- (IBAction)button_net_wired_click:(id)sender {
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    b_to_display_wired=true;
    view_spinner.hidden=false;
    label_spinner_hint.text=NSLocalizedString(@"m_getting_netif", @"");
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_cli_get_netif_settings:m_share_item.h_connector];
}

-(void)init_wifi_view
{
    [m_wifi_manager clean];
    [tableview_wifi reloadData];
    img_left_cur_net.hidden=true;
    label_cur_net.text=NSLocalizedString(@"m_no_wifi", @"");
    img_pass_cur_net.hidden=true;
    img_signal_cur_net.hidden=true;
}
-(void)get_wifi_list
{
    NSLog(@"to get_wifi_list.........................");
    if (m_share_item.m_connect_state==1)
    {
        [spinner_wifi_list startAnimating];
        [goe_Http cli_lib_get_wifi_lists:m_share_item.h_connector];
    }
    else{
        sleep(1);
        vv_req_info* cur_req= [vv_req_info new];
        cur_req.data_tag1=nil;
        cur_req.int_tag1=-1;
        [self performSelectorOnMainThread:@selector(on_cam_wifi_list_mainthread:) withObject:cur_req waitUntilDone:YES];
    }
    
}
- (IBAction)button_net_wireless_click:(id)sender {
    view_main_wifi.hidden=false;
    [self init_wifi_view];
    [view_main_netset bringSubviewToFront:view_main_wifi];
    [self get_wifi_list];
}



- (IBAction)button_net_wired_return_click:(id)sender {
    view_wanlan.hidden=true;
}

- (IBAction)button_net_wireless_return_click:(id)sender {
    [self stop_wifiupdate_timer];
    view_main_netset.hidden=true;
    //view_main_wifi.hidden=true;
}
- (IBAction)button_net_wired_set_ensure_click:(id)sender
{
    [item_tv_ip resignFirstResponder];
    [item_tv_netgate resignFirstResponder];
    [item_tv_netmask resignFirstResponder];
    [item_tv_dns1 resignFirstResponder];
    [item_tv_dns2 resignFirstResponder];
    if (m_share_item.m_connect_state !=1) {
        [OMGToast showWithText:NSLocalizedString(@"dev_not_connected", @"")];
        return;
    }
    
    NSMutableDictionary* dic_netinfo = [[NSMutableDictionary alloc]init];
    [dic_netinfo setObject:[NSNumber numberWithInt:wired_type] forKey:@"net_type"];
    if (wired_type==1) {
        [dic_netinfo setObject:item_tv_ip.text forKey:@"ip"];
        [dic_netinfo setObject:item_tv_netmask.text forKey:@"mask"];
        [dic_netinfo setObject:item_tv_netgate.text forKey:@"gate"];
        [dic_netinfo setObject:[NSNumber numberWithInt:0] forKey:@"dns_dhcp"];
        [dic_netinfo setObject:item_tv_dns1.text forKey:@"dns1"];
        [dic_netinfo setObject:item_tv_dns2.text forKey:@"dns2"];
    }
    else if(wired_type==2){
        [dic_netinfo setObject:@"" forKey:@"ip"];
        [dic_netinfo setObject:@"" forKey:@"mask"];
        [dic_netinfo setObject:@"" forKey:@"gate"];
        [dic_netinfo setObject:[NSNumber numberWithInt:1] forKey:@"dns_dhcp"];
        [dic_netinfo setObject:@"" forKey:@"dns1"];
        [dic_netinfo setObject:@"" forKey:@"dns2"];
    }
    NSData* savedata = [NSJSONSerialization dataWithJSONObject:dic_netinfo options:NSJSONWritingPrettyPrinted error:nil];
    //NSString* aStr= [[NSString alloc] initWithData:savedata encoding:NSUTF8StringEncoding];
    //NSLog(@"cli_lib_cli_set_netif==%@",aStr);
    view_spinner.hidden=false;
    label_spinner_hint.text=NSLocalizedString(@"m_setting_net", @"");
    [self.view bringSubviewToFront:view_spinner];
    [goe_Http cli_lib_cli_set_netif:m_share_item.h_connector set_json:savedata];
}
- (IBAction)button_join_net_cancel_click:(id)sender
{
    view_join_net_bg.hidden=true;
    [tv_wifi_pass resignFirstResponder];
}
- (IBAction)button_join_net_ensure_click:(id)sender
{
    view_join_net_bg.hidden=true;
    [tv_wifi_pass resignFirstResponder];
    m_new_ssidpass=tv_wifi_pass.text;
    [self start_wifi_set];
}
-(void)on_cam_private_return:(int)res status:(int)status
{
    view_spinner.hidden=true;
    
    if (res !=200) {
        //[OMGToast showWithText:NSLocalizedString(@"m_operate_fail", @"")];
    }
    else{
        if (m_share_item.cur_cam_list_item.m_private_status==0) {
            img_cam_private_switch.image=[UIImage imageNamed:@"zx_switch_off.png"];
        }
        else{
            img_cam_private_switch.image=[UIImage imageNamed:@"zx_switch_on.png"];
        }
    }
    
}

- (IBAction)button_devinfo_return_click:(id)sender {
    [tf_devname resignFirstResponder];
    [tf_devpass resignFirstResponder];
    view_devinfo.hidden=true;
}

- (IBAction)button_devinfo_save_click:(id)sender {
    [tf_devname resignFirstResponder];
    [tf_devpass resignFirstResponder];
    NSString* m_newname=[tf_devname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* m_newpass=[tf_devpass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (m_newname==nil||m_newname.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"Please enter system name.", @"")];
        return;
    }
    if (m_newpass==nil||m_newpass.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"Wrong security code", @"")];
        return;
    }
    [m_list_manager edit_cam_byid:m_share_item.cur_cam_list_item.m_id with_newpass:m_newpass newname:m_newname];
    m_share_item.cur_cam_list_item.m_title=m_newname;
    m_share_item.cur_cam_list_item.m_dev_pass=m_newpass;
    [OMGToast showWithText:NSLocalizedString(@"Save successfully.", @"")];
}
//-----------------------------
-(void)ShowTextOnMainThread:(NSString*)string{
    [OMGToast showWithText:string];
}

-(void)toast_on_editpass
{
    NSString* msg=nil;
    view_spinner.hidden=true;
    int res=edit_pass_res;
    switch (res) {
        case 200:
            msg=NSLocalizedString(@"m_edit_pass_ok", @"");
            [m_list_manager editpass_cam_byid:m_share_item.cur_cam_list_item.m_devid with_newpass:m_dev_newpass];
            break;
        case -2:
            msg=NSLocalizedString(@"err_2", @"");
            break;
        case -3:
            msg=NSLocalizedString(@"err_3", @"");
            break;
        case -4:
            msg=NSLocalizedString(@"err_4", @"");
            break;
        case -5:
            msg=NSLocalizedString(@"err_5", @"");
            break;
        case -6:
            msg=NSLocalizedString(@"err_6", @"");
            break;
        case 400:
            msg=NSLocalizedString(@"err_400", @"");
            break;
        case 410:
            msg=NSLocalizedString(@"err_410", @"");
            break;
        case 203:
            msg=NSLocalizedString(@"err_203", @"");
            break;
        case 412:
            msg=NSLocalizedString(@"err_412", @"");
            break;
        case 413:
            msg=NSLocalizedString(@"err_413", @"");
            break;
        case 414:
            msg=NSLocalizedString(@"err_414", @"");
            break;
        case 500:
            msg=NSLocalizedString(@"err_500", @"");
            break;
        case 501:
            msg=NSLocalizedString(@"err_501", @"");
            break;
        case 502:
            msg=NSLocalizedString(@"err_502", @"");
            break;
        default:
            msg=NSLocalizedString(@"err_else", @"");
            break;
    }
    [self ShowTextOnMainThread:msg];
}
-(void)cli_lib_devsetpass_CALLBACK:(int)HttpRes devid:(NSString*)dev_id
{
    NSLog(@"cli_lib_devsetpass_CALLBACK, res=%d",HttpRes);
    edit_pass_res=HttpRes;
    [self performSelectorOnMainThread:@selector(toast_on_editpass) withObject:nil waitUntilDone:YES];
}
//------------------------------------------------------------------------
-(NSString*)get_netif_fail_reason:(int)res
{
    NSString* msg=nil;
    switch (res) {
            
        case -2:
            msg=NSLocalizedString(@"err_2", @"");
            break;
        case -3:
            msg=NSLocalizedString(@"err_3", @"");
            break;
        case -4:
            msg=NSLocalizedString(@"err_4", @"");
            break;
        case -5:
            msg=NSLocalizedString(@"err_5", @"");
            break;
        case -6:
            msg=NSLocalizedString(@"err_6", @"");
            break;
        case 400:
            msg=NSLocalizedString(@"err_400", @"");
            break;
        case 409:
            msg=NSLocalizedString(@"err_409", @"");
            break;
        case 410:
            msg=NSLocalizedString(@"err_410", @"");
            break;
        case 203:
            msg=NSLocalizedString(@"err_203", @"");
            break;
        case 412:
            msg=NSLocalizedString(@"err_412", @"");
            break;
        case 413:
            msg=NSLocalizedString(@"err_413", @"");
            break;
        case 414:
            msg=NSLocalizedString(@"err_414", @"");
            break;
        case 500:
            msg=NSLocalizedString(@"err_500", @"");
            break;
        case 501:
            msg=NSLocalizedString(@"err_501", @"");
            break;
        case 502:
            msg=NSLocalizedString(@"err_502", @"");
            break;
        default:
            msg=NSLocalizedString(@"err_else", @"");
            break;
    }
    return msg;
}
-(void)view_dhcp_set:(BOOL)isdhcp
{
    //NSLog(@"view_dhcp_set==%d",isdhcp);
    if (isdhcp==true) {
        /*
         NSLog(@"to set disable");
         item_view_ip.hidden=true;
         item_view_netmask.hidden=true;
         item_view_netgate.hidden=true;
         item_view_dns1.hidden=true;
         item_view_dns2.hidden=true;
         */
        
        item_tv_ip.textColor=UIColorFromRGB(m_strings.top_gray);
        item_tv_ip.enabled=false;
        
        item_tv_netmask.textColor=UIColorFromRGB(m_strings.top_gray);
        item_tv_netmask.enabled=false;
        
        item_tv_netgate.textColor=UIColorFromRGB(m_strings.top_gray);
        item_tv_netgate.enabled=false;
        
        item_tv_dns1.textColor=UIColorFromRGB(m_strings.top_gray);
        item_tv_dns1.enabled=false;
        
        item_tv_dns2.textColor=UIColorFromRGB(m_strings.top_gray);
        item_tv_dns2.enabled=false;
        
        wired_type=2;
        
    }
    else{
        
        item_tv_ip.textColor=UIColorFromRGB(m_strings.text_gray);
        item_tv_ip.enabled=true;
        
        item_tv_netmask.textColor=UIColorFromRGB(m_strings.text_gray);
        item_tv_netmask.enabled=true;
        
        item_tv_netgate.textColor=UIColorFromRGB(m_strings.text_gray);
        item_tv_netgate.enabled=true;
        
        item_tv_dns1.textColor=UIColorFromRGB(m_strings.text_gray);
        item_tv_dns1.enabled=true;
        
        item_tv_dns2.textColor=UIColorFromRGB(m_strings.text_gray);
        item_tv_dns2.enabled=true;
        
        /*
         item_view_ip.hidden=false;
         item_view_netmask.hidden=false;
         item_view_netgate.hidden=false;
         item_view_dns1.hidden=false;
         item_view_dns2.hidden=false;
         */
        wired_type=1;
    }
}
-(void)set_wirednet_enable:(BOOL)enable
{
    if (enable==true) {
        button_item_wirednet_bg.enabled=true;
        label_item_wanlan_set.textColor=[UIColor blackColor];
    }
    else{
        button_item_wirednet_bg.enabled=false;
        label_item_wanlan_set.textColor=UIColorFromRGB(m_strings.text_gray);
    }
}
-(void)set_wirelessnet_enable:(BOOL)enable
{
    if (enable==true) {
        button_item_wireless_bg.enabled=true;
        label_wireless_set.textColor=[UIColor blackColor];
    }
    else{
        button_item_wireless_bg.enabled=false;
        label_wireless_set.textColor=UIColorFromRGB(m_strings.text_gray);
    }
}
-(void)process_get_netif_result{
    label_spinner_hint.text=@"";
    view_spinner.hidden=true;
    if(m_get_netif_res==200){
        if (wired_type !=-1) {
            [self set_wirednet_enable:true];
            set_type=0;
            net_type=0;
            
            if (wired_type==1)//手动
            {
                [item_switch_dhcp setOn:false animated:YES];
                [self view_dhcp_set:false];
            }
            else if(wired_type==2)//dhcp
            {
                [item_switch_dhcp setOn:true animated:YES];
                [self view_dhcp_set:true];
            }
            
            item_tv_ip.text=m_wired_net_info.ip;
            item_tv_netmask.text=m_wired_net_info.mask;
            item_tv_netgate.text=m_wired_net_info.gate;
            item_tv_dns1.text=m_wired_net_info.dns1;;
            item_tv_dns2.text=m_wired_net_info.dns2;
        }
        else{
            [self set_wirednet_enable:false];
        }
        if(wireless_type != -1){
            set_type=1;
            net_type=1;
            [self set_wirelessnet_enable:true];
        }
        else{
            [self set_wirelessnet_enable:false];
        }
        if (wired_type != -1 && wireless_type!=-1) {
            net_type=2;
        }
        
        if(b_to_display_wired==true){
            b_to_display_wired=false;
            view_wanlan.hidden=false;
            [view_main_netset bringSubviewToFront:view_wanlan];
        }
        return;
    }
    NSString* msg=[self get_netif_fail_reason:m_get_netif_res];
    [self ShowTextOnMainThread:msg];
}
-(void)cli_lib_netif_cli_get_CALLBACK:(int)res with_data:(NSData*)net_data
{
    //[goe_Http cli_lib_stop_getting_netif];
    m_get_netif_res=res;
    m_netinfo_data=net_data;
    if(m_get_netif_res==200){
        net_type=0;
        set_type=1;
        wired_type=-1;
        wireless_type=-1;
        NSError* reserr;
        NSMutableDictionary *g_info_dictionary= [NSJSONSerialization JSONObjectWithData:m_netinfo_data options:NSJSONReadingMutableContainers error:&reserr];
        if (g_info_dictionary !=nil) {
            //NSLog(@"cli_lib_netif_cli_get_CALLBACK==%@",g_info_dictionary);
            if ([g_info_dictionary objectForKey:@"netifs"]) {
                for (NSDictionary* net_item in [g_info_dictionary objectForKey:@"netifs"]) {
                    int nettype=[[net_item objectForKey:@"net_type"]intValue];
                    //NSLog(@"nettype=%d",nettype);
                    if (nettype==1 || nettype==2) {
                        if (wired_type == -1) {
                            wired_type=nettype;
                            m_wired_net_info=nil;
                            if (m_wired_net_info==nil) {
                                m_wired_net_info=[wired_net_info alloc];
                                
                                m_wired_net_info.token=[net_item objectForKey:@"token"];
                                m_wired_net_info.ip_type=[[net_item objectForKey:@"net_type"]intValue];
                                m_wired_net_info.ip=[net_item objectForKey:@"ip"];
                                if (m_wired_net_info.ip==nil) {
                                    m_wired_net_info.ip=@"0.0.0.0";
                                }
                                m_wired_net_info.mask=[net_item objectForKey:@"mask"];
                                if (m_wired_net_info.mask==nil) {
                                    m_wired_net_info.mask=@"";
                                }
                                m_wired_net_info.gate=[net_item objectForKey:@"gate"];
                                if (m_wired_net_info.gate==nil) {
                                    m_wired_net_info.gate=@"";
                                }
                                m_wired_net_info.dns_type=[[net_item objectForKey:@"dns_dhcp"]intValue];
                                m_wired_net_info.dns1=[net_item objectForKey:@"dns1"];
                                if (m_wired_net_info.dns1==nil) {
                                    m_wired_net_info.dns1=@"";
                                }
                                m_wired_net_info.dns1=[net_item objectForKey:@"dns1"];
                                if (m_wired_net_info.dns2==nil) {
                                    m_wired_net_info.dns2=@"";
                                }
                            }
                            
                        }
                    }
                    else if (nettype==3 || nettype==4) {
                        m_cur_ssid=[net_item objectForKey:@"ssid"];
                        if (wireless_type == -1) {
                            wireless_type=nettype;
                        }
                    }
                    
                }
            }
        }
        
    }
    
    [self performSelectorOnMainThread:@selector(process_get_netif_result) withObject:nil waitUntilDone:YES];
}
///////////////////////////////
-(void)stop_wifiupdate_timer
{
    [spinner_wifi_list stopAnimating];
    if ([m_wifiupdate_Timer isValid]==true) {
        [m_wifiupdate_Timer invalidate];
        //NSLog(@"m_flow_Timer  invalidate...");
    }
}
-(void)update_cur_net_info:(NSString*)name ispass:(int)ispass signal:(int)signal
{
    NSString* wifiname=name;
    if (wifiname==nil || wifiname.length<=0) {
        wifiname=NSLocalizedString(@"m_no_wifi", @"");
        if (m_cur_ssid != nil && m_cur_ssid.length>0) {
            label_cur_net.text=[NSString stringWithFormat:@"%@(%@)",m_cur_ssid,wifiname ];
        }
        else
            label_cur_net.text=wifiname;
        img_signal_cur_net.hidden=true;
        img_pass_cur_net.hidden=true;
        return;
    }
    label_cur_net.text=wifiname;
    if ([m_wifi_manager cur_wifi_pass]==1) {
        img_pass_cur_net.hidden=false;
    }
    else{
        img_pass_cur_net.hidden=true;
    }
    img_signal_cur_net.hidden=false;
    switch (signal)
    {
        case 0:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi1.png"];
            break;
        case 1:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi2.png"];
            break;
        case 2:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi3.png"];
            break;
        case 3:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
        default:
            img_signal_cur_net.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
    }
}
-(void)on_cam_wifi_list_mainthread:(vv_req_info *)req
{
    if (view_main_wifi.hidden==true) {
        return;
    }
    if(b_setting_wifi==true){
        [spinner_cur_net stopAnimating];
        b_setting_wifi=false;
    }
    [spinner_wifi_list stopAnimating];
    int res=req.int_tag1;
    if (res==200) {
        
        if([m_wifi_manager setJsonData:req.data_tag1 type:0]==true)
        {
            NSString* wifiname=[m_wifi_manager cur_wifi_name];
            if (wifiname==nil || wifiname.length<=0) {
                wifiname=NSLocalizedString(@"m_no_wifi", @"");
            }
            [self update_cur_net_info:wifiname ispass:[m_wifi_manager cur_wifi_pass] signal:[m_wifi_manager cur_wifi_signal]];
            [tableview_wifi reloadData];
        }
    }
    m_wifiupdate_Timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(get_wifi_list) userInfo:nil repeats:NO];
}
-(void)cli_lib_get_wifi_list_callback:(int)res data:(NSData*)data
{
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.data_tag1=data;
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_cam_wifi_list_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)process_set_netif_result
{
    view_spinner.hidden=true;
    label_spinner_hint.text=@"";
    NSString* strmsg_code=@"";
    if (m_set_netif_res==200) {
        strmsg_code=NSLocalizedString(@"m_device_net_set_ok", @"");
    }
    else{
        NSString* msg=[self get_fail_reason:m_set_netif_res];
        strmsg_code=[NSString stringWithFormat:@"%@(%d):",msg,m_set_netif_res];
    }
    [OMGToast showWithText:strmsg_code];
}
-(void)cli_lib_netif_cli_set_CALLBACK:(int)res
{
    m_set_netif_res=res;
    //m_set_netif_res=409;
    [self performSelectorOnMainThread:@selector(process_set_netif_result) withObject:nil waitUntilDone:YES];
}
@end
