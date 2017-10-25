//
//  MatchProcessInfraredViewController.h
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
@class MatchInfoModel;
@class DeviecNameTypeModel;

@interface MatchProcessInfraredViewController : JSBaseViewController

@property (nonatomic, strong) MatchInfoModel *matchInfoModel;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, strong) DeviecNameTypeModel *deviceNameTypeModel;


@property (nonatomic, copy) NSString *roomID;


@end
