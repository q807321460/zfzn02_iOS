//
//  ViewController_alarm_media.m
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "ViewController_alarm_media.h"

@interface ViewController_alarm_media ()

@end

@implementation ViewController_alarm_media
@synthesize view_main_pic;
@synthesize view_top_pic;
@synthesize button_return_pic;
@synthesize label_title_pic;
@synthesize button_pic_video;
@synthesize tableview_pic;

@synthesize view_main_video;
@synthesize view_top_video;
@synthesize button_return_video;
@synthesize label_title_video;
@synthesize tableview_video;
///Users/yy/Desktop/ZaoFengZhiNeng/zfzn2/zfzn2/EzCam/goe_ui/view_media/view_alarm_media/ViewController_alarm_media.m:28:13: Property implementation must have its declaration in interface 'ViewController_alarm_media' or one of its extensions
@synthesize button_video_pic;

@synthesize view_spinner_bg;
@synthesize m_spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    goe_Http=[ppview_cli getInstance];
    m_alarm_manager= [zx_alarm_manager getInstance];
    m_share_item=[share_item getInstance];
    m_file_array=[NSMutableArray new];
    //m_pic_manager=[pic_cache_list_manager getInstance];
    m_photo_manager=[gallery_photo_manager getInstance];
    
    
    //view_main_pic.backgroundColor=UIColorFromRGB(m_strings.background_gray);
    
    
    [view_spinner_bg setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    
    //[view_top_pic setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    
    
    [button_pic_video setTitle:NSLocalizedString(@"m_alarm_video", @"") forState:UIControlStateNormal];
    
    [button_return_pic setTitle:NSLocalizedString(@"m_alarm_pic", @"") forState:UIControlStateNormal];
    label_title_pic.text=NSLocalizedString(@"m_alarm_pic", @"");
    
    
    
    
    //view_main_video.backgroundColor=UIColorFromRGB(m_strings.background_gray);
    
    //[view_top_video setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    
    label_title_video.text=NSLocalizedString(@"m_alarm_video", @"");
    
    tableview_pic.delegate=self;
    tableview_pic.dataSource=self;
    tableview_video.delegate=self;
    tableview_video.dataSource=self;
    
    b_events_get=false;
    if (m_share_item.cur_cam_list_item != nil) {
        view_spinner_bg.hidden=false;
        [self.view bringSubviewToFront:view_spinner_bg];
        goe_Http.cli_devconnect_single_delegate=self;
        if(h_connector != 0){
            [goe_Http cli_lib_releaseconnect:h_connector];
            h_connector=0;
        }
        
        h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"ViewController_alarm_media"];
        NSLog(@"h_connector=%ld",h_connector);
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
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
-(void)quit_me
{
    [m_file_array removeAllObjects];
    [m_alarm_manager clear];
    goe_Http.cli_devconnect_single_delegate=nil;
    goe_Http.cli_c2s_arm_events_delegate=nil;
    if (h_connector !=0) {
        [goe_Http cli_lib_releaseconnect:h_connector];
        h_connector=0;
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)button_return_click:(id)sender {
    [self quit_me];
}

- (IBAction)button_display_video_click:(id)sender {
    [self.view bringSubviewToFront:view_main_video];
}

- (IBAction)button_video_return:(id)sender {
    [self.view bringSubviewToFront:view_main_pic];
}

- (IBAction)button_display_pic_click:(id)sender {
    [self.view bringSubviewToFront:view_main_pic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellheight = 44;
    if (tableview_pic==tableView) {
        cellheight=44;
    }
    else if(tableview_video==tableView){
        cellheight=44;
    }
    return cellheight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (tableview_pic==tableView) {
        count=[m_alarm_manager getCount_pic];
    }
    else if(tableview_video==tableView){
        count=[m_alarm_manager getCount_video];
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"view_camera,  cellForRowAtIndexPath**************************");
    static NSString *CellIdentifier0 = @"TableViewCell_pic_day";
    static NSString *CellIdentifier1 = @"TableViewCell_pic_info";
    if (tableview_pic==tableView)
    {
        zx_alarm_item* cur_item=[m_alarm_manager getItem_pic:(int)indexPath.row];
        if (cur_item.m_item_type==0) {
            TableViewCell_pic_day* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_day" owner:self options:nil] lastObject];
            }
            [Cell config_cell:cur_item.m_eventid with_tag:cur_item.m_eventid with_pos:(int)indexPath.row expand:cur_item.m_bexpand];
            return Cell;
        }
        else{
            TableViewCell_pic_info* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_info" owner:self options:nil] lastObject];
            }
            
            [Cell config_cell_pic:cur_item.m_time type:cur_item.m_title num:cur_item.m_pic_num with_tag:cur_item.m_eventid with_pos:(int)indexPath.row];
            return Cell;
        }
        
    }
    else if(tableview_video==tableView)
    {
        zx_alarm_item* cur_item=[m_alarm_manager getItem_video:(int)indexPath.row];
        if (cur_item.m_item_type==0) {
            TableViewCell_pic_day* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_day" owner:self options:nil] lastObject];
            }
            [Cell config_cell:cur_item.m_eventid with_tag:cur_item.m_eventid with_pos:(int)indexPath.row expand:cur_item.m_bexpand];
            return Cell;
        }
        else{
            TableViewCell_pic_info* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_info" owner:self options:nil] lastObject];
            }
            [Cell config_cell_video:cur_item.m_time type:cur_item.m_title num:cur_item.m_video_long with_tag:cur_item.m_eventid with_pos:(int)indexPath.row];
            return Cell;
        }
    }
    else
        return nil;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableview_video==tableView)
    {
        zx_alarm_item* cur_item=[m_alarm_manager getItem_video:(int)indexPath.row];
        if (cur_item.m_item_type==0) {
            [m_alarm_manager set_video_expand_state:cur_item.m_eventid pos:(int)indexPath.row with_state:!cur_item.m_bexpand];
            [tableview_video reloadData];
        }
        else{
            m_share_item.cur_alarm_item=cur_item;
            if (m_share_item.cur_alarm_item==nil) {
                return;
            }
            if ([m_share_item.cur_cam_list_item is_stream_process]==false) {
                [m_share_item.cur_cam_list_item process_stream];
            }
            if (m_share_item.cur_cam_list_item.m_fisheyetype<=0) {
                zxy_playbackViewController_alarm* destview=nil;
                destview = [[zxy_playbackViewController_alarm alloc]initWithNibName:@"zxy_playbackViewController_alarm" bundle:nil];
                [self presentViewController:destview animated:YES completion:nil];
            }
            else{
                zxy_playbackViewController_alarm* destview=nil;
                destview = [[zxy_playbackViewController_alarm alloc]initWithNibName:@"zxy_fish_playbackViewController_alarm" bundle:nil];
                [self presentViewController:destview animated:YES completion:nil];
            }
        }
        
    }
    else if(tableview_pic==tableView){
        zx_alarm_item* cur_item=[m_alarm_manager getItem_pic:(int)indexPath.row];
        if (cur_item==nil) {
            return;
        }
        if (cur_item.m_item_type==0) {
            [m_alarm_manager set_pic_expand_state:cur_item.m_eventid pos:(int)indexPath.row with_state:!cur_item.m_bexpand];
            [tableview_pic reloadData];
        }
        else{
            int res= [m_photo_manager set_info:m_share_item.cur_cam_list_item.m_id eventid:cur_item.m_eventid num:cur_item.m_pic_num type:1 connector:h_connector];
            
            if (res==1) {
                m_share_item.cur_playpic_src=1;
                if ([m_share_item.cur_cam_list_item is_stream_process]==false) {
                    [m_share_item.cur_cam_list_item process_stream];
                }
                cur_item.m_video_fishtype=m_share_item.cur_cam_list_item.m_fisheyetype;
                cur_item.m_video_space_left=m_share_item.cur_cam_list_item.main_stream.m_fish_left;
                cur_item.m_video_space_right=m_share_item.cur_cam_list_item.main_stream.m_fish_right;
                cur_item.m_video_space_top=m_share_item.cur_cam_list_item.main_stream.m_fish_top;
                cur_item.m_video_space_bottom=m_share_item.cur_cam_list_item.main_stream.m_fish_bottom;
                m_share_item.cur_alarm_item=cur_item;
                ViewController_gallery *m_Gallery  = [[ViewController_gallery alloc]initWithNibName:@"ViewController_gallery" bundle:nil];
                [self.navigationController pushViewController:m_Gallery animated:NO];
                m_Gallery=nil;
            }
            else
                return;
            
        }
    }
    
}

