//
//  ApplianceDetailViewController.h
//  Smart360
//
//  Created by michael on 15/12/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSApplianceBaseViewController.h"
#import "ApplianceModel.h"

@class RoomContainApplianceModel;

@interface ApplianceDetailViewController : JSApplianceBaseViewController

@property (nonatomic, strong) RoomContainApplianceModel *roomContainApplianceModel;
@property (nonatomic, strong) NSArray *archAllRoomArray;

@end
