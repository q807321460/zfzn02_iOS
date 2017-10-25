//
//  ModelSearchViewController.m
//  Smart360
//
//  Created by michael on 15/11/25.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "ModelSearchViewController.h"

#import "SBApplianceEngineMgr.h"


#import "DeviecNameTypeModel.h"
#import "MatchProcessInfraredViewController.h"
#import "MatchInfoModel.h"
#import "SBApplianceEngineMgr.h"


@interface ModelSearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITextField *deviceTF;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TJRemote *> *dataArray;

@end

@implementation ModelSearchViewController


- (void)dealloc
{
    
    JSDebug(@"dealloc", @"");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"型号搜索"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createUI];
    
}

-(void)createUI{
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(80);
    }];
    label.text = @"如果您知道添加设备的型号，请在型号输入框输入。如果您不清楚添加设备的型号，请点击屏幕下方的模糊搜索匹配。";
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x999999);
    
    
    UIButton *exactSearchBtn = [UIButton new];
    [self.view addSubview:exactSearchBtn];
    [exactSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.size.mas_equalTo(IMAGE(@"Home_btn_Inquire").size);
    }];
//    [exactSearchBtn setTitle:@"点击搜索" forState:UIControlStateNormal];
    [exactSearchBtn setBackgroundImage:IMAGE(@"Home_btn_Inquire") forState:UIControlStateNormal];
//    [exactSearchBtn setBackgroundColor:[UIColor blackColor]];
    [exactSearchBtn addTarget:self action:@selector(exactSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIImageView * bacImageView = [[UIImageView alloc] init];
    bacImageView.image = IMAGE(@"bgkuang");
    [self.view addSubview:bacImageView];
    [bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(exactSearchBtn);
        make.top.mas_equalTo(exactSearchBtn);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(exactSearchBtn.mas_left).offset(-20);
    }];
    
    
    self.deviceTF = [UITextField new];
    [self.view addSubview:self.deviceTF];
    self.deviceTF.placeholder = @" 请输入设备型号";
    self.deviceTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bacImageView).offset(0);
        make.left.equalTo(bacImageView).offset(10);
        make.height.mas_equalTo(bacImageView);
        make.right.equalTo(bacImageView).offset(0);
    }];
//    self.deviceTF.layer.masksToBounds = YES;
//    self.deviceTF.layer.cornerRadius = 8;
//    self.deviceTF.layer.borderWidth = 1;
//    self.deviceTF.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){ 0, 0, 0, 1 });
//    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    
    
    
    if (!self.tableView) {
        self.tableView=[UITableView new];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
        
        WS(weakSelf);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.top.equalTo(exactSearchBtn.mas_bottom).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 150));
        }];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ModelSearchVCTableViewCell"];
    }
    
    
    
//    UIButton * fuzzySearchBtn = [UIButton new];
//    [self.view addSubview:fuzzySearchBtn];
//    [fuzzySearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_bottom).with.offset(18);
//        make.left.equalTo(self.view).with.offset(10);
//        make.right.equalTo(self.view).with.offset(-10);
//        make.height.mas_equalTo(@40);
//    }];
//    [fuzzySearchBtn addTarget:self action:@selector(fuzzySearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    fuzzySearchBtn.backgroundColor = UIColorFromRGB(0xff6868);
//    fuzzySearchBtn.layer.masksToBounds = YES;
//    fuzzySearchBtn.layer.cornerRadius = 8;
//    [fuzzySearchBtn setTitle:@"模糊搜索匹配" forState:UIControlStateNormal];
//    [fuzzySearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    fuzzySearchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModelSearchVCTableViewCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    TJRemote *remote = self.dataArray[indexPath.row];
//    [TJRemoteUtil generateRemoteName:remote];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@",remote.localeName,remote._id ];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",remote.localeName ];
    NSLog(@"%@",cell.textLabel.text);

    return cell;
}

#pragma mark - 型号搜索
-(void)exactSearchBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];  //收键盘
    
    [self showHud];
    self.tjBrandPage.keyword = self.deviceTF.text;
    NSDictionary *dic = @{@"commandType": @"assistantInfraredModelSearchCmd",@"brand":self.brandName,@"applianceId":self.redSatelliteID,@"applianceType":self.deviceNameTypeModel.deviceType,@"model":@""};
