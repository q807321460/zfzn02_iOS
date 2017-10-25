//
//  SBApplianceEngineMgr.m
//  Smart360
//
//  Created by michael on 15/11/5.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SBApplianceEngineMgr.h"

//#include "SBApplianceEng_Interface.h"

//#include "SBEngine.h"

#import "ApplianceModel.h"
#import "DevicesOfBrandModel.h"
#import "BrandAccountModel.h"
#import "RoomModel.h"
#import "RoomContainApplianceModel.h"
#import "PlugModel.h"
#import "ChannelModel.h"
#import "MatchInfoModel.h"
#import "MatchResultModel.h"
#import "DeviecNameTypeModel.h"

#import "FuncProModel.h"

@implementation SBApplianceEngineMgr

//数据结构转换 ApplianceModel ---> DevicesOfBrandModel
+(NSMutableArray *)getBrandsContainAppliancesArray:(NSMutableArray *)array{
    
    NSMutableArray *resArray = [NSMutableArray new];
    
    for (int i=0; i<array.count; i++) {
        
        ApplianceModel *applianceModel = [[ApplianceModel alloc] init];
        applianceModel = array[i];
        
        if (0 == i) {
            DevicesOfBrandModel *devicesOfBrandModel = [[DevicesOfBrandModel alloc] init];
            devicesOfBrandModel.brandName = applianceModel.brandName;
            devicesOfBrandModel.brandID = applianceModel.brandID;
            devicesOfBrandModel.isNeedPwd = applianceModel.isNeedPwd;
            NSMutableArray *muArrayAppliance = [NSMutableArray new];
            [muArrayAppliance addObject:applianceModel];
            devicesOfBrandModel.applianceArray = muArrayAppliance;
            
            [resArray addObject:devicesOfBrandModel];
        }else{
            
            BOOL isHaveThisBrand = NO;
            int jMark = -1;
            
            for (int j=0; j<resArray.count; j++) {
                
                DevicesOfBrandModel *devicesOfBrandModel = [[DevicesOfBrandModel alloc] init];
                devicesOfBrandModel = resArray[j];
                
                isHaveThisBrand = [applianceModel.brandName isEqualToString:devicesOfBrandModel.brandName];
                if (isHaveThisBrand) {
                    jMark = j;
                    break;
                }
            }
            if (-1 == jMark) {
                //不包含this brand
                DevicesOfBrandModel *devicesOfBrandModel = [[DevicesOfBrandModel alloc] init];
                devicesOfBrandModel.brandName = applianceModel.brandName;
                devicesOfBrandModel.brandID = applianceModel.brandID;
                devicesOfBrandModel.isNeedPwd = applianceModel.isNeedPwd;
                NSMutableArray *muArrayAppliance = [NSMutableArray new];
                [muArrayAppliance addObject:applianceModel];
                devicesOfBrandModel.applianceArray = muArrayAppliance;
                
                [resArray addObject:devicesOfBrandModel];
                
            }else{
                //包含this brand
                DevicesOfBrandModel *devicesOfBrandModel = [[DevicesOfBrandModel alloc] init];
                devicesOfBrandModel = resArray[jMark];
                NSMutableArray *devicesOfBrandModelApplianceArray = [[NSMutableArray alloc] initWithArray:devicesOfBrandModel.applianceArray];
                [devicesOfBrandModelApplianceArray addObject:applianceModel];
                devicesOfBrandModel.applianceArray = devicesOfBrandModelApplianceArray;
#warning 若brand本应有多个而UI只显示一个说明此处还需对resArray[jMark]进行替换devicesOfBrandModel <备注>
                
            }
            
        }
        
    }
    
    return resArray;
}


#pragma mark - 删除房间设备
+ (void)deleteAppliance:(NSDictionary *)appliance withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock{
    NSDictionary *dic = @{@"commandType":@"assistantUnregisterDeviceCmd",@"Appliance":appliance,@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            
            if (successBlock) {
                successBlock();
            }
            
            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"删除设备失败，请稍后再试");
        }
        
    }];

}

#pragma mark - 添加房间
+ (void)addRoom:(NSDictionary *)roomInfo withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock{
    NSDictionary *dic = @{@"commandType":@"assistantAddRoomCmd",@"RoomInfo":roomInfo};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            
            if (successBlock) {
                successBlock();
            }
            
            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"添加房间失败，请稍后再试");
        }
        
    }];

}

