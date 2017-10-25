//
//  JSApplianceBaseViewController.h
//  Smart360
//
//  Created by michael on 15/12/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBoxBaseViewController.h"
@class ApplianceModel;

@interface JSApplianceBaseViewController : JSBoxBaseViewController

@property (nonatomic) BOOL isOnline;

@property (nonatomic, strong) ApplianceModel *applianceModel;

@property (nonatomic, strong) NSMutableArray *roomsUsedArrayUpdateRoom;


// 接口方法  房间推送
//注意dict中model可能为空
-(void)updateRoomNotifi:(NSMutableDictionary *)notifiDict;


// 接口方法  家电设备推送
//注意dict中model可能为空
-(void)updateDeviceNotifi:(NSMutableDictionary *)notifiDict;




@end
