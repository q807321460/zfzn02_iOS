//
//  AddApplianceSeleteRoomViewController.m
//  Smart360
//
//  Created by michael on 15/12/8.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "AddApplianceSeleteRoomViewController.h"
#import "AddRoomTableViewCell.h"
#import "RoomModel.h"
#import "ApplianceModel.h"
#import "RoomContainApplianceModel.h"

#import "SBApplianceEngineMgr.h"

@interface AddApplianceSeleteRoomViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath* lastIndexPath;

@end

@implementation AddApplianceSeleteRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"选择房间"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createTableView];
    [self showHud];
    [self getData];
}

-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
#ifdef __SBApplianceEngine__HaveData__
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetRoomAndApplianceUserDefinedAddApplianceSelecteRoomVC:) name:kNotifi_SBApplianceEngineCallBack_Event_GetRoomAndApplianceUserDefined object:nil];
    [SBApplianceEngineMgr queryRoomsAndAppliancesUserDefined];
    
    
#else
    
    self.dataArray = @[@"卧室",@"主卧",@"客卧",@"次卧",@"客厅"];
    [self hideHud];
#endif
    
    
}

-(void)notifiGetRoomAndApplianceUserDefinedAddApplianceSelecteRoomVC:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetRoomAndApplianceUserDefined object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.dataArray = dict[kSBEngine_Data];
        JSDebug(@"AddApplianceSelecteRoomVC", @" all room count: %d",self.dataArray.count);
        
        if (0 == self.dataArray.count) {
            
            JSError(@"AddApplianceSelecteRoomVC", @" all room count: %d , please check!!!",self.dataArray.count);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self hideHud];
                [self.tableView reloadData];
                [self.view makeToast:@"没有可用于添加的房间" duration:1.0 position:CSToastPositionCenter];
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self hideHud];
                [self.tableView reloadData];
            });
            
        }
        
    }else{
        
        JSError(@"AddApplianceSelecteRoomVC", @"get Rooms And Appliances fail, errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            
            [self.view makeToast:@"获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}





-(void)createTableView{
    if (!self.tableView) {
        self.tableView=[UITableView new];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.backgroundColor = kDevicesManager_BackgroundColor;
        
        [self.view addSubview:self.tableView];
        
        WS(weakSelf);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    
}
#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//section header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
//section headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddApplianceSelecteRoomVCTableViewCell"];
    if (!cell) {
        cell = [[AddRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddApplianceSelecteRoomVCTableViewCell"];
    }
    
    
#ifdef __SBApplianceEngine__HaveData__
    RoomContainApplianceModel *roomContainApplianceModel = self.dataArray[indexPath.row];
    RoomModel *roomModel = roomContainApplianceModel.roomModel;
    cell.textLabel.text = roomModel.name;
    
#else
    
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif
    
    return cell;
}



//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AddRoomTableViewCell *cell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.lastIndexPath == indexPath) {
        
    }else{
        
        if (self.lastIndexPath) {
            AddRoomTableViewCell *lastCell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:self.lastIndexPath];
            lastCell.seleRightImageView.hidden = YES;
            cell.seleRightImageView.hidden = NO;
            
            self.lastIndexPath = indexPath;
            
        }else{
            cell.seleRightImageView.hidden = NO;
            self.lastIndexPath = indexPath;
        }
        
    }
    
    
    RoomContainApplianceModel *roomContainApplianceModel = self.dataArray[indexPath.row];
    RoomModel *roomModel = roomContainApplianceModel.roomModel;
    
    self.selecteRoomBlock(roomModel);
    [self.navigationController popViewControllerAnimated:YES];
    
    
//#ifdef __SBApplianceEngine__HaveData__
//    [self showHud];
//    
//    RoomModel *roomModel = self.dataArray[indexPath.row];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddWiFiDevice:) name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
//    
//    
//    
//    self.applianceModel.alias =@"qqq";
//    
//    JSDebug(@"addWiFiDevice", @"brandID:%d, roomID:%@, deviceInherentID:%@, name:%@, alias:%@, deviceType:%@",self.applianceModel.brandID,roomModel.roomID,self.applianceModel.deviceInherentID,self.applianceModel.name,self.applianceModel.alias,self.applianceModel.deviceType);
//    
//    [SBApplianceEngineMgr addWifiDevice:self.applianceModel.brandID roomID:roomModel.roomID deviceInherentID:self.applianceModel.deviceInherentID devName:self.applianceModel.name devAlias:self.applianceModel.alias devType:self.applianceModel.deviceType belongsArray:@[@""]];
//    
//    
//#else
//    
//#endif
    
}
//-(void)notifiAddWiFiDevice:(NSNotification *)notifi{
//    
//    NSDictionary *dict = notifi.userInfo;
//    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self hideHud];
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
//        
//    }else{
//        
//        JSError(@"AddWiFiDevice", @"add WiFi Device fail errorCode: %@",dict[kSBEngine_ErrCode]);
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            
//            [self hideHud];
//            [self.view makeToast:@"添加失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
//        });
//        
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
//}

#pragma  mark - leftItemClicked 返回
- (void)leftItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
