//
//  sensors_manager.h
//  ppview_zx
//
//  Created by zxy on 14-12-27.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "item_sensor.h"
#import "vv_strings.h"
@interface sensors_manager : NSObject
{
    NSMutableArray* m_sensors_array;
    NSMutableArray* m_cam_sensors_array;
}
+(sensors_manager*) getInstance;
-(BOOL)setJsonData:(NSData*)sensordata;
-(int)setJsonData_codding:(NSData*)reqdata;
-(int)getCount;
-(item_sensor*)getItem:(int)position;
-(item_sensor*)getItemByID:(NSString*)itemid;
-(BOOL)sensor_delete:(NSString*)sensor_id;


-(BOOL)setJsonData_cam:(NSData*)sensordata;
-(int)getCount_cam;
-(item_sensor*)getItem_cam:(int)position;
-(item_sensor*)getItemByID_cam:(NSString*)itemid;

@end
