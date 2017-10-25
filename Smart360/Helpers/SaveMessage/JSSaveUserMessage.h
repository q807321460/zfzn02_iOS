//
//  JSSaveUserMessage.h
//  Smart360
//
//  Created by sun on 15/8/12.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSSaveUserMessage : NSObject

+ (JSSaveUserMessage *)sharedInstance;
- (NSString *)readLoginName;
- (void)saveUserId:(NSNumber *)userId;
- (void)saveUserName:(NSString *)LoginName;
- (void)saveLoginName:(NSString *)LoginName;
- (void)savePassword:(NSString *)Password;
- (void)test;

@property (nonatomic) NSString *loginName;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
///*登录账号信息*/
//@property (nonatomic, strong, getter = readLoginName, setter = saveLoginName:) NSString *loginName;
//
///*密码*/
//@property (nonatomic, strong, getter = readPassword, setter = savePassword:) NSString *;
//
////用户id
//@property (nonatomic, strong, getter = readUserId, setter = saveUserId:) NSNumber *userId;
//
////用户昵称
//@property (nonatomic, strong, getter = readUserName, setter = saveUserName:) NSString *userName;
//
@property (nonatomic, copy) NSString *currentBoxSN;



@end
