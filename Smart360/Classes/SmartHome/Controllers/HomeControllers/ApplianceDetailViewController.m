//
//  ApplianceDetailViewController.m
//  Smart360
//
//  Created by michael on 15/12/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "ApplianceDetailViewController.h"
#import "SBApplianceEngineMgr.h"
#import "RightLabelTableViewCell.h"
#import "SelecteChannelViewController.h"
#import "SBAEngineDataMgr.h"
#import "PlugModel.h"
#import "RoomContainApplianceModel.h"
#import "LearnProViewController.h"
#import "DeviecNameTypeModel.h"

@interface ApplianceDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *descripLabel;



@end

@implementation ApplianceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titleStr = [NSString stringWithFormat:@"%@%@",self.applianceModel.brandName,self.applianceModel.deviceType];
    if ([self.applianceModel.type isEqualToString:kApplianceType_redstar]) {
        titleStr = @"红卫星";
    }
    
    [self setNavigationItemWithTitle:titleStr];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createUI];
    [self createTableView];
    
    [self getData];
    
}

-(void)getData{
    
    self.iconImageView.image = [SBAEngineDataMgr matchIconNameWithApplianceName:self.applianceModel];
//    IMAGE(@"SmartHome_Ico_TV_L");
    self.descripLabel.text = @"";
//    @"语音控制说明：说小智打开电视、说小智关闭电视、说小智调高音量、说小智调低音量、说小智转到湖南卫视。";
    
    
    [self showHud];
    
    if ([self.applianceModel.type isEqualToString:kApplianceType_redstar] || [self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Pro]) {
        //红卫星、博联RM Pro 不显示语音说明
    }else{
        
        [SBApplianceEngineMgr getApplianceCtrlCmd:self.applianceModel.deviceID withSuccessBlock:^(NSString *result) {
            [self hideHud];
            CGFloat desLabelHeight = [JSUtility heightForText:result labelWidth:SCREEN_WIDTH-20 fontOfSize:12];
            self.backView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 30+110+25+desLabelHeight+20);
            
            [self.descripLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
                make.left.equalTo(self.backView).offset(10);
                make.right.equalTo(self.backView).offset(-10);
                make.height.mas_equalTo(desLabelHeight+5);
            }];
            
            self.descripLabel.text = result;
            
        } withFailBlock:^(NSString *msg) {
            [self hideHud];
        }];

        
    }
    
//
    
}





-(void)createUI{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 170)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    self.iconImageView = [UIImageView new];
    [self.backView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(30);
        make.size.mas_equalTo(IMAGE(@"SmartHome_Ico_TV_L").size);
    }];
    
    self.descripLabel = [UILabel new];
    [self.backView addSubview:self.descripLabel];
    [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.left.equalTo(self.backView).offset(10);
        make.right.equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    self.descripLabel.numberOfLines = 0;
    self.descripLabel.textColor = UIColorFromRGB(0x999999);
    self.descripLabel.font = [UIFont systemFontOfSize:12];
    
    
}
-(void)createTableView{
    if (!self.tableView) {
        self.tableView=[UITableView new];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.backgroundColor = kDevicesManager_BackgroundColor;
        self.tableView.scrollEnabled = NO;
        
        [self.view addSubview:self.tableView];
        
        WS(weakSelf);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.top.equalTo(self.backView.mas_bottom).with.offset(20);
            make.height.mas_equalTo(300);
        }];
        
        
        [self createTableFooterView];
        
    }
    
}
-(void)createTableFooterView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.tableView.tableFooterView = footView;
    
    UIButton *deleButton = [UIButton new];
    [footView addSubview:deleButton];
    [deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(20);
        make.left.equalTo(footView).with.offset(10);
        make.right.equalTo(footView).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [deleButton addTarget:self action:@selector(deleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    deleButton.backgroundColor = UIColorFromRGB(0xff6868);
    deleButton.layer.masksToBounds = YES;
    deleButton.layer.cornerRadius = 8;
    [deleButton setTitle:@"移除设备" forState:UIControlStateNormal];
    [deleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleButton.titleLabel.font=[UIFont systemFontOfSize:15];
    
}
-(void)deleBtnClick:(UIButton *)btn{
    
    if ([self.applianceModel.type isEqualToString:kApplianceType_redstar]) {
        //红卫星
        BOOL isHaveInfraredDevice = [SBAEngineDataMgr haveInfraredApplianceWithRoomContainApplianceModel:self.roomContainApplianceModel];
        if (isHaveInfraredDevice) {
            [self.view makeToast:@"当前房间有红外设备，红卫星不能删除" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        
    }
    
    
    [self showHud];
    NSDictionary *applianceInfo = @{@"roomId":self.applianceModel.roomID,@"id":self.applianceModel.deviceID};
    [SBApplianceEngineMgr deleteAppliance:applianceInfo withSuccessBlock:^{
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
        
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
    }];

}
-(void)notifiDeleteAppliance:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_DeleteAppliance object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"删除设备成功" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else{
        
        NSString *errMsg = (NSString *)dict[kSBEngine_Data][0];
        
        JSError(@"DeleteAppliance", @"delete appliance fail errorCode: %@ ,errMsg :%@",dict[kSBEngine_ErrCode],errMsg);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:errMsg duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount;
    if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
        return 1;
    }
    
    if (self.applianceModel.controlledByProSN.length>0) {
        //Pro控制的设备
        if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
            rowCount = 3;
        }else{
            rowCount = 2;
        }
        
    }else if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV_0]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_IPTV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_SetTopBox]) {
        
        rowCount = 2;

    } else {
        rowCount = 1;
    }
    
    return rowCount;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RightLabelTableViewCell *cell = (RightLabelTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ApplianceDetailTableViewCell"];
    if (!cell) {
        cell = [[RightLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplianceDetailTableViewCell"];
    }
    
    if (0 == indexPath.row) {
        
        if (self.applianceModel.controlledByProSN.length>0) {
            //Pro控制的设备
            
            NSString *textProRoomName = [SBAEngineDataMgr getProRoomNameWithProSN:self.applianceModel.controlledByProSN archArray:self.archAllRoomArray];
            if (textProRoomName.length == 0) {
                textProRoomName = [SBAEngineDataMgr getProRoomNameWithRoomId:self.applianceModel.roomID archArray:self.archAllRoomArray];
            }
            if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"控制器：小智内嵌控制器（%@）",textProRoomName];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"控制器：博联智能遥控器（%@）",textProRoomName];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.height.equalTo(cell.textLabel);
                make.width.mas_equalTo(100);
            }];
            
            //        }
            cell.textLabel.text = @"房间";
            cell.rightLabel.text = self.applianceModel.roomName;
        }
        
        
    }else if (1 == indexPath.row){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.applianceModel.controlledByProSN.length>0) {
            //Pro控制的设备
            cell.textLabel.text = @"控制学习";
            cell.rightLabel.text = @"";
        }else{
            //与Pro无关设备
            
            if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
                cell.textLabel.text = @"设备名称";
                
                NSMutableString *rightStr = [[NSMutableString alloc] init];
                for (PlugModel *plugModel in self.applianceModel.plugArray) {
                    
                    if (rightStr.length == 0) {
                        [rightStr appendString:plugModel.name];
                    }else{
                        [rightStr appendFormat:@"、%@",plugModel.name];
                    }
                }
                
                cell.rightLabel.text = rightStr;
                
            }else if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV_0]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_IPTV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_SetTopBox]){
                
                cell.textLabel.text = @"常用频道";
                cell.rightLabel.text = @"";
            }
            
        }
        
    }else if (2 == indexPath.row){
        //RF Plug 关联设备
        cell.textLabel.text = @"设备名称";
        NSMutableString *rightStr = [[NSMutableString alloc] init];
        for (PlugModel *plugModel in self.applianceModel.plugArray) {
            if (rightStr.length == 0) {
                [rightStr appendString:plugModel.name];
            }else{
                [rightStr appendFormat:@"、%@",plugModel.name];
            }
        }
        cell.rightLabel.text = rightStr;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}
