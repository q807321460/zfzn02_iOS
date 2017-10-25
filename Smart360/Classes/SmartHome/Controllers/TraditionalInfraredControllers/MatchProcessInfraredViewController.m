//
//  MatchProcessInfraredViewController.m
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "MatchProcessInfraredViewController.h"

#import "SelecteChannelViewController.h"
#import "MatchInfoModel.h"
#import "MatchResultModel.h"
#import "DeviecNameTypeModel.h"
#import "SBApplianceEngineMgr.h"
#import "IndexShowView.h"
#import "ActionRightWrongView.h"

@interface MatchProcessInfraredViewController ()<ActionRightWrongViewDelegate>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *guideLabel1;
@property (nonatomic, strong) UILabel *guideLabel2;

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) IndexShowView *indexShowView;
@property (nonatomic, strong) ActionRightWrongView *actionRightWrongView;


@property (nonatomic, strong) MatchResultModel *matchResultModel;



@end

@implementation MatchProcessInfraredViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:[NSString stringWithFormat:@"%@(%@)",self.deviceNameTypeModel.deviceType,self.brandName]];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;

    JSDebug(@"MatchProcessVC", @"currIndex:%d, total:%d",self.matchInfoModel.currentIndex,self.matchInfoModel.totalIndex);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiInfraredBoxDownload:) name:kNotifi_SBApplianceEngineCallBack_Event_InfraredBoxDownload object:nil];
    
    
    [self createUI];
    
}


-(void)createUI{
    
    WS(weakSelf);
    
    self.tipLabel = [[UILabel alloc] init];
    [self.view addSubview:self.tipLabel];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = UIColorFromRGB(0x999999);
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(84);
        make.height.mas_equalTo(15);
        
    }];
    
    
    
    self.guideLabel1 = [[UILabel alloc] init];
    [self.view addSubview:self.guideLabel1];
    self.guideLabel1.textAlignment = NSTextAlignmentCenter;
    self.guideLabel1.font = [UIFont systemFontOfSize:16];
    self.guideLabel1.numberOfLines = 0;
    self.guideLabel1.textColor = UIColorFromRGB(0x333333);
    
    [self.guideLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    
    self.guideLabel2 = [[UILabel alloc] init];
    [self.view addSubview:self.guideLabel2];
    self.guideLabel2.textAlignment = NSTextAlignmentCenter;
    self.guideLabel2.font = [UIFont systemFontOfSize:16];
    self.guideLabel2.numberOfLines = 0;
    self.guideLabel2.textColor = UIColorFromRGB(0x333333);
    
    [self.guideLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideLabel1.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    
    self.actionButton = [[UIButton alloc] init];
    [self.view addSubview:self.actionButton];
    [self.actionButton setBackgroundImage:IMAGE(@"Btn_switch_normal") forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:IMAGE(@"Btn_switch_pressed") forState:UIControlStateSelected];
    [self.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideLabel2.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(IMAGE(@"Btn_switch_normal").size);
    }];
    
    
    self.indexShowView = [[IndexShowView alloc] initCustom];
    [self.view addSubview:self.indexShowView];
    
    [self.indexShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionButton.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
    self.actionRightWrongView = [[ActionRightWrongView alloc] initWithAction:self.matchInfoModel.action];
    self.actionRightWrongView.delegate = self;
    [self.view addSubview:self.actionRightWrongView];
    
    self.actionRightWrongView.hidden = YES;
    
    [self.actionRightWrongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indexShowView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
        
    }];
    
    
    
    self.tipLabel.text = @"设备需要时间来响应您的操作，还请操作后适当等待一下";
    self.guideLabel1.text = [NSString stringWithFormat:@"请确保红卫星对准%@",self.deviceNameTypeModel.deviceType];
    self.guideLabel2.text = [NSString stringWithFormat:@"点击按钮，查看%@是否正确响应",self.deviceNameTypeModel.deviceType];
    [self.actionButton setTitle:self.matchInfoModel.action andTitleColor:[UIColor whiteColor] andTitleFont:16];
    [self.indexShowView updateCurrentIndex:self.matchInfoModel.currentIndex totalIndex:self.matchInfoModel.totalIndex];
}



