//
//  ApplianceModel.h
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomModel.h"

@interface ApplianceModel : NSObject

//要不要boxSN？？？？

//@property (nonatomic, strong) NSNumber *brandID;
@property (nonatomic) int brandID;
@property (nonatomic, copy) NSString *deviceID;  //服务器生成的
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic) BOOL isNeedPwd;
@property (nonatomic, copy) NSString *deviceInherentID;  //设备固有ID 只有智能设备有 红外设备没有
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;     //infrared  wifi redstar normal

@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *roomName;

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *status;
@property (nonatomic) BOOL isEnable;
@property (nonatomic, copy) NSString *applianceId; //prosn
//所属pro的SN
@property (nonatomic, copy) NSString *controlledByProSN;
@property (nonatomic, copy) NSString *learnCode;//小智学习code

@property (nonatomic, strong) NSArray *plugArray;  //若此设备是插座，表示插座所有的插孔
@property (nonatomic, strong) NSArray *channelArray;

//恬家红外设备类型
@property (nonatomic, copy) NSString *machineType;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)initWithDeviceDic:(NSDictionary *)deviceDic;
- (instancetype)initWithApplianceDic:(NSDictionary *)appliance roomModel:(RoomModel *)roomModel;
@end