//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    RightLabelTableViewCell *cell = (RightLabelTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (0 == indexPath.row) {
        //更改设备房间
        
//        if ([self.applianceModel.type isEqualToString:kApplianceType_redstar]) {
//            
//            [self.view makeToast:@"红卫星不可更改房间" duration:1.0 position:CSToastPositionCenter];
//            return;
//        }
        
        
//
//        DeviceChangeRoomViewController *deviceChangeRoomVC = [[DeviceChangeRoomViewController alloc] init];
//        deviceChangeRoomVC.applianceModel = self.applianceModel;
//        [self.navigationController pushViewController:deviceChangeRoomVC animated:YES];
        
        
    }else if (1 == indexPath.row){
        
        if (self.applianceModel.controlledByProSN.length>0) {
            //Pro控制的设备
            LearnProViewController *learnProVC = [[LearnProViewController alloc] init];
            learnProVC.isAddDevice = NO;
            learnProVC.applianceModel = self.applianceModel;
            [self.navigationController pushViewController:learnProVC animated:YES];
            
        }else{
            //与Pro无关设备
            
            //区分插座、电视机
            
            if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
      
                
            }else if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_TV_0]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_IPTV]||[self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_SetTopBox]){
                
                //电视机
                SelecteChannelViewController *selecteChannelVC = [[SelecteChannelViewController alloc] init];
                selecteChannelVC.applianceModel = self.applianceModel;
                selecteChannelVC.deviceNameTypeModel = [[DeviecNameTypeModel alloc] initWithApplianceModel:self.applianceModel];
                selecteChannelVC.isFirstAdd = NO;
                [self.navigationController pushViewController:selecteChannelVC animated:YES];
            }
            
        }
        
    }else if (2 == indexPath.row){
        //RF Plug 关联设备
        if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
                    
        }
        
    }

}

//注意dict中model可能为空
-(void)updateRoomNotifi:(NSMutableDictionary *)notifiDict{
    
    //如果roomContainApplianceModel存在的话
    if (notifiDict[kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel]) {
        self.roomContainApplianceModel = notifiDict[kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel];
    }
    
    
    
    //如果applianceModel存在的话
    if (notifiDict[kNotifi_UpdateRoom_Notifi_ApplianceModel]) {
        self.applianceModel = notifiDict[kNotifi_UpdateRoom_Notifi_ApplianceModel];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.tableView reloadData];
            
        });
    }
    
}


// 接口方法  家电设备推送
//注意dict中model可能为空
-(void)updateDeviceNotifi:(NSMutableDictionary *)notifiDict{
    
    //如果roomContainApplianceModel存在的话
    if (notifiDict[kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel]) {
        self.roomContainApplianceModel = notifiDict[kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel];
    }

    
    
    
    if (notifiDict[kNotifi_UpdateRoom_Notifi_ApplianceModel]) {
        self.applianceModel = notifiDict[kNotifi_UpdateRoom_Notifi_ApplianceModel];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.tableView reloadData];
            
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
