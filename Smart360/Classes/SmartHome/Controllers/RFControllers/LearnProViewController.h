//
//  LearnProViewController.h
//  Smart360
//
//  Created by michael on 16/1/22.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
@class ApplianceModel;

@interface LearnProViewController : JSBaseViewController

@property (nonatomic) BOOL isAddDevice;
@property (nonatomic, strong) ApplianceModel *applianceModel;

@end
