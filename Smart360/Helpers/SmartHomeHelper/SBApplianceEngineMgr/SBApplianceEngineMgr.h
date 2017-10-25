//
//  SBApplianceEngineMgr.h
//  Smart360
//
//  Created by michael on 15/11/5.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBApplianceEngineMgr : NSObject

//{
//    void *handleEngine;
//}

+ (long)createApplianceEngine:(NSString *)boxSN;

+ (long)destroyEngine;

+ (long)queryRoomsAndAppliancesUserDefined;

+ (long)addRoom:(NSString *)name type:(NSString *)type alias:(NSString *)alias;

+ (long)removeRoom:(NSString *)roomID;
//更改房间名称
+ (long)reNameRoom:(NSString *)roomID newRoomType:(NSString *)type newRoomName:(NSString *)name;
//设备更改房间
+ (long)deviceChangeRoom:(NSString *)devID newRoomID:(NSString *)newRoomID newRoomName:(NSString *)newRoomName;


+ (long)deleteAppliance:(NSString *)applianceID roomID:(NSString *)roomID;
+ (long)getRegistedBrandAccount;
+ (long)getSpecialBrandAccount:(int)brandID;


+ (long)getRoomList;

//获取 控制指令
+ (long)getCtrlCmd:(NSString *)deviceID;

#pragma mark - 添加房间
+ (void)addRoom:(NSDictionary *)roomInfo withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;
#pragma mark - 删除房间
+ (void)removeRoom:(NSString *)roomID withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;
#pragma mark - 获取房间列表
+ (void)getRoomListWithSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

/* 智能设备：搜索设备界面，红外设备：选择设备类型界面，EVENT_GETDEVICES   device type */

#pragma mark - 恬家
#pragma mark - 获取红外设备
+ (void)getInfraredDevicesWithSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

+ (long)getDeviceList;
+ (long)setBrandAccount:(int)brandID userName:(NSString *)userName password:(NSString *)password;

+ (long)addWifiDevice:(int)brandID roomID:(NSString *)roomID deviceInherentID:(NSString *)deviceInherentID devName:(NSString *)devName devAlias:(NSString *)devAlias devType:(NSString *)devType belongsArray:(NSArray *)belongsArray;   ///????

//插座更改设备
+ (long)changePlugDeviceWithDeviceID:(NSString *)deviceID deviceInherentID:(NSString *)deviceInherentID belongsArray:(NSArray *)belongsArray;
#pragma mark - 删除房间设备
+ (void)deleteAppliance:(NSDictionary *)appliance withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 获取 控制指令
//+ (long)getCtrlCmd:(NSString *)deviceID
+ (void)getApplianceCtrlCmd:(NSString *)deviceID withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 获取品牌列表

+ (void)getBrandListOfDeviceTypeInfrared:(NSString *)deviceType withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 型号搜索
+ (void)modelSearchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 型号搜索结果的确认
+ (void)confirmModelSearchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

//红卫星添加前 config
+ (long)redSatelliteConfig:(NSString *)devID;
#pragma mark - 红卫星添加前 config
+ (void)redSatelliteConfigWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

+ (long)addRedSatellite:(NSString *)roomID devID:(NSString *)devID devName:(NSString *)devName devAlias:(NSString *)devAlias;

#pragma mark - 添加红卫星
+ (void)addRedSatellite:(NSString *)roomID devID:(NSString *)devID withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 修改频道
//modifyDevNormalChannelsCmd
+ (void)modifyDevNormalChannelsBrandName:(NSString *)brandName deviceName:(NSString *)deviceName devType:(NSString *)devType devID:(NSString *)devId channelArray:(NSArray *)channelArray withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 开始模糊搜索匹配
+ (void)startFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 模糊搜索 点击开机等操作
+ (void)fuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark -红外操作响应错误
+ (void)wrongFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark -红外操作响应正确
+ (void)rightFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;


