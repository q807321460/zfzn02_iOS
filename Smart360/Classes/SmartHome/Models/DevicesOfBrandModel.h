//
//  DevicesOfBrandModel.h
//  Smart360
//
//  Created by michael on 15/11/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicesOfBrandModel : NSObject

@property (nonatomic, copy) NSString *brandName;
@property (nonatomic) long brandID;

@property (nonatomic) BOOL isNeedPwd;

@property (nonatomic, strong) NSArray *applianceArray;


- (instancetype)initWthTJBrand:(NSDictionary *)brand;


@end
