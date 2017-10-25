//
//  SelectDeviceTypeViewController.m
//  Smart360
//
//  Created by michael on 15/11/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SelectDeviceTypeViewController.h"

#import "SBApplianceEngineMgr.h"
#import "SBAEngineDataMgr.h"
#import "SelectBrandViewController.h"
#import "DeviecNameTypeModel.h"
#import "LearnProViewController.h"
#import "ApplianceModel.h"



@interface SelectDeviceTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SelectDeviceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titleVC = @"设备类型";
    if ([self.addType isEqualToString:kApplianceType_infrared]) {
        titleVC = @"红外设备类型";
    }else if ([self.addType isEqualToString:kApplianceType_RF]){
        titleVC = @"射频设备类型";
    }else if ([self.addType isEqualToString:kApplianceType_ProInfrared]){
        titleVC = @"红外设备类型";
    }
    
    
    [self setNavigationItemWithTitle:titleVC];
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
    [SBApplianceEngineMgr getInfraredDevicesWithSuccessBlock:^(NSArray *result) {
        self.dataArray = result;
        [self.tableView reloadData];
        [self hideHud];
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
    }];


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
    
    DeviecNameTypeModel *deviceNameTypeModel = [[DeviecNameTypeModel alloc] init];
    deviceNameTypeModel = self.dataArray[indexPath.row];
    cell.textLabel.text = deviceNameTypeModel.deviceType;
    
