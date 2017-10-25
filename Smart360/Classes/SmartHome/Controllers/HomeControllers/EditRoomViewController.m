//
//  EditRoomViewController.m
//  Smart360
//
//  Created by michael on 15/12/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "EditRoomViewController.h"
#import "SBApplianceEngineMgr.h"
#import "AddRoomTableViewCell.h"
#import "RoomModel.h"

@interface EditRoomViewController ()<UITableViewDataSource,UITableViewDelegate>


//得到的房间列表，原始数据
@property (nonatomic, strong) NSMutableArray *originalDataArray;
//用于tableview展示的数据
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath* lastIndexPath;

@end

@implementation EditRoomViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"编辑房间"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    
    [self createTableView];
    [self showHud];
    [self getData];
}

-(void)getData{
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
        self.originalDataArray = [[NSMutableArray alloc] init];
    }
    [SBApplianceEngineMgr getRoomListWithSuccessBlock:^(NSArray *result) {
        self.originalDataArray = [NSMutableArray arrayWithArray:result];
        [self hideHud];
        //去除已用房间
        [self removeUsedRoomInDataArrayEditRoomVC];
        if (0 == self.dataArray.count) {
            [self.view makeToast:@"没有可用于更换的房间" duration:1.0 position:CSToastPositionCenter];
            
        }else{
            [self.tableView reloadData];
        }
        
        [self hideHud];
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
    }];
    
    
}

//去除已用房间
-(void)removeUsedRoomInDataArrayEditRoomVC{
    
    //注意此处用copy 不能直接指向（指向时引用计数加一，data修改时original也就改了）
    self.dataArray = [NSMutableArray arrayWithArray:self.originalDataArray];
    
    JSDebug(@"EditRoomVC", @"removeUsedRoom : originalDataArray count :%lu , 赋值给dataArray count :%lu",(unsigned long)self.originalDataArray.count,(unsigned long)self.dataArray.count);
    
    //去除已用房间
    for (RoomModel *roomModelUsed in self.roomsUsedArray) {
        
        RoomModel *markRoomModel = [[RoomModel alloc] init];
        for (RoomModel *roomModel in self.dataArray) {
            
            if ([roomModelUsed.name isEqualToString:roomModel.name]) {
                markRoomModel = roomModel;
                break;
            }
        }
        [self.dataArray removeObject:markRoomModel];
        
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
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-50));
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self createTableFooterView];
        
    }
    
}

-(void)createTableFooterView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    footView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footView];
    
    
    UIButton *deleButton = [UIButton new];
    [footView addSubview:deleButton];
    [deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(5);
        make.left.equalTo(footView).with.offset(10);
        make.right.equalTo(footView).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [deleButton addTarget:self action:@selector(deleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    deleButton.backgroundColor = UIColorFromRGB(0xff6868);
    deleButton.layer.masksToBounds = YES;
    deleButton.layer.cornerRadius = 8;
    [deleButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleButton.titleLabel.font=[UIFont systemFontOfSize:15];
    
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
    
    AddRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditRoomTableViewCell"];
    if (!cell) {
        cell = [[AddRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditRoomTableViewCell"];
    }
#ifdef __SBApplianceEngine__HaveData__
    RoomModel *roomModel = self.dataArray[indexPath.row];
    cell.textLabel.text = roomModel.name;
    
#else
    
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif
    
    return cell;
}

#pragma mark - 切换房间、更换房间
//选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddRoomTableViewCell *cell = (AddRoomTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
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
    
#ifdef __SBApplianceEngine__HaveData__
    
//    [self showHud];
    
    RoomModel *selectRoomModel = self.dataArray[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiReNameRoom:) name:kNotifi_SBApplianceEngineCallBack_Event_ReNameRoom object:nil];
    [SBApplianceEngineMgr reNameRoom:self.roomModel.roomID newRoomType:selectRoomModel.type newRoomName:selectRoomModel.name];
#else
    
#endif
    
}
-(void)notifiReNameRoom:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_ReNameRoom object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"改变房间成功" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else{
        
        JSError(@"ReNameRoom", @"reName room fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"改变房间失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}

#pragma mark - 删除房间
-(void)deleBtnClick:(UIButton *)btn{
    
    //最后一个房间不可删
    if (1 == self.roomsUsedArray.count) {
        [self.view makeToast:@"最后一个房间不可删除" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    //有设备不可删
    if (self.isHaveDeviceCurrentRoom) {
        [self.view makeToast:@"房间内有设备，不可删除" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [self showHud];
    [SBApplianceEngineMgr removeRoom:self.roomModel.roomID withSuccessBlock:^{
        [self hideHud];
        [self.view makeToast:@"删除房间成功" duration:1.0 position:CSToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];

    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:@"删除房间失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    
    
}


#pragma  mark - leftItemClicked 返回
- (void)leftItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}









// 接口方法  房间推送
//注意dict中model可能为空
-(void)updateRoomNotifi:(NSMutableDictionary *)notifiDict{
    
    self.roomsUsedArray = notifiDict[kNotifi_UpdateRoom_Notifi_roomsUsedArray];
    
    //去除已用房间
    [self removeUsedRoomInDataArrayEditRoomVC];
    
    JSDebug(@"updateRoomNotifi", @" room count(can be used to add room) %lu",(unsigned long)self.dataArray.count);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if (0 == self.dataArray.count) {
            [self.view makeToast:@"暂没有可用于修改的房间" duration:1.0 position:CSToastPositionCenter];
        }
        
        [self.tableView reloadData];
        
    });
    
    
}


// 接口方法  家电设备推送
//注意dict中model可能为空
-(void)updateDeviceNotifi:(NSMutableDictionary *)notifiDict{
    
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
