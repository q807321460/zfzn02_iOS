//
//  SBAEngineDataMgr.m
//  Smart360
//
//  Created by michael on 15/11/23.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SBAEngineDataMgr.h"

#import "RoomContainApplianceModel.h"
#import "ApplianceModel.h"
#import "DevicesOfBrandModel.h"
#import "PlugModel.h"
#import "DeviecNameTypeModel.h"
#import "ProRoomModel.h"



@implementation SBAEngineDataMgr

//插座上面添加的设备 类型
+(NSMutableArray *)getTypesNormalPlugsDevices:(NSMutableArray *)array{
    
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    
    for (ApplianceModel *applianceModel in array) {
        
        if ([applianceModel.type isEqualToString:kApplianceType_normal]) {
            if ([resArray containsObject:applianceModel.deviceType]) {
                
            }else{
                //不包含这个设备类型
                [resArray addObject:applianceModel.deviceType];
            }
        }
    }
    
    return resArray;
}




//数据结构转换 ApplianceModel ---> DevicesOfBrandModel
// 智能 WiFi
+(NSMutableArray *)getBrandsContainAppliancesArray:(NSMutableArray *)array{
    
    NSMutableArray *resArray = [NSMutableArray new];
    
    ApplianceModel *applianceModel = [[ApplianceModel alloc] init];
    
    for (int i=0; i<array.count; i++) {
        
        applianceModel = array[i];
        
        if ([applianceModel.type isEqualToString:kApplianceType_wifi]) {
            
            DevicesOfBrandModel *devicesOfBrandModel = [[DevicesOfBrandModel alloc] init];
            devicesOfBrandModel.brandName = applianceModel.brandName;
            devicesOfBrandModel.brandID = applianceModel.brandID;
            devicesOfBrandModel.isNeedPwd = applianceModel.isNeedPwd;
            
            JSDebug(@"SBAEngineDataMgr_Wifi__", @"brandID:%d, brandName:%@, isNeedPwd:%d",applianceModel.brandID,applianceModel.brandName,applianceModel.isNeedPwd);
            
            NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
            for (DevicesOfBrandModel *repeatModel in resArray) {
                [repeatArray addObject:repeatModel.brandName];
            }
            
            if ([repeatArray containsObject:devicesOfBrandModel.brandName]) {
                
            }else{
                [resArray addObject:devicesOfBrandModel];
            }
            
            
            
        }
        
    }
    
    return resArray;
}


//数据结构转换 ApplianceModel ---> DeviecNameTypeModel
// RedStar infrared 、 Pro infrared 、 RF
+(NSMutableArray *)getTypesContainBrandArray:(NSMutableArray *)array type:(NSString *)type{
    
    NSMutableArray *resArray = [NSMutableArray new];
    
    ApplianceModel *applianceModel = [[ApplianceModel alloc] init];
    
    for (int i=0; i<array.count; i++) {
        applianceModel = array[i];
        
        if ([applianceModel.type isEqualToString:type]) {
            
            DeviecNameTypeModel *deviecNameTypeModel = [[DeviecNameTypeModel alloc] init];
            deviecNameTypeModel.deviceType = applianceModel.deviceType;
            deviecNameTypeModel.deviceName = applianceModel.name;
            deviecNameTypeModel.deviceAlias = applianceModel.alias;
            
            JSDebug(@"SBAEngineDataMgr_Infrared_ProInfrared_RF__", @"deviceType:%@, deviceName:%@, deviceAlias:%@",applianceModel.deviceType,applianceModel.name,applianceModel.alias);
            
            NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
            for (DeviecNameTypeModel *repeatModel in resArray) {
                [repeatArray addObject:repeatModel.deviceType];
            }
            
            if ([repeatArray containsObject:deviecNameTypeModel.deviceType]) {
                
            }else{
                [resArray addObject:deviecNameTypeModel];
            }
            
        }
        
    }
    return resArray;
}


// 匹配家电名字和对应图片
+(UIImage *)matchIconNameWithApplianceName:(ApplianceModel *)applianceModel{
    
    
    NSArray *applianceNameArray = @[kApplianceDeviceType_Pro,kApplianceDeviceType_IPTV,kApplianceType_redstar,kApplianceDeviceType_TV,kApplianceDeviceType_TV_0,kApplianceDeviceType_AirConditioner,kApplianceDeviceType_Light,kApplianceDeviceType_InfraredLamp,kApplianceDeviceType_Plug,kApplianceDeviceType_Refrigerator,kApplianceDeviceType_Fan,kApplianceDeviceType_PowerAmplifier,kApplianceDeviceType_InternetBox,kApplianceDeviceType_SetTopBox,kApplianceDeviceType_Oven,kApplianceDeviceType_AirBox,kApplianceDeviceType_WaterHeater,kApplianceDeviceType_DigitalCamera,kApplianceDeviceType_Projector,kApplianceDeviceType_WashingMachine,kApplianceDeviceType_RemoteControlBao,kApplianceDeviceType_RemoteControlMachine,kApplianceDeviceType_Host,kApplianceDeviceType_DVD];
    
    //图片 数组 不能改
    NSArray *iconNameArray = @[@"RMpro",@"机顶盒",@"红卫星",@"电视",@"电视",@"空调",@"灯",@"灯",@"插座",@"冰箱",@"风扇",@"功放",@"互联网盒子",@"机顶盒",@"烤箱",@"空气盒子",@"热水器",@"数码相机",@"投影仪",@"洗衣机",@"遥控宝",@"遥控器",@"主机",@"DVD"];
    
    //匹配红卫星
    if ([applianceNameArray containsObject:applianceModel.type]) {
        unsigned long markIndex = [applianceNameArray indexOfObject:applianceModel.type];
        return IMAGE(iconNameArray[markIndex]);
    }
    
    if ([applianceNameArray containsObject:applianceModel.deviceType]) {
        unsigned long markIndex = [applianceNameArray indexOfObject:applianceModel.deviceType];
        return IMAGE(iconNameArray[markIndex]);
    }
    
    //匹配灯，含灯的都是这个icon
    NSRange range = [applianceModel.deviceType rangeOfString:@"开"];
    if (range.length > 0) {
        return IMAGE(@"灯");
    }


//    if ([applianceModel.deviceType containsString:@"灯"]) {
//        return IMAGE(@"灯");
//    }
    
#warning 此处注意 匹配不到icon时返回此icon
    return IMAGE(@"Home_Ico_add");
    
}