#pragma mark - 删除房间
+ (void)removeRoom:(NSString *)roomID withSuccessBlock:(void (^)(void))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSDictionary *dic = @{@"commandType":@"assistantRemoveRoomCmd",@"RoomInfo":@{@"id":roomID,@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN}};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            
            if (successBlock) {
                successBlock();
            }
            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"删除房间失败，请稍后再试");
        }
        
    }];
    
}

#pragma mark - 获取房间列表
+ (void)getRoomListWithSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSDictionary *dic = @{@"commandType":@"assistantDownloadRoomListCmd",@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            NSMutableArray *roomArray = [NSMutableArray array];
            NSDictionary *content = resultDic[@"content"];
            for (NSDictionary *room in content[@"rooms"]) {
                RoomModel *roomModel = [[RoomModel alloc] initWithDic:room];
                [roomArray addObject:roomModel];
            }
            if (successBlock) {
                successBlock(roomArray);
            }
            
            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];
    
}


#pragma mark - 获取 控制指令
//+ (kResult)getCtrlCmd:(NSString *)deviceID
+ (void)getApplianceCtrlCmd:(NSString *)deviceID withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSDictionary *dic = @{@"commandType":@"assistantCommandListCmd",@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN,@"Appliance":@{@"id":deviceID}};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            NSArray *commands = resultDic[@"content"][@"commands"];
            NSString *commandStr = @"";
            if (commands.count > 0) {
                NSMutableArray *cmdarrTemp = [NSMutableArray array];
                for (NSDictionary *cmd in commands) {
                    NSString *cmdStr = cmd[@"cmd"];
                    [cmdarrTemp addObject:cmdStr];
                }
                
                commandStr = [cmdarrTemp componentsJoinedByString:@"、"];
                 commandStr = [NSString stringWithFormat:@"%@%@%@",@"语音控制说明：",commandStr,@"。"];
            }
            if (successBlock) {
                successBlock(commandStr);
            }
            
            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];
    
}
#pragma mark - 恬家
#pragma mark - 获取红外设备
+ (void)getInfraredDevicesWithSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSDictionary *dic = @{@"commandType":@"assistantDownloadDeviceListCmd",@"type":@"infrared"};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            NSMutableArray *deviceArray = [NSMutableArray array];
            for (NSDictionary *dic in resultDic[@"content"][@"appliances"]) {
                NSArray *arr = dic[@"applianceDevs"];
                NSDictionary *temDic = arr[0];
                NSLog(@"%@##########%@",temDic[@"name"],temDic[@"applianceType"]);
                ApplianceModel *applianceModel = [[ApplianceModel alloc] initWithDeviceDic:dic];
                DeviecNameTypeModel *deviceNameTypeModel = [[DeviecNameTypeModel alloc] initWithApplianceModel:applianceModel];
                [deviceArray addObject:deviceNameTypeModel];
            }
            
            if (successBlock) {
                successBlock(deviceArray);
            }

            
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];

}
#pragma mark - 获取某品牌未配置的家电设备
+ (void)getUnregistDevicesOfOneBrandWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"" success:^(NSURLSessionDataTask *, id responseObject) {
        
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSString *str = [JSUtility jsonStringWithObj:responseObject error:nil];
        NSLog(@"服务器返回response json格式: %@", str);
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                NSDictionary *dic = resultDic[@"content"];
//                NSDictionary *result = dic[@"Appliance"];
                successBlock(dic);
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *) {
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];
    
}


#pragma mark - 获取品牌列表

+ (void)getBrandListOfDeviceTypeInfrared:(NSString *)deviceType withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock{
    NSDictionary *dic = @{@"commandType":@"assistantInfraredGetBrandCmd",@"applianceType":deviceType};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"查询品牌列表失败");
        }

    }];

}

#pragma mark - 型号搜索
+ (void)modelSearchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"发送成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"型号搜索失败");
        }

    }];
}


#pragma mark - 型号搜索结果的确认
//confirmModelSearchInfrared
+ (void)confirmModelSearchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(resultDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        NSLog(@"%@",error.domain);
        if (failBlock) {
            failBlock(@"遥控器下载失败");
        }

    }];
}


#pragma mark - 红卫星添加前 config
+ (void)redSatelliteConfigWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"配置红卫星成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"配置红卫星失败");
        }

    }];
    
}



