//
//  ViewController_adddev.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController_adddev.h"
#import "item_search.h"
#import "cam_list_manager_req.h"
#import "QRCodeGenerator.h"
@interface ViewController_adddev ()

@end

@implementation ViewController_adddev


@synthesize view_add_main_v1;
@synthesize tv_devname_v1;
@synthesize tv_devid_v1;
@synthesize tv_devpass_v1;
/////////////////////////
@synthesize view_add_main;
@synthesize view_add_main_top;
@synthesize button_add_main_return;
@synthesize button_add_ensure;
@synthesize label_add_main;
@synthesize tv_devid;
@synthesize tv_devpass;

////////////////////////////////////////////////////
@synthesize view_spinner;
@synthesize label_spinner_hint;
///////////////////////////////////////////////////
@synthesize view_devs;
@synthesize view_devs_top;
@synthesize button_devs_return;
@synthesize label_devs;
@synthesize tablevew_devs;
///////////////////////////////////////////////
@synthesize view_add_fail;
@synthesize label_err_code;
@synthesize label_err_reason;
@synthesize button_add_fail;

///////////////////////////////////
@synthesize view_set_wireless;
@synthesize label_set_wireless;
@synthesize button_set_wireless_next;

@synthesize view_wireless_name;
@synthesize img_wireless_name;
@synthesize lable_wireless_name;


@synthesize view_wireless_pass;
@synthesize text_wireless_pass;
///////////////////////////////////


@synthesize label_dev_qrcode;
@synthesize label_ap_title;
///////////////
@synthesize view_wifi_qrcode;
@synthesize view1_wifi_qrcode_wifiinfo;
@synthesize button_view1_next_step;
@synthesize label_view1_title;
@synthesize label_view1_ssid;
@synthesize tv_view1_ssidpass;
@synthesize button_view1_skip;

