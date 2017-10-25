//
//  EditRoomViewController.h
//  Smart360
//
//  Created by michael on 15/12/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSApplianceBaseViewController.h"
#import "RoomModel.h"

@interface EditRoomViewController : JSApplianceBaseViewController

@property (nonatomic) BOOL isHaveDeviceCurrentRoom;
@property (nonatomic, strong) RoomModel *roomModel;
@property (nonatomic, strong) NSMutableArray *roomsUsedArray;

@end
