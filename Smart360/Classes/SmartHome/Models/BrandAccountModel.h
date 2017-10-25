//
//  BrandAccountModel.h
//  Smart360
//
//  Created by michael on 15/11/6.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandAccountModel : NSObject

@property (nonatomic) int brandID;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *encryptType;

@property (nonatomic) BOOL isLastRegSucc;



@end
