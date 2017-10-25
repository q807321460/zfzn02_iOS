//
//  AddPlugSingleDeviceViewController.m
//  Smart360
//
//  Created by michael on 15/12/22.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "AddPlugSingleDeviceViewController.h"

#import "ApplianceModel.h"
#import "AddRoomTableViewCell.h"
#import "SBApplianceEngineMgr.h"
#import "SBAEngineDataMgr.h"
#import "SortForArray.h"

@interface AddPlugSingleDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSArray *selecteBelongsArray;



@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSIndexPath* lastIndexPath;
@property (nonatomic, strong) NSArray *orderKeys;
@property (nonatomic, strong) NSDictionary *resultDataDic;
@end

@implementation AddPlugSingleDeviceViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"设备名称"];
    [self setNavigationItemRightButtonWithTitle:@"保存"];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createTableView];
    [self showHud];
    [self getData];
}

-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [[NSArray alloc] init];
    }
#ifdef __SBApplianceEngine__HaveData__
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetDevicesAddPlugSingleVC:) name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    [SBApplianceEngineMgr getDeviceList];
    
    
#else
    
    [self hideHud];
    
    self.dataArray = @[@"DVD",@"LED灯",@"按摩器",@"冰箱"];
#endif
    
    
}

-(void)notifiGetDevicesAddPlugSingleVC:(NSNotification *)notifi{

    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {

        self.dataArray = [SBAEngineDataMgr getTypesNormalPlugsDevices:dict[kSBEngine_Data]];
                
        JSDebug(@"AddPlugSingleVC", @"devices count: %lu",(unsigned long)self.dataArray.count);
        SortForArray *sort = [[SortForArray alloc] initWithDataArray:self.dataArray];
        self.resultDataDic = sort.resultDataDic;
        self.orderKeys = sort.resultKeysArray;

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];

            [self.tableView reloadData];

        });

    }else{

        JSError(@"AddPlugSingleVC", @"get devicesList fail errorCode: %@",dict[kSBEngine_ErrCode]);
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
//设置分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.orderKeys.count ;
}

// 设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.resultDataDic objectForKey:self.orderKeys[section]] count];
}


//section header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
//section headerView
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.orderKeys[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.orderKeys;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPlugSingleDeviceVCTableViewCell"];
    if (!cell) {
        cell = [[AddRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPlugSingleDeviceVCTableViewCell"];
    }
    
    cell.textLabel.text = self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row];
    
    return cell;
}



//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddRoomTableViewCell *cell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
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
    //self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row];
//    self.blockSelectSinglePlug(self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row]);
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    self.selecteBelongsArray = @[self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row]];
    
}


#pragma mark - right click
-(void)rightItemClicked:(id)sender{
    
//    if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
    
        if ((self.selecteBelongsArray == nil)||(self.selecteBelongsArray.count == 0)) {
            
            [self.view makeToast:@"请选择插座上的设备" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        
//    }else{
//        
//        self.selecteBelongsArray = @[@""];
//        
//    }
    
    
#ifdef __SBApplianceEngine__HaveData__
    [self showHud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddWiFiDeviceAddPlugSingle:) name:kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice object:nil];
    
    self.applianceModel.alias =@"360";
    
    JSDebug(@"addWiFiDevice", @"brandID:%d, roomID:%@, deviceInherentID:%@, name:%@, alias:%@, deviceType:%@",self.applianceModel.brandID,self.roomID,self.applianceModel.deviceInherentID,self.applianceModel.name,self.applianceModel.alias,self.applianceModel.deviceType);
    
    [SBApplianceEngineMgr addWifiDevice:self.applianceModel.brandID roomID:self.roomID deviceInherentID:self.applianceModel.deviceInherentID devName:self.applianceModel.name devAlias:self.applianceModel.alias devType:self.applianceModel.deviceType belongsArray:self.selecteBelongsArray];
    
    
#else
    
#endif
    
}
-(void)notifiAddWiFiDeviceAddPlugSingle:(NSNotification *)notifi{
    
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
            [self.view makeToast:@"添加失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
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
