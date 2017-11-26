//
//  ViewController_apmode.m
//  pano360
//
//  Created by zxy on 2017/5/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController_apmode.h"


@interface ViewController_apmode ()

@end

@implementation ViewController_apmode

@synthesize view0;
@synthesize label_top0;
@synthesize button_view0_nextstep;
@synthesize tv_view0_hint0;
@synthesize tv_view0_hint1;
@synthesize button_view0_wifi_set;

@synthesize view2;
@synthesize label_top2;
@synthesize button_view2_nextstep;
@synthesize tv_view2_hint0;
@synthesize label_view2_wifiname;
@synthesize tv_view2_wifiname;
@synthesize label_view2_wifipass;
@synthesize tv_view2_wifipass;

@synthesize view3;
@synthesize view_view3_sendok;
@synthesize view_view3_sendfail;
@synthesize label_view3;
@synthesize tv_view3_hint0;

@synthesize label_view3_sendfail;
@synthesize button_view3_sendfail_exit;
@synthesize tv_view3_sendfail_hint;
@synthesize button_view3_sendfail_retry;

@synthesize view4;
@synthesize label_view4_top;
@synthesize tv_view4_hint;
@synthesize view_view4_bindfail;
@synthesize label_view4_bindfail_top;
@synthesize tv_view4_bindfail_hint;
@synthesize button_view4_bindfail_ensure;

@synthesize button_view3_return;
@synthesize button_view4_return;

@synthesize view_login;
@synthesize label_login_title;
@synthesize button_login_ensure;
@synthesize tf_dev_usr;
@synthesize tf_dev_pass;
/////////////
@synthesize view_wifilist;
@synthesize tableview_wifi;
@synthesize label_wifilist_title;
@synthesize button_wifilist_referesh;
@synthesize label_wifilist_hint;

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self init_view_value];
    tv_view2_wifiname.delegate=self;
    tv_view2_wifipass.delegate=self;
    tf_dev_usr.delegate=self;
    tf_dev_pass.delegate=self;
    
    m_connect_mode=-1;
    m_connect_state=-1;
    MyShareData=[zxy_share_data getInstance];
    goe_Http=[ppview_cli getInstance];
    m_cams_manager= [cam_list_manager_local getInstance];
    m_wifi_manager=[wifi_manager getInstance];
    goe_Http.cli_devconnect_single_delegate=self;
    goe_Http.cli_devadd_delegate=self;
    goe_Http.cli_c2s_dev_wifi_delegate=self;
    
    
    tableview_wifi.delegate = self;
    tableview_wifi.dataSource = self;
    /*
    if ([self isWifiNetwork]==true) {
        m_wifi_ssid=[self getDeviceSSID];
        BOOL bVVAP=[m_wifi_ssid hasPrefix:@"VVAP"];
        if(bVVAP==true)
            m_wifi_ssid=@"";
    }
    else{
        m_wifi_ssid=@"";
    }
     */
    
}
-(void)init_view_value
{
    m_dev_usr=@"admin";
    m_dev_pass=@"123456";
    label_top0.text=NSLocalizedString(@"m_ap_adddev", @"");
    [button_view0_nextstep setTitle:NSLocalizedString(@"m_next_step", @"") forState:UIControlStateNormal];
    tv_view0_hint0.text=NSLocalizedString(@"m_ap_mode_in", @"");
    tv_view0_hint1.text=NSLocalizedString(@"m_mobile_ap_set", @"");
    [button_view0_wifi_set setTitle:NSLocalizedString(@"m_in_wifi_set", @"") forState:UIControlStateNormal];
    
    label_top2.text=NSLocalizedString(@"m_ap_adddev", @"");
    [button_view2_nextstep setTitle:NSLocalizedString(@"m_next_step", @"") forState:UIControlStateNormal];
    tv_view2_hint0.text=NSLocalizedString(@"m_input_wifi", @"");
    label_view2_wifiname.text=NSLocalizedString(@"m_wifi_name", @"");
    label_view2_wifipass.text=NSLocalizedString(@"m_wifi_pass", @"");

    label_view3.text=NSLocalizedString(@"m_ap_adddev", @"");
    tv_view3_hint0.text=NSLocalizedString(@"m_send_wifiset_req", @"");
    
    
    label_view3_sendfail.text=NSLocalizedString(@"m_ap_adddev", @"");
    [button_view3_sendfail_exit setTitle:NSLocalizedString(@"m_exit", @"") forState:UIControlStateNormal];
    [button_view3_sendfail_retry setTitle:NSLocalizedString(@"m_retry_add", @"") forState:UIControlStateNormal];
    
    label_view4_top.text=NSLocalizedString(@"m_add_cam", @"");
    tv_view4_hint.text=[NSString stringWithFormat:@"%@...",NSLocalizedString(@"m_connecting_dev", @"")];
    label_view4_bindfail_top.text=NSLocalizedString(@"m_adding_dev_fail", @"");
    [button_view4_bindfail_ensure setTitle:NSLocalizedString(@"m_ensure", @"") forState:UIControlStateNormal];
    
    label_login_title.text=NSLocalizedString(@"m_dev_login", @"");
    [button_login_ensure setTitle:NSLocalizedString(@"m_ensure", @"") forState:UIControlStateNormal];
    tf_dev_usr.placeholder=NSLocalizedString(@"m_input_dev_usr", @"");
    tf_dev_pass.placeholder=NSLocalizedString(@"m_input_devpass", @"");
    
    label_wifilist_title.text=NSLocalizedString(@"m_select_net", @"");
    [button_wifilist_referesh setTitle:NSLocalizedString(@"m_referesh", @"") forState:UIControlStateNormal];
    label_wifilist_hint.text=NSLocalizedString(@"m_select_net_hint", @"");

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn....");
    [textField resignFirstResponder];
    return YES;
}
- (NSString *) getDeviceSSID
{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //NSLog(@"networkinfo==%@",info);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    if (ssid==nil) {
        ssid=@"";
    }
    return ssid;
}

