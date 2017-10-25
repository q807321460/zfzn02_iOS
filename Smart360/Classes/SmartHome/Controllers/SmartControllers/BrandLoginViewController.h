//
//  BrandLoginViewController.h
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"

#import "DevicesOfBrandModel.h"

@interface BrandLoginViewController : JSBaseViewController

@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, strong) DevicesOfBrandModel *devicesOfBrandModel;

@end