#pragma mark - 添加红卫星
+ (void)addRedSatellite:(NSString *)roomID devID:(NSString *)devID withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    
    unsigned long devIdLong = strtoul([devID UTF8String], 0, 16);
    NSString *redSatelliteID = [NSString stringWithFormat:@"%lu",devIdLong];
    
    NSDictionary *dic = @{@"commandType": @"assistantRegisterDeviceCmd",@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN,@"Appliance":@{@"roomId":roomID,@"brandId":@"",@"brand":@"",@"applianceId":redSatelliteID,@"applianceType":@"",@"proApplianceId":@"",@"name":@"红卫星",@"type":@"redstar",@"alias":@"红卫星",@"enable":@"",@"belongs":@[],@"channels":	@[]}};

    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"添加红卫星失败");
        }

    }];
}

#pragma mark - 修改频道
//modifyDevNormalChannelsCmd
+ (void)modifyDevNormalChannelsBrandName:(NSString *)brandName deviceName:(NSString *)deviceName devType:(NSString *)devType devID:(NSString *)devId channelArray:(NSArray *)channelArray withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSMutableArray *channelOfTV = [NSMutableArray array];
    for (ChannelModel *channelModel in channelArray) {
        NSDictionary *channelDic = @{@"channel":channelModel.channel,@"name":channelModel.name};
        [channelOfTV addObject:channelDic];
    }
    NSDictionary *dic = @{@"commandType":@"modifyDevNormalChannelsCmd",@"boxSN":[JSSaveUserMessage sharedInstance].currentBoxSN,@"brandId":@"",@"brand":brandName,@"applianceId":devId,@"applianceType":devType,@"name":deviceName,@"type":@"infrared",@"applianceServerId":devId,@"alias":deviceName,@"channels":channelOfTV};
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            if (successBlock) {
                successBlock(@"更新频道成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        NSLog(@"%@",error.domain);
        if (failBlock) {
            failBlock(@"设置频道失败");
        }
        
    }];

}

#pragma mark - 开始模糊搜索匹配
+ (void)startFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
//                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        NSLog(@"%@",error.domain);
        if (failBlock) {
            failBlock(@"搜索失败");
        }

    }];
}


#pragma mark - 模糊搜索 点击开机等操作
+ (void)fuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                //                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"");
        }

    }];
}

#pragma mark -红外操作响应错误
+ (void)wrongFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                //                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"");
        }

    }];
}

#pragma mark -红外操作响应正确
+ (void)rightFuzzyMatchInfrared:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                //                successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"");
        }

    }];
}



#pragma mark - 添加红外设备
+ (void)addInfraredDevice:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                 successBlock(@"添加成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        if (failBlock) {
            failBlock(@"红外设备添加失败");
        }

    }];
}

#pragma mark - 获取智能家居列表
+ (void)getSmartHomeDeviceListWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSMutableArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                NSDictionary *content = resultDic[@"content"];
                NSLog(@"房间信息%@",content);
                NSMutableArray *resultArray = [NSMutableArray array];
                 NSMutableArray *emptyAppliancesRoom = [NSMutableArray array];
                //房间内设备
                NSArray *appliances = content[@"appliances"];
                for (NSDictionary *room in content[@"rooms"]) {
                    
                    NSDictionary *roomApplianceInfo = [NSDictionary dictionary];
//                    BOOL isRedstar;
                    for (NSDictionary *roomAppliances in appliances) {
                        NSLog(@"%@",roomAppliances[@"alias"]);
                        if ([roomAppliances[@"roomId"] isEqualToString:room[@"id"]] && [roomAppliances[@"type"] isEqualToString:@"redstar"]) {
                            roomApplianceInfo = roomAppliances;
//                            isRedstar = YES;
                            break;
                        }
                    }
                    RoomModel *roomModel = [[RoomModel alloc] initWithDic:room roomAppliances:roomApplianceInfo];
                    NSLog(@"%@",room[@"name"]);
                    
                    //封装房间信息
                    RoomContainApplianceModel *roomContainApplianceModel = [[RoomContainApplianceModel alloc] initWithRoomModel:roomModel appliancesModel:appliances];
                   
                    if (roomContainApplianceModel.applianceModelArray.count == 0) {
                        [emptyAppliancesRoom addObject:roomContainApplianceModel];
                        
                    } else {
                        [resultArray addObject:roomContainApplianceModel];
                    }
                    
                }
                [resultArray addObjectsFromArray:emptyAppliancesRoom];
                successBlock(resultArray);
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *) {
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];
    
}