-(BOOL)isWifiNetwork
{
    
    if([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]== NotReachable)
    {
        return false;
    }
    else
    {
        return true;
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

- (IBAction)button_exit_click:(id)sender {
    
    [self quit_viewcontroller:0];
}

- (IBAction)button_view0_nextstep_click:(id)sender {
    m_ap_ssid=[self getDeviceSSID];
    if (m_ap_ssid==nil || m_ap_ssid.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"m_nodevice_set", @"")];
        return;        
    }
    BOOL bVVAP=true;//[m_ap_ssid hasPrefix:@"VVAP"];
    if (bVVAP==false) {
        [OMGToast showWithText:NSLocalizedString(@"m_nodevice_set", @"")];
        return;
    }
    
    view0.hidden=true;
    button_view3_return.hidden=true;
    tv_view3_hint0.text=NSLocalizedString(@"m_ap_connecting_dev", @"");
    view3.hidden=false;
    [self.view bringSubviewToFront:view3];
    m_ap_connect_count=0;
    bAPNet=true;
    h_connector=[goe_Http cli_lib_createconnect_ip:@"192.168.255.1" devuser:m_dev_usr devpass:m_dev_pass];
    h_connector=0;
    
}

- (IBAction)button_view0_wifiset_click:(id)sender {
   
    if(MyShareData.m_sys_version<10){
        NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
    }
    
}
- (IBAction)button_view2_nextstep_click:(id)sender {
    m_wifi_pass=[tv_view2_wifipass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (m_wifi_pass==nil) {
        m_wifi_pass=@"";
    }
    view3.hidden=false;
    view_view3_sendok.hidden=true;
    view_view3_sendfail.hidden=true;
    
    [tv_view2_wifiname resignFirstResponder];
    [tv_view2_wifipass resignFirstResponder];
    view2.hidden=true;
    m_search_count=0;
    button_view3_return.hidden=true;
    tv_view3_hint0.text=NSLocalizedString(@"m_getting_devinfo", @"");

    [goe_Http cli_lib_get_devinfo:h_connector with_usr:m_dev_usr with_pass:m_dev_pass with_sess:@"" with_type:0 tag:@""];
    //[goe_Http cli_lib_set_dev_net:h_connector net_type:4 ip:nil net_mask:nil net_gate:nil net_dns:nil ssid:m_wifi_ssid ssid_pass:m_wifi_pass];
    [self.view bringSubviewToFront:view3];
}


- (IBAction)button_view2_return_click:(id)sender {
  
    //[self.view bringSubviewToFront:view0];
    view2.hidden=true;
}

- (IBAction)button_view3_return_click:(id)sender {
}

- (IBAction)button_view3_sendfail_exit_click:(id)sender {
    [self quit_viewcontroller:1];
}

- (IBAction)button_view3_sendfail_retry_click:(id)sender {
    view_view3_sendfail.hidden=true;
    view3.hidden=true;
    view0.hidden=false;
    label_view3_sendfail.hidden=true;
    [self.view bringSubviewToFront:view0];
}

- (IBAction)button_view4_bindfail_ensure_click:(id)sender {
    [self quit_viewcontroller:1];
}

- (IBAction)button_login_ensure_click:(id)sender {
    [tf_dev_usr resignFirstResponder];
    [tf_dev_pass resignFirstResponder];
    m_dev_usr=[tf_dev_usr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    m_dev_pass=[tf_dev_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (m_dev_usr==nil || m_dev_usr.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"m_dev_usr_isnull", @"")];
        return;
    }
    if (m_dev_pass==nil || m_dev_pass.length<=0) {
        [OMGToast showWithText:NSLocalizedString(@"m_dev_pass_isnull", @"")];
        return;
    }
    view_login.hidden=true;
   // [goe_Http cli_lib_cli_get_netif_settings:h_connector];
    bAPNet=true;
    m_ap_connect_count=0;
    if (h_connector!=0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    h_connector=[goe_Http cli_lib_createconnect_ip:@"192.168.255.1" devuser:m_dev_usr devpass:m_dev_pass];
    h_connector=0;
    
    
}

- (IBAction)button_login_return_click:(id)sender {
    [tf_dev_usr resignFirstResponder];
    [tf_dev_pass resignFirstResponder];
    [self quit_viewcontroller:1];
}

- (IBAction)button_wifi_referesh_click:(id)sender {
    if(h_connector<=0)
        return;
    bRefereshWIFIlist=true;
    [_indicator_referesh_wifi startAnimating];
    [goe_Http cli_lib_get_wifi_lists:h_connector];
}

-(void)get_devinfo:(NSData*)jsondata
{
    
    NSError* reserr;
    NSMutableDictionary* tmp_dev_dictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&reserr];
    if (tmp_dev_dictionary==nil) {
        return;
    }
    NSLog(@"reget_devinfo:%@",tmp_dev_dictionary);

    NSString* devid=[tmp_dev_dictionary objectForKey:@"dev_id"];
    if (devid==nil || devid.length<=0)
    {
        return;
    }
}
-(void)process_getdevinfodev_result:(cam_list_manager_req*)req
{
    
    
    if (req.int_tag1==200) {
        
        if (h_connector!=0) {
            [goe_Http cli_lib_releaseconnect:h_connector];
            h_connector=0;
        }
  
        [m_cams_manager add_dev:req.data_tag1 with_user:m_dev_usr with_pass:m_dev_pass with_name:m_ap_ssid];
        [self quit_viewcontroller:1];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_to_main_ex" object:self];
        //pauseTimer= [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(quit_viewcontroller) userInfo:nil repeats:NO];
        return;
    }
   
    NSString* msg=nil;
    switch (add_dev_result_code) {
            
        case -98:
            msg=NSLocalizedString(@"m_connect_dev_fail", @"");
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
        case 407:
            msg=NSLocalizedString(@"err_407", @"");
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

    NSString* strmsg_code=[NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"m_adding_dev_fail", @""),add_dev_result_code];
    strmsg_code= [strmsg_code stringByAppendingString:msg];
    tv_view4_bindfail_hint.text=strmsg_code;
    view_view4_bindfail.hidden=false;
    [self.view4 bringSubviewToFront:view_view4_bindfail];
    
}



-(void)hint_view3_msg:(NSString*)msg
{
    tv_view3_hint0.text=msg;
}


-(NSString*)get_fail_reason:(int)res
{
    NSString* msg=nil;
    switch (res) {
        case -98:
            msg=NSLocalizedString(@"err_connect_dev", @"");
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
-(void)process_ap_adddev_result
{
    if(m_ap_res !=200){
        NSString* strmsg_code=@"";
        NSString* msg=[self get_fail_reason:m_res];
        
        switch (m_ap_res) {
            case -99:
                //ap模式连接设备失败
                [NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"m_ap_connectdev_fail", @""),m_res];
                button_view3_return.hidden=false;
                break;
            case -98:
                //获取网络配置失败
                if(m_res==414|| m_res==203){
                    view_login.hidden=false;
                    [self.view bringSubviewToFront:view_login];
                    return;
                }
                [NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"m_get_devnet_fail", @""),m_res];
                button_view3_return.hidden=false;
                break;
            case -97:
                //设置网络配置失败
                [NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"m_set_devnet_fail", @""),m_res];
                button_view3_return.hidden=false;
                break;
            case -96:
                //获取设备信息失败
                [NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"m_get_devinfo_fail", @""),m_res];
                button_view3_return.hidden=false;
                break;
            default:
                [NSString stringWithFormat:@"%@(%d):",NSLocalizedString(@"err_else", @""),m_res];
                button_view3_return.hidden=false;
                break;
        }
        if (h_connector!=0) {
            [goe_Http cli_lib_releaseconnect:h_connector];
            h_connector=0;
        }
        strmsg_code= [strmsg_code stringByAppendingString:msg];
        view3.hidden=false;
        tv_view3_sendfail_hint.text=strmsg_code;
        view_view3_sendfail.hidden=false;
        [self.view3 bringSubviewToFront:view_view3_sendfail];
        return;
    }
    NSString* msg=[NSString stringWithFormat:@"%@,%@" ,NSLocalizedString(@"m_device_net_set_ok", @""),NSLocalizedString(@"m_wait_device_quit_ap", @"")];
    [self hint_view3_msg:msg];
 
}


