//
//  message_cache_list_manager.h
//  ppview_zx
//
//  Created by zxy on 15-2-4.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zx_message_cache_item.h"
@interface message_cache_list_manager : NSObject
{
    NSMutableArray* m_mes_array;
    NSMutableDictionary *m_mes_dictionary;
    int m_max_mes_num;
    
    NSString* m_path_mes;
    NSString* m_absulate_path_mes;
}

+(message_cache_list_manager*) getInstance;
-(NSString*)get_filename:(NSString*)camid mesid:(NSString*)mesid index:(int)index;
-(BOOL)is_file_exist:(NSString*)filename;
-(void)add_item:(NSString*)camid mesid:(NSString*)mesid index:(int)index with_type:(int)type;
-(void)save_meslist_file;
-(void)read_meslist_file;

-(BOOL)save_mes_file:(NSData*)mesdata camid:(NSString*)camid mesid:(NSString*)mesid index:(int)index;
-(void)delete_mes_file:(NSString*)camid mesid:(NSString*)mesid index:(int)index;
@end
