//
//  DeviecNameTypeModel.h
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApplianceModel;

@interface DeviecNameTypeModel : NSObject

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceAlias;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, strong) NSNumber *machineType;

- (instancetype)initWithApplianceModel:(ApplianceModel *)applianceModel;

@end
