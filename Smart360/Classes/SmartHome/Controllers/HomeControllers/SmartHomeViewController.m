//
//  SmartHomeViewController.m
//  Smart360
//
//  Created by michael on 15/11/2.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SmartHomeViewController.h"

#import "RoomTableViewCell.h"

#import "RoomContainApplianceModel.h"
#import "RoomModel.h"
#import "ApplianceModel.h"

#import "RoomContainApplianceModel.h"
#import "RoomModel.h"
#import "ApplianceModel.h"
#import "PlugModel.h"
#import "BrandAccountModel.h"
#import "ChannelModel.h"
#import "DevicesOfBrandModel.h"
#import "DeviecNameTypeModel.h"


#import "AddRoomViewController.h"
#import "SelectDeviceTypeViewController.h"
#import "AddRedSatelliteViewController.h"
#import "EditRoomViewController.h"
#import "ApplianceDetailViewController.h"
#import "AddRedSatelliteGuideViewController.h"

#import "JSCustomPopoverView.h"
#import "SBApplianceEngineMgr.h"
#import "SelecteAddTypeView.h"
#import "SBAEngineDataMgr.h"
#import "ProRoomModel.h"
#import "ProListView.h"


@interface SmartHomeViewController ()<UITableViewDataSource,UITableViewDelegate,RoomTableViewCellDelegate,SelecteAddTypeViewDelegate,ProListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *footerView;


@property (nonatomic, strong) NSArray *boxListNameArray;
@property (nonatomic, strong) NSArray *boxListSNArray;


@end

@implementation SmartHomeViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    JSDebug(@"WillAppear", @"");
    
}



-(void)createRightBarButtonItem{
    //origin
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(0, 0, 80, 44);
    [rightButton setImageWithNormal:@"Nav_Ico_Down_normal" andHightLighted:@"Nav_Ico_Down_pressed"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton setOnClickSelector:@selector(rightItemClicked:) target:self];
    
    NSString *strRightButton = @"设备切换";
    CGFloat widthStrRightButton = [NSString widthForText:strRightButton fontOfSize:14 width:80];
    [rightButton setTitle:strRightButton andTitleColor:UIColorFromRGB(0xffffff) andTitleFont:14];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -IMAGE(@"Nav_Ico_Down_normal").size.width, 0, IMAGE(@"Nav_Ico_Down_normal").size.width);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, widthStrRightButton, 0, -widthStrRightButton);
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightBarButtonItem];
    
    [self setNavigationItemWithTitle:@"我的设备"];
//    [self setNavigationItemLeftButtonWithTitle:@"查询房间信息"];
    //演示厅: SZB0C0301B88F
    //二楼:   SZB0C0300803F
    //feng:  SZB0C03005BBF
//    self.boxListNameArray = @[@"演示厅:SZB0C0301B88F",@"二楼:SZB0C0300803F",@"feng:SZB0C03005BBF",@"红卫星:SZB0C030023DF"];
//    self.boxListSNArray = @[@"SZB0C0301B88F",@"SZB0C0300803F",@"SZB0C03005BBF",@"SZB0C030023DF"];
    self.boxListNameArray = @[@"公司测试:SZB0C0300D7EF",];
    self.boxListSNArray = @[@"SZB0C0300D7EF"];
    [self createTableView];
    [self showHud];
    self.isOnline = YES;
    if (!self.boxListNameArray) {
        self.boxListNameArray = [[NSArray alloc] init];
    }
    if (!self.boxListSNArray) {
        self.boxListSNArray = [[NSArray alloc] init];
    }
    //konnn test
    //[self testKonnn];
}