// 匹配按钮
-(void)actionButtonClick:(UIButton *)btn{
    
    //让用户选完设备响应情况，才能接着action
    if (!self.actionRightWrongView.hidden) {
        [self.view makeToast:@"请选择设备响应情况" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    [self showHud];
    
    NSDictionary *dic = @{@"commandType":@"assistantInfraredMatchCmd",@"Appliance":@{@"roomId":self.roomID,@"brandId":@"",@"brand":self.brandName,@"applianceId":@"",@"applianceType":self.deviceNameTypeModel.deviceType,@"proApplianceId":@"",@"name":self.deviceNameTypeModel.deviceName,@"type":self.deviceNameTypeModel.deviceType,@"alias":self.deviceNameTypeModel.deviceName,@"enable":@"",@"belongs":@[],@"channels":	@[]},@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN};
    
    dic = @{@"commandType":@"assistantInfraredMatchCmd",@"roomId":self.roomID,@"brandId":@"",@"brand":self.brandName,@"applianceId":self.redSatelliteID,@"applianceType":self.deviceNameTypeModel.deviceType,@"matchUuid":@"",@"name":self.deviceNameTypeModel.deviceName,@"type":self.deviceNameTypeModel.deviceType,@"totalIndex":self.deviceNameTypeModel.deviceName,@"actionId":@"",@"action":@"",@"currentIndex":@"",@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN};

    [SBApplianceEngineMgr fuzzyMatchInfrared:dic withSuccessBlock:^(NSArray *result) {
        
    } withFailBlock:^(NSString *msg) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiFuzzyMatchInfrared:) name:kNotifi_SBApplianceEngineCallBack_Event_MatchInfrared object:nil];
    
    [SBApplianceEngineMgr fuzzyMatchInfrared:self.brandName redSatelliteID:self.redSatelliteID devType:self.deviceNameTypeModel.deviceType];
    
    JSDebug(@"MatchActionClick", @"brandName:%@, redSatelliteID:%@, deviceType:%@, deviceName:%@, deviceAlias:%@",self.brandName,self.redSatelliteID,self.deviceNameTypeModel.deviceType,self.deviceNameTypeModel.deviceName,self.deviceNameTypeModel.deviceAlias);
    
    
}
// action 回调
-(void)notifiFuzzyMatchInfrared:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_MatchInfrared object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        MatchInfoModel *testMatchInfoModel =  dict[kSBEngine_Data][0];
        
        JSDebug(@"MatchActionNotifi", @"action:%@, currentIndex:%d, totalIndex:%d",testMatchInfoModel.action,testMatchInfoModel.currentIndex,testMatchInfoModel.totalIndex);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            
            [self.view makeToast:@"请选择设备响应情况" duration:1.0 position:CSToastPositionCenter];
            self.actionRightWrongView.hidden = NO;
            
        });
        
        
    }else{
#warning 失败了  什么都不做
        
        JSError(@"MatchInfrared", @"match action fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"match action 失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
        
    }
    
    
}



//设备响应了
-(void)actionRightClick{
    
    JSDebug(@"ActionRight", @"Click");
    
    self.actionRightWrongView.hidden = YES;
    
    [self showHud];
    //“commandType”:”assistantInfraredMatchRightCmd”
    NSDictionary *dic = @{@"commandType":@"assistantInfraredMatchRightCmd"};
    [SBApplianceEngineMgr rightFuzzyMatchInfrared:dic withSuccessBlock:^(NSArray *result) {
        
    } withFailBlock:^(NSString *msg) {
        
    }];
    
    return;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiMatchResultInfrared:) name:kNotifi_SBApplianceEngineCallBack_Event_MatchResultInfrared object:nil];
    
    [SBApplianceEngineMgr rightFuzzyMatchInfrared:self.brandName redSatelliteID:self.redSatelliteID devType:self.deviceNameTypeModel.deviceType];
}