////////////////////////////

-(NSString*)get_err_msg:(int)res type:(int)type
{
    
    NSString* msg=@"";
    switch (res) {
        case 203:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"err_203", @""),res];
            break;
        case 204:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sensor_err_204", @""),res];
            break;
        case 205:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sensor_err_205", @""),res];
            break;
        case 404:
            msg=[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sdcard_err_404", @""),res];
            break;
        case 409:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sensor_err_409", @""),res];
            break;
        case 500:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sensor_err_500", @""),res];
            break;
        case 501:
            msg= [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"m_sensor_err_501", @""),res];
            break;
        default:
            msg=[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"err_else", @""),res];
            break;
    }
    return msg;
}
-(void)on_events_get_mainthread:(vv_req_info *)req
{
    view_spinner_bg.hidden=true;
    int res=req.int_tag1;
    if (res==200)
    {
        b_events_get=true;
        //NSString *aString = [[NSString alloc] initWithData:req.data_tag1 encoding:NSUTF8StringEncoding];
        //NSLog(@"on_events_get_mainthread=%@",aString);
        
        if ([m_alarm_manager setJsonData:req.data_tag1]==true) {
            [tableview_pic reloadData];
            [tableview_video reloadData];
        }
    }
    else
    {
        b_events_get=false;
        [OMGToast showWithText:[self get_err_msg:req.int_tag1 type:0]];
    }
}
-(void)cli_lib_arm_events_get_callback:(int)res type:(int)type data:(NSData*)data
{
    NSLog(@"onvif_lib_arm_events_get_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.data_tag1=data;
    [self performSelectorOnMainThread:@selector(on_events_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
{
    NSLog(@"cctv  Onvif_lib_devconnect_CALLBACK_dev, res=%d",res);
    if (h_connector<=0) {
        return;
    }
    if (h_connector != connector) {
        return;
    }
    if (res==1) {
        m_connect_state=1;
        if (b_events_get==false) {
            goe_Http.cli_c2s_arm_events_delegate=self;
            [goe_Http cli_lib_get_events:h_connector chanid:m_share_item.cur_cam_list_item.m_chlid type:1];
        }
    }
    else{
        m_connect_state=-1;
        [goe_Http cli_lib_releaseconnect:connector];
        h_connector=0;
        h_connector=[goe_Http cli_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"ViewController_alarm_media"];
        [m_photo_manager reset_connector:h_connector];
    }
    
}

@end