// 匹配家电名字
+(NSString *)matchNameWithApplianceModel:(ApplianceModel *)applianceModel{
    
    
//    JSDebug(@"MatchName", @"applianceModel.deviceType:%@, name:%@",applianceModel.deviceType,applianceModel.name);
    
    if ([applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
        
        if (applianceModel.plugArray.count == 1) {
            
            PlugModel *plugModel = applianceModel.plugArray[0];
            
//            JSDebug(@"MatchName", @"plugModel: device name:%@",plugModel.name);
            return plugModel.name;
        }else{
            
//            JSDebug(@"MatchName", @"multi plug : device count:%lu",(unsigned long)applianceModel.plugArray.count);
#warning 此处为多插排的情况
            return applianceModel.name;
        }
        
    }else{
        return applianceModel.name;
    }

    
}


// 是否有红外设备
+(BOOL)haveInfraredApplianceWithRoomContainApplianceModel:(RoomContainApplianceModel *)roomContainApplianceModel{
    
    for (ApplianceModel *applianceModel in roomContainApplianceModel.applianceModelArray) {
        if ([applianceModel.type isEqualToString:kApplianceType_infrared]) {
            //是红外设备
            return YES;
        }
    }
    return NO;
}

//是否有 Pro 及所在房间信息
//dict 中有： 是哪种控制器、pro的个数房间信息
+(NSDictionary *)getIsProOrRedSatelliteRoomInfo:(NSString *)roomID archArray:(NSArray *)archArray;{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *proRoomArray = [[NSMutableArray alloc] init];
    
    for (RoomContainApplianceModel *roomContainApplianceModel in archArray) {
        if ([roomContainApplianceModel.roomModel.roomID isEqualToString:roomID]) {
            ProRoomModel *proRoomModel = [[ProRoomModel alloc] init];
            proRoomModel.proSN = @"123456789";
            proRoomModel.roomID = roomContainApplianceModel.roomModel.roomID;
            proRoomModel.roomName = roomContainApplianceModel.roomModel.name;
            [proRoomArray addObject:proRoomModel];
            //本房间
            if (0 == roomContainApplianceModel.roomModel.redSatelliteID.length) {
                if (0 == roomContainApplianceModel.roomModel.ProSN.length) {
                    [dict setValue:@"" forKey:kAddType_CurrentRoom_DeviceControllerName];
                }else{
                    [dict setValue:kApplianceDeviceType_Pro forKey:kAddType_CurrentRoom_DeviceControllerName];
                    //此处若有必要可以在dict中set一个currentRoom proSN
                    //此处可能是第一个（array中0个pro），或者array中已经有pro个数不确定---（涉及选择类型是否显示射频设备！！！）
                    ProRoomModel *proRoomModel = [[ProRoomModel alloc] init];
                    proRoomModel.proSN = roomContainApplianceModel.roomModel.ProSN;
                    proRoomModel.roomID = roomContainApplianceModel.roomModel.roomID;
                    proRoomModel.roomName = roomContainApplianceModel.roomModel.name;
                    [proRoomArray addObject:proRoomModel];

                    [dict setValue:proRoomArray forKey:kAddType_ProRoomModelArray];

                    return dict;
                }
            }else{
                [dict setValue:kApplianceType_redstar forKey:kAddType_CurrentRoom_DeviceControllerName];
            }
            
        }
        else{
            //其他房间
            if (roomContainApplianceModel.roomModel.ProSN.length > 0) {
                //有Pro
                ProRoomModel *proRoomModel = [[ProRoomModel alloc] init];
                proRoomModel.proSN = roomContainApplianceModel.roomModel.ProSN;
                proRoomModel.roomID = roomContainApplianceModel.roomModel.roomID;
                proRoomModel.roomName = roomContainApplianceModel.roomModel.name;
                [proRoomArray addObject:proRoomModel];
            }
        }
    }
    
    [dict setValue:proRoomArray forKey:kAddType_ProRoomModelArray];
    
    return dict;
}


//由ProSN得到此pro所在房间Name
+(NSString *)getProRoomNameWithProSN:(NSString *)proSN archArray:(NSArray *)archArray{
    
    for (RoomContainApplianceModel *roomContainApplianceModel in archArray) {
        if ([roomContainApplianceModel.roomModel.ProSN isEqualToString:proSN]) {
            return roomContainApplianceModel.roomModel.name;
        }
    }
    
    
    
    return nil;
}

+(NSString *)getProRoomNameWithRoomId:(NSString *)roomId archArray:(NSArray *)archArray{
    
    for (RoomContainApplianceModel *roomContainApplianceModel in archArray) {
        if ([roomContainApplianceModel.roomModel.roomID isEqualToString:roomId]) {
            return roomContainApplianceModel.roomModel.name;
        }
    }
    
    
    
    return nil;
}



@end
