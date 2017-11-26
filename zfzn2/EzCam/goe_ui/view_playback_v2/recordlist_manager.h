//
//  recordlist_manager.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-7-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordlist_manager : NSObject
{

    NSMutableArray* g_record_time_array;//dev_list_item
    NSMutableDictionary *g_record_date_dictionary;//存储所有摄像头 cam_list_item
}
+(recordlist_manager*)getInstance;
-(void)clear;
-(void)add_item:(int)startmin with_end:(int)endmin;
-(NSMutableArray*)get_time_array;
-(int)getlastmin;
-(BOOL)add_item_date:(NSString*)date_month datelist:(NSString*)c_date devid:(NSString*)devid chlid:(int)chlid;
-(NSMutableArray*)get_date_array:(NSString*)devid chldid:(int)chlid date_month:(NSString*)date_month;
-(BOOL)is_month_exist:(NSString*)devid chldid:(int)chlid date_month:(NSString*)date_month;
@end
