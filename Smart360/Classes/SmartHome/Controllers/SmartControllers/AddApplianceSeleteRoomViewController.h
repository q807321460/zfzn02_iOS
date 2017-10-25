//
//  AddApplianceSeleteRoomViewController.h
//  Smart360
//
//  Created by michael on 15/12/8.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"
@class RoomModel;

typedef void(^SelecteRoomIDBlock)(RoomModel *roomModel);

@interface AddApplianceSeleteRoomViewController : JSBaseViewController

@property (nonatomic, copy) SelecteRoomIDBlock selecteRoomBlock;

@end