//    NSDictionary *dic = @{};
    [SBApplianceEngineMgr modelSearchInfrared:dic withSuccessBlock:^(NSString *result) {
        [self searchModel];
    } withFailBlock:^(NSString *msg) {
        [self.view makeToast:@"型号搜索获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    
    
}

- (void)searchModel {
    [[TJRemoteClient sharedClient] searchOfficial:self.tjBrandPage callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
        NSLog(@"searchOfficial: %d, %d", errcode, (int)remoteList.count);
        [self hideHud];
        if (errcode == TJWebErrorCode_Success) {
            if (remoteList.count) {
                self.dataArray = remoteList;
                NSMutableArray *tempArr = [NSMutableArray array];
                for (TJRemote *remote in remoteList) {
                    NSString *remotestr =[NSString stringWithFormat:@"%@--%@",remote.localeName,remote._id ];
                    
                    [tempArr addObject:remotestr];
                }
                //                TJRemoteUtil
                NSLog(@"%@",tempArr);
                [self.tableView reloadData];
                
            } else {
                [self.view makeToast:@"没有搜索到相应型号的设备" duration:1.0 position:CSToastPositionCenter];
            }
            
        } else {
            [self.view makeToast:@"型号搜索获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            
        }
        
    }];

}


#pragma mark - 型号搜索 结果 确认
//选中cell  型号确认
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showHud];
    
    //assistantInfraredModelConfirmCmd
    TJRemote *remote = self.dataArray[indexPath.row];
    NSString *remoteId = remote._id;
    
    //电风扇7003005100300000
    //空调0000200122ad002e
    NSDictionary *dic = @{@"commandType": @"assistantInfraredModelConfirmCmd",@"brand":self.brandName,@"applianceId":self.redSatelliteID,@"applianceType":self.deviceNameTypeModel.deviceType,@"model":remote.localeName};

    [SBApplianceEngineMgr confirmModelSearchInfrared:dic withSuccessBlock:^(NSDictionary *result) {
        [self hideHud];
        NSLog(@"型号确认%@",result);
        //brand:长虹,DeviceType:电视机,DeviceName:电视机
        //创维电视: code:7001006705500000
        NSDictionary *deviceDic = @{@"commandType":@"assistantRegisterDeviceCmd",@"Appliance":@{@"roomId":self.roomID,@"brandId":@"",@"brand":self.brandName,@"applianceId":@"",@"applianceType":self.deviceNameTypeModel.deviceType,@"proApplianceId":@"",@"name":self.deviceNameTypeModel.deviceName,@"type":@"infrared",@"alias":self.deviceNameTypeModel.deviceName,@"enable":@"",@"code":remoteId,@"belongs":@[],@"channels":@[]},@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN};
        
        NSLog(@"添加的设备%@,%@,%@,%@",self.brandName,self.deviceNameTypeModel.deviceType,self.deviceNameTypeModel.deviceName,self.deviceNameTypeModel.deviceName);
        
        [SBApplianceEngineMgr addInfraredDevice:deviceDic withSuccessBlock:^(NSString *result) {
            [self hideHud];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }

        } withFailBlock:^(NSString *msg) {
            [self hideHud];
            [self.view makeToast:@"红外设备添加失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        }];
        
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
    }];
    
    
}

#pragma mark - 点击 模糊搜索匹配

-(void)fuzzySearchBtnClick:(UIButton *)btn{
    
    TJRemoteMatchPage *page = [TJRemoteMatchPage new];
    // 设置电器类型和品牌
    page.appliance_type = self.tjBrandPage.appliance_type;
    page.brand_id = self.tjBrandPage.brand_id; // 品牌id
    // App当前使用的语言
    page.lang = [TJRemoteHelper fetchCurrentLang];
       [[TJRemoteClient sharedClient] exactMatchRemote:page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
        NSLog(@"next_key=%d, errcode=%d, remote count=%d", page.next_key, errcode, (int)remoteList.count);
        if (errcode == TJWebErrorCode_MatchCompleted || errcode != TJWebErrorCode_Success) {
            
            
            return;
        }
        if (remoteList.count) {
            
            TJRemote *remote = remoteList[0];
            
            TJIrKey *key = remote.keys[0];
            //            self.lastKey = key;
            
            MatchInfoModel *matchInfoModel = [[MatchInfoModel alloc] init];
            matchInfoModel.action = key.localeName;
            matchInfoModel.currentIndex = 1 ;
            matchInfoModel.totalIndex = (int)remote.keys.count;
            JSDebug(@"ModelSearchVC", @"currIndex:%d, total:%d",matchInfoModel.currentIndex,matchInfoModel.totalIndex);
            MatchProcessInfraredViewController *matchProcessInfraredVC = [[MatchProcessInfraredViewController alloc] init];
            matchProcessInfraredVC.matchInfoModel = matchInfoModel;
            
            matchProcessInfraredVC.roomID = self.roomID;
            matchProcessInfraredVC.brandName = self.brandName;
            matchProcessInfraredVC.redSatelliteID = self.redSatelliteID;
            matchProcessInfraredVC.deviceNameTypeModel = self.deviceNameTypeModel;
            
            [self.navigationController pushViewController:matchProcessInfraredVC animated:YES];
            
        } else {
            
        }
    }];

    return;
    
    [self showHud];
    NSDictionary *dic = @{@"commandType": @"assistantInfraredMatchStartCmd",@"brand":self.brandName,@"applianceId":self.redSatelliteID,@"applianceType":self.deviceNameTypeModel.deviceType};

    [SBApplianceEngineMgr startFuzzyMatchInfrared:dic withSuccessBlock:^(NSArray *result) {
        [self hideHud];
        MatchProcessInfraredViewController *matchProcessInfraredVC = [[MatchProcessInfraredViewController alloc] init];
        matchProcessInfraredVC.matchInfoModel = result[0];
        
        matchProcessInfraredVC.roomID = self.roomID;
        matchProcessInfraredVC.brandName = self.brandName;
        matchProcessInfraredVC.redSatelliteID = self.redSatelliteID;
        matchProcessInfraredVC.deviceNameTypeModel = self.deviceNameTypeModel;
        
        
        MatchInfoModel *matchInfoModelTest = result[0];
        JSDebug(@"ModelSearchVC", @"currIndex:%d, total:%d",matchInfoModelTest.currentIndex,matchInfoModelTest.totalIndex);

        [self.navigationController pushViewController:matchProcessInfraredVC animated:YES];
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:@"开始模糊搜索失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    
    return;
    
    
    
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
