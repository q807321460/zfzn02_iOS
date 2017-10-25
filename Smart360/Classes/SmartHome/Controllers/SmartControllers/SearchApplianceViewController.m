//
//  SearchApplianceViewController.m
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SearchApplianceViewController.h"

#import "BrandApplianceListViewController.h"
#import "BrandLoginViewController.h"

#import "SBApplianceEngineMgr.h"
#import "SBAEngineDataMgr.h"

#import "DevicesOfBrandModel.h"


@interface SearchApplianceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation SearchApplianceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"搜索设备"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetDevices:) name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    [SBApplianceEngineMgr getDeviceList];
    
    
#else
    self.dataArray = @[@"博联",@"欧瑞博",@"幻腾",@"遥控宝",@"AmazingBox",@"海尔",@"控客",@"美的"];
    [self hideHud];
#endif

}

-(void)notifiGetDevices:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.dataArray = [SBAEngineDataMgr getBrandsContainAppliancesArray:dict[kSBEngine_Data]];
        
        JSDebug(@"SearchAppliance", @"brand count: %d",self.dataArray.count);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
                
            [self.tableView reloadData];
            
        });
        
        
    }else{
        
        JSError(@"SearchAppliance", @"get devices Brand fail errorCode: %@",dict[kSBEngine_ErrCode]);
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
    
    DevicesOfBrandModel *devicesOfBrandModle = [[DevicesOfBrandModel alloc] init];
    devicesOfBrandModle = self.dataArray[indexPath.row];
    cell.textLabel.text = devicesOfBrandModle.brandName;
    
#else
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
#ifdef __SBApplianceEngine__HaveData__
    
    DevicesOfBrandModel *devicesOfBrandModle = [[DevicesOfBrandModel alloc] init];
    devicesOfBrandModle = self.dataArray[indexPath.row];
    
    if (devicesOfBrandModle.isNeedPwd) {
        //需要账号
        BrandLoginViewController *brandLoginVC = [[BrandLoginViewController alloc] init];
        brandLoginVC.devicesOfBrandModel = devicesOfBrandModle;
        brandLoginVC.roomID = self.roomID;
        [self.navigationController pushViewController:brandLoginVC animated:YES];
        
        
    }else{
        //不需要账号
        BrandApplianceListViewController *brandApplianceListVC = [[BrandApplianceListViewController alloc] init];
        brandApplianceListVC.roomID = self.roomID;
        brandApplianceListVC.brandID = devicesOfBrandModle.brandID;
        brandApplianceListVC.brandName = cell.textLabel.text;
        [self.navigationController pushViewController:brandApplianceListVC animated:YES];
    }
    
#else
    
    switch (indexPath.row) {
        case 0:
        {
            JSDebug(@"cell", @"0");
            
            BrandApplianceListViewController *brandApplianceListVC = [[BrandApplianceListViewController alloc] init];
            [self.navigationController pushViewController:brandApplianceListVC animated:YES];
            
        }
            break;
        case 1:
        {
            JSDebug(@"cell", @"1");
        }
            break;
        case 2:
        {
            JSDebug(@"cell", @"2");
            
            BrandLoginViewController *brandLoginVC = [[BrandLoginViewController alloc] init];
            [self.navigationController pushViewController:brandLoginVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

#endif
    
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
