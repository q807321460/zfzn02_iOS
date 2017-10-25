//
//  SBAEngineDataMgr.h
//  Smart360
//
//  Created by michael on 15/11/23.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplianceModel;
@class RoomContainApplianceModel;

@interface SBAEngineDataMgr : NSObject

//数据结构转换 ApplianceModel ---> DevicesOfBrandModel
+(NSMutableArray *)getBrandsContainAppliancesArray:(NSMutableArray *)array;



//数据结构转换 ApplianceModel ---> BrandsOfOneTypeModel
+(NSMutableArray *)getTypesContainBrandArray:(NSMutableArray *)array type:(NSString *)type;

//数据结构转换  ApplianceModel ---> NSString
+(NSMutableArray *)getTypesNormalPlugsDevices:(NSMutableArray *)array;



// 匹配家电名字和对应图片
+(UIImage *)matchIconNameWithApplianceName:(ApplianceModel *)applianceModel;

// 匹配家电名字
+(NSString *)matchNameWithApplianceModel:(ApplianceModel *)applianceModel;


// 是否有红外设备
+(BOOL)haveInfraredApplianceWithRoomContainApplianceModel:(RoomContainApplianceModel *)roomContainApplianceModel;

//是否有 Pro 及所在房间信息
+(NSDictionary *)getIsProOrRedSatelliteRoomInfo:(NSString *)roomID archArray:(NSArray *)archArray;

//由ProSN得到此pro所在房间Name
+(NSString *)getProRoomNameWithProSN:(NSString *)proSN archArray:(NSArray *)archArray;

+(NSString *)getProRoomNameWithRoomId:(NSString *)roomId archArray:(NSArray *)archArray;

@end
