//
//  JSNetworkMgr.h
//  Smart360
//
//  Created by nimo on 15/8/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSNetworkMgr : AFHTTPSessionManager

- (void)postWithParameters:(id)parameters
                    subUrl:(NSString *)subUrl
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)postDeviceMgrWithParameters:(id)parameters
                             subUrl:(NSString *)subUrl
                            success:(void (^)(NSURLSessionDataTask *, id))success
                            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)getWithParameters:(id)parameters
                  withUrl:(NSString *)url
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
