//
//  zx_alarm_manager.h
//  ppview_zx
//
//  Created by zxy on 15-1-20.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zx_alarm_item.h"
#import "vv_strings.h"
@interface zx_alarm_manager : NSObject
{
    NSMutableArray* g_tree_pic_array;
    NSMutableArray* g_ui_tree_pic_array;
    NSMutableDictionary *g_pic_dictionary;
    
    NSMutableArray* g_tree_video_array;
    NSMutableArray* g_ui_tree_video_array;
    NSMutableDictionary *g_video_dictionary;
}
+(zx_alarm_manager*) getInstance;
-(void)clear;
-(BOOL)setJsonData:(NSData*)data;
-(int)getCount_pic;
-(zx_alarm_item*)getItem_pic:(int)position;
-(void)set_pic_expand_state:(NSString*)groupid pos:(int)position with_state:(BOOL)bExpanded;

-(int)getCount_video;
-(zx_alarm_item*)getItem_video:(int)position;
-(void)set_video_expand_state:(NSString*)groupid pos:(int)position with_state:(BOOL)bExpanded;
@end
