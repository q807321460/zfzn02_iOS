//
//  JDDeviceInfo.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/20.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdBaseModel.h"

@interface JdDeviceInfo : JdBaseModel

@property (nonatomic,copy) NSString * hardwareVersion;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * softwareVersion;
@property (nonatomic,copy) NSString * uuid;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,assign) int onlineStatus;

+ (instancetype)deviceInfoWithDictionary:(NSDictionary *)dictionary;

@end
