//
//  zx_message_cache_item.h
//  ppview_zx
//
//  Created by zxy on 15-2-4.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zx_message_cache_item : NSObject
@property (retain, nonatomic) NSString* str_camid;
@property (retain, nonatomic) NSString* str_mesid;
@property (retain, nonatomic) NSString* str_day;
@property (retain, nonatomic) NSString* str_time;
@property (assign) int m_mes_type;
@property (assign) int m_index;
@end
