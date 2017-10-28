//
//  MultiDevicesAddViewController.m
//  Smart360
//
//  Created by michael on 15/12/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "MultiDevicesAddViewController.h"

#import "ApplianceModel.h"
#import "AddRoomTableViewCell.h"
#import "SBApplianceEngineMgr.h"


@interface MultiDevicesAddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation MultiDevicesAddViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetDevicesMultiDevicesVCVC:) name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    [SBApplianceEngineMgr getDeviceList];
    
    
#else
    
    [self hideHud];
    
    self.dataArray = @[@"DVD",@"LED灯",@"按摩器",@"冰箱"];
#endif
    
    
}

-(void)notifiGetDevicesMultiDevicesVCVC:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetDevices object:nil];
    
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.dataArray = dict[kSBEngine_Data];
        JSDebug(@"AddMultiPlugVC", @"devices count: %lu",(unsigned long)self.dataArray.count);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            
            [self.tableView reloadData];
            
        });
        
    }else{
        
        JSError(@"AddMultiPlugVC", @"get devicesList fail errorCode: %@",dict[kSBEngine_ErrCode]);
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
        
        //允许多选
        self.tableView.allowsMultipleSelection = YES;
        
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
    
    AddRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultiDevicesAddTableViewCell"];
    if (!cell) {
        cell = [[AddRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MultiDevicesAddTableViewCell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    // cell选中类型 无风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//取消选择
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddRoomTableViewCell *cell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.seleRightImageView.hidden = YES;
    
    JSDebug(@"MutilDevicesAdd_Cell", @"取消选择, cell.selected:%d ,row:%ld ",cell.selected,(long)indexPath.row);
    
}

//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddRoomTableViewCell *cell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.seleRightImageView.hidden = NO;
    JSDebug(@"MutilDevicesAdd_Cell", @"选中, cell.selected:%d ,row:%ld",cell.selected,(long)indexPath.row);
    
}

#pragma mark - right click
-(void)rightItemClicked:(id)sender{
    
    [self passDataUIJump];
    
}


-(void)passDataUIJump{
    NSArray *seleArray = [self.tableView indexPathsForSelectedRows];
    JSDebug(@"MutilDevicesAdd_Cell", @"选中cell的index集合%@",seleArray);
    
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *markIndexPath in seleArray) {
        [resArray addObject:self.dataArray[markIndexPath.row]];
    }
    
    self.selectBelongsBlock(resArray);
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma  mark - leftItemClicked 返回
- (void)leftItemClicked:(id)sender {

    [self passDataUIJump];
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