#pragma mark - 小智内嵌射频控制器学习
+ (void)smallzhiRFStudyWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSArray *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                NSMutableArray *resultArray = [NSMutableArray array];

                successBlock(resultArray);
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }

    } failure:^(NSURLSessionDataTask *, NSError *) {
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }

    }];
    
}

#pragma mark - 添加小智内嵌射频控制器设备
+ (void)addSmallzhiRFDeviceWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                NSDictionary *dic = resultDic[@"content"];
                NSDictionary *result = dic[@"Appliance"];
                successBlock(result);
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *, NSError *) {
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
        
    }];
    
}

#pragma mark - 控制红卫星，by konnn
+ (void)testControl:(NSString *)sControlMsg withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    //    NSDictionary *dic = @{@"pkgSeqId":@"CAD92F57-7E1B-46E4-84B2-FAB7A15A3631",@"reserved1":@"",@"locationName":@"上海",@"userId":@"13523544871",@"errorMsg":@"success",@"receiveId":@0,@"appId":@"alex",@"content":@"打开空调",@"sequenceId":@1498534868666,@"sendTime":@1498534868666,@"reserved2":@"",@"pkgDirection":@"Request",@"devSN":@"D3D83849-52F2-4C83-BE1D-BB6B0A95D1B8",@"protocolVersion":@"1.0.0.0",@"sendName":@"18105631968",@"errorCode":@"0",@"sendId":@4503,@"pkgType":@"[SESSION]TxtReq",@"protocolType":@"App_Server",@"receiveName":@"talkservice",@"rootId":@"205c2730-91e9-11e6-924a-90b11c260255",@"commandType":@"APPNLPCommand",@"requestTimeStamp":@"11#41#8#6"};
    //SZB0B0A00036X
    NSDictionary *dic = @{
                          @"pkgSeqId":@"CAD92F57-7E1B-46E4-84B2-FAB7A15A3631",
                          @"reserved1":@"",
                          @"locationName":@"上海",
                          @"userId":@"18105631968",
                          @"errorMsg":@"success",
                          @"receiveId":@0,
                          @"appId":@"alex",
                          @"content":sControlMsg,
                          @"sequenceId":@1498534868666,
                          @"sendTime":@1498534868666,
                          @"reserved2":@"",
                          @"pkgDirection":@"Request",
                          @"devSN":@"D3D83849-52F2-4C83-BE1D-BB6B0A95D1B8",
                          @"protocolVersion":@"1.0.0.0",
                          @"sendName":@"18105631968",
                          @"errorCode":@"0",
                          @"sendId":@4503,
                          @"pkgType":@"[SESSION]TxtReq",
                          @"protocolType":@"App_Server",
                          @"receiveName":@"talkservice",
                          @"rootId":@"205c2730-91e9-11e6-924a-90b11c260255",
                          @"commandType":@"APPNLPCommand",
                          @"requestTimeStamp":@"11#41#8#6"
                          };
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            NSLog(@"返回成功");
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"控制红卫星失败，请稍后再试");
        }
    }];
}

#pragma mark - 根据手机号获取小智列表，by konnn
+ (void)testGetSN:(NSString *)sControlMsg withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    NSDictionary *dic = @{
                          @"osType":@"ios",
                          @"userId":@"18105631968",
                          @"appVersion":@"1.0",
                          @"protocolVersion":@"1.0.0.0",
                          @"appId":@"huawei",
                          @"sn":@"",
                          @"content":@{
                                  @"UserInfo":@{
                                          @"userName":@"guest",
                                          @"userId":@101483,
                                          @"phoneIP":@"192.168.1.41"
                                          },
                                  @"commandType":@"assistantGetDevicesCmd"
                                  },
                          @"robotId":@"1b961fee-91e9-11e6-924a-90b11c260255",
                          @"boxVersion":@""
                          };
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSLog(@"服务器返回response json格式: %@", [JSUtility jsonStringWithObj:responseObject error:nil]);
        if ([resultDic[@"status"] integerValue] == 1) {
            NSLog(@"返回成功");
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(@"获取数据失败，请稍后再试");
        }
    }];
}

//{"osType":"ios","userId":"18768957426","appVersion":"1.0","protocolVersion":"1.0.0.0","appId":"huawei","sn":"SZB0B0A00036X","content":{"UserInfo":{"userName":"guest","userId":101483,"phoneIP":"192.168.1.41"},"commandType":"assistantGetDevicesCmd"},"robotId":"1b961fee-91e9-11e6-924a-90b11c260255","boxVersion":""}

#pragma mark - Pro


@end
