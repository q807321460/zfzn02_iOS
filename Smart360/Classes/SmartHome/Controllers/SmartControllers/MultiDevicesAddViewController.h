//
//  MultiDevicesAddViewController.h
//  Smart360
//
//  Created by michael on 15/12/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"

typedef void(^SelectBelongsArrayBlock)(NSArray *selecteBelongsArray);

@interface MultiDevicesAddViewController : JSBaseViewController

@property (nonatomic, copy) SelectBelongsArrayBlock selectBelongsBlock;



@end
