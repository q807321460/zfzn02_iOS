//
//  RoomContainApplianceModel.h
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoomModel.h"


@interface RoomContainApplianceModel : NSObject

@property (nonatomic, strong) RoomModel *roomModel;

@property (nonatomic, strong) NSArray *applianceModelArray;

- (instancetype)initWithRoomModel:(RoomModel *)roomModel appliancesModel:(NSArray *)appliances;

@end
