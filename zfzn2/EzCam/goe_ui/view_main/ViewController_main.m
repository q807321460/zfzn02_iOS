//
//  ViewController_main.m
//  easycam
//
//  Created by zxy on 2017/8/8.
//  Copyright © 2017年 vveye. All rights reserved.
//

#import "ViewController_main.h"
#import "ModalAlert.h"
@interface ViewController_main ()

@end

@implementation ViewController_main
@synthesize tableview_cam;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_hidden=true;
    tableview_cam.delegate = self;
    tableview_cam.dataSource = self;
    goe_Http =[ppview_cli getInstance];
    m_share_item=[share_item getInstance];
    MyShareData= [zxy_share_data getInstance];
    gPicCache=[pic_file_manager getInstance];
    [gPicCache init_file_path];
    m_vv_camlist_manager= [cam_list_manager_local getInstance];
    m_vv_camlist_manager.delegate=self;
    [m_vv_camlist_manager start_pre_connect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void)enteredBackground:(NSNotification*) notification{
    [m_vv_camlist_manager release_pre_connect];
    [goe_Http cli_lib_cli_active_status:0];
}

-(void)enterForeground:(NSNotification*) notification{
    [goe_Http cli_lib_cli_active_status:1];
    [m_vv_camlist_manager start_pre_connect];
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

- (IBAction)button_back_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"返回");}];
}

- (IBAction)button_add_click:(id)sender {
    ViewController_adddev *destview=[[ViewController_adddev alloc]initWithNibName:@"ViewController_adddev" bundle:nil];
    [self presentViewController:destview animated:YES completion:nil];
}

- (IBAction)button_piclib_click:(id)sender {
    zxy_FolderViewController* destview=nil;
    destview = [[zxy_FolderViewController alloc]initWithNibName:@"zxy_FolderViewController" bundle:nil];
    [self.navigationController pushViewController:destview animated:YES];
    //[self presentViewController:destview animated:YES completion:nil];
//    destview=nil;
}

- (IBAction)button_referesh_click:(id)sender {
    [m_vv_camlist_manager release_pre_connect];
    [m_vv_camlist_manager start_pre_connect];
    [self vv_update_tableview ];
}

- (IBAction)button_hidden_click:(id)sender {
    m_hidden=!m_hidden;
    [self vv_update_tableview];
}
-(void)start_play
{
    if(MyShareData.playarray.count==1){
        cam_list_item* item= [MyShareData.playarray objectAtIndex:0];
        
        if (item.m_fisheyetype==1 || item.m_fisheyetype==2)
        {
            ViewController_fishplay* destview=nil;
            destview = [[ViewController_fishplay alloc]initWithNibName:@"ViewController_fishplay" bundle:nil];
            destview.delegate=self;
            [self presentViewController:destview animated:YES completion:nil];
            destview=nil;
        }
        
    }
    
}
-(void)on_button_play_click:(NSString*)cam_id pos:(int)pos
{
   cam_list_item *m_cur_vvitem  = [m_vv_camlist_manager getCamItem:cam_id];
    // if (m_cur_vvitem.m_state==1)
    {
        [MyShareData.playarray removeAllObjects];
        [MyShareData.playarray addObject:m_cur_vvitem];
        [self start_play];
    }
}
-(void)on_button_set_click:(NSString*)cam_id pos:(int)pos
{
     cam_list_item *m_cur_vvitem  = [m_vv_camlist_manager getCamItem:cam_id];
    
    m_share_item.cur_cam_list_item=m_cur_vvitem;
    ViewController_camset_detail* destview=nil;
    destview = [[ViewController_camset_detail alloc]initWithNibName:@"ViewController_camset_detail" bundle:nil];
    [self.navigationController pushViewController:destview animated:YES];
}
-(void)on_button_playback_click:(NSString*)cam_id pos:(int)pos
{
    cam_list_item *m_cur_vvitem  = [m_vv_camlist_manager getCamItem:cam_id];
    
    if (m_cur_vvitem.m_state!=1)
        return;
    m_share_item.cur_cam_list_item=m_cur_vvitem;
    
     ViewController_playback* destview=nil;
     destview = [[ViewController_playback alloc]initWithNibName:@"ViewController_playback" bundle:nil];
     [self presentViewController:destview animated:YES completion:nil];
    
}
-(void)on_button_events_click:(NSString*)cam_id pos:(int)pos
{
    cam_list_item *m_cur_vvitem  = [m_vv_camlist_manager getCamItem:cam_id];
    
    if (m_cur_vvitem.m_state!=1)
        return;
    m_share_item.cur_cam_list_item=m_cur_vvitem;
 
    ViewController_alarm_media* destview=nil;
    destview = [[ViewController_alarm_media alloc]initWithNibName:@"ViewController_alarm_media" bundle:nil];
    //[self presentViewController:destview animated:YES completion:nil];
    [self.navigationController pushViewController:destview animated:YES];
}
-(void)on_button_delete_click:(NSString*)cam_id pos:(int)pos
{
    
    cam_list_item *camObj  = [m_vv_camlist_manager getCamItem:cam_id];
    NSString *question=[NSString stringWithFormat:NSLocalizedString(@"Are you sure you want to delete '%@'?", nil), camObj.m_title];
    NSArray *arrBtn=[[NSArray alloc] initWithObjects:NSLocalizedString(@"Yes",nil), nil];
    int nRet=(int)[ModalAlert ask:question withCancel:NSLocalizedString(@"NO", nil) withButtons:arrBtn];
    if(nRet==1)
    {
        
        [m_vv_camlist_manager delete_dev:camObj.m_devid];
                
    }
}
-(void)on_tableview_needreferesh
{
    [self vv_update_tableview];
}

- (BOOL)shouldAutorotate{
    return YES;
}

-(void)vv_update_tableview
{
    [self.tableview_cam reloadData];
}

-(void)cli_lib_camlist_change_callback
{
    NSLog(@"masterview-------cli_lib_camlist_change_callback");
    [self vv_update_tableview];
    //[m_vv_camlist_manager mapToAPNsWithDID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return NULL;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellheight = 200;
    return cellheight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count=(int)([m_vv_camlist_manager getCount]);
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"view_camera,  cellForRowAtIndexPath**************************");
    static NSString *CellIdentifier_camEx = @"TableViewCell_cam";
    TableViewCell_cam* Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_camEx];
    if (Cell == nil) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier_camEx owner:self options:nil] lastObject];
    }
    
    cam_list_item* m_cur_vvitem=[m_vv_camlist_manager getItemByIndex:(int)indexPath.row];
    
    UIImage  *imgBackground=nil;
    
    NSString* backimgname=[gPicCache get_cam_thumbil_filename:m_cur_vvitem.m_id];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:backimgname])
    {
        //NSLog(@"imageWithContentsOfFile....%@",cam_id);
        imgBackground = [UIImage imageWithContentsOfFile:backimgname];
    }
    else
        imgBackground = [UIImage imageNamed:@"png_carempic_bak.png"];
    [Cell.button_cam setBackgroundImage:imgBackground forState:UIControlStateNormal];
    [Cell config_cell:m_cur_vvitem.m_title devid:m_cur_vvitem.m_devid on_line:(int)m_cur_vvitem.m_state with_pos:(int)indexPath.row with_tag:m_cur_vvitem.m_id hidden:m_hidden];
    Cell.delegate=self;
    return Cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
