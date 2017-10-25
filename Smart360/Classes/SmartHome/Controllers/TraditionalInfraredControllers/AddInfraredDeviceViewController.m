//
//  AddInfraredDeviceViewController.m
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "AddInfraredDeviceViewController.h"

#import "RightLabelTableViewCell.h"
#import "SBApplianceEngineMgr.h"
#import "RoomModel.h"
#import "DeviecNameTypeModel.h"
#import "AddApplianceSeleteRoomViewController.h"

@interface AddInfraredDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RoomModel *selecteRoomModel;

@property (nonatomic, strong) NSArray *selecteBelongsArray;

@end

@implementation AddInfraredDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"设置"];
    [self setNavigationItemRightButtonWithTitle:@"保存"];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createTableView];
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
    
    if ([self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_TV]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_TV_0]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_IPTV]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_SetTopBox]) {
        
        return 2;
    }else{
        return 1;
    }
    
    
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
    
    RightLabelTableViewCell *cell = (RightLabelTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"AddInfraredDeviceVCTableViewCell"];
    if (!cell) {
        cell = [[RightLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddInfraredDeviceVCTableViewCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (0 == indexPath.row) {
        cell.textLabel.text = @"选择房间";
        cell.rightLabel.text = self.selecteRoomModel.name;
        
    }else{
        cell.textLabel.text = @"设置频道";
    }
    
    return cell;
}

#pragma mark - 切换房间、更换房间
//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row) {
        AddApplianceSeleteRoomViewController *addApplianceSeleteRoomVC = [[AddApplianceSeleteRoomViewController alloc] init];
        
        addApplianceSeleteRoomVC.selecteRoomBlock = ^(RoomModel *roomModel){
            
            self.selecteRoomModel = roomModel;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [tableView reloadData];
            });
            
        };
        
        [self.navigationController pushViewController:addApplianceSeleteRoomVC animated:YES];
        
    }else{
        //设置频道
//        
//        //单插座
//        AddPlugSingleDeviceViewController *addPlugSingleDeviceVC = [[AddPlugSingleDeviceViewController alloc] init];
//        addPlugSingleDeviceVC.blockSelectSinglePlug = ^(NSString *selecteName){
//            self.selecteBelongsArray = @[selecteName];
//        };
//        [self.navigationController pushViewController:addPlugSingleDeviceVC animated:YES];
        
    }
    
}

//#pragma mark - right click
//-(void)rightItemClicked:(id)sender{
//    
//    if (self.selecteRoomModel == nil) {
//        [self.view makeToast:@"请选择房间" duration:1.0 position:CSToastPositionCenter];
//        return;
//    }
//    
//    
//    if ([self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
//        
//        if ((self.selecteBelongsArray == nil)||(self.selecteBelongsArray.count == 0)) {
//            
//            [self.view makeToast:@"请选择插座上的设备" duration:1.0 position:CSToastPositionCenter];
//            return;
//        }
//        
//    }else{
//        
//        self.selecteBelongsArray = @[@""];
//        
//    }
//    
//    
//#ifdef __SBApplianceEngine__HaveData__
//    [self showHud];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddWiFiDevice:) name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
//    
//    self.applianceModel.alias =@"qqq";
//    
//    JSDebug(@"addWiFiDevice", @"brandID:%d, roomID:%@, deviceInherentID:%@, name:%@, alias:%@, deviceType:%@",self.applianceModel.brandID,self.selecteRoomModel.roomID,self.applianceModel.deviceInherentID,self.applianceModel.name,self.applianceModel.alias,self.deviceNameTypeModel.deviceType);
//    
//    [SBApplianceEngineMgr addWifiDevice:self.applianceModel.brandID roomID:self.selecteRoomModel.roomID deviceInherentID:self.applianceModel.deviceInherentID devName:self.applianceModel.name devAlias:self.applianceModel.alias devType:self.deviceNameTypeModel.deviceType belongsArray:self.selecteBelongsArray];
//    
//    
//#else
//    
//#endif
//    
//}
//-(void)notifiAddWiFiDevice:(NSNotification *)notifi{
//    
//    NSDictionary *dict = notifi.userInfo;
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
//    
//    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self hideHud];
//            
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                
//                if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
//            
//            
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
//    
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