@synthesize view_wifi_qrcode_create;
@synthesize label_view2_title;
@synthesize img_view2_qrcode;
@synthesize textview_view2_hint;
@synthesize button_wifiqrcode_nexttosearch;
///////////
@synthesize jsw_label_devname;
@synthesize jsw_tf_devname;
@synthesize jsw_tf_devid;
@synthesize jsw_label_devpass;
@synthesize jsw_tf_devpass;
@synthesize jsw_button_search;
@synthesize jsw_button_cancel;
@synthesize jsw_button_save;
@synthesize jsw_button_scan_devqrcode;
@synthesize jsw_button_qrcode_add;
@synthesize jsw_apmode_add;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_ui_mode=0;
    
    goe_Http=[ppview_cli getInstance];
    m_cams_manager= [cam_list_manager_local getInstance];
    m_strings=[vv_strings getInstance];
   
    m_search_list=[NSMutableArray new];
    bSearching=false;
    bToMainVIew=false;

    tv_devid.delegate=self;
    tv_devid_v1.delegate=self;
    
    tv_devpass_v1.delegate=self;
    tv_devname_v1.delegate=self;
    
    text_wireless_pass.delegate=self;
   
    tablevew_devs.delegate = self;
    tablevew_devs.dataSource = self;
    

    
    
    [self init_view_value];
    m_src_screen_bright=[UIScreen mainScreen].brightness;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
}
- (void)quit_controller
{
    [self performSelectorOnMainThread:@selector(quit_viewController) withObject:nil waitUntilDone:NO];
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear， viewcontroller_adddev");
    goe_Http.cli_devadd_delegate=self;
    goe_Http.cli_devconnect_single_delegate=self;
}
-(void)init_view_value
{
    
    
    [view_spinner setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_add_fail setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [view_add_main setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
        [view_devs setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [view_set_wireless setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
   

    label_add_main.text=NSLocalizedString(@"m_add_cam", @"");
    tv_devid_v1.placeholder=NSLocalizedString(@"m_input_devid", @"");
    tv_devpass_v1.placeholder=NSLocalizedString(@"m_input_devpass", @"");
    
    label_devs.text=NSLocalizedString(@"m_select_dev", @"");
    _label_wireless_title.text=NSLocalizedString(@"m_local_search", @"");
    [button_add_ensure setTitle:NSLocalizedString(@"m_add", @"") forState:UIControlStateNormal];
    [button_add_fail setTitle:NSLocalizedString(@"m_know", @"") forState:UIControlStateNormal];
    
   
    
    label_set_wireless.text=NSLocalizedString(@"m_join_wifi_title", @"");
    [button_set_wireless_next setTitle:NSLocalizedString(@"m_next_step", @"") forState:UIControlStateNormal];
    text_wireless_pass.placeholder=NSLocalizedString(@"m_join_wifi_title", @"");
    
    [label_set_wireless setTextColor:UIColorFromRGB(m_strings.text_gray)];
   
    

    label_dev_qrcode.text=NSLocalizedString(@"m_dev_qrcorde", @"");
    label_ap_title.text=NSLocalizedString(@"m_ap_adddev", @"");
    
    jsw_label_devname.text=NSLocalizedString(@"System Name:", @"");
    jsw_tf_devname.placeholder=NSLocalizedString(@"Please enter system name.", @"");
    jsw_label_devpass.text=NSLocalizedString(@"Security Code:", @"");
    jsw_tf_devpass.placeholder=NSLocalizedString(@"m_please_input_sercurity_code", @"");
    
    [jsw_button_search setTitle:NSLocalizedString(@"Search", @"") forState:UIControlStateNormal];
    [jsw_button_cancel setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    [jsw_button_save setTitle:NSLocalizedString(@"m_save", @"") forState:UIControlStateNormal];
    [jsw_button_scan_devqrcode setTitle:NSLocalizedString(@"Scan DID Lable", @"") forState:UIControlStateNormal];
    [jsw_button_qrcode_add setTitle:NSLocalizedString(@"m_barcode_search", @"") forState:UIControlStateNormal];
    [jsw_apmode_add setTitle:NSLocalizedString(@"m_ap_adddev", @"") forState:UIControlStateNormal];
    
    label_view1_title.text=NSLocalizedString(@"m_join_wifi_title", @"");
    tv_view1_ssidpass.placeholder=NSLocalizedString(@"m_join_wifi_title", @"");
    [button_view1_skip setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
    
}
- (NSString *) getDeviceSSID
{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [(NSDictionary *)info count])
        {
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
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return m_search_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    item_search* cur_item=[m_search_list objectAtIndex:indexPath.row];
    NSString* cur_devid=cur_item.m_devid;
    static NSString *CellIdentifier = @"TableViewCell_search_dev";
    TableViewCell_search_dev *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_search_dev" owner:self
                                            options:nil] lastObject];
    }
    if (cur_devid != nil) {
        [cell config_cell:cur_devid devip:cur_item.m_ip exist:cur_item.m_exist pos:(int)indexPath.row tag:cur_devid];
        cell.delgate=self;
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
-(void)on_add_dev_select_click:(int)pos tag:(NSString*)tag
{
    item_search* cur_item=[m_search_list objectAtIndex:pos];
    if (m_ui_mode==0) {
        
        NSString* cur_devid=cur_item.m_devid;
        bRemoteBind=false;
        new_devip=cur_item.m_ip;
        [tv_devid_v1 setText:cur_devid];
        view_devs.hidden=true;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn....");
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        return NO;
        
    }
    if (tv_devid_v1==textField) {
        bRemoteBind=true;
        
    }
    return YES;
}

-(NSString*)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}
-(void)start_search_dev
{
    [m_search_list removeAllObjects];
    m_search_count=0;
    bSearching=true;
    view_spinner.hidden=false;
    label_spinner_hint.text= NSLocalizedString(@"m_serarching", @"");
    [self.view bringSubviewToFront:view_spinner];
    m_search_sess=[self stringWithUUID];
    [goe_Http cli_lib_start_search];
}
-(void)start_search_dev_smartwifi
{
    bSearching=true;
    m_search_sess=[self stringWithUUID];
    [goe_Http cli_lib_start_search];
}
- (IBAction)button_return_click:(id)sender
{
    [self quit_viewController];
}
- (IBAction)button_search_click:(id)sender
{
    if (bSearching==true) {
        return;
    }    
    [self start_search_dev];
}



-(void)on_scan_string:(NSString*)str_data
{
    if(str_data == nil || str_data.length<=0)
        return;
    if ([str_data hasPrefix:@"{\""]==true) {
        NSData *data =[str_data dataUsingEncoding:NSUTF8StringEncoding];
        if (data != nil) {
            NSError* reserr;
            NSMutableDictionary* m_dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reserr];
            if (m_dictionary==nil) {
                return;
            }

            
            [tv_devid_v1 setText:[m_dictionary objectForKey:@"id"]];
            [tv_devpass_v1 setText:[m_dictionary objectForKey:@"pass"]];
            
            new_devuser=[m_dictionary objectForKey:@"user"];
        }
    }
    else{

         [tv_devid_v1 setText:str_data];
    }

    bRemoteBind=true;
    //button_add1_set_wifi.hidden=false;
}
- (IBAction)button_barcode_click:(id)sender
{
    if (bSearching==true) {
        return;
    }
    ScanViewController * rt = [[ScanViewController alloc]init];
    rt.delegate=self;
    [self presentViewController:rt animated:YES completion:^{
    }];

}


-(void)start_add_dev
{
    new_devuser=@"admin";
    view_spinner.hidden=false;
    
    [self.view bringSubviewToFront:view_spinner];
    label_spinner_hint.text=[NSString stringWithFormat:@"%@......",NSLocalizedString(@"m_adding_dev", @"")];
    //goe_Http.cli_devconnect_single_delegate=self;
    if (bRemoteBind==true) {
        h_connector=[goe_Http cli_lib_createconnect:new_devid devuser:new_devuser devpass:new_devpass tag:@"viewcontroller_adddev"];
    }
    else{
        h_connector=[goe_Http cli_lib_createconnect_ip:new_devip devuser:new_devuser devpass:new_devpass];
    }
}

- (IBAction)button_add_dev_ensure:(id)sender
{


    
    [tv_devname_v1 resignFirstResponder];
    [tv_devid_v1 resignFirstResponder];
    [tv_devpass_v1 resignFirstResponder];
    new_devid=[tv_devid_v1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (new_devid==nil||[new_devid isEqualToString:@""]) {
        [OMGToast showWithText:NSLocalizedString(@"m_devid_isnull", @"")];
        return;
    }
    new_devname=[tv_devname_v1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (new_devname==nil || new_devname.length<=0) {
        new_devname=new_devid;
    }
    new_devpass=[tv_devpass_v1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (new_devpass==nil) {
        new_devpass=@"";
    }
    if (new_devuser==nil || new_devuser.length<=0) {
        new_devuser=@"admin";
    }
    
   //goe_Http.cli_devconnect_single_delegate=self;
    view_spinner.hidden=false;
    [self.view bringSubviewToFront:view_spinner];
    label_spinner_hint.text=[NSString stringWithFormat:@"%@......",NSLocalizedString(@"m_adding_dev", @"")];
    if (bRemoteBind==true) {
        h_connector=[goe_Http cli_lib_createconnect:new_devid devuser:new_devuser devpass:new_devpass tag:@"viewcontroller_adddev"];
    }
    else{
        h_connector=[goe_Http cli_lib_createconnect_ip:new_devip devuser:new_devuser devpass:new_devpass];
    }
}

- (IBAction)button_wifiqrcode_click:(id)sender {
    view_wifi_qrcode.hidden=false;
    wireless_ssid=[self getDeviceSSID];
    label_view1_ssid.text=wireless_ssid;
    tv_view1_ssidpass.text=@"";
    view1_wifi_qrcode_wifiinfo.hidden=false;
    [view_wifi_qrcode bringSubviewToFront:view1_wifi_qrcode_wifiinfo];
    [self.view bringSubviewToFront:view_wifi_qrcode];
}
- (IBAction)button_qrcodewifi_return_click:(id)sender {
    view_wifi_qrcode.hidden=true;
    
}
- (IBAction)button_qrcodewifi_view1_nextstep:(id)sender {
    [tv_view1_ssidpass resignFirstResponder];
    
    wireless_ssid=label_view1_ssid.text;
    wireless_pass=tv_view1_ssidpass.text;
    if (wireless_ssid==nil)
    {
        wireless_pass=@"";
    }
    NSString* m_wifiqrcode_info=@"";
    
    
    m_wifiqrcode_info= [NSString stringWithFormat:@"%@`|%@",wireless_ssid,wireless_pass];//[goe_Http cli_lib_getwifi_qrcode:wireless_ssid ssidpass:wireless_pass lang:MyShareData.m_language];
    if (m_wifiqrcode_info==nil) {
        [OMGToast showWithText:NSLocalizedString(@"m_qrcode_info_fail", @"")];
        return;
    }
    //NSLog(@"m_wifi_info=%@",m_wifiqrcode_info);
    is_in_qrcode_ui=true;
    img_view2_qrcode.image = [QRCodeGenerator qrImageForString:m_wifiqrcode_info imageSize:img_view2_qrcode.bounds.size.width];
    view_wifi_qrcode_create.hidden=false;
    
    [[UIScreen mainScreen] setBrightness:0.25];
    
    [self.view_wifi_qrcode bringSubviewToFront:view_wifi_qrcode_create];
   
}
- (IBAction)button_sqcodewifi_view1_skip:(id)sender {
    [tv_view1_ssidpass resignFirstResponder];
    
    NSString* m_wifiqrcode_info=@"";
    
    
    //m_wifiqrcode_info=[goe_Http cli_lib_getwifi_qrcode:@"" ssidpass:@"" lang:MyShareData.m_language];
    m_wifiqrcode_info= [NSString stringWithFormat:@"%@`|%@",wireless_ssid,wireless_pass];
    if (m_wifiqrcode_info==nil) {
        [OMGToast showWithText:NSLocalizedString(@"m_qrcode_info_fail", @"")];
        return;
    }
    //NSLog(@"m_wifi_info=%@",m_wifiqrcode_info);
    is_in_qrcode_ui=true;
    img_view2_qrcode.image = [QRCodeGenerator qrImageForString:m_wifiqrcode_info imageSize:img_view2_qrcode.bounds.size.width];
    view_wifi_qrcode_create.hidden=false;
    [[UIScreen mainScreen] setBrightness:0.25];
    [self.view_wifi_qrcode bringSubviewToFront:view_wifi_qrcode_create];
}
- (IBAction)button_qrcodewifi_view2_return_click:(id)sender {
    is_in_qrcode_ui=false;
    view_wifi_qrcode_create.hidden=true;
    [[UIScreen mainScreen] setBrightness:m_src_screen_bright];
}

- (void) ensure_dev_online {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"m_ensure_devonline", @"") preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    _okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"m_ensure", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (bSearching==true) {
            return;
        }
        [self start_search_dev];
    }];
    _cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"m_cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:_okAction];
    [alert addAction:_cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
- (IBAction)button_qrcodewifi_tosearch_click:(id)sender {
    [self ensure_dev_online];
    /*
     if (bSearching==true) {
     return;
     }
     [self start_search_dev];
     */
}


- (IBAction)button_devs_return_click:(id)sender {
    view_devs.hidden=true;
}

- (IBAction)button_add_fail_click:(id)sender {
    view_add_fail.hidden=true;
}



- (IBAction)button_wireless_set_return_click:(id)sender {
    m_ui_mode=0;
    view_set_wireless.hidden=true;
}

- (IBAction)button_wireless_set_next_click:(id)sender {
    [text_wireless_pass resignFirstResponder];
    
    wireless_ssid=lable_wireless_name.text;
    wireless_pass=text_wireless_pass.text;
    if (wireless_ssid==nil)
    {
        wireless_pass=@"";
    }
    
    [m_search_list removeAllObjects];
    
    
}


- (IBAction)button_ap_mode_click:(id)sender {
    bToMainVIew=false;
    destview_apmode=[[ViewController_apmode alloc]initWithNibName:@"ViewController_apmode" bundle:nil];
    destview_apmode.delegate=self;
    [self presentViewController:destview_apmode animated:YES completion:nil];
}




-(BOOL)is_dev_exist:(NSString*)devid
{
    if (devid==nil) {
        return true;
    }
    for(item_search* cur_item in m_search_list)
    {
        if ([cur_item.m_devid isEqualToString:devid]==true) {
            return true;
        }
    }
    return false;
}
-(void)process_result:(cam_list_manager_req*)req
{
    if (res_type==0) {
        if (m_ui_mode==0) {
            NSString* strdevid=@"";
            NSString* strdevip=@"";
           

            NSError* reserr;
            NSMutableDictionary* devlist_dictionary = [NSJSONSerialization JSONObjectWithData:req.data_tag1 options:NSJSONReadingMutableContainers error:&reserr];
            if (devlist_dictionary!=nil) {
                for (NSDictionary* dic in [devlist_dictionary objectForKey:@"devices"]) {
                    strdevid=[dic objectForKey:@"dev_id"];
                    strdevip=[dic objectForKey:@"ip"];
                    if([self is_dev_exist:strdevid]==true)
                        continue;
                    item_search* cur_item= [item_search new];
                    cur_item.m_devid = strdevid;
                    cur_item.m_ip = strdevip;
                    cur_item.m_exist=[m_cams_manager is_dev_exist:cur_item.m_devid];
                    [m_search_list addObject:cur_item];
                }
            }
            if (m_search_count>=3) {
                if (is_in_qrcode_ui==true) {
                    is_in_qrcode_ui=false;
                    view_wifi_qrcode_create.hidden=true;
                    [[UIScreen mainScreen] setBrightness:m_src_screen_bright];
                    view_wifi_qrcode.hidden=true;
                }
                
                view_spinner.hidden=true;
                view_devs.hidden=false;
                [tablevew_devs reloadData];
                [self.view bringSubviewToFront:view_devs];
                bSearching=false;
            }
            else{
                [goe_Http cli_lib_start_search];
            }
            
        }
    }
}
-(void)cli_lib_vv_search_callback:(NSData*)searchdata
{
    m_search_count++;
    [goe_Http cli_lib_stop_search];
    res_type=0;
    cam_list_manager_req* cur_req=[cam_list_manager_req alloc];
    cur_req.data_tag1=searchdata;
    //NSString *aString = [[NSString alloc] initWithData:searchdata encoding:NSUTF8StringEncoding];
    //NSLog(@"camdata=%@",aString);
    [self performSelectorOnMainThread:@selector(process_result:) withObject:cur_req waitUntilDone:YES];
}

-(void)cli_lib_getdevinfo_callback:(int)result with_data:(NSData*)jsondata
{
    //NSLog(@"cli_lib_getdevinfo_callback, result=%d",result);
    if (h_connector>0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    add_dev_result_code=result;
    cam_list_manager_req* cur_req=[cam_list_manager_req alloc];
    cur_req.int_tag1=result;
    cur_req.data_tag1=jsondata;
    [self performSelectorOnMainThread:@selector(process_getdevinfodev_result:) withObject:cur_req waitUntilDone:YES];
}
-(void) ViewController_apmode_quit
{
    destview_apmode.delegate=nil;
    destview_apmode=nil;
    bToMainVIew=true;
    pauseTimer= [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(quit_viewController) userInfo:nil repeats:NO];
   // [self performSelectorOnMainThread:@selector(quit_viewController) withObject:nil waitUntilDone:YES];

}
-(void)quit_viewController
{
    NSLog(@"viewcontroller_adddev  quit_viewController......");
    
    goe_Http.cli_devconnect_single_delegate=nil;
    goe_Http.cli_devadd_delegate=nil;
    goe_Http.cli_c2s_sharecams_delegate=nil;
    goe_Http.cli_c2s_push_msg_ex_delegate=nil;
    if ([pauseTimer isValid]==true) {
        [pauseTimer invalidate];
    }
    
    if (h_connector>0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (bToMainVIew==true) {
        bToMainVIew=false;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_to_main" object:self];
    }
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
        
    }];
}
-(BOOL)set_dev_exist_flag:(NSString*)devid
{
    if (devid==nil) {
        return false;
    }
    for(item_search* cur_item in m_search_list)
    {
        if ([cur_item.m_devid isEqualToString:devid]==true) {
            cur_item.m_exist=true;
            return true;
        }
    }
    return false;
}
-(void)process_adddev_result
{
    view_spinner.hidden=true;
    //goe_Http.cli_devconnect_single_delegate=nil;
    if(add_dev_result_code==200){
        if (m_ui_mode==0) {
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"add_dev_ok" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_to_main" object:self];
            pauseTimer= [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(quit_viewController) userInfo:nil repeats:NO];
        }
        
        return;
    }
    NSString* strmsg_code=[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_err_code", @""),add_dev_result_code];
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
    if (m_ui_mode==0) {
        view_add_fail.hidden=false;
        [self.view bringSubviewToFront:view_add_fail];
        label_err_reason.text=msg;
        label_err_code.text=strmsg_code;
    }
    
}

-(void)process_getdevinfodev_result:(cam_list_manager_req*)req
{
    
    
    if (req.int_tag1==200) {
       
        if (h_connector!=0) {
            [goe_Http cli_lib_releaseconnect:h_connector];
            h_connector=0;
        }
        
        [m_cams_manager add_dev:req.data_tag1 with_user:new_devuser with_pass:new_devpass with_name:new_devname];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"add_dev_ok" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_to_main" object:self];
        pauseTimer= [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(quit_viewController) userInfo:nil repeats:NO];
        return;
    }
    view_spinner.hidden=true;
    NSString* strmsg_code=[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_adding_dev_fail", @""),add_dev_result_code];
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
    view_add_fail.hidden=false;
    [self.view bringSubviewToFront:view_add_fail];
    label_err_reason.text=msg;
    label_err_code.text=strmsg_code;
    
}





-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
{
    NSLog(@"adddevviewcontroller, cli_lib_devconnect_CALLBACK,  res=%d",res);
    
    if (h_connector!=0 && h_connector!=connector) {
        return;
    }
    if (res==1) {
         m_bind_sess=[self stringWithUUID];
        if (h_connector==0) {
            if (connector<0) {
                add_dev_result_code=414;
                if (connector!=0) {
                    [goe_Http cli_lib_releaseconnect:connector];
                    h_connector=0;
                }
                [self performSelectorOnMainThread:@selector(process_adddev_result) withObject:nil waitUntilDone:YES];
                return;
            }
            h_connector=connector;
        }
         [goe_Http cli_lib_get_devinfo:h_connector with_usr:new_devuser with_pass:new_devpass with_sess:m_bind_sess with_type:0 tag:new_devid];
         //[goe_Http cli_lib_bind_lang:h_connector devname:new_devname devusr:new_devuser devpass:new_devpass bind_sess:m_bind_sess lang:MyShareData.m_language];
        
    }
    else{
        add_dev_result_code=-98;
        if (connector!=0) {
            [goe_Http cli_lib_releaseconnect:connector];
            h_connector=0;
        }
        [self performSelectorOnMainThread:@selector(process_adddev_result) withObject:nil waitUntilDone:YES];
    }
    
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
