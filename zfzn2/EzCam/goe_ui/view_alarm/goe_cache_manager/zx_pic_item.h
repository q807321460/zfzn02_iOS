//
//  zx_pic_item.h
//  ppview_zx
//
//  Created by zxy on 15-1-19.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zx_pic_item : NSObject
@property (retain, nonatomic) NSString* str_camid;
@property (retain, nonatomic) NSString* str_picid;
@property (retain, nonatomic) NSString* str_day;
@property (retain, nonatomic) NSString* str_time;
@property (assign) int m_pic_type;

@property (retain, nonatomic) NSString* str_eventid;
@property (assign) int m_index;
@end
