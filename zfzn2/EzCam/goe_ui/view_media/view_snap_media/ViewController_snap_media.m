//
//  ViewController_snap_media.m
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "ViewController_snap_media.h"
#include "sys/stat.h"
@interface ViewController_snap_media ()

@end

@implementation ViewController_snap_media
@synthesize view_main_pic;
@synthesize view_top_pic;
@synthesize button_return_pic;
@synthesize label_title_pic;
@synthesize button_pic_video;
@synthesize tableview_pic;

@synthesize view_main_local;
@synthesize view_folder;
@synthesize view_folder_top;
@synthesize button_return_folder;
@synthesize label_title_folder;
@synthesize view_pic_folder;
@synthesize label_pic_folder_title;
@synthesize img_pic_folder;
@synthesize button_pic_folder_bg;
@synthesize view_video_folder;
@synthesize label_video_folder_title;
@synthesize img_video_folder;
@synthesize button_video_folder_bg;
@synthesize view_record_folder;
@synthesize label_record_folder_title;
@synthesize img_record_folder;
@synthesize button_record_folder_bg;

@synthesize view_pic;
@synthesize mode_pic_tool;
@synthesize mode_pic_label;
@synthesize mode_pic_button_edit;
@synthesize mode_pic_button_delete;
@synthesize mode_pic_button_return;
@synthesize m_pic_tableview;

@synthesize view_video;
@synthesize mode_video_tool;
@synthesize mode_video_label;
@synthesize mode_video_button_edit;
@synthesize mode_video_button_delete;
@synthesize mode_video_button_return;
@synthesize m_video_tableview;


