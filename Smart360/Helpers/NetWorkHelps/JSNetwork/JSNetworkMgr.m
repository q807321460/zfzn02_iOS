//
//  JSNetworkMgr.m
//  Smart360
//
//  Created by sun on 15/8/7.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSNetworkMgr.h"


@implementation JSNetworkMgr

#pragma mark - Initialization
+ (instancetype)manager {
    static JSNetworkMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super manager];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [self configSerializer:NO];
    }
    
    return self;
}

- (void)configSerializer:(BOOL)responseEncrypted {
    
    if (responseEncrypted) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:self.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        self.responseSerializer.acceptableContentTypes = contentTypes;
    }
}

#pragma mark - Request data
#pragma mark o2o业务
- (void)postWithParameters:(id)parameters
                    subUrl:(NSString *)subUrl
                   success:(void (^)(NSURLSessionDataTask *, id))success
                   failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *url = [[NSString stringWithFormat:@"%@%@",BASE_URL,subUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *request = @{@"protocolVersion":@"1.0.0.0",
                              @"appId":@"",
                              @"rootId":@"",
                              @"content":parameters};
    
   [self POST:url parameters:request success:success failure:failure];
    
}

//@"http://192.168.16.55:8080"
#pragma mark 设备业务
- (void)postDeviceMgrWithParameters:(id)parameters
                             subUrl:(NSString *)subUrl
                            success:(void (^)(NSURLSessionDataTask *, id))success
                            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //@"192.168.16.20:8080"Assistant_Server_url
//    NSString *url = [[NSString stringWithFormat:@"%@%@",Assistant_Server_url,@"/DeviceServer/app"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *url = [[NSString stringWithFormat:@"%@%@",@"http://192.168.16.24:8081",@"/box/app"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [[NSString stringWithFormat:@"%@%@",Assistant_Server_url,@"/DeviceServer/app"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSDictionary *request = @{@"protocolVersion":@"1.0.0.0",
                              @"appId":@"com.voice.assistant.main",
                              @"robotId":@"573e0d07-2ee9-469e-ace8-a6cc611968e4",
                              @"userId":[[JSSaveUserMessage sharedInstance] readLoginName] ? : @"",
                              @"sn":[[JSSaveUserMessage sharedInstance] currentBoxSN] ? : @"",
                              @"appVersion":currentAppVersion,
                              @"boxVersion":@"",
                              @"osType":@"ios",
                              @"content":parameters};
//    Assistant_Server_url = @"http://box.360iii.com:8680";
    NSString *str = [JSUtility jsonStringWithObj:request error:nil];
    NSLog(@"发送字典格式: %@, json格式: %@",request, str);
    [self POST:url parameters:request success:success failure:failure];
}


//根据errorCode确定错误信息
//- (NSDictionary *) getErrorMessageWith:(NSDictionary *)send {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    if ([send isKindOfClass:[NSDictionary class]]) {
//        dic = [NSMutableDictionary dictionaryWithDictionary:send];
//        NSString *errorCode ;
//        NSLog(@"=======%@",NSStringFromClass([dic[@"errorCode"] class]));
//        if (dic[@"errorCode"]) {
//            errorCode = dic[@"errorCode"];
//            if ([errorCode isEqualToString:@"0001"]) {
//                errorCode = @"没有找到用户信息";
//            } else if ([errorCode isEqualToString:@"0002"]) {
//                errorCode = @"用户id为空";
//            } else if ([errorCode isEqualToString:@"0003"]) {
//                errorCode = @"验证码校验失败";
//            } else if ([errorCode isEqualToString:@"0004"]) {
//                errorCode = @"注册手机号已存在";
//            } else if ([errorCode isEqualToString:@"0005"]) {
//                errorCode = @"手机号格式错误";
//            } else if ([errorCode isEqualToString:@"0006"]) {
//                errorCode = @"登录账号不存在";
//            } else if ([errorCode isEqualToString:@"0007"]) {
//                errorCode = @"密码错误";
//            } else if ([errorCode isEqualToString:@"2003"]) {
//                errorCode = @"发送验证码失败";
//            } else if ([errorCode isEqualToString:@"2002"]) {
//                errorCode = @"参数非法，参数的数量、名称或类型有误";
//            } else if ([errorCode isEqualToString:@"2001"]) {
//                errorCode = @"没有查询数据";
//            }
//            
//        }
//        [dic setObject:errorCode forKey:@"errorCode"];
//    }
//    return dic;
//}


- (void)readDataFromPlist:(NSInteger)categoryId pageNo:(NSInteger)pageNo{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlUTF ;
    [manager GET:urlUTF parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)getWithParameters:(id)parameters withUrl:(NSString *)url success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //具体的请求的参数
    
   [self GET:url parameters:parameters success:success failure:failure];
}

@end
