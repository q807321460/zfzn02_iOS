//
//  SceneModeNetWork.h
//  Smart360
//
//  Created by sun on 16/6/27.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneModeMgr : NSObject

//情景模式
+ (void)sceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;

//获取情景模式列表
+ (void)fetchSceneModeList:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;

//添加或者更新情景模式(id为空代表是添加,有id代表是更新)
+ (void)updateSceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;

//删除情景模式
+ (void)deleteSceneMode:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;


//获取情景模式名称
+ (void)fetchSceneModeNameList:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;

//添加或者删除情景模式名称
+ (void)updateSceneModeName:(NSDictionary *)paramer successBlock:(void(^)(NSDictionary *result))successBlock failBlock:(void(^)(NSString *msg))failBlock;



@end
