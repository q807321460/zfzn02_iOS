//
//  SceneModeNetWork.m
//  Smart360
//
//  Created by sun on 16/6/27.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "SceneModeMgr.h"

@implementation SceneModeMgr

+ (void)sceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];

}



//获取情景模式列表
+ (void)fetchSceneModeList:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];

}

//添加或者更新情景模式(id为空代表是添加,有id代表是更新)
+ (void)updateSceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];
}

//删除情景模式
+ (void)deleteSceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];
}


//获取情景模式名称
+ (void)fetchSceneModeNameList:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];
}


//添加或者删除情景模式名称
+ (void)updateSceneModeName:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock {
    
    [[JSNetworkMgr manager] postDeviceMgrWithParameters:paramer subUrl:@"/app" success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功返回
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        if ([responseDic[@"status"] integerValue] == 1) {
            if (successBlock) {
                successBlock(responseDic[@"content"]);
            }
        } else {
            if (failBlock) {
                failBlock(responseDic[@"errorMsg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //请求失败
        if (failBlock) {
            failBlock(error.domain);
        }
        
    }];
}




@end
