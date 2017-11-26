//
//  cam_list_manager_req.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cam_list_manager_req : NSObject
@property (retain, nonatomic) NSString* str_tag1;
@property (retain, nonatomic) NSString* str_tag2;
@property (retain, nonatomic) NSString* str_tag3;
@property (assign) int int_tag1;
@property (assign) int int_tag2;;
@property (assign) int int_tag3;
@property (retain, nonatomic) NSData* data_tag1;
@property (retain, nonatomic) NSDictionary* dic_tag1;
@end
