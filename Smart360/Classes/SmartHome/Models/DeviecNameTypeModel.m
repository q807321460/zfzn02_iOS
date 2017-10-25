//
//  DeviecNameTypeModel.m
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import "DeviecNameTypeModel.h"
#import "ApplianceModel.h"

@implementation DeviecNameTypeModel

- (instancetype)initWithApplianceModel:(ApplianceModel *)applianceModel {
    self = [super init];
    if (self) {
        _deviceType = applianceModel.deviceType;
        _deviceName = applianceModel.name;
        _deviceAlias = applianceModel.alias;
        _machineType = @([applianceModel.machineType integerValue]);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"_deviceName = %@, _deviceType = %@, _deviceAlias = %@",_deviceName, _deviceType, _deviceAlias];
}

@end
