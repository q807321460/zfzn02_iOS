//
//  BrandApplianceListViewController.m
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "BrandApplianceListViewController.h"

#import "SBApplianceEngineMgr.h"
#import "ApplianceModel.h"
#import "AddApplianceRoomViewController.h"
#import "AddPlugSingleDeviceViewController.h"

@interface BrandApplianceListViewController ()

@end

@implementation BrandApplianceListViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"设备列表"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    

    [self createTableView];
    
    [self showHud];
    
    [self getData];
}

-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [NSArray new];
    }
    
#ifdef __SBApplianceEngine__HaveData__
    
    
//    NSDictionary *dic = @{@"commandType":@"assistantRequireUnregisterDeviceCmd",@"boxSN":[[JSSaveUserMessage sharedInstance] currentBoxSN] readDefaultBoxSN],@"brandId":[NSString stringWithFormat:@"%@",@(self.brandID)],@"brand":self.brandName,@"secquenceId":@""};
//    
//    [SBApplianceEngineMgr getUnregistDevicesOfOneBrandWithDic:dic withSuccessBlock:^(NSDictionary *result) {
//        
//    } withFailBlock:^(NSString *msg) {
//        
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetUnregistDevicesOfOneBrand:) name:kNotifi_SBApplianceEngineCallBack_Event_GetUnregistDevicesOfOneBrand object:nil];
    
    [SBApplianceEngineMgr getUnregistDevicesOfOneBrand:self.brandID];
    
    
#else
    self.dataArray = @[@"插座"];
    [self hideHud];
#endif
}

-(void)notifiGetUnregistDevicesOfOneBrand:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetUnregistDevicesOfOneBrand object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.dataArray = dict[kSBEngine_Data];
#warning 此处预留参数1 的内容是是否需要密码
        
        JSDebug(@"UnregistDevices", @"device count: %lu",(unsigned long)self.dataArray.count);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            
            [self.tableView reloadData];
            
        });
        
    }else{
        
        JSError(@"UnregistDevices", @"get unregist devices fail errorCode: %@",dict[kSBEngine_ErrCode]);
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
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchApplianceVCTableViewCell"];
        
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchApplianceVCTableViewCell" forIndexPath:indexPath];
    
#ifdef __SBApplianceEngine__HaveData__
    ApplianceModel *applianceModel = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ MAC %@",applianceModel.name,applianceModel.deviceInherentID];
    JSDebug(@"ApplianceList__Cell", @"name:%@ , inherentID:%@",applianceModel.name,applianceModel.deviceInherentID);
#else
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ApplianceModel *seleApplianceModel = self.dataArray[indexPath.row];
    
    if ([seleApplianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
        //是插座
        //选择设备名称
        
        //单插座
        AddPlugSingleDeviceViewController *addPlugSingleDeviceVC = [[AddPlugSingleDeviceViewController alloc] init];
        addPlugSingleDeviceVC.roomID = self.roomID;
        addPlugSingleDeviceVC.applianceModel = seleApplianceModel;
        [self.navigationController pushViewController:addPlugSingleDeviceVC animated:YES];
        
        
        
        //        //多选插排
        //        MultiDevicesAddViewController *multiDevicesAddVC = [[MultiDevicesAddViewController alloc] init];
        //
        //        multiDevicesAddVC.selectBelongsBlock = ^(NSArray *selectBelongsArray){
        //
        //            self.selecteBelongsArray = selectBelongsArray;
        //        };
        //
        //
        //        [self.navigationController pushViewController:multiDevicesAddVC animated:YES];
        
        
        
        
    }else{
        //不是插座
        
        [self showHud];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddWiFiDeviceBrandApplianceListVC:) name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
        
        seleApplianceModel.alias =@"360";
        
        JSDebug(@"addWiFiDevice", @"brandID:%d, roomID:%@, deviceInherentID:%@, name:%@, alias:%@, deviceType:%@",seleApplianceModel.brandID,self.roomID,seleApplianceModel.deviceInherentID,seleApplianceModel.name,seleApplianceModel.alias,seleApplianceModel.deviceType);
        
        [SBApplianceEngineMgr addWifiDevice:seleApplianceModel.brandID roomID:self.roomID deviceInherentID:seleApplianceModel.deviceInherentID devName:seleApplianceModel.name devAlias:seleApplianceModel.alias devType:seleApplianceModel.deviceType belongsArray:@[]];
        

        
    }
    
    //原来需要选择房间方案（下面的代码）
//    AddApplianceRoomViewController *addApplianceRoomVC = [[AddApplianceRoomViewController alloc] init];
//#ifdef __SBApplianceEngine__HaveData__
//    addApplianceRoomVC.applianceModel = self.dataArray[indexPath.row];
//#endif
//    
//    [self.navigationController pushViewController:addApplianceRoomVC animated:YES];
    
}
-(void)notifiAddWiFiDeviceBrandApplianceListVC:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
    
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
            
        });
        
    }else{
        
        JSError(@"AddWiFiDevice", @"add WiFi Device fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            if (3004 == [dict[kSBEngine_ErrCode] intValue]) {
                [self.view makeToast:@"该房间已有红卫星，不能再添加Pro" duration:1.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:@"添加失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            }
        });
        
    }
    
}




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