@synthesize view_spinner_bg;
@synthesize m_spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_video_cur_mode=0;
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    goe_Http=[ppview_cli getInstance];
    m_snap_manager= [zx_snap_manager getInstance];
    m_share_item=[share_item getInstance];
    m_file_manager=[pic_file_manager getInstance];
    m_file_array=[NSMutableArray new];
    m_folder_pic_array=[NSMutableArray new];
    m_folder_video_array=[NSMutableArray new];
    m_file_delete_array=[NSMutableArray new];
    m_pic_manager=[pic_cache_list_manager getInstance];
    m_photo_manager=[gallery_photo_manager getInstance];
    
    m_width=MyShareData.screen_width;
    m_height=MyShareData.screen_height-MyShareData.status_bar_height-MyShareData.screen_y_offset;
    m_y_offset=MyShareData.screen_y_offset;
    view_main_pic.frame=CGRectMake(0, m_y_offset, m_width, m_height);
    view_main_pic.backgroundColor=UIColorFromRGB(m_strings.background_gray);
    
    view_spinner_bg.frame=CGRectMake(0, m_y_offset+44, m_width, m_height-44);
    [view_spinner_bg setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    m_spinner.frame=CGRectMake((m_width-37)/2, (m_height-44-37)/2, 37, 37);
    f_view_top_tool_height=44;
    
    view_top_pic.frame=CGRectMake(0, 0, m_width, f_view_top_tool_height);
    [view_top_pic setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    
    button_return_pic.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    button_pic_video.frame=CGRectMake(m_width-f_view_top_tool_height-40-5, 0, f_view_top_tool_height+40, f_view_top_tool_height);
    [button_pic_video setTitle:MYLocalizedString(@"m_capture_video", @"") forState:UIControlStateNormal];
    label_title_pic.frame=CGRectMake(f_view_top_tool_height+60, 0, m_width-(f_view_top_tool_height+60)*2, f_view_top_tool_height);
    label_title_pic.text=MYLocalizedString(@"m_capture_pic", @"");
    tableview_pic.frame=CGRectMake(0, f_view_top_tool_height, m_width, m_height-f_view_top_tool_height);
    
    
    [self draw_view_local];
    
    tableview_pic.delegate=self;
    tableview_pic.dataSource=self;
    m_pic_tableview.uiGridViewDelegate=self;
    m_video_tableview.delegate=self;
    m_video_tableview.dataSource=self;

    b_events_get=false;
    h_connector=0;
    
    if (m_share_item.cur_cam_list_item != nil && m_share_item.cur_cam_list_item.m_state==1) {
        view_spinner_bg.hidden=false;
        [self.view bringSubviewToFront:view_spinner_bg];
        goe_Http.onvif_devconnect_single_delegate=self;
        if(h_connector != 0){
            [goe_Http onvif_lib_releaseconnect:h_connector];
            h_connector=0;
        }
        
        h_connector=[goe_Http onvif_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"ViewController_snap"];
        NSLog(@"h_connector=%ld",h_connector);
    }
     
}
-(void)draw_view_local
{
    view_main_local.frame=CGRectMake(0, m_y_offset, m_width, m_height);
    //view_main_video.backgroundColor=UIColorFromRGB(m_strings.background_gray);
    [self draw_view_folder];
    [self draw_view_pic_list];
    [self draw_view_video_list];
   
}
-(void)draw_view_folder
{
    view_folder.frame=CGRectMake(0, 0, m_width, m_height);
    view_folder_top.frame=CGRectMake(0, 0, m_width, f_view_top_tool_height);
    [view_folder_top setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    button_return_folder.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);    
    label_title_folder.frame=CGRectMake(f_view_top_tool_height, 0, m_width-(f_view_top_tool_height)*2, f_view_top_tool_height);
    label_title_folder.text=MYLocalizedString(@"m_capture_video", @"");
    float f_view_folder_width=60;
    float f_view_folder_height=80;
    float f_label_height=20;
    float f_spacing=20;
    
    view_pic_folder.frame=CGRectMake(f_spacing, f_view_top_tool_height, f_view_folder_width, f_view_folder_height);
    button_pic_folder_bg.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_height);
    img_pic_folder.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_width);
    label_pic_folder_title.frame=CGRectMake(0, f_view_folder_width-10, f_view_folder_width, f_label_height);
    label_pic_folder_title.text=MYLocalizedString(@"m_photo", @"");
    
    view_video_folder.frame=CGRectMake(f_spacing*2+f_view_folder_width, f_view_top_tool_height, f_view_folder_width, f_view_folder_height);
    button_video_folder_bg.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_height);
    img_video_folder.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_width);
    label_video_folder_title.frame=CGRectMake(0, f_view_folder_width-10, f_view_folder_width, f_label_height);
    label_video_folder_title.text=MYLocalizedString(@"m_video", @"");
    
    view_record_folder.frame=CGRectMake(f_spacing*3+f_view_folder_width*2, f_view_top_tool_height, f_view_folder_width, f_view_folder_height);
    button_record_folder_bg.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_height);
    img_record_folder.frame=CGRectMake(0, 0, f_view_folder_width, f_view_folder_width);
    label_record_folder_title.frame=CGRectMake(0, f_view_folder_width-10, f_view_folder_width, f_label_height);
    label_record_folder_title.text=MYLocalizedString(@"m_record_video", @"");
}
-(void)draw_view_pic_list
{
    view_pic.frame=CGRectMake(0, 0, m_width, m_height);
    mode_pic_tool.frame=CGRectMake(0, 0, m_width, f_view_top_tool_height);
    [mode_pic_tool setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    mode_pic_button_return.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    mode_pic_button_delete.frame=CGRectMake(f_view_top_tool_height+5, 0, f_view_top_tool_height, f_view_top_tool_height);
    [mode_pic_button_delete setTitle:MYLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
    mode_pic_button_edit.frame=CGRectMake(m_width-f_view_top_tool_height, 0, f_view_top_tool_height, f_view_top_tool_height);
    [mode_pic_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    mode_pic_label.frame=CGRectMake(f_view_top_tool_height*2+5, 0, m_width-(f_view_top_tool_height*2+5)*2, f_view_top_tool_height);
    mode_pic_label.text=MYLocalizedString(@"m_local_phote", @"");
    m_pic_tableview.frame=CGRectMake(0, f_view_top_tool_height, m_width, m_height-f_view_top_tool_height);
}
-(void)draw_view_video_list
{
    view_video.frame=CGRectMake(0, 0, m_width, m_height);
    mode_video_tool.frame=CGRectMake(0, 0, m_width, f_view_top_tool_height);
    [mode_video_tool setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    mode_video_button_return.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    mode_video_button_delete.frame=CGRectMake(f_view_top_tool_height+5, 0, f_view_top_tool_height, f_view_top_tool_height);
    mode_video_button_edit.frame=CGRectMake(m_width-f_view_top_tool_height, 0, f_view_top_tool_height, f_view_top_tool_height);
    mode_video_label.frame=CGRectMake(f_view_top_tool_height*2+5, 0, m_width-(f_view_top_tool_height*2+5)*2, f_view_top_tool_height);
    mode_video_label.text=MYLocalizedString(@"m_local_video", @"");
    [mode_video_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [mode_video_button_delete setTitle:MYLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
    m_video_tableview.frame=CGRectMake(0, f_view_top_tool_height, m_width, m_height-f_view_top_tool_height);
    
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
    [m_snap_manager clear];
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
- (long long) fileSizeAtPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}
-(void)load_folder_imgs:(NSString*)camid
{
    if (camid==nil) {
        return;
    }
    NSString* pic_path=[[pic_file_manager getInstance] get_local_pic_path];
    NSString* video_path=[[pic_file_manager getInstance] get_local_video_path];
    [m_folder_pic_array removeAllObjects];
    [m_folder_video_array removeAllObjects];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    if (pic_path != nil) {
        NSArray *tempArray = [fileMgr subpathsOfDirectoryAtPath: pic_path error:nil];
        BOOL isfolder=false;
        for (NSString* fileName in tempArray)
        {
            //NSLog(@"load_folder_imgs, fileName=%@",fileName);
            NSRange range = [fileName rangeOfString:camid];//判断字符串是否包含
            
            //if (range.location ==NSNotFound)//不包含
            if (range.length >0)//包含
            {
                NSString* full_filename=[pic_path stringByAppendingPathComponent:fileName];
                if ([fileMgr fileExistsAtPath:full_filename isDirectory:&isfolder])
                {
                    if (isfolder==false)
                    {
                        foler_item* cur_item=[foler_item new];
                        cur_item.m_absolute_name=fileName;
                        cur_item.m_full_name=full_filename;
                        [m_folder_pic_array addObject:cur_item];
                    }
                }
                
            }
            else//不包含
            {
                continue;
            }
        }
    }
    if (video_path != nil) {
        NSArray *tempArray = [fileMgr subpathsOfDirectoryAtPath: video_path error:nil];
        BOOL isfolder=false;
        for (NSString* fileName in tempArray)
        {
           // NSLog(@"load_folder_imgs, fileName=%@",fileName);
            NSString* full_filename=[video_path stringByAppendingPathComponent:fileName];
            NSRange range = [fileName rangeOfString:camid];//判断字符串是否包含
            long long nseize=[self fileSizeAtPath:full_filename];
            //NSLog(@"%@====>%lld",fileName,nseize);
            //if (range.location ==NSNotFound)//不包含
            if (range.length >0)//包含
            {
                
                if ([fileMgr fileExistsAtPath:full_filename isDirectory:&isfolder])
                {
                    if (isfolder==false)
                    {
                        if ([fileName hasSuffix:@".vvi"]==true) {
                            
                            foler_item* cur_item=[foler_item new];
                            cur_item.m_absolute_name=fileName;
                            cur_item.m_full_name=full_filename;
                            [m_folder_video_array addObject:cur_item];
                        }
                       
                    }
                }
                
            }
            else//不包含
            {
                continue;
            }
        }
    }
}
- (IBAction)button_display_video_click:(id)sender {
    
    [self load_folder_imgs:m_share_item.cur_cam_list_item.m_item_id];
    [m_pic_tableview reloadData];
    [m_video_tableview reloadData];
    view_main_local.hidden=false;
    [self.view bringSubviewToFront:view_main_local];
}

- (IBAction)button_local_return:(id)sender {
    view_main_local.hidden=true;
}

- (IBAction)button_folder_pic_click:(id)sender {
    //NSLog(@"button_folder_pic_click.....");
    view_pic.hidden=false;
    [view_main_local bringSubviewToFront:view_pic];
}

- (IBAction)button_folder_video_click:(id)sender {
    //NSLog(@"button_folder_video_click.....");
    view_video.hidden=false;
    [view_main_local bringSubviewToFront:view_video];
}

-(void)start_playback
{
    if (m_share_item.cur_cam_list_item.m_state!=1)
        return;
    zxy_playbackViewController* destview=nil;
    if(MyShareData.screen_width==320&& MyShareData.screen_height==480)
        destview = [[zxy_playbackViewController alloc]initWithNibName:@"zxy_playbackViewController" bundle:nil];
    else
        destview = [[zxy_playbackViewController alloc]initWithNibName:@"zxy_playbackViewController_4" bundle:nil];
    [self presentViewController:destview animated:YES completion:nil];
}
- (IBAction)button_folder_record_click:(id)sender {
    [self start_playback];
}

- (IBAction)button_view_pic_return_click:(id)sender {
    view_pic.hidden=true;
}

- (IBAction)mode_file_button_edit_click:(id)sender {
    for (foler_item* item in m_folder_pic_array)
    {
        item.b_selected=false;
    }
    [m_file_delete_array removeAllObjects];
    if (m_pic_cur_mode==0) {
        
        m_pic_cur_mode=1;
        mode_pic_button_delete.hidden=false;
        mode_pic_button_delete.enabled=false;
        [mode_pic_button_edit setTitle:MYLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
        [mode_pic_label setText:MYLocalizedString(@"m_select_picture", @"")];
    }
    else{
        m_pic_cur_mode=0;
        mode_pic_button_delete.hidden=true;
        [mode_pic_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
        [mode_pic_label setText:MYLocalizedString(@"m_view_picture", @"")];
    }
    [m_pic_tableview reloadData];
}

- (IBAction)mode_file_button_delete_click:(id)sender {
    for (foler_item* item in m_file_delete_array)
    {
        if (item.b_selected==true) {
            NSString* curpath=item.m_full_name;
            [m_file_manager delete_folder:curpath];
        }
        
    }
    [m_folder_pic_array removeObjectsInArray:m_file_delete_array];
    m_pic_cur_mode=0;
    mode_pic_button_delete.hidden=true;
    [mode_pic_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [m_pic_tableview reloadData];
}


- (IBAction)button_view_video_return_click:(id)sender
{
    view_video.hidden=true;
}
- (IBAction)mode_video_button_edit_click:(id)sender
{
    for (foler_item* item in m_folder_video_array)
    {
        item.b_selected=false;
    }
    [m_file_delete_array removeAllObjects];
    if (m_video_cur_mode==0) {
        
        m_video_cur_mode=1;
        mode_video_button_delete.hidden=false;
        mode_video_button_delete.enabled=false;
        [mode_video_button_edit setTitle:MYLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
        [mode_video_label setText:MYLocalizedString(@"m_select_video", @"")];
    }
    else{
        m_video_cur_mode=0;
        mode_video_button_delete.hidden=true;
        [mode_video_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
        [m_video_tableview reloadData];
        [mode_video_label setText:MYLocalizedString(@"m_local_video", @"")];
    }
    [m_video_tableview reloadData];
}
- (IBAction)mode_video_button_delete_click:(id)sender
{
    for (foler_item* item in m_file_delete_array)
    {
        if (item.b_selected==true) {
            NSString* curpath=item.m_full_name;
            [m_file_manager delete_folder:curpath];
            NSString* curpath_thumbil=[curpath stringByReplacingOccurrencesOfString:@".vvi" withString:@".jpg"];
            [m_file_manager delete_folder:curpath_thumbil];
        }
        
    }
    [m_folder_video_array removeObjectsInArray:m_file_delete_array];
    m_video_cur_mode=0;
    mode_video_button_delete.hidden=true;
    [mode_video_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [mode_video_label setText:MYLocalizedString(@"m_local_video", @"")];
    [m_video_tableview reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellheight = 44;
    if (tableview_pic==tableView) {
        cellheight=44;
    }
    else if(m_video_tableview==tableView){
        cellheight=62;
    }
    return cellheight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (tableview_pic==tableView) {
        count=[m_snap_manager getCount_pic];
    }
    else if(m_video_tableview==tableView){
        count=[m_folder_video_array count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier0 = @"TableViewCell_pic_day";
    static NSString *CellIdentifier1 = @"TableViewCell_pic_info";
    static NSString *CellIdentifier2 = @"TableViewCell_localvideo";
    if (tableview_pic==tableView)
    {
        zx_alarm_item* cur_item=[m_snap_manager getItem_pic:indexPath.row];
        if (cur_item.m_item_type==0) {
            TableViewCell_pic_day* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_day" owner:self options:nil] lastObject];
            }
            [Cell config_cell:cur_item.m_eventid with_tag:cur_item.m_eventid with_pos:indexPath.row expand:cur_item.m_bexpand];
            return Cell;
        }
        else{
            TableViewCell_pic_info* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (Cell==nil) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_pic_info" owner:self options:nil] lastObject];
            }
            
            [Cell config_cell_pic:cur_item.m_time type:cur_item.m_title num:cur_item.m_pic_num with_tag:cur_item.m_eventid with_pos:indexPath.row];
            return Cell;
        }
        
    }
    else if(m_video_tableview==tableView){
        foler_item* cur_item= [m_folder_video_array objectAtIndex:indexPath.row];
        TableViewCell_localvideo* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (Cell==nil) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_localvideo" owner:self options:nil] lastObject];
        }
        NSString* str_date=@"";
        NSString* str_time=@"";
        if (cur_item != nil && cur_item.m_absolute_name!=nil) {
            NSArray *str_array = [cur_item.m_absolute_name componentsSeparatedByString:@"_"];
            if (str_array != nil && str_array.count>=1) {
                NSString* str_date_time=[str_array objectAtIndex:1];
                if (str_date_time!=nil && str_date_time.length==18) {
                    NSRange range_year = NSMakeRange(0, 4);
                    NSRange range_month = NSMakeRange(4, 2);
                    NSRange range_day = NSMakeRange(6, 2);
                    NSRange range_hour = NSMakeRange(8, 2);
                    NSRange range_min = NSMakeRange(10, 2);
                    NSRange range_sec = NSMakeRange(12, 2);
                    NSString* str_year=[str_date_time substringWithRange:range_year];
                    NSString* str_month=[str_date_time substringWithRange:range_month];
                    NSString* str_day=[str_date_time substringWithRange:range_day];
                    NSString* str_hour=[str_date_time substringWithRange:range_hour];
                    NSString* str_min=[str_date_time substringWithRange:range_min];
                    NSString* str_sec=[str_date_time substringWithRange:range_sec];
                    str_date=[NSString stringWithFormat:@"%@-%@-%@",str_year,str_month,str_day];
                    str_time=[NSString stringWithFormat:@"%@:%@:%@",str_hour,str_min,str_sec];
                }
                
            }

        }
        
        //TEST-XRKJ-20140115006-0_2015.02.06-16:49:47.jpg
        NSString * filename = [cur_item.m_full_name stringByReplacingOccurrencesOfString:@".vvi" withString:@".jpg"];
        [Cell config_cell:str_date time:str_time thumbil_file:filename mode:m_video_cur_mode selected:cur_item.b_selected with_tag:nil with_pos:indexPath.row];
        Cell.delegate=self;
        return Cell;
    }
    else
        return nil;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (m_video_tableview==tableView) {
        return  nil;
    }
    return indexPath;
}

-(BOOL)on_cell_localvideo_click:(int)pos cell:(id)cell
{
    foler_item* cur_item=[m_folder_video_array objectAtIndex:pos];
    if (m_video_cur_mode==0){
        m_share_item.cur_foler_item=cur_item;
        ViewController_playback_local* destview=nil;
        destview = [[ViewController_playback_local alloc]initWithNibName:@"ViewController_playback_local" bundle:nil];
        [self presentViewController:destview animated:YES completion:nil];
    }
    else if (m_video_cur_mode==1){
        
        if (cur_item==nil) {
            return false;
        }
        cur_item.b_selected=!cur_item.b_selected;
        TableViewCell_localvideo* my_cell=(TableViewCell_localvideo*)cell;
        if (cur_item.b_selected==true) {
            my_cell.img_right.image=[UIImage imageNamed:@"check_box_yes.png"];
            [m_file_delete_array addObject:cur_item];
        }
        else{
            my_cell.img_right.image=[UIImage imageNamed:@"checkbox_no.png"];
            [m_file_delete_array removeObject:cur_item];
        }
        if ([m_file_delete_array count]<=0) {
            [mode_video_button_delete setEnabled:false];
        }
        else{
            [mode_video_button_delete setEnabled:true];
        }
        [mode_video_label setText:[NSString stringWithFormat:@"%@(%d)",MYLocalizedString(@"m_selected_num", @""),m_file_delete_array.count]];
    }
    return true;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableview_pic==tableView){
        zx_alarm_item* cur_item=[m_snap_manager getItem_pic:indexPath.row];
        if (cur_item==nil) {
            return;
        }
        if (cur_item.m_item_type==0) {
            [m_snap_manager set_pic_expand_state:cur_item.m_eventid pos:indexPath.row with_state:!cur_item.m_bexpand];
            [tableview_pic reloadData];
        }
        else{
            int res= [m_photo_manager set_info:m_share_item.cur_cam_list_item.m_item_id eventid:cur_item.m_eventid num:cur_item.m_pic_num type:0 connector:h_connector];
            if (res==1) {
                ViewController_gallery *m_Gallery  = [[ViewController_gallery alloc]initWithNibName:@"ViewController_gallery" bundle:nil];
                [self.navigationController pushViewController:m_Gallery animated:NO];
                m_Gallery=nil;
            }
            else
                return;
        }
    }
}



- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return m_width/3;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{

    return 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 3;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return [m_folder_pic_array count];
    
}
- (UIImage *)thumbnailWithImage:(UIImage *)image with_size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
   
        int pos=rowIndex*3+columnIndex;
        
        foler_item* cur_item= [m_folder_pic_array objectAtIndex:pos];
        item_file_cell *cell = (item_file_cell *)[grid dequeueReusableCell];
        
        if (cell == nil) {
            cell = [[item_file_cell alloc]init:320/3 with_heigth:80];
        }
        
        //cell.cell_title.text = [NSString stringWithFormat:@"(%d,%d)", rowIndex, columnIndex];
        UIImage* src_img=[UIImage imageWithContentsOfFile:cur_item.m_full_name];
        UIImage* new_img=[self thumbnailWithImage:src_img with_size:CGSizeMake(80, 60)];
        src_img=nil;
        [cell.cell_img setImage:new_img];
        if (m_pic_cur_mode==0) {
            cell.cell_img_ok.hidden=true;
        }
        else if(m_pic_cur_mode==1){
            if (cur_item.b_selected==true) {
                cell.cell_img_ok.hidden=false;
            }
        }
        return cell;
    
}

//- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex with_cell:(UIGridViewCell*)cell
{
    //NSLog(@"%d, %d clicked", rowIndex, colIndex);
    int pos=rowIndex*3+colIndex;    
    if (m_pic_cur_mode==0){
        int res= [m_photo_manager set_local_array:m_folder_pic_array start_index:pos];
        if (res==1) {
            ViewController_gallery *m_Gallery  = [[ViewController_gallery alloc]initWithNibName:@"ViewController_gallery" bundle:nil];
            [self.navigationController pushViewController:m_Gallery animated:NO];
            m_Gallery=nil;
        }
        else
            return;
    }
    else if (m_pic_cur_mode==1){
        foler_item* cur_item=[m_folder_pic_array objectAtIndex:pos];
        if (cur_item==nil) {
            return;
        }
        cur_item.b_selected=!cur_item.b_selected;
        item_file_cell* my_cell=(item_file_cell*)cell;
        if (cur_item.b_selected==true) {
            my_cell.cell_img_ok.hidden=false;
            [m_file_delete_array addObject:cur_item];
        }
        else{
            my_cell.cell_img_ok.hidden=true;
            [m_file_delete_array removeObject:cur_item];
        }
        if ([m_file_delete_array count]<=0) {
            [mode_pic_button_delete setEnabled:false];
        }
        else{
                [mode_pic_button_delete setEnabled:true];
        }
        
        [mode_pic_label setText:[NSString stringWithFormat:@"%@(%d)",MYLocalizedString(@"m_selected_num", @""),(int)m_file_delete_array.count]];
    }

}
////////////////////////////


-(void)on_events_get_mainthread:(vv_req_info *)req
{
    view_spinner_bg.hidden=true;
    if (req.int_tag1==200) {
        b_events_get=true;
        //NSString *aString = [[NSString alloc] initWithData:req.data_tag1 encoding:NSUTF8StringEncoding];
        //NSLog(@"on_events_get_mainthread=%@",aString);
        
        if ([m_snap_manager setJsonData:req.data_tag1]==true) {
            [tableview_pic reloadData];
            
        }
        
    }
    else{
        b_events_get=false;
        //[OMGToast showWithText:[self get_err_msg:req.int_tag1 type:0]];
    }
}
-(void)onvif_lib_arm_events_get_callback:(int)res type:(int)type data:(NSData*)data
{
    //NSLog(@"onvif_lib_arm_events_get_callback, res=%d",res);
    vv_req_info* cur_req= [vv_req_info new];
    cur_req.int_tag1=res;
    cur_req.data_tag1=data;
    [self performSelectorOnMainThread:@selector(on_events_get_mainthread:) withObject:cur_req waitUntilDone:YES];
}
-(void)Onvif_lib_devconnect_CALLBACK:(int)msg_id connector:(int)connector result:(int)res
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
            goe_Http.onvif_c2s_arm_events_delegate=self;
            [goe_Http onvif_lib_get_events:h_connector chanid:m_share_item.cur_cam_list_item.m_chlid type:0];
        }
    }
    else{
        m_connect_state=-1;
        [goe_Http onvif_lib_releaseconnect:connector];
        h_connector=0;
        h_connector=[goe_Http onvif_lib_createconnect:m_share_item.cur_cam_list_item.m_devid devuser:m_share_item.cur_cam_list_item.m_dev_user devpass:m_share_item.cur_cam_list_item.m_dev_pass tag:@"ViewController_snap"];
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
