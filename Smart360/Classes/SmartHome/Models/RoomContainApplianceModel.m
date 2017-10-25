//
//  RoomContainApplianceModel.m
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "RoomContainApplianceModel.h"
#import "ApplianceModel.h"

@implementation RoomContainApplianceModel

- (instancetype)initWithRoomModel:(RoomModel *)roomModel appliancesModel:(NSArray *)appliances {
    self = [super init];
    if (self) {
        self.roomModel = roomModel;
        //房间内的设备数组
        NSMutableArray *muArrayApplianceModel = [NSMutableArray new];
        for (NSDictionary *roomAppliances in appliances) {
            
            ApplianceModel *applianceModel = [[ApplianceModel alloc] initWithApplianceDic:roomAppliances roomModel:roomModel];
            applianceModel.roomID = roomAppliances[@"roomId"];
            applianceModel.roomName = roomModel.name;
            NSLog(@"%@",applianceModel);
            if ([applianceModel.roomID isEqualToString:roomModel.roomID]) {
                if ([applianceModel.type isEqualToString:kApplianceType_redstar]) {
                    //红卫星
                    [muArrayApplianceModel insertObject:applianceModel atIndex:0];
                }else{
                    [muArrayApplianceModel addObject:applianceModel];
                }
                
            }
            
        }
        self.applianceModelArray = muArrayApplianceModel;
    }
    return self;
}

@end
