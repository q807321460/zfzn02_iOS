//
//  AddPlugSingleDeviceViewController.h
//  Smart360
//
//  Created by michael on 15/12/22.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
@class ApplianceModel;

//typedef void(^SelectSinglePlugBlock)(NSString *selecteName);

@interface AddPlugSingleDeviceViewController : JSBaseViewController

//@property (nonatomic, copy) SelectSinglePlugBlock blockSelectSinglePlug;


@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, strong) ApplianceModel *applianceModel;



@end