#pragma mark - 添加红外设备
+ (void)addInfraredDevice:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

//添加红外设备
+ (long)addInfraredDevice:(NSString *)roomID brandName:(NSString *)brandName deviceName:(NSString *)deviceName devAlias:(NSString *)devAlias devType:(NSString *)devType channelArray:(NSArray *)channelArray;





//智能设备 获取一个品牌未注册的设备
+ (long)getUnregistDevicesOfOneBrand:(int)brandID;
#pragma mark - 获取某品牌未配置的家电设备
+ (void)getUnregistDevicesOfOneBrandWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;


//红外设备 由deviceType得到brandlist
+ (long)getBrandListOfDeviceTypeInfrared:(NSString *)deviceType;

//型号搜索
+(long)modelSearchInfrared:(NSString *)brandName redSatelliteID:(NSString *)redSatelliteID devType:(NSString *)devType modelName:(NSString *)modelName;
//型号搜索结果的确认
+(long)confirmModelSearchInfrared:(NSString *)brandName redSatelliteID:(NSString *)redSatelliteID devType:(NSString *)devType modelName:(NSString *)modelName;

//开始模糊搜索匹配
+(long)startFuzzyMatchInfrared:(NSString *)brandName devID:(NSString *)devID devType:(NSString *)devType;
//模糊搜索 第一次点击开机
+ (long)fuzzyMatchInfrared:(NSString *)brandName redSatelliteID:(NSString *)redSatelliteID devType:(NSString *)devType;

//模糊搜索 匹配错误
+ (long)wrongFuzzyMatchInfrared:(NSString *)brandName redSatelliteID:(NSString *)redSatelliteID devType:(NSString *)devType;
//模糊搜索 匹配正确
+ (long)rightFuzzyMatchInfrared:(NSString *)brandName redSatelliteID:(NSString *)redSatelliteID devType:(NSString *)devType;

//更改 电视频道
+ (long)changChannelsInfrared:(NSString *)deviceID deviceInherentID:(NSString *)deviceInherentID devType:(NSString *)devType deviceName:(NSString *)deviceName channelArray:(NSArray *)channelArray;

#pragma mark - 获取智能家居列表
+ (void)getSmartHomeDeviceListWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSMutableArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 小智内嵌射频控制器
+ (void)smallzhiRFStudyWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 添加小智内嵌射频控制器设备
+ (void)addSmallzhiRFDeviceWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 根据手机号获取小智列表，by konnn
+ (void)testGetSN:(NSString *)sControlMsg withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

#pragma mark - 控制红卫星，by konnn
+ (void)testControl:(NSString *)sControlMsg withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock;

// Pro

//获得设备学习的详情
+ (long)getProStudyResult:(NSString *)deviceID;
//XRESULT SBApplianceEng_GetProStudyResult(XHANDLE hSBApplianceEng, const XCHAR *pcId);

//设备学习过程
+ (long)proStudy:(NSString *)deviceID ProSN:(NSString *)proSN deviceName:(NSString *)deviceName devType:(NSString *)devType functionName:(NSString *)functionName;
//XRESULT SBApplianceEng_ProStudy(XHANDLE hSBApplianceEng, const XCHAR *pcId, const XCHAR *pcProSn,
//                                const XCHAR *pcDevName,  const XCHAR *pcType, const XCHAR *pcFunctionName);

//上传学习结果
+ (long)saveProStudyResult:(NSString *)deviceID ProSN:(NSString *)proSN funArray:(NSArray *)funArray;
//XRESULT SBApplianceEng_SetProStudyResult(XHANDLE hSBApplianceEng, const XCHAR *pcProId,
//                                         APPLIANCE_PROSTUDY_STRU *pFList);

/* add a RF appliacne */
+ (long)addRF:(NSString *)roomID ProSN:(NSString *)proSN devType:(NSString *)devType devName:(NSString *)devName devAlias:(NSString *)devAlias;



@end
