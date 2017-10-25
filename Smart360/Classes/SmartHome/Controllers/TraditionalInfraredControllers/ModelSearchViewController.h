//
//  ModelSearchViewController.h
//  Smart360
//
//  Created by michael on 15/11/25.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
#import "ApplianceModel.h"
@class DeviecNameTypeModel;

@interface ModelSearchViewController : JSBaseViewController

@property (nonatomic, copy) NSString *brandName; //品牌名称
//@property (nonatomic, assign) long long brandId; //品牌id
//@property (nonatomic, assign) int tjDeviceType; //设备类型

@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, strong) TJRemotePage *tjBrandPage;



@property (nonatomic, strong) DeviecNameTypeModel *deviceNameTypeModel;

@end
