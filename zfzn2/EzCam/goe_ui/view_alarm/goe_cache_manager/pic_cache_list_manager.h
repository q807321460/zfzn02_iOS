//
//  pic_list_manager.h
//  ppview_zx
//
//  Created by zxy on 14-12-4.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zx_pic_item.h"
@interface pic_cache_list_manager : NSObject
{
    NSMutableArray* m_pic_array;
    NSMutableDictionary *m_pic_dictionary;
    int m_max_pic_num;
    
    NSString* m_path_pic;
    NSString* m_absulate_path_pic;
}

+(pic_cache_list_manager*) getInstance;
-(NSString*)get_filename:(NSString*)camid eventid:(NSString*)eventid index:(int)index;
-(BOOL)is_file_exist:(NSString*)filename;
-(void)add_item:(NSString*)camid eventid:(NSString*)event_id index:(int)index with_type:(int)type;
-(void)save_piclist_file;
-(void)read_piclist_file;

-(BOOL)save_jpg_file:(NSData*)jpgdata camid:(NSString*)camid eventid:(NSString*)eventid index:(int)index;
-(void)delete_jpg_file:(NSString*)camid eventid:(NSString*)event_id index:(int)index;
@end
