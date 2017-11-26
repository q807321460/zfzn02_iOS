//
//  recordlist_manager.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-7-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "recordlist_manager.h"
#import "minutes_item.h"
@implementation recordlist_manager
static recordlist_manager* instance = nil;

- (id)init
{
    @synchronized(self) {
        self = [super init];
        g_record_time_array= [NSMutableArray new];
        g_record_date_dictionary=[NSMutableDictionary dictionary];
        return self;
    }
}

+(recordlist_manager*)getInstance{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}
-(void)clear
{
    [g_record_time_array removeAllObjects];
}

-(void)add_item:(int)startmin with_end:(int)endmin
{
    //NSLog(@"recordlist_manager, startmin=%d, endmin=%d",startmin, endmin);
    minutes_item *cur_item= [minutes_item alloc];
    cur_item.m_start_minutes=startmin;
    cur_item.m_end_minutes=endmin;
    [g_record_time_array addObject:cur_item];
}
-(BOOL)add_item_date:(NSString*)date_month datelist:(NSString*)c_date devid:(NSString*)devid chlid:(int)chlid
{
    if (date_month==nil || c_date==nil || c_date.length != 31 || devid==nil) {
        return false;
    }
    NSString* date_key=[NSString stringWithFormat:@"%@:%d:%@",devid,chlid,date_month];
    @synchronized(self){
        
        if ([g_record_date_dictionary objectForKey:date_key] != nil) {
            [g_record_date_dictionary removeObjectForKey:date_key];
        }
        NSMutableArray* tmp_array= [NSMutableArray new];
        char* pCharsTimes=(char*)[c_date UTF8String];
        for (int i=0; i<31; i++) {
            char ivalue=pCharsTimes[i];
            if (ivalue=='0') {
                [tmp_array addObject:[NSNumber numberWithInt:0]];
            }
            else{
                [tmp_array addObject:[NSNumber numberWithInt:01]];
            }
        }
        [g_record_date_dictionary setObject:tmp_array forKey:date_key];
    }
    return true;
}
-(NSMutableArray*)get_date_array:(NSString*)devid chldid:(int)chlid date_month:(NSString*)date_month
{
    if (date_month==nil ||  devid==nil) {
        return nil;
    }
    NSString* date_key=[NSString stringWithFormat:@"%@:%d:%@",devid,chlid,date_month];
    @synchronized(self){
        return [g_record_date_dictionary objectForKey:date_key];
    }
}
-(BOOL)is_month_exist:(NSString*)devid chldid:(int)chlid date_month:(NSString*)date_month
{
    if (date_month==nil ||  devid==nil) {
        return false;
    }
    NSString* date_key=[NSString stringWithFormat:@"%@:%d:%@",devid,chlid,date_month];
    if ([g_record_date_dictionary objectForKey:date_key]==nil) {
        return  false;
    }
    else
        return true;
}
-(NSMutableArray*)get_time_array
{
    return g_record_time_array;
}
-(int)getlastmin
{
    int icount=(int)g_record_time_array.count;
    if (icount>0) {
        minutes_item *cur_item= [g_record_time_array objectAtIndex:icount-1];
        return cur_item.m_end_minutes;

    }
    return 0;
}
@end
