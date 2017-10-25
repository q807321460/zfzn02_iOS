//
//  SelecteChannelViewController.h
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSApplianceBaseViewController.h"
@class DeviecNameTypeModel;
@class ApplianceModel;

@interface SelecteChannelViewController : JSApplianceBaseViewController

@property (nonatomic, assign) BOOL isFirstAdd;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, copy) NSString *roomID;

@property (nonatomic, strong) DeviecNameTypeModel *deviceNameTypeModel;

@end