-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *dic = @{@"commandType":@"assistantQueryRoomCmd",@"boxSN":[[JSSaveUserMessage sharedInstance] currentBoxSN]};
    [SBApplianceEngineMgr getSmartHomeDeviceListWithDic:dic withSuccessBlock:^(NSMutableArray *result) {
        [self hideHud];
        [self.dataArray removeAllObjects];
        self.dataArray = result;
        [self.tableView reloadData];
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:@"获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    
    return;
    
}

-(void)createTableView{
    if (!self.tableView) {
        
        UIImageView *backImageViewHome = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        backImageViewHome.image = IMAGE(@"Home_BG");
        [self.view addSubview:backImageViewHome];
        
        self.tableView=[UITableView new];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.tableView];
        
        WS(weakSelf);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view).with.offset(64);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-80));
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self createFooterView];
    }
    
}
-(void)createFooterView{
    
    CGFloat widthToLeftEdge = 15;
    CGFloat widthButtonInterval = 15;
    CGFloat widthButton = (SCREEN_WIDTH - widthToLeftEdge*2 -widthButtonInterval*2)/3;
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    self.footerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.footerView];
   
    
    UIButton *addRoomButton = [[UIButton alloc] initWithFrame:CGRectMake(widthToLeftEdge, 5, widthButton, 70)];
    addRoomButton.backgroundColor = [UIColor whiteColor];
    addRoomButton.layer.masksToBounds = YES;
    addRoomButton.layer.cornerRadius = 5;
    [self.footerView addSubview:addRoomButton];
    [addRoomButton setTitle:@"添加房间" andTitleColor:UIColorFromRGB(0x333333) andTitleFont:15];
    [addRoomButton setImage:IMAGE(@"Home_Ico_add2") forState:UIControlStateNormal];
    
    CGFloat widthTitle = [NSString widthForText:@"添加房间" fontOfSize:15 width:widthButton];
    CGFloat imageUpwardHeight = 20;
    CGFloat titleDownwardHeight = 30;
    
    addRoomButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addRoomButton.titleEdgeInsets = UIEdgeInsetsMake(titleDownwardHeight,  -IMAGE(@"Home_Ico_add2").size.width, 0, 0);  //top left bottom right
    addRoomButton.imageEdgeInsets = UIEdgeInsetsMake(-imageUpwardHeight, 0, 0, -widthTitle);
    [addRoomButton addTarget:self action:@selector(addRoomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)addRoomBtnClick:(UIButton *)btn{
    
    if (!self.isOnline) {
        [self.view makeToast:@"当前机器人不在线，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    
    //获取已用房间列表
    NSMutableArray *roomsUsedArray = [[NSMutableArray alloc] init];
    for (RoomContainApplianceModel *roomContainApplianceModel in self.dataArray) {
        [roomsUsedArray addObject:roomContainApplianceModel.roomModel];
        
    }
    
    AddRoomViewController *addRoomVC = [[AddRoomViewController alloc] init];
    addRoomVC.roomsUsedArray = roomsUsedArray;
    [self.navigationController pushViewController:addRoomVC animated:YES];
    
}

#pragma mark - 情景模式

#pragma mark - tableView Delegate
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
//每组 header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return 15;
    }else{
        return 10;
    }
    
}
//每组 headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

        UIView * headerView = [[UIView alloc] initWithFrame:CGRectZero];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
}

