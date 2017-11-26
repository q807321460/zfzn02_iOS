//
//  zx_alarm_manager.m
//  ppview_zx
//
//  Created by zxy on 15-1-20.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "zx_alarm_manager.h"
#include <time.h>
@implementation zx_alarm_manager
static zx_alarm_manager* instance;

-(id)init{
    self = [super init];
    g_tree_pic_array = [NSMutableArray new];
    g_ui_tree_pic_array = [NSMutableArray new];
    g_pic_dictionary= [NSMutableDictionary dictionary];
    
    g_tree_video_array = [NSMutableArray new];
    g_ui_tree_video_array = [NSMutableArray new];
    g_video_dictionary= [NSMutableDictionary dictionary];
    return self;
}
+(zx_alarm_manager*) getInstance{
    if(instance==nil)
    {
        instance = [[zx_alarm_manager alloc] init];
    }
    return instance;
}

-(void)clear
{
    @synchronized(self){
        [g_tree_pic_array removeAllObjects];
        [g_ui_tree_pic_array removeAllObjects];
        [g_tree_video_array removeAllObjects];
        [g_ui_tree_video_array removeAllObjects];
        [g_pic_dictionary removeAllObjects];
        [g_video_dictionary removeAllObjects];
    }
}
-(BOOL)setJsonData:(NSData*)data
{
    if (data==NULL) {
        return false;
    }    
    //NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"camdata=%@",aString);
    @synchronized(self){
        NSError* reserr;
        NSMutableDictionary *m_dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reserr];
        if (m_dictionary==nil) {
            return false;
        }
        [g_tree_pic_array removeAllObjects];
        [g_ui_tree_pic_array removeAllObjects];
        [g_tree_video_array removeAllObjects];
        [g_ui_tree_video_array removeAllObjects];
        [g_pic_dictionary removeAllObjects];
        [g_video_dictionary removeAllObjects];
        
        NSMutableArray* tmp_array= [NSMutableArray new];
        if ([m_dictionary objectForKey:@"events"]) {
            
            for (NSDictionary* dic_0 in [m_dictionary objectForKey:@"events"]) {
                zx_alarm_item* cur_pic_item= [zx_alarm_item new];
                cur_pic_item.m_eventid=[dic_0 objectForKey:@"event_id"];
                cur_pic_item.m_sensor=[dic_0 objectForKey:@"name"];
                cur_pic_item.m_video_long=[[dic_0 objectForKey:@"rec_sec"]intValue];
                cur_pic_item.m_pic_num=[[dic_0 objectForKey:@"snap"]intValue];
                cur_pic_item.m_event_type=[[dic_0 objectForKey:@"event_type"]intValue];
                time_t  lcur_time=[[dic_0 objectForKey:@"event_time"]longValue];
                struct tm *p=localtime(&lcur_time);
                cur_pic_item.m_time=[NSString stringWithFormat:@"%d-%.2d-%.2d %.2d:%.2d:%.2d",1900+p->tm_year,1+p->tm_mon,p->tm_mday,p->tm_hour,p->tm_min,p->tm_sec];
                cur_pic_item.m_play_time=[NSString stringWithFormat:@"%d%.2d%.2d%.2d%.2d%.2d",1900+p->tm_year,1+p->tm_mon,p->tm_mday,p->tm_hour,p->tm_min,p->tm_sec];
                cur_pic_item.m_day=[NSString stringWithFormat:@"%d-%.2d-%.2d",1900+p->tm_year,1+p->tm_mon,p->tm_mday];
                cur_pic_item.m_item_level=1;
                cur_pic_item.m_parent=cur_pic_item.m_day;
                cur_pic_item.m_item_type=1;
                NSString* tmp_msg=@"";
                switch (cur_pic_item.m_event_type) {
                    case 10001:
                        tmp_msg=NSLocalizedString(@"m_event_type_10001",@"");
                        break;
                    case 10002:
                        tmp_msg=NSLocalizedString(@"m_event_type_10002",@"");
                        break;
                    case 10003:
                        tmp_msg=NSLocalizedString(@"m_event_type_10003",@"");
                        break;
                    case 10004:
                        tmp_msg=NSLocalizedString(@"m_event_type_10004",@"");
                        break;
                    case 10005:
                        tmp_msg=NSLocalizedString(@"m_event_type_10005",@"");
                        break;
                    case 10006:
                        tmp_msg=NSLocalizedString(@"m_event_type_10006",@"");
                        break;
                    case 10007:
                        tmp_msg=NSLocalizedString(@"m_event_type_10007",@"");
                        break;
                    case 10008:
                        tmp_msg=NSLocalizedString(@"m_event_type_10008",@"");
                        break;
                    case 10009:
                        tmp_msg=NSLocalizedString(@"m_event_type_10009",@"");
                        break;
                    case 10010:
                        tmp_msg=NSLocalizedString(@"m_event_type_10010",@"");
                        break;
                    case 10011:
                        tmp_msg=NSLocalizedString(@"m_event_type_10011",@"");
                        break;
                    case 10012:
                        tmp_msg=NSLocalizedString(@"m_event_type_10012",@"");
                        break;
                    case 10022:
                        tmp_msg=NSLocalizedString(@"m_event_type_10022",@"");
                        break;
                    default:
                        tmp_msg=NSLocalizedString(@"m_sensor_type_unknown",@"");
                        break;
                }
                if (cur_pic_item.m_sensor==nil || cur_pic_item.m_sensor.length<=0) {
                    cur_pic_item.m_title=tmp_msg;
                }
                else{
                    cur_pic_item.m_title=[NSString stringWithFormat:@"%@:%@",tmp_msg,cur_pic_item.m_sensor];
                }
                [tmp_array insertObject:cur_pic_item atIndex:0];
            }
        }
        for (zx_alarm_item* cur_pic_item in tmp_array) {
            if (cur_pic_item.m_pic_num>0) {
                if ([g_pic_dictionary objectForKey:cur_pic_item.m_day]==nil) {
                    zx_alarm_item* cur_day_item= [zx_alarm_item new];
                    cur_day_item.m_eventid=cur_pic_item.m_day;
                    cur_day_item.m_day=cur_pic_item.m_day;
                    cur_day_item.m_item_level=0;
                    cur_day_item.m_parent=nil;
                    cur_day_item.m_item_type=0;
                    cur_day_item.m_bexpand=false;
                    
                    [g_pic_dictionary setObject:cur_day_item forKey:cur_day_item.m_eventid];
                    [g_ui_tree_pic_array addObject:cur_day_item];
                    [g_tree_pic_array addObject:cur_day_item];
                }
                [g_tree_pic_array addObject:cur_pic_item];
                [g_pic_dictionary setObject:cur_pic_item forKey:cur_pic_item.m_eventid];
            }
            if (cur_pic_item.m_video_long>0) {
                if ([g_video_dictionary objectForKey:cur_pic_item.m_day]==nil) {
                    zx_alarm_item* cur_day_item= [zx_alarm_item new];
                    cur_day_item.m_eventid=cur_pic_item.m_day;
                    cur_day_item.m_day=cur_pic_item.m_day;
                    cur_day_item.m_item_level=0;
                    cur_day_item.m_parent=nil;
                    cur_day_item.m_item_type=0;
                    cur_day_item.m_bexpand=false;
                    [g_video_dictionary setObject:cur_day_item forKey:cur_day_item.m_eventid];
                    [g_ui_tree_video_array addObject:cur_day_item];
                    [g_tree_video_array addObject:cur_day_item];
                }
                [g_tree_video_array addObject:cur_pic_item];
                [g_video_dictionary setObject:cur_pic_item forKey:cur_pic_item.m_eventid];
            }
        }
        [tmp_array removeAllObjects];
        tmp_array=nil; 
        
        return true;
    }
}
-(int)getCount_pic
{
    return (int)g_ui_tree_pic_array.count;
}
-(zx_alarm_item*)getItem_pic:(int)position
{
    if (position < 0 || position >= g_ui_tree_pic_array.count)
        return nil;
    return [g_ui_tree_pic_array objectAtIndex:position];
}
-(void)set_pic_expand_state:(NSString*)groupid pos:(int)position with_state:(BOOL)bExpanded
{
    
    if (g_ui_tree_pic_array.count<=0) {
        return;
    }
    zx_alarm_item* cur_tree_group_item=nil;
    cur_tree_group_item=[g_ui_tree_pic_array objectAtIndex:position];
    if (cur_tree_group_item==nil || cur_tree_group_item.m_item_type !=0 ) {
        return;
    }
    if (cur_tree_group_item.m_bexpand==bExpanded) {
        return;
    }
    cur_tree_group_item.m_bexpand=bExpanded;
    if (cur_tree_group_item.m_bexpand==true) {
        int level = cur_tree_group_item.m_item_level;
        int nextlevel = level + 1;
        int i = position + 1;
        for (zx_alarm_item* cur_item in g_tree_pic_array) {
            if (cur_item.m_parent !=nil && [cur_item.m_parent isEqualToString:cur_tree_group_item.m_eventid]==true) {
                cur_item.m_item_level=nextlevel;
                cur_item.m_bexpand=false;
                [g_ui_tree_pic_array insertObject:cur_item atIndex:i];
                i++;
            }
        }
    }
    else{
        NSMutableArray* temp=[NSMutableArray new];
        for (int i = position+1; i < g_ui_tree_pic_array.count; i++)
        {
            zx_alarm_item* cur_item=[g_ui_tree_pic_array objectAtIndex:i];
            // if (cur_item!=nil&&[cur_item.parent_id isEqualToString:cur_tree_group_item.item_id]==true)
            if(cur_tree_group_item.m_item_level >= cur_item.m_item_level)
            {
                break;
            }
            cur_item.m_bexpand=false;
            [temp addObject:cur_item];
        }
        [g_ui_tree_pic_array removeObjectsInArray:temp];
    }
    
}

