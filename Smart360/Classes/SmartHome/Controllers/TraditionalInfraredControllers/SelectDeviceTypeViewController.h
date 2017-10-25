//
//  SelectDeviceTypeViewController.h
//  Smart360
//
//  Created by michael on 15/11/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"

@interface SelectDeviceTypeViewController : JSBaseViewController

//红卫星Infrared、ProInfrared、RF
@property (nonatomic, copy) NSString *addType;


@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, copy) NSString *roomID;

//ProSN
@property (nonatomic, copy) NSString *proSN;


@end
