//
//  AddRoomViewController.m
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "AddRoomViewController.h"

#import "SBApplianceEngineMgr.h"
#import "AddRoomTableViewCell.h"

#import "RoomModel.h"


@interface AddRoomViewController ()<UITableViewDataSource,UITableViewDelegate>

//得到的房间列表，原始数据
@property (nonatomic, strong) NSMutableArray *originalDataArray;
//用于tableview展示的数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath* lastIndexPath;


@end

@implementation AddRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"添加房间"];
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
        
        //去除已用房间
        [self removeUsedRoomInDataArray];
        if (0 == self.dataArray.count) {
            [self hideHud];
            [self.view makeToast:@"暂没有可用于添加的房间" duration:1.0 position:CSToastPositionCenter];
            
        }else{
            [self hideHud];
            [self.tableView reloadData];
        }

        [self hideHud];
    } withFailBlock:^(NSString *msg) {
        [self hideHud];
    }];
    
    return ;
    
#ifdef __SBApplianceEngine__HaveData__
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetRoomList:) name:kNotifi_SBApplianceEngineCallBack_Event_GetRoomList object:nil];
    [SBApplianceEngineMgr getRoomList];
    
#else
    
   self.dataArray = @[@"卧室",@"主卧",@"客卧",@"次卧",@"客厅"];
    [self hideHud];
#endif
    
    
}


-(void)notifiGetRoomList:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetRoomList object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.originalDataArray = dict[kSBEngine_Data];
        
        //去除已用房间
        [self removeUsedRoomInDataArray];
        
        JSDebug(@"AddRoomVC_GetRoomList", @"original count :%d, room count(can be used to add room) %lu",self.originalDataArray.count,(unsigned long)self.dataArray.count);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if (0 == self.dataArray.count) {
                [self hideHud];
                [self.view makeToast:@"暂没有可用于添加的房间" duration:1.0 position:CSToastPositionCenter];
                
            }else{
                [self hideHud];
                [self.tableView reloadData];
            }
            
            
        });
        
    }else{
        
        JSError(@"GetRoomList", @"get roomList fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}



-(void)removeUsedRoomInDataArray{
    
    //注意此处用copy 不能直接指向（指向时引用计数加一，data修改时original也就改了）
    self.dataArray = [NSMutableArray arrayWithArray:self.originalDataArray];
    
    
    JSDebug(@"AddRoomVC", @"removeUsedRoom : originalDataArray count :%lu , 赋值给dataArray count :%lu",self.originalDataArray.count,(unsigned long)self.dataArray.count);
    
    
    
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
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
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
    
    AddRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddRoomTableViewCell"];
    if (!cell) {
        cell = [[AddRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddRoomTableViewCell"];
    }
    
    
#ifdef __SBApplianceEngine__HaveData__
    RoomModel *roomModel = self.dataArray[indexPath.row];
    cell.textLabel.text = roomModel.name;
    
#else
    
    cell.textLabel.text = self.dataArray[indexPath.row];
#endif

    return cell;
}

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
    
    [self showHud];
    RoomModel *roomModel = self.dataArray[indexPath.row];
    NSLog(@"%@",roomModel);
    NSDictionary *roomInfo = @{@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN,@"name":roomModel.name,@"type":roomModel.type,@"alias":roomModel.alias};
    
    [SBApplianceEngineMgr addRoom:roomInfo withSuccessBlock:^{
        [self hideHud];
        
        [self.navigationController popViewControllerAnimated:YES];

    } withFailBlock:^(NSString *msg) {
        [self hideHud];
        [self.view makeToast:@"添加房间失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }];
    return;
#ifdef __SBApplianceEngine__HaveData__
    [self showHud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddRoom:) name:kNotifi_SBApplianceEngineCallBack_Event_AddRoom object:nil];
    [SBApplianceEngineMgr addRoom:roomModel.name type:roomModel.type alias:roomModel.alias];
    
    
#else
    
#endif
    
}
-(void)notifiAddRoom:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];

            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else{
        
        JSError(@"AddRoom", @"add room fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"添加房间失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddRoom object:nil];
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
    [self removeUsedRoomInDataArray];
    
    JSDebug(@"updateRoomNotifi", @" room count(can be used to add room) %lu",(unsigned long)self.dataArray.count);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if (0 == self.dataArray.count) {
            [self.view makeToast:@"暂没有可用于添加的房间" duration:1.0 position:CSToastPositionCenter];
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
