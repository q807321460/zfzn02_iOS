//
//  gallery_photo_manager.m
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "gallery_photo_manager.h"
#import "foler_item.h"
@implementation gallery_photo_manager
static gallery_photo_manager* instance;

-(id)init{
    self = [super init];
     m_pic_manager=[pic_cache_list_manager getInstance];
    goe_Http=[ppview_cli getInstance];
    total_num=3;
    b_connector_using=false;
    _photoLoaders = [NSMutableDictionary dictionary];
    _photoLoaders_local = [NSMutableDictionary dictionary];
    return self;
}
+(gallery_photo_manager*) getInstance{
    if(instance==nil)
    {
        instance = [[gallery_photo_manager alloc] init];
    }
    return instance;
}
-(void)exit
{
    bexit=true;
}
- (void)loadFullsizeInThread_dev
{
    @autoreleasepool {
        b_connector_using=true;
        bexit=false;
        int res_code=-1;
        for (int i=0; i<total_num; i++) {
            if (bexit==true) {
                break;
            }
            zxy_gallery_photo* cur_photo= [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", i]];
            if (cur_photo.b_image_ready==false) {
                NSLog(@"loadFullsizeInThread_dev to load:%d",i);
                NSData* fullsize_data=[goe_Http cli_lib_get_event_pic:h_connector eventid:m_eventid index:i type:m_pic_type res_code:&res_code];
                NSLog(@"loadFullsizeInThread_dev end load:%d, res=%d",i,res_code);
                if (fullsize_data != nil) {
                    if ([m_pic_manager save_jpg_file:fullsize_data camid:m_camid eventid:m_eventid index:i]==true) {
                        [m_pic_manager add_item:m_camid eventid:m_eventid index:i with_type:m_pic_type];
                        [cur_photo set_image_ready_state:true];
                        cur_photo.m_errcode=200;
                        [cur_photo loadFullsize_vv];
                        //NSLog(@"loadFullsizeInThread_dev finish:%d",i);
                    }
                }
                else{
                    [cur_photo set_errcode:res_code];
                    [cur_photo set_image_ready_state:true];
                }
            }
        }
        NSLog(@"loadFullsizeInThread_dev to exit");
        b_connector_using=false;
    }
}
-(void)reset_connector:(long)connector
{
    h_connector=connector;
}
-(int)set_info:(NSString*)camid eventid:(NSString*)eventid num:(int)num type:(int)type connector:(long)connector
{
    if (b_connector_using==true) {
        return -1;
    }
    cur_type=0;
    cur_loading_index=0;
    total_num=num;
    m_camid=camid;
    m_eventid=eventid;
    m_pic_type=type;
    h_connector=connector;
    m_start_index=-1;
    [_photoLoaders removeAllObjects];
    int todown_num=0;
    NSString* m_file_name=@"";
    BOOL b_image_ready=false;
    for (int i=0; i<num; i++) {
        m_file_name=[m_pic_manager get_filename:m_camid eventid:m_eventid index:i];
        b_image_ready=[m_pic_manager is_file_exist:m_file_name];
        zxy_gallery_photo* cur_photo=[[zxy_gallery_photo alloc] initWithThumbnailPath:m_file_name fullsizePath:m_file_name index:i type:0];
        cur_photo.b_image_ready=b_image_ready;
        if (b_image_ready==false) {
            todown_num++;
             NSLog(@"set_info to download:%d",i);
        }
        else{
            [cur_photo set_errcode:200];
            NSLog(@"set_info to local:%d",i);
        }
        [_photoLoaders setObject:cur_photo forKey:[NSString stringWithFormat:@"%i", i]];
    }
    if (todown_num>0) {
        
        [NSThread detachNewThreadSelector:@selector(loadFullsizeInThread_dev) toTarget:self withObject:nil];
    }
    return 1;
}
-(int)set_local_array:(NSMutableArray*)filearray start_index:(int)index
{
    if (filearray==nil || filearray.count<=0) {
        return -1;
    }
    cur_type=1;
    m_start_index=index;
    [_photoLoaders_local removeAllObjects];
    for (int i=0; i<filearray.count; i++) {
        foler_item* cur_item=[filearray objectAtIndex:i];
        zxy_gallery_photo* cur_photo=[[zxy_gallery_photo alloc] initWithThumbnailPath:cur_item.m_full_name fullsizePath:cur_item.m_full_name index:i type:0];
        cur_photo.b_image_ready=1;
        [cur_photo set_errcode:200];
        [_photoLoaders_local setObject:cur_photo forKey:[NSString stringWithFormat:@"%i", i]];
    }
    return 1;
}
-(int)start_index
{
    return m_start_index;
}
-(void)set_delegate:(NSObject<zxy_gallery_photo_Delegate>*)delegate
{
    if (cur_type==0){
        for (int i=0; i<total_num; i++) {
            zxy_gallery_photo* cur_photo=[_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", i]];
            if (cur_photo != nil) {
                cur_photo.delegate=delegate;
            }
        }
    }
    else if(cur_type==1){
        for (int i=0; i<_photoLoaders_local.count; i++) {
            zxy_gallery_photo* cur_photo=[_photoLoaders_local objectForKey:[NSString stringWithFormat:@"%i", i]];
            if (cur_photo != nil) {
                cur_photo.delegate=delegate;
            }
        }
    }
}

-(BOOL)is_image_available:(int)index
{
    if (cur_type==0) {
        zxy_gallery_photo* cur_photo=[_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
        if (cur_photo==nil) {
            return  false;
        }
        return cur_photo.b_image_ready;
    }
    else if(cur_type==1){
        return  true;
    }
    return false;
}
-(int)get_image_errcode:(int)index
{
    if (cur_type==0) {
        zxy_gallery_photo* cur_photo=[_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
        if (cur_photo==nil) {
            return  0;
        }
        return cur_photo.m_errcode;
    }
    else if(cur_type==1){
        return  200;
    }
    return false;
}
-(void)start_load_fullsize:(int)index
{
    if (cur_type==0) {
        zxy_gallery_photo* cur_photo=[_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
        if (cur_photo==nil) {
            return ;
        }
        [cur_photo loadFullsize_vv];
    }
    else if(cur_type==1)
    {
        zxy_gallery_photo* cur_photo=[_photoLoaders_local objectForKey:[NSString stringWithFormat:@"%i", index]];
        if (cur_photo==nil) {
            return ;
        }
        [cur_photo loadFullsize_vv];
    }
    
}
-(void)unload_fullsize:(int)index
{
     if (cur_type==0) {
         zxy_gallery_photo* cur_photo=[_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
         if (cur_photo==nil) {
             return ;
         }
         [cur_photo unloadFullsize];
     }
    else if(cur_type==1)
    {
        zxy_gallery_photo* cur_photo=[_photoLoaders_local objectForKey:[NSString stringWithFormat:@"%i", index]];
        if (cur_photo==nil) {
            return ;
        }
        [cur_photo unloadFullsize];
    }
}
-(int)numberOfPhotosForPhotoGallery
{
    if (cur_type==0) {
        return (int)_photoLoaders.count;
    }
    else if(cur_type==1){
        return (int)_photoLoaders_local.count;
    }
    else
        return 0;
}
@end