-(int)getCount_video;
{
    return g_ui_tree_video_array.count;
}
-(zx_alarm_item*)getItem_video:(int)position
{
    if (position < 0 || position >= g_ui_tree_video_array.count)
        return nil;
    return [g_ui_tree_video_array objectAtIndex:position];
}
-(void)set_video_expand_state:(NSString*)groupid pos:(int)position with_state:(BOOL)bExpanded
{
    
    if (g_ui_tree_video_array.count<=0) {
        return;
    }
    zx_alarm_item* cur_tree_group_item=nil;
    cur_tree_group_item=[g_ui_tree_video_array objectAtIndex:position];
    if (cur_tree_group_item==nil || cur_tree_group_item.m_item_type !=0 ) {
        return;
    }
    if (cur_tree_group_item.m_bexpand==bExpanded) {
        return;
    }
    cur_tree_group_item.m_bexpand=bExpanded;
    if (cur_tree_group_item.m_bexpand==true) {
        int level = cur_tree_group_item.m_item_level;
        int nextlevel = level + 1;
        int i = position + 1;
        for (zx_alarm_item* cur_item in g_tree_video_array) {
            if (cur_item.m_parent !=nil && [cur_item.m_parent isEqualToString:cur_tree_group_item.m_eventid]==true) {
                cur_item.m_item_level=nextlevel;
                cur_item.m_bexpand=false;
                [g_ui_tree_video_array insertObject:cur_item atIndex:i];
                i++;
            }
        }
    }
    else{
        NSMutableArray* temp=[NSMutableArray new];
        for (int i = position+1; i < g_ui_tree_video_array.count; i++)
        {
            zx_alarm_item* cur_item=[g_ui_tree_video_array objectAtIndex:i];
            // if (cur_item!=nil&&[cur_item.parent_id isEqualToString:cur_tree_group_item.item_id]==true)
            if(cur_tree_group_item.m_item_level >= cur_item.m_item_level)
            {
                break;
            }
            cur_item.m_bexpand=false;
            [temp addObject:cur_item];
        }
        [g_ui_tree_video_array removeObjectsInArray:temp];
    }
    
}
@end
