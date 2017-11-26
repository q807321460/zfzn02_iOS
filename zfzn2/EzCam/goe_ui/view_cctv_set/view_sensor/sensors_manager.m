//
//  sensors_manager.m
//  ppview_zx
//
//  Created by zxy on 14-12-27.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "sensors_manager.h"

@implementation sensors_manager
static sensors_manager* instance;

-(id)init{
    self = [super init];
    
    m_sensors_array= [NSMutableArray new];
    m_cam_sensors_array= [NSMutableArray new];
    return self;
}


+(sensors_manager*) getInstance{
    if(instance==nil){
        instance = [[sensors_manager alloc] init ];
    }
    return instance;
}
-(int)setJsonData_codding:(NSData*)reqdata
{
    if (reqdata==NULL) {
        return -1;
    }
    
     NSString *aString = [[NSString alloc] initWithData:reqdata encoding:NSUTF8StringEncoding];
     NSLog(@"reqdata=%@",aString);
    int add_res=0;//0 无 1：添加 2:重复
    @synchronized(self){
        NSError* reserr;
        NSMutableDictionary* share_dictionary = [NSJSONSerialization JSONObjectWithData: reqdata options:NSJSONReadingMutableContainers error:&reserr];
        if (share_dictionary==nil) {
            return -1;
        }
        if ([share_dictionary objectForKey:@"sensors"]) {
            for (NSDictionary* item_dic in [share_dictionary objectForKey:@"sensors"])
            {
                NSString* sensor_id=[item_dic objectForKey:@"sensor_id"];
                if ([self getItemByID:sensor_id] !=nil) {
                    add_res=2;
                }
                else{
                    item_sensor* cur_item= [item_sensor alloc];
                    cur_item.m_sensor_id=[item_dic objectForKey:@"sensor_id"];
                    cur_item.m_type=[[item_dic objectForKey:@"type"]intValue];
                    
                    switch (cur_item.m_type) {
                        case 0x01:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_1", @"");
                            break;
                        case 0x02:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_2", @"");
                            break;
                        case 0x03:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_3", @"");
                            break;
                        case 0x04:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_4", @"");
                            break;
                        case 0x05:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_5", @"");
                            break;
                        case 0x06:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_6", @"");
                            break;
                        case 0x07:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_7", @"");
                            break;
                        case 0x08:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_8", @"");
                            break;
                        case 0x09:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_9", @"");
                            break;
                        case 0xF1:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F1", @"");
                            break;
                        case 0xF2:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F2", @"");
                            break;
                        case 0xF9:
                            cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F9", @"");
                            break;
                        default:
                            cur_item.m_sensor_type=@"m_sensor_type_unknown";
                            break;
                    }
                    cur_item.m_sensor_name=cur_item.m_sensor_id;
                    cur_item.b_new=true;
                    [m_sensors_array addObject:cur_item];
                    add_res=1;
                    break;
                }
                
            }
        }
        
        return add_res;
    }
    
}
-(BOOL)setJsonData:(NSData*)sensordata
{
    if (sensordata==NULL) {
        return false;
    }
    
    
    
    @synchronized(self){
        NSError* reserr;
        NSMutableDictionary* share_dictionary = [NSJSONSerialization JSONObjectWithData:sensordata options:NSJSONReadingMutableContainers error:&reserr];
        if (share_dictionary==nil) {
            return false;
        }
        [m_sensors_array removeAllObjects];
        
        if ([share_dictionary objectForKey:@"sensors"]) {
            for (NSDictionary* item_dic in [share_dictionary objectForKey:@"sensors"])
            {
                item_sensor* cur_item= [item_sensor alloc];
                cur_item.m_sensor_id=[item_dic objectForKey:@"sensor_id"];
                cur_item.m_type=[[item_dic objectForKey:@"type"]intValue];;
                
                switch (cur_item.m_type) {
                    case 0x01:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_1", @"");
                        break;
                    case 0x02:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_2", @"");
                        break;
                    case 0x03:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_3", @"");
                        break;
                    case 0x04:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_4", @"");
                        break;
                    case 0x05:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_5", @"");
                        break;
                    case 0x06:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_6", @"");
                        break;
                    case 0x07:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_7", @"");
                        break;
                    case 0x08:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_8", @"");
                        break;
                    case 0x09:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_9", @"");
                        break;
                    case 0xF1:
                        cur_item.m_sensor_type=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"m_sensor_type_F1", @""),cur_item.m_subchl_count,NSLocalizedString(@"m_chl", @"")];
                        break;
                    case 0xF2:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F2", @"");
                        break;
                    case 0xF9:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F9", @"");
                        break;
                    default:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_unknown", @"");
                        break;
                }
                cur_item.m_sensor_name=[item_dic objectForKey:@"name"];
                if (cur_item.m_sensor_name==nil || cur_item.m_sensor_name.length<=0) {
                    cur_item.m_sensor_name=cur_item.m_sensor_id;
                }
                cur_item.m_sensor_preset=[[item_dic objectForKey:@"preset"]intValue];
                cur_item.b_alarm=[[item_dic objectForKey:@"is_alarm"]intValue]?YES:NO;//是否触发报警
                cur_item.m_status=[[item_dic objectForKey:@"status"]intValue];
                cur_item.b_new=false;
                [m_sensors_array addObject:cur_item];
            }
        }
        
        return true;
    }
}

