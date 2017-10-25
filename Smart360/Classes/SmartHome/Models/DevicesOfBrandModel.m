//
//  DevicesOfBrandModel.m
//  Smart360
//
//  Created by michael on 15/11/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "DevicesOfBrandModel.h"

@implementation DevicesOfBrandModel

- (instancetype)initWthTJBrand:(NSDictionary *)brand{
    self = [super init];
    if (self) {
        self.brandID = [brand[@""] longValue];
        self.brandName = brand[@""];
    }
    return self;
}

@end
