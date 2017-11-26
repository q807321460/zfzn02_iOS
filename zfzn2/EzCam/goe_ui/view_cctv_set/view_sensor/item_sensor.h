//
//  item_sensor.h
//  ppview_zx
//
//  Created by zxy on 14-12-24.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface item_sensor : NSObject
@property (retain) NSString* m_sensor_id;
@property (retain) NSString* m_sensor_type;
@property (retain) NSString* m_sensor_name;
@property (assign) int m_subchl_count;
@property (assign) int m_sensor_preset;
@property (assign) int m_type;
@property (assign) int b_alarm;//是否触发报警
@property (assign) int m_status;//0 关闭 1 打开
@property (assign) int low_power;
@property (assign) BOOL b_new;
@end