-(void)on_cam_wifi_list_mainthread:(vv_req_info *)req
{
    //获取网络配置失败
    bDevinfo_get=false;
    int res=req.int_tag1;
    m_res=res;
    if (bRefereshWIFIlist==true) {
        bRefereshWIFIlist=false;
        [_indicator_referesh_wifi stopAnimating];
    }
    if(m_res==200){
        
        if([m_wifi_manager setJsonData:req.data_tag1 type:1]==true)
        {
            [tableview_wifi reloadData];
        }
        view_wifilist.hidden=false;
        [self.view bringSubviewToFront:view_wifilist];
    }
    else{
        bAPNet=false;
        m_ap_res=-98;
       
        [self process_ap_adddev_result];
    }

}
-(void)cli_lib_get_wifi_list_callback:(int)res data:(NSData*)data
{
    NSLog(@"cli_lib_get_wifi_list_callback, res===%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.data_tag1=data;
    cur_req.int_tag1=res;
    [self performSelectorOnMainThread:@selector(on_cam_wifi_list_mainthread:) withObject:cur_req waitUntilDone:YES];
    
    
}
-(void)cli_lib_set_wifi_callback:(int)res
{
    NSLog(@"cli_lib_netif_set_CALLBACK==%d",res);
    //[goe_Http cli_lib_stop_setting_netif];
    if (h_connector>0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    bAPNet=false;
    m_res=res;
    if (res !=200) {
        m_ap_res=-97;
        [self performSelectorOnMainThread:@selector(process_ap_adddev_result) withObject:nil waitUntilDone:YES];
    }
    else{
        m_ap_res=200;
        add_dev_result_code=res;
        cam_list_manager_req* cur_req=[cam_list_manager_req alloc];
        cur_req.int_tag1=res;
        cur_req.data_tag1=[NSJSONSerialization dataWithJSONObject:g_dev_dictionary options:kNilOptions error:nil];;
        [self performSelectorOnMainThread:@selector(process_getdevinfodev_result:) withObject:cur_req waitUntilDone:YES];
    }
   
}

-(void)cli_lib_getdevinfo_callback:(int)result with_data:(NSData*)jsondata
{
    NSLog(@"cli_lib_getdevinfo_callback, result=%d",result);
    if (result!=200 || jsondata==nil) {
        m_ap_res=-96;
        m_res=result;
        [self performSelectorOnMainThread:@selector(process_ap_adddev_result) withObject:nil waitUntilDone:YES];
        return;
    }
    
    NSError* reserr;
    g_dev_dictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&reserr];
    if (g_dev_dictionary==nil) {
        m_ap_res=-96;
        m_res=result;
        [self performSelectorOnMainThread:@selector(process_ap_adddev_result) withObject:nil waitUntilDone:YES];
        return;
    }
    bDevinfo_get=true;
    NSLog(@"cli_lib_getdevinfo_callback:%@",g_dev_dictionary);
    NSString* msg=NSLocalizedString(@"m_setting_net", @"");
    [self performSelectorOnMainThread:@selector(hint_view3_msg:) withObject:msg waitUntilDone:NO];

    [goe_Http cli_lib_set_dev_net:h_connector net_type:4 ip:nil net_mask:nil net_gate:nil net_dns:nil ssid:m_wifi_ssid ssid_pass:m_wifi_pass];
   
}
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
{
    //NSLog(@"apmode, cli_lib_devconnect_CALLBACK,  res=%d",res);
    int m_conn_res=res;

    if (bAPNet==true && h_connector==0) {
        if (m_conn_res==1) {
            m_ap_connect_count=0;
            h_connector=connector;
            //[goe_Http cli_lib_cli_get_netif_settings:h_connector];
            NSString* msg=NSLocalizedString(@"m_getting_netif", @"");
            [self performSelectorOnMainThread:@selector(hint_view3_msg:) withObject:msg waitUntilDone:NO];
             [goe_Http cli_lib_get_wifi_lists:h_connector];
             //[goe_Http cli_lib_get_devinfo:h_connector with_usr:m_dev_usr with_pass:m_dev_pass with_sess:@"" with_type:0 tag:@""];
            
        }
        else{
            m_ap_res=-99;
            m_res=-98;
            [goe_Http cli_lib_releaseconnect:connector];
            m_ap_connect_count++;
            if (m_ap_connect_count>=3) {
                [self performSelectorOnMainThread:@selector(process_ap_adddev_result) withObject:nil waitUntilDone:YES];
            }
            else{
                h_connector=[goe_Http cli_lib_createconnect_ip:@"192.168.255.1" devuser:m_dev_usr devpass:m_dev_pass];
                h_connector=0;
            }
            
        }
        return;
    }
}

-(void)quit_viewcontroller:(int)type
{
    goe_Http.cli_devadd_delegate=nil;
    goe_Http.cli_devconnect_single_delegate=nil;
    if (h_connector!=0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    if (type==1 &&delegate!=nil && [delegate respondsToSelector:@selector(ViewController_apmode_quit)]) {
        [delegate ViewController_apmode_quit];
        
    }
    [self dismissViewControllerAnimated:NO completion:^(){
        
    }];
}


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

-(BOOL)on_item_wifi_click:(NSString*)cell_id pos:(int)pos
{
    item_wifi* cur_item=[m_wifi_manager getItem:pos];
    if(cur_item==nil)
        return false;
    m_wifi_ssid=cur_item.m_wifi_name;
    m_wifi_pass=@"";
    
    tv_view2_wifiname.text=m_wifi_ssid;
    tv_view2_wifipass.text=m_wifi_pass;
    view2.hidden=false;
    [self.view bringSubviewToFront:view2];
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
@end
