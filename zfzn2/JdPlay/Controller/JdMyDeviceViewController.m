//
//  JDMyDeviceViewController.m
//  JDMusic
//
//  Created by henry on 15/10/17.
//  Copyright © 2015年 henry. All rights reserved.
//  需要在这里修改部分代码使之可以对接上兆丰智能软件

#import "JdMyDeviceViewController.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "JdDeviceInfoTableViewCell.h"
#import "JdCategory_AViewController.h"
#import "TopAlertView.h"

@interface JdMyDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,DeviceListView>
{
    JdShareClass * shareObj;
    JdDeviceListPresenter * mPresenter;
    
}
@end

@implementation JdMyDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shareObj = [JdShareClass sharedInstance];
    mPresenter = [JdDeviceListPresenter sharedManager];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    [self.tableview registerNib:[UINib nibWithNibName:@"JdDeviceInfoTableViewCell"  bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mPresenter.delegate = self;
    [self reflashUI];
}


-(NSMutableArray *)deviceListArr
{
    if (!_deviceListArr) {
        _deviceListArr = [[NSMutableArray alloc] init];
    }
    return _deviceListArr;
}


-(void)reflashUI
{
    if(self.deviceListArr == nil || [self.deviceListArr count] ==0)
    {
        _tableview.hidden = YES;
        _noDevice.hidden = NO;
    }
    else
    {
        _noDevice.hidden = YES;
        _tableview.hidden = NO;
        [_tableview reloadData];
    }
    
}


#pragma mark - DeviceListView
-(void)onJdDeviceInfoChange:(NSArray *)infos
{
    self.deviceListArr = [NSMutableArray arrayWithArray:infos];
    [self performSelectorOnMainThread:@selector(reflashUI) withObject:nil waitUntilDone:YES];
}



#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceListArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JdDeviceInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    JdDeviceInfo * model = self.deviceListArr[indexPath.row];
    cell.deviceModel = model;
    if ([shareObj.currentDeviceID isEqualToString:model.uuid]) {
        cell.mark.image = [UIImage imageNamed:@"check_press"];
    }else{
        cell.mark.image = [UIImage imageNamed:@"check_nol"];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JdDeviceInfo * model = self.deviceListArr[indexPath.row];
    if (!model.onlineStatus) {
        [TopAlertView showWithType:TopAlertTypeTip text:@"设备离线，请选择在线设备！" parentView:self.view];
        return;
    }
    if (![model.uuid isEqualToString:shareObj.currentDeviceID]) {
        [mPresenter selectDevice:model.uuid];
        shareObj.currentDeviceID = model.uuid;
        shareObj.deviceInfo = model;
    }
    JdCategory_AViewController * VC = [[JdCategory_AViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"返回");}];
}
@end
