//
//  RoomModel.h
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModel : NSObject

//@property (nonatomic, copy) NSString *boxSN;

@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *alias;

//
@property (nonatomic, copy) NSString *redSatelliteID;
@property (nonatomic, copy) NSString *ProSN;

- (instancetype)initWithDic:(NSDictionary *)roomDic;
- (instancetype)initWithDic:(NSDictionary *)roomDic roomAppliances:(NSDictionary *)appliances;

@end