//设备没有响应
-(void)actionWrongClick{
    
    JSDebug(@"ActionWrong", @"Click");
    
    self.actionRightWrongView.hidden = YES;
    
    [self showHud];
    //“commandType”:”assistantInfraredMatchWrongCmd”
    NSDictionary *dic = @{@"commandType":@"assistantInfraredMatchWrongCmd"};
    [SBApplianceEngineMgr wrongFuzzyMatchInfrared:dic withSuccessBlock:^(NSArray *result) {
        
    } withFailBlock:^(NSString *msg) {
        
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiMatchResultInfrared:) name:kNotifi_SBApplianceEngineCallBack_Event_MatchResultInfrared object:nil];
    
    [SBApplianceEngineMgr wrongFuzzyMatchInfrared:self.brandName redSatelliteID:self.redSatelliteID devType:self.deviceNameTypeModel.deviceType];
}

#pragma mark - 匹配结果 回调 match result
-(void)notifiMatchResultInfrared:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_MatchResultInfrared object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.matchResultModel =  dict[kSBEngine_Data][0];
        
        
        if ([self.matchResultModel.result isEqualToString:kInfraredMatchResult_Succ]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.view makeToast:@"匹配成功" duration:1.0 position:CSToastPositionCenter];
            });
        }
        
        if ([self.matchResultModel.result isEqualToString:kInfraredMatchResult_Error]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self hideHud];
                [self.view makeToast:@"匹配失败" duration:1.0 position:CSToastPositionCenter];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        if ([self.matchResultModel.result isEqualToString:kInfraredMatchResult_Continue]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self hideHud];
                
                [self.actionButton setTitle:self.matchResultModel.matchInfoModel.action forState:UIControlStateNormal];
                [self.indexShowView updateCurrentIndex:self.matchResultModel.matchInfoModel.currentIndex totalIndex:self.matchResultModel.matchInfoModel.totalIndex];
                //此处暂不用显示action
//                [self.actionRightWrongView updateActionStr:self.matchResultModel.matchInfoModel.action];
            });
        }
        
        
    }else{
        
        JSError(@"MatchResultInfrared", @"match result  fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
#warning 失败了 什么都不做
            [self hideHud];
            [self.view makeToast:@"match result 失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}


#pragma mark - 匹配成功 Box download

-(void)notifiInfraredBoxDownload:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_InfraredBoxDownload object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
            if ([self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_TV]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_TV_0]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_IPTV]||[self.deviceNameTypeModel.deviceType isEqualToString:kApplianceDeviceType_SetTopBox]){
                
                //是电视
                [self hideHud];
                
                SelecteChannelViewController *selecteChannelVC = [[SelecteChannelViewController alloc] init];
                
                selecteChannelVC.deviceNameTypeModel = self.deviceNameTypeModel;
                selecteChannelVC.roomID = self.roomID;
                selecteChannelVC.redSatelliteID = self.redSatelliteID;
                selecteChannelVC.brandName = self.brandName;
                selecteChannelVC.isFirstAdd = YES;
                
                [self.navigationController pushViewController:selecteChannelVC animated:YES];
            
            }else{
                //不是电视
                //添加红外设备
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddInfrared:) name:kNotifi_SBApplianceEngineCallBack_Event_AddInfrared object:nil];
                
                [SBApplianceEngineMgr addInfraredDevice:self.roomID brandName:self.brandName deviceName:self.deviceNameTypeModel.deviceName devAlias:self.deviceNameTypeModel.deviceName devType:self.deviceNameTypeModel.deviceType channelArray:nil];
                
            }
            
        });
        
    }else{
#warning 失败了  pop上一级
        
        JSError(@"BoxDownload", @"box download fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"box download 失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
}

#pragma mark - 添加红外设备
-(void)notifiAddInfrared:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddInfrared object:nil];
    
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
        
        JSError(@"AddInfrared", @"AddInfrared fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"AddInfrared 失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
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
