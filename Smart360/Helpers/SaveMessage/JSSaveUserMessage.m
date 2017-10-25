//
//  JSSaveUserMessage.m
//  Smart360
//
//  Created by sun on 15/8/12.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSSaveUserMessage.h"

@implementation JSSaveUserMessage

- (void) test {
    NSLog(@"hello world");
}

+ (JSSaveUserMessage *)sharedInstance {
    static JSSaveUserMessage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//获得用户名
- (NSString *)readLoginName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *loginName = [userDefaults objectForKey:@"LoginName"];
    NSLog(@"获取用户名: *****%@*******",loginName);
    return loginName;
}

//保存用户名
- (void)saveLoginName:(NSString *)LoginName {
    if (LoginName.length != 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"存储用户名: *****%@*******",LoginName);
        [userDefaults setValue:LoginName forKey:@"LoginName"];
        [userDefaults synchronize];
    }
}

//获得用户密码
- (NSString *)readPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults objectForKey:@"PassWord"];
    NSLog(@"读取用户密码: *****%@*******",password);
    return password;
}

//保存用户密码
- (void)savePassword:(NSString *)Password {//
//    NSLog(@"保存用户密码: *****%@*******",Password);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValue:Password forKey:@"PassWord"];
//    [userDefaults synchronize];
}


- (NSNumber *)readUserId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [userDefaults objectForKey:@"UserId"];
    return userId;
}

- (void)saveUserId:(NSNumber *)userId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userId forKey:@"UserId"];
    [userDefaults synchronize];

}

- (NSString *)readUserName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"UserName"];
    return userName;
}


- (void)saveUserName:(NSString *)userName {
    if (userName.length != 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:userName forKey:@"UserName"];
        [userDefaults synchronize];
    }
    
}


- (NSString *)currentBoxSN {
    //演示厅: SZB0C0301B88F
    //二楼:   SZB0C0300803F
    //feng:   SZB0C03005BBF
    //konnn: SZB0C0300803F
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *boxSN = [userDefaults objectForKey:@"BoxSN"];
    if (boxSN.length == 0) {
        [userDefaults setValue:@"SZB0C0300D7EF" forKey:@"BoxSN"];
        [userDefaults synchronize];
        return @"SZB0C0300D7EF";
    }
    return boxSN;
    //return @"SZB0C0300D7EF";
}

- (void)setCurrentBoxSN:(NSString *)currentBoxSN {
    if (currentBoxSN.length != 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:currentBoxSN forKey:@"BoxSN"];
        [userDefaults synchronize];
    }

    
}




@end