-(BOOL)setJsonData_cam:(NSData*)sensordata
{
    if (sensordata==NULL) {
        return false;
    }
    
    //NSString *aString = [[NSString alloc] initWithData:sensordata encoding:NSUTF8StringEncoding];
    //NSLog(@"reqdata=%@",aString);
    
    @synchronized(self){
        NSError* reserr;
        NSMutableDictionary* share_dictionary = [NSJSONSerialization JSONObjectWithData:sensordata options:NSJSONReadingMutableContainers error:&reserr];
        if (share_dictionary==nil) {
            return false;
        }
        [m_cam_sensors_array removeAllObjects];
        
        if ([share_dictionary objectForKey:@"sensors"]) {
            for (NSDictionary* item_dic in [share_dictionary objectForKey:@"sensors"])
            {
                item_sensor* cur_item= [item_sensor alloc];
                cur_item.m_sensor_id=[item_dic objectForKey:@"sensor_id"];
                cur_item.m_type=[[item_dic objectForKey:@"type"]intValue];
                cur_item.m_subchl_count=[[item_dic objectForKey:@"sub_chl_count"]intValue];
               
                switch (cur_item.m_type) {
                    case 0x01:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_1", @"");
                        break;
                    case 0x02:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_2", @"");
                        break;
                    case 0x03:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_3", @"");
                        break;
                    case 0x04:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_4", @"");
                        break;
                    case 0x05:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_5", @"");
                        break;
                    case 0x06:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_6", @"");
                        break;
                    case 0x07:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_7", @"");
                        break;
                    case 0x08:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_8", @"");
                        break;
                    case 0x09:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_9", @"");
                        break;
                    case 0xF1:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F1", @"");
                        break;
                    case 0xF2:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F2", @"");
                        break;
                    case 0xF9:
                        cur_item.m_sensor_type=NSLocalizedString(@"m_sensor_type_F9", @"");
                        break;
                    default:
                        cur_item.m_sensor_type=@"m_sensor_type_unknown";
                        break;
                }
                cur_item.m_sensor_name=[item_dic objectForKey:@"name"];
                if (cur_item.m_sensor_name==nil || cur_item.m_sensor_name.length<=0) {
                    cur_item.m_sensor_name=cur_item.m_sensor_id;
                }
                cur_item.m_sensor_preset=[[item_dic objectForKey:@"preset"]intValue];
                cur_item.b_alarm=[[item_dic objectForKey:@"is_alarm"]intValue]?YES:NO;//是否触发报警
                cur_item.m_status=[[item_dic objectForKey:@"status"]intValue];
                cur_item.low_power=[[item_dic objectForKey:@"low_power"]intValue];
                [m_cam_sensors_array addObject:cur_item];
                
            }
        }
        
        return true;
    }

}
-(int)getCount
{
    return m_sensors_array.count;
}
-(int)getCount_cam
{
   return m_cam_sensors_array.count;
}
-(item_sensor*)getItem:(int)position
{
    return [m_sensors_array objectAtIndex:position];
}
-(item_sensor*)getItem_cam:(int)position
{
    return [m_cam_sensors_array objectAtIndex:position];
}
-(item_sensor*)getItemByID_cam:(NSString*)itemid
{
    for (item_sensor* item_sensor in m_cam_sensors_array)
    {
        if ([item_sensor.m_sensor_id isEqualToString:itemid]==true) {
            return item_sensor;
        }
    }
    return nil;
}
-(item_sensor*)getItemByID:(NSString*)itemid
{
    for (item_sensor* item_sensor in m_sensors_array)
    {
        if ([item_sensor.m_sensor_id isEqualToString:itemid]==true) {
            return item_sensor;
        }
    }
    return nil;
}
-(BOOL)sensor_delete:(NSString*)sensor_id
{
     @synchronized(self){
         BOOL res=false;
         if (sensor_id==nil) {
             return res;
         }
         for (item_sensor* item_sensor in m_sensors_array)
         {
             if ([item_sensor.m_sensor_id isEqualToString:sensor_id]==true) {
                 [m_sensors_array removeObject:item_sensor];
                 res=true;
                 break;
             }
         }
         return res;
     }
}

@end
