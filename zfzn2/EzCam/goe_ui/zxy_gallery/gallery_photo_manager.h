//
//  gallery_photo_manager.h
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zxy_gallery_photo.h"
#import "pic_cache_list_manager.h"
#import "ppview_cli.h"
@interface gallery_photo_manager : NSObject
{
    pic_cache_list_manager *m_pic_manager;
    ppview_cli* goe_Http;
    NSMutableDictionary *_photoLoaders;
    NSMutableDictionary *_photoLoaders_local;
    int cur_loading_index;
    int total_num;
    BOOL b_connector_using;
    NSString* m_camid;
    NSString* m_eventid;
    int m_pic_type;
    long h_connector;
    BOOL bexit;
    
    int cur_type;
    
    int m_start_index;
}
+(gallery_photo_manager*) getInstance;
-(int)set_info:(NSString*)camid eventid:(NSString*)eventid num:(int)num type:(int)type connector:(long)connector;
-(int)set_local_array:(NSMutableArray*)filearray start_index:(int)index;
-(int)start_index;
-(void)set_delegate:(NSObject<zxy_gallery_photo_Delegate>*)delegate;
-(void)reset_connector:(long)connector;
-(BOOL)is_image_available:(int)index;
-(int)get_image_errcode:(int)index;
-(int)numberOfPhotosForPhotoGallery;
-(void)start_load_fullsize:(int)index;
-(void)unload_fullsize:(int)index;
-(void)exit;
@end
