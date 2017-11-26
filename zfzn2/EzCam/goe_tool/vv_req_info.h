//
//  req_info.h
//  ppview_zx
//
//  Created by zxy on 14-11-12.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface vv_req_info : NSObject
@property (retain, nonatomic) NSString* str_tag1;
@property (retain, nonatomic) NSString* str_tag2;
@property (retain, nonatomic) NSString* str_tag3;
@property (retain, nonatomic) NSString* str_tag4;

@property (retain, nonatomic) NSData* data_tag1;

@property (assign) int int_tag1;
@property (assign) int int_tag2;
@property (assign) int int_tag3;
@property (assign) int int_tag4;
@property (assign) int int_tag5;

@end
