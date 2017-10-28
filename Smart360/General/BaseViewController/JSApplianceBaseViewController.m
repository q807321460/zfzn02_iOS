//
//  JSApplianceBaseViewController.m
//  Smart360
//
//  Created by michael on 15/12/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSApplianceBaseViewController.h"

#import "ApplianceModel.h"
#import "RoomContainApplianceModel.h"
#import "RoomModel.h"






@interface JSApplianceBaseViewController ()


@property (nonatomic, strong) NSMutableArray *updateRoomArray;
@property (nonatomic, strong) NSMutableArray *updateDeviceArray;



@end

@implementation JSApplianceBaseViewController



//说明： 在viewWillDisappear时最好不要全部移除notifi，除非确实是最后一个界面（因为前面的界面还需要数据刷新，同理通知在viewDidLoad中addObserv）

// SmartHomeVC 没有继承此base

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.updateRoomArray) {
        self.updateRoomArray = [[NSMutableArray alloc] init];
        self.updateDeviceArray = [[NSMutableArray alloc] init];
    }
    
    
    
    //房间信息改变 推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiUpdateArchRoomHomeBaseVC:) name:kNotifi_SBApplianceEngineCallBack_Event_UpdateArchRoom object:nil];
    //家电设备信息变化 推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiUpdateArchApplianceDeviceHomeBaseVC:) name:kNotifi_SBApplianceEngineCallBack_Event_UpdateArchApplianceDevice object:nil];
    
}


#pragma mark - 房间信息改变 推送
-(void)notifiUpdateArchRoomHomeBaseVC:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.updateRoomArray = dict[kSBEngine_Data];
        
        JSDebug(@"HomeBaseVC_UpdateRoom", @"room count : %lu",(unsigned long)self.updateRoomArray.count);
        
        NSMutableDictionary * notifiRoomDict = [self getNotifiDict_UpdateRoom_WithArchArray:self.updateRoomArray];
        
        [self updateRoomNotifi:notifiRoomDict];
        
    }else{
        
        JSError(@"HomeBaseVC_UpdateRoom", @"HomeBaseVC_UpdateRoom fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.view makeToast:@"房间信息变化推送失败" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}

#pragma mark - 家电设备信息改变 推送
-(void)notifiUpdateArchApplianceDeviceHomeBaseVC:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        self.updateDeviceArray = dict[kSBEngine_Data];
        
        JSDebug(@"HomeBaseVC_UpdateDevice", @"room count : %lu",(unsigned long)self.updateDeviceArray.count);
        
        NSMutableDictionary * notifiRoomDict = [self getNotifiDict_UpdateRoom_WithArchArray:self.updateDeviceArray];
        
        [self updateDeviceNotifi:notifiRoomDict];
        
        
        
        
    }else{
        
        JSError(@"HomeBaseVC_UpdateDevice", @"HomeBaseVC_UpdateDevice fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.view makeToast:@"家电设备信息变化推送失败" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}




#pragma mark - 接口方法  房间推送

-(void)updateRoomNotifi:(NSMutableDictionary *)notifiDict{
    //注意 dict中 notifiApplianceModel、 roomContainApplianceModel可能为nil
}



#pragma mark - 接口方法  家电设备推送
-(void)updateDeviceNotifi:(NSMutableDictionary *)notifiDict{
    //注意 dict中 notifiApplianceModel、 roomContainApplianceModel 可能为nil
}




#pragma mark - 房间推送 数据处理
-(NSMutableDictionary *)getNotifiDict_UpdateRoom_WithArchArray:(NSArray *)archArray{
    
    NSMutableArray *roomsUsedArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjects:@[roomsUsedArray] forKeys:@[kNotifi_UpdateRoom_Notifi_roomsUsedArray]];
    
    for (RoomContainApplianceModel *roomContainApplianceModel in archArray) {
        
        //获取roomsUsedArray
        [roomsUsedArray addObject:roomContainApplianceModel.roomModel];
        
        //设备有关详情界面applianceModel
        if ([self.applianceModel.roomID isEqualToString:roomContainApplianceModel.roomModel.roomID]) {
            //当前设备的房间
            
            [dict setValue:roomContainApplianceModel forKey:kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel];
            
            //获取当前设备的model信息
            for (ApplianceModel *notifiApplianceModel in roomContainApplianceModel.applianceModelArray) {
                if ([self.applianceModel.deviceID isEqualToString:notifiApplianceModel.deviceID]) {
                    
                    [dict setValue:notifiApplianceModel forKey:kNotifi_UpdateRoom_Notifi_ApplianceModel];
                    break;
                }
            }

        }
    
    
    }
    
    [dict setValue:roomsUsedArray forKey:kNotifi_UpdateRoom_Notifi_roomsUsedArray];
    
    return dict;
}




#pragma mark - 家电设备推送 数据处理














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
