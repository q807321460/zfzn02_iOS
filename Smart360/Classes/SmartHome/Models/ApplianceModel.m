//
//  ApplianceModel.m
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "ApplianceModel.h"
#import "ChannelModel.h"

/*{
 alias = "";
 applianceId = 123456789;
 applianceType = "LED\U706f\U5e26";
 belongs =     (
 );
 brand = "\U7b2c\U4e09\U5973\U795e";
 brandId = 1;
 channels =     (
 );
 code = 5A5555010027299200AAAA;
 enable = "";
 id = 5833fcf35cc503375f6a598e;
 name = "LED\U706f\U5e26";
 proApplianceId = 123456789;
 roomId = 5833f9ad5cc503375f6a5216;
 status = "";
 type = rf;
 }*/

@implementation ApplianceModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        NSLog(@"000");
//        [self setValuesForKeysWithDictionary:dic];
//        NSLog(@"111");
        self.brandID = 1;
//        NSLog(@"222");
        self.deviceID = dic[@"id"];
        self.brandName = dic[@"brand"];
        self.deviceType = dic[@"deviceType"];
        self.roomID = dic[@"roomId"];
        self.controlledByProSN = dic[@"proApplianceId"];
        self.name = dic[@"name"];
        self.type = dic[@"type"];
        self.status = dic[@"status"];
//        self.status = dic[@"status"];
        self.alias = dic[@"alias"];
        self.applianceId = dic[@"applianceId"];
        if ([dic objectForKey:@"code"]) {
            self.learnCode = dic[@"code"];
        }

    }
    return self;
}

/*
 applianceDevs =     (
 {
 applianceType = "\U76d2\U5b50";
 name = "\U76d2\U5b50";
 type = infrared;
 }
 );
 brand = "<null>";
 brandId = "";
 id = "";
 isNeedPwd = "";
 */

- (instancetype)initWithDeviceDic:(NSDictionary *)deviceDic {
    self = [super init];
    if (self) {
        
        NSArray *applianceDevs = deviceDic[@"applianceDevs"];
        NSDictionary *applianceDevDic = applianceDevs[0];
        self.deviceType = applianceDevDic[@"applianceType"];
        self.name = applianceDevDic[@"name"];
        self.type = applianceDevDic[@"type"];
        if (applianceDevDic[@"sdk_code"]) {
            self.machineType = applianceDevDic[@"sdk_code"];
        }
        
        
        self.brandName = deviceDic[@"brand"];
        self.deviceID = deviceDic[@"id"];
        self.brandID = [deviceDic[@"brandID"] intValue];
        self.isNeedPwd = NO;
        self.alias = @"";
    }
    return self;

}




- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"applianceDevs"]) {
//        NSArray *applianceDevs = value;
//        NSDictionary *applianceDevDic = applianceDevs[0];
//        self.deviceType = applianceDevDic[@"applianceType"];
//        self.name = applianceDevDic[@"name"];
//        self.type = applianceDevDic[@"type"];
//        if (applianceDevDic[@"sdk_code"]) {
//            self.machineType = applianceDevDic[@"sdk_code"];
//        }

//    }
}


- (instancetype)initWithApplianceDic:(NSDictionary *)appliance roomModel:(RoomModel *)roomModel {
    self = [super init];
    if (self) {
        self.roomID = appliance[@"roomId"];
        self.roomName = roomModel.name;
        self.deviceType = appliance[@"applianceType"];
        self.name = appliance[@"name"];
        self.type = appliance[@"type"];
        self.brandName = appliance[@"brand"];
        self.deviceID = appliance[@"id"];
        self.brandID = [appliance[@"brandID"] intValue];
        self.isNeedPwd = NO;
        self.alias = appliance[@"alias"];
        NSMutableArray *tempArr = [NSMutableArray array];
        if (appliance[@"channels"]) {
            for (NSDictionary *dic in appliance[@"channels"]) {
                ChannelModel *channelModel = [[ChannelModel alloc] initWithDic:dic];
                [tempArr addObject:channelModel];
            }
        }
        
        self.channelArray = tempArr;
    }
    return self;
    
}
- (NSString *)description {
    return [NSString stringWithFormat:@"deviceID: %@,brandName: %@,deviceType: %@,name: %@,type: %@,roomID: %@,roomName: %@,alias: %@,status: %@,controlledByProSN: %@",_deviceID,_brandName,_deviceType,_name,_type,_roomID,_roomName,_alias,_status,_controlledByProSN];
}

@end
