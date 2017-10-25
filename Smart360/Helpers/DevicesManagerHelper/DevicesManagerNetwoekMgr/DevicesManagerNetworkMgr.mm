//
//  DevicesManagerNetworkMgr.m
//  Smart360
//
//  Created by michael on 15/10/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "DevicesManagerNetworkMgr.h"

#include <list>


@implementation DevicesManagerNetworkMgr

//Create smart box engine





#pragma mark - 设置音箱参数
+ (void)setDeviceParamWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"更新成功");
            }
        } else {
            if (failBlock) {
                failBlock(resultDic[@"errorMsg"]);
            }
        }

    } failure:^(NSURLSessionDataTask *, NSError *error) {
        NSLog(@"%@",error.domain);
    }];

}

#pragma mark - 备忘
//+ (kResult)getMemosWithSN:(NSString *)boxSN{
//    if (isContainAssistant) {
//        return SBEngine_GetAllRemindMemos(CstringFromOC(boxSN));
//    }else{
//        return Invalid_Return_Value;
//    }
//}

+ (void)fetchMemosWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"/app" success:^(NSURLSessionDataTask *, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *, NSError *error) {
        NSLog(@"%@",error.domain);
    }];
}


#pragma mark - 更新备忘
//更新备忘
+ (void)updateMemosWithDic:(NSDictionary *)dic withSuccessBlock:(void (^)(NSString *result))successBlock withFailBlock:(void (^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:dic subUrl:@"" success:^(NSURLSessionDataTask *, id responseObject) {
        //成功返回
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([resultDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(@"备忘更新成功");
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



//typedef struct
//{
//    std::string stEventId;
//    std::string stEventType;
//    std::string stExecuteTime;
//    XBOOL stIsOverDue;
//    std::string stEventContent;
//    XBOOL stIsExecute;
//}RemindInfo;
//
//typedef struct
//{
//    std::list<RemindInfo> remindInfo;
//} REMINDINFO_LIST_STRU;

#pragma mark - SN二维码加解密
//XRESULT SBEngine_SnEncrypt(const XCHAR *sn, XCHAR *encryptCode);
//
//XRESULT SBEngine_SnDecrypt(const XCHAR *code, XCHAR *sn);
//
//XINT SBEngine_GetEncryptLen(const XCHAR *sn);
//
//XINT SBEngine_GetDecryptLen(const XCHAR *code);

//得到加密后的SN



@end
