//
//  SelectBrandViewController.m
//  Smart360
//
//  Created by michael on 15/11/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SelectBrandViewController.h"
#import "ApplianceModel.h"
#import "ModelSearchViewController.h"
#import "SBApplianceEngineMgr.h"
#import "DeviecNameTypeModel.h"
#import "SortForArray.h"
#import "JSNetworkMgr.h"

@interface SelectBrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *orderKeys;
@property (nonatomic, strong) NSDictionary *resultDataDic;

@end

@implementation SelectBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"品牌选择"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    
    [self createTableView];
    
    [self showHud];
    
//    [self getData];
    
}

-(void)viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    [self getData];
}

-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    

//@"commandType":@"assistantInfraredGetBrandCmd"
//@"applianceType":self.deviceNameTypeModel.deviceType
    
    [SBApplianceEngineMgr getBrandListOfDeviceTypeInfrared:self.deviceNameTypeModel.deviceType withSuccessBlock:^(NSString *result) {
        [self hideHud];
        [self getTJBrand];
    } withFailBlock:^(NSString *msg) {
        //请求失败
        [self hideHud];
        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];

    }];

    
    
}

- (void)getTJBrand {
    //获取品牌列表
    [[TJRemoteClient sharedClient] getBrandList:self.tjDeviceType callback:^(NSMutableArray<TJBrand *> *brands) {
        NSLog(@"TV brand: %@", brands);
        NSLog(@"TV brand: %@", [NSThread currentThread]);
        //
        if (brands.count == 0) {
            [self hideHud];
            [self.view makeToast:@"未获取到列表，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            return ;
        }
        NSMutableArray *brandsArray = [NSMutableArray array];
        for (TJBrand *tjBrand in brands) {
            //            NSString *brandName = tjBrand.brand_cn;
            //            long long  brandID = tjBrand._id;
            [brandsArray addObject:tjBrand];
        }
        self.dataArray = brandsArray;
        SortForArray *sort = [[SortForArray alloc] initWithDataArray:self.dataArray];
        self.resultDataDic = sort.resultDataDic;
        self.orderKeys = sort.resultKeysArray;
        //            [self.tableView reloadData];
        [self hideHud];
        [self.tableView reloadData];
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
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SelectBrandVCTableViewCell"];
        
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


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.orderKeys[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.orderKeys;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBrandVCTableViewCell" forIndexPath:indexPath];
    
#ifdef __SBApplianceEngine__HaveData__
    TJBrand *brand = self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",brand.brand_cn];
    
#else
    
    cell.textLabel.text = self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row];
#endif
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ModelSearchViewController *modelSeachVC = [[ModelSearchViewController alloc] init];
    modelSeachVC.redSatelliteID = self.redSatelliteID;
    modelSeachVC.roomID = self.roomID;
    modelSeachVC.deviceNameTypeModel = self.deviceNameTypeModel;
    TJBrand *brand = self.resultDataDic[self.orderKeys[indexPath.section]][indexPath.row];
    modelSeachVC.brandName = brand.brand_cn;
    
    TJRemotePage *tjBrandPage = [TJRemotePage new];
    tjBrandPage.appliance_type = self.tjDeviceType;
    tjBrandPage.brand_id = brand._id; // 康佳
    modelSeachVC.tjBrandPage = tjBrandPage;

    [self.navigationController pushViewController:modelSeachVC animated:YES];
            
        
    
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
