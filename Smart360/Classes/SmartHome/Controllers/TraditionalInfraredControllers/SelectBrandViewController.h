//
//  SelectBrandViewController.h
//  Smart360
//
//  Created by michael on 15/11/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
@class DeviecNameTypeModel;

@interface SelectBrandViewController : JSBaseViewController

@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, assign) int tjDeviceType;

@property (nonatomic, strong) DeviecNameTypeModel *deviceNameTypeModel;

@end
