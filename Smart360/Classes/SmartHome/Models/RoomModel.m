//
//  RoomModel.m
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "RoomModel.h"

@implementation RoomModel
- (instancetype)initWithDic:(NSDictionary *)roomDic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:roomDic];
        self.roomID = roomDic[@"id"];
        self.ProSN = @"";
        self.redSatelliteID = @"";
        self.alias = @"";

    }
    return self;
}


- (instancetype)initWithDic:(NSDictionary *)roomDic roomAppliances:(NSDictionary *)appliances {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:roomDic];
        self.roomID = roomDic[@"id"];
        self.ProSN = appliances[@"proApplianceId"];
        if ([appliances[@"type"] isEqualToString:@"redstar"]) {
            self.redSatelliteID = appliances[@"applianceId"];
        } else {
            self.redSatelliteID = @"";
        }
        
        
    }
    return self;

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@,type: %@,roomID: %@,roomName: %@,alias: %@",_name,_type,_roomID,_name,_alias];
}


@end