#else
    
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviecNameTypeModel *deviceNameTypeModel = self.dataArray[indexPath.row];
    
        //红卫星Infrared
        SelectBrandViewController *seleBrandVC = [[SelectBrandViewController alloc] init];
        seleBrandVC.deviceNameTypeModel = deviceNameTypeModel;
        seleBrandVC.redSatelliteID = self.redSatelliteID;
        seleBrandVC.roomID = self.roomID;
        seleBrandVC.tjDeviceType = [deviceNameTypeModel.machineType intValue];
        
        [self.navigationController pushViewController:seleBrandVC animated:YES];
    
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
 <__NSArrayM 0x180f48a0>(
 deviceID: ,brandName: ,deviceType: 门,name: 门,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 消毒柜,name: 消毒柜,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灯带,name: 灯带,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 充电牙刷,name: 充电牙刷,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 加湿器,name: 加湿器,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 果蔬解毒机,name: 果蔬解毒机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 落地灯,name: 落地灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 洗碗机,name: 洗碗机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 壁灯,name: 壁灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 冰吧,name: 冰吧,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 抽湿机,name: 抽湿机,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 干衣机,name: 干衣机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 微波炉,name: 微波炉,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED台灯,name: LED台灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 按摩椅,name: 按摩椅,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 扫地机器人,name: 扫地机器人,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 调光灯,name: 调光灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 料理机,name: 料理机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 痛风仪,name: 痛风仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 熨斗,name: 熨斗,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED台灯,name: LED台灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 功放,name: 功放,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电压力锅,name: 电压力锅,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 冷风扇,name: 冷风扇,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 煮蛋器,name: 煮蛋器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED灯,name: LED灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: DVD,name: DVD,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电视机,name: 电视机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 烤箱,name: 烤箱,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 台灯,name: 台灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: IPTV,name: IPTV,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电风扇,name: 电风扇,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电脑音箱,name: 电脑音箱,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 卷发器,name: 卷发器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 水晶灯,name: 水晶灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 直发器,name: 直发器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 数码相机,name: 数码相机,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 窗帘,name: 窗帘,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电话机,name: 电话机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 净水机,name: 净水机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 射灯,name: 射灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灶具,name: 灶具,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电磁炉,name: 电磁炉,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 洁身器,name: 洁身器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 扫地机器人,name: 扫地机器人,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 游戏机平板,name: 游戏机平板,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 投影仪,name: 投影仪,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 筒灯,name: 筒灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 地暖,name: 地暖,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 主灯,name: 主灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 煎药壶,name: 煎药壶,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 热水瓶,name: 热水瓶,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 音箱,name: 音箱,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电视机,name: 电视机,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 射灯,name: 射灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 加湿器,name: 加湿器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 平板,name: 平板,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 烟机,name: 烟机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 镜前灯,name: 镜前灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 纯水机,name: 纯水机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 纱窗,name: 纱窗,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 机顶盒,name: 机顶盒,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 面包机,name: 面包机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 血糖仪,name: 血糖仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 吊灯,name: 吊灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 厨房秤,name: 厨房秤,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 空气净化器,name: 空气净化器,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 美容器,name: 美容器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 香薰机,name: 香薰机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 吸顶灯,name: 吸顶灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 插座,name: 插座,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 家庭影院,name: 家庭影院,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 管线机,name: 管线机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 吸顶灯,name: 吸顶灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 背景灯,name: 背景灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 壁灯,name: 壁灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 按摩椅,name: 按摩椅,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 豆浆机,name: 豆浆机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 滤水杯,name: 滤水杯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 网络摄像机,name: 网络摄像机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED灯带,name: LED灯带,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 按摩器,name: 按摩器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 盒子,name: 盒子,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 吊灯,name: 吊灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 理发器,name: 理发器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 足浴盆,name: 足浴盆,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED灯带,name: LED灯带,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灯,name: 灯,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电水壶,name: 电水壶,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 空气净化器,name: 空气净化器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 筒灯,name: 筒灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 中央净水机,name: 中央净水机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 机顶盒,name: 机顶盒,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电热毯,name: 电热毯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 开关,name: 开关,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 胎心仪,name: 胎心仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 功放,name: 功放,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 空调,name: 空调,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电脑,name: 电脑,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 酒柜,name: 酒柜,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 收音机,name: 收音机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 脂肪检测仪,name: 脂肪检测仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: DVD,name: DVD,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 夜灯,name: 夜灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电风扇,name: 电风扇,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 净化器,name: 净化器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 摄像头,name: 摄像头,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 浴霸,name: 浴霸,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电吹风,name: 电吹风,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 节能灯,name: 节能灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 软水机,name: 软水机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 饮水机,name: 饮水机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电风扇,name: 电风扇,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 台灯,name: 台灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 插座,name: 插座,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 监护器,name: 监护器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 取暖电器,name: 取暖电器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 夜灯,name: 夜灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 门,name: 门,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灯带,name: 灯带,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 家庭影院,name: 家庭影院,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 排气扇,name: 排气扇,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 血氧仪,name: 血氧仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 顶灯,name: 顶灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 窗帘,name: 窗帘,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 取暖电器,name: 取暖电器,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 迷你音响,name: 迷你音响,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 窗户,name: 窗户,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 节能灯,name: 节能灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 抽湿机,name: 抽湿机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 开关,name: 开关,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 过滤器,name: 过滤器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 马桶,name: 马桶,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 洗衣机,name: 洗衣机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灯,name: 灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电冰箱,name: 电冰箱,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 除湿机,name: 除湿机,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 挂烫机,name: 挂烫机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 吸尘器,name: 吸尘器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED吸顶灯,name: LED吸顶灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 背景灯,name: 背景灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 按摩器,name: 按摩器,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 顶灯,name: 顶灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 路由器,name: 路由器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 投影仪,name: 投影仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED灯,name: LED灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: LED吸顶灯,name: LED吸顶灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: IPTV,name: IPTV,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电炖锅,name: 电炖锅,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 冷柜,name: 冷柜,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 助听器,name: 助听器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: DVD,name: DVD,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 数码相机,name: 数码相机,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电视盒子,name: 电视盒子,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 空调,name: 空调,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 体温计,name: 体温计,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 治疗仪,name: 治疗仪,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 盒子,name: 盒子,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 投影仪,name: 投影仪,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电热饭盒,name: 电热饭盒,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 咖啡机,name: 咖啡机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 酸奶机,name: 酸奶机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 红外灯,name: 红外灯,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电视机,name: 电视机,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电烤箱,name: 电烤箱,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 净饮机,name: 净饮机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 收录机,name: 收录机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 榨汁机,name: 榨汁机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 晾衣架,name: 晾衣架,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电饭煲,name: 电饭煲,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 镜前灯,name: 镜前灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 烧烤盘,name: 烧烤盘,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 鱼缸,name: 鱼缸,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 机顶盒,name: 机顶盒,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 电饼铛,name: 电饼铛,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 中央灯,name: 中央灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 健康秤,name: 健康秤,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 热水器,name: 热水器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 音响,name: 音响,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 空调,name: 空调,type: infrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 水晶灯,name: 水晶灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 加湿香薰器,name: 加湿香薰器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 清洁机,name: 清洁机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 养生壶,name: 养生壶,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 落地灯,name: 落地灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 灯,name: 灯,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 车库,name: 车库,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 计步器,name: 计步器,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 暖气,name: 暖气,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 血压计,name: 血压计,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 调光灯,name: 调光灯,type: rf,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 除湿机,name: 除湿机,type: normal,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: ,brandName: ,deviceType: 迷你音响,name: 迷你音响,type: proInfrared,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 洗衣机,name: 洗衣机,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 空调,name: 空调,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 热水器,name: 热水器,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 电冰箱,name: 电冰箱,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 烤箱,name: 烤箱,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 5,brandName: 海尔,deviceType: 空气盒子,name: 空气盒子,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 1,brandName: 博联,deviceType: 遥控器,name: 遥控器,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 1,brandName: 博联,deviceType: 插座,name: 插座,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 3,brandName: 幻腾,deviceType: Nova灯,name: Nova灯,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 6,brandName: 控客,deviceType: 小K插座,name: 小K插座,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 2,brandName: 欧瑞博,deviceType: 插座,name: 插座,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null),
 deviceID: 2,brandName: 欧瑞博,deviceType: 遥控器,name: 遥控器,type: wifi,roomID: (null),roomName: (null),alias: ,status: (null),controlledByProSN: (null)
 )
*/

@end