//Cell选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomContainApplianceModel *roomContainApplianceModel = self.dataArray[indexPath.section];
    
    long n = roomContainApplianceModel.applianceModelArray.count;
    
    return 56+88*((n/4)+1);
    
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDevicesRoomTableViewCell"];
    if (!cell) {
        cell = [[RoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyDevicesRoomTableViewCell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    [cell showDataWithModel:self.dataArray[indexPath.section]];
    return cell;
}


#pragma mark - Cell Delegate

-(void)clickChangeRoomNameDelegate:(RoomContainApplianceModel *)roomContainApplianceModel{
    
    if (!self.isOnline) {
        [self.view makeToast:@"当前机器人不在线，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    //获取已用房间列表
    NSMutableArray *roomsUsedArray = [[NSMutableArray alloc] init];
    for (RoomContainApplianceModel *roomContainApplianceModel in self.dataArray) {
        [roomsUsedArray addObject:roomContainApplianceModel.roomModel];
    }
    
    JSDebug(@"CellDelegate", @"%@",roomContainApplianceModel.roomModel.name);
    EditRoomViewController *editRoomVC = [[EditRoomViewController alloc] init];
    editRoomVC.roomModel = roomContainApplianceModel.roomModel;
    editRoomVC.roomsUsedArray = roomsUsedArray;
    if (roomContainApplianceModel.applianceModelArray.count>0) {
        editRoomVC.isHaveDeviceCurrentRoom = YES;
    }else{
        editRoomVC.isHaveDeviceCurrentRoom = NO;
    }
    [self.navigationController pushViewController:editRoomVC animated:YES];
    
}

//点击cell里的button
-(void)clickApplianceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel number:(NSInteger)number isDevice:(BOOL)isDevice{
    
    JSDebug(@"CellDelegate", @"isDevice:%d",isDevice);
    
    if (!self.isOnline) {
        
        [self.view makeToast:@"当前机器人不在线，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!isDevice) {
        JSDebug(@"点击",@"点击添加家电");
//        NSDictionary *dict = [SBAEngineDataMgr getIsProOrRedSatelliteRoomInfo:roomContainApplianceModel.roomModel.roomID archArray:[NSArray arrayWithArray:self.dataArray]];
//        
//        SelecteAddTypeView *selecteAddTypeView = [[SelecteAddTypeView alloc] initWithRoomContainApplianceModel:roomContainApplianceModel ProStarDict:dict];
//        selecteAddTypeView.delegate = self;
//        [selecteAddTypeView showSelecteAddTypeView];
        
        [self addInfraredDeviceDelegate:roomContainApplianceModel];
            
    }else{
    
        JSDebug(@"点击", @"点击进入家电");
            
        ApplianceDetailViewController *applianceDetailVC = [[ApplianceDetailViewController alloc] init];
        applianceDetailVC.applianceModel = roomContainApplianceModel.applianceModelArray[number];
        applianceDetailVC.roomContainApplianceModel = roomContainApplianceModel;
        applianceDetailVC.archAllRoomArray = [NSArray arrayWithArray:self.dataArray];
//        [self.dataArray copy];
        JSDebug(@"ApplianceDetail", @"deviceID:%@",applianceDetailVC.applianceModel.deviceID);
        
        [self.navigationController pushViewController:applianceDetailVC animated:YES];
            
    }
    
}

-(void)jumpToSelectDeviceTypeVCWithRoomID:(NSString *)roomID redSatelliteID:(NSString *)redSatelliteID ProSN:(NSString *)proSN addType:(NSString *)addType{
    
    SelectDeviceTypeViewController *selectDevTypeVC = [[SelectDeviceTypeViewController alloc] init];
    selectDevTypeVC.redSatelliteID = redSatelliteID;
    selectDevTypeVC.proSN = proSN;
    selectDevTypeVC.addType = addType;
    selectDevTypeVC.roomID = roomID;

    [self.navigationController pushViewController:selectDevTypeVC animated:YES];
}



#pragma mark - 选择添加 传统家电 智能家电 射频设备delegate
#pragma mark - 选择添加 传统家电
//传统家电
-(void)addInfraredDeviceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel{
    
    JSDebug(@"Add Traditional Device", @"redSatelliteID: %@ ,proSN:%@",roomContainApplianceModel.roomModel.redSatelliteID,roomContainApplianceModel.roomModel.ProSN);
    if (!self.isOnline) {
        [self.view makeToast:@"当前机器人不在线，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (roomContainApplianceModel.roomModel.redSatelliteID.length > 0 ) {
        //有红卫星
        JSDebug(@"Add Infrared", @"redSatellite");

        [self jumpToSelectDeviceTypeVCWithRoomID:roomContainApplianceModel.roomModel.roomID redSatelliteID:roomContainApplianceModel.roomModel.redSatelliteID ProSN:nil addType:kApplianceType_infrared];
        
    } else {
        //没有红卫星、没有Pro
        AddRedSatelliteGuideViewController *addRedSatelliteGuideVC = [[AddRedSatelliteGuideViewController alloc] init];
        addRedSatelliteGuideVC.roomID = roomContainApplianceModel.roomModel.roomID;
        [self.navigationController pushViewController:addRedSatelliteGuideVC animated:YES];
    }
    
}
#pragma mark - 选择添加 智能家电
//智能家电
#pragma mark - 选择添加 射频设备
//熟悉AVCaptureDevice,封装QRView类库实现原生二维码生成与扫描
//RF设备
//dict 中有： 是哪种控制器、pro的个数房间信息
//本房间有Pro、其他房间有Pro

#pragma mark - ProListView delegate 


#pragma mark - leftItemClicked:
- (void)leftItemClicked:(id)sender {
    
    [self getData];
    
}


#pragma mark - rightItemClicked:
- (void)rightItemClicked:(id)sender {
    CGPoint point = CGPointMake(SCREEN_WIDTH - 13,  64);
    
    JSCustomPopoverView *pop = [[JSCustomPopoverView alloc] initWithPoint:point titles:self.boxListNameArray images:nil isOnNav:YES];
    
    pop.currentIndexPath = [self queryIndexPathOfBoxSN:[JSSaveUserMessage sharedInstance].currentBoxSN];
    
    
    JSDebug(@"rightItemClick", @"pop.currentIndexPath:%ld ",(long)pop.currentIndexPath.row);
    
    pop.selectRowAtIndex = ^(NSIndexPath *selectIndexPath){
        
        [self haddleSelectedDefaultBoxButton:selectIndexPath.row];
    };
    [pop show];
    
}

-(NSIndexPath *)queryIndexPathOfBoxSN:(NSString *)boxSN{
    
    for (int i = 0; i <self.boxListNameArray.count; i++) {
        NSString *tempBoxSN = self.boxListNameArray[i];
        if ([tempBoxSN containsString:boxSN]) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
//        if ([boxSN isEqualToString:tempBoxSN]) {
//            return [NSIndexPath indexPathForRow:i inSection:0];
//        }
    }
    return nil;
}

- (void)haddleSelectedDefaultBoxButton:(NSInteger)index{
    [JSSaveUserMessage sharedInstance].currentBoxSN = self.boxListSNArray[index];
    
    [self getData];
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
#pragma mark - test:
- (void)testKonnn {
    NSLog(@"testKonnn");
    [SBApplianceEngineMgr testControl:@"制热模式" withSuccessBlock:^(NSString *result) {
        [self hideHud];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        } 
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:@"红外设备控制失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    return;
}





@end
