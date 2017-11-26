//
//  zxy_gallery_photo.m
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "zxy_gallery_photo.h"

@implementation zxy_gallery_photo
@synthesize delegate;
@synthesize isThumbLoading;
@synthesize hasThumbLoaded;
@synthesize isFullsizeLoading;
@synthesize hasFullsizeLoaded;
@synthesize thumbnail;
@synthesize fullsize;
@synthesize b_image_ready;
@synthesize m_errcode;



- (id)initWithThumbnailVV:(long)connector camid:(NSString*)camid eventid:(NSString*)eventid index:(int)index type:(int)type
{
    self = [super init];
    goe_Http=[ppview_cli getInstance];
    m_pic_manager=[pic_cache_list_manager getInstance];
    _useConnector=true;
    _hConnector=connector;
    _eventid=eventid;
    _camid=camid;
    _index=index;
    _pictype=type;
    b_image_ready=false;

    return self;
}
- (id)initWithThumbnailPath:(NSString*)thumb fullsizePath:(NSString*)fullsizepath index:(int)index type:(int)type
{
    self = [super init];
    _useNetwork = NO;
    _thumbUrl = thumb;
    _fullsizeUrl = fullsizepath;
    _index=index;
     _pictype=type;
    b_image_ready=false;
    return self;
}
-(void)set_image_ready_state:(BOOL)bReady
{
    b_image_ready=bReady;

}
-(void)did_load_err
{
    if(delegate!=nil && [delegate respondsToSelector:@selector(zxy_LoadFullsize_err:errcode:)])
        [delegate zxy_LoadFullsize_err:_index errcode:m_errcode];
}
-(void)set_errcode:(int)errcode
{
    m_errcode=errcode;
    if (errcode != 200) {
        [self performSelectorOnMainThread:@selector(did_load_err) withObject:nil waitUntilDone:YES];
        
    }
}
- (int)loadFullsize_vv
{
    if (b_image_ready==false) {
        return -1;
    }
    if (m_errcode !=200) {
        return m_errcode;
    }
    [NSThread detachNewThreadSelector:@selector(loadFullsizeInThread_file) toTarget:self withObject:nil];
    return m_errcode;
}
- (void)loadThumbnail
{
    
}
- (void)loadFullsize
{
    if( _isFullsizeLoading || _hasFullsizeLoaded )
        return;
    if (_useConnector==true) {
        
        if(delegate!=nil&&[self.delegate respondsToSelector:@selector(zxy_willLoadFullsizeFromDev:)]){
            [delegate zxy_willLoadFullsizeFromDev:_index];
        }
        _isFullsizeLoading = YES;
        [NSThread detachNewThreadSelector:@selector(loadFullsizeInThread_dev) toTarget:self withObject:nil];
        return;
    }
    else
    {
        if (_fullsizeUrl==nil)
            return;
        if(delegate!=nil&&[self.delegate respondsToSelector:@selector(zxy_willLoadFullsizeFromPath:)]){
            [delegate zxy_willLoadFullsizeFromDev:_index];
        }
        _isFullsizeLoading = YES;
        // spawn a new thread to load from disk
        [NSThread detachNewThreadSelector:@selector(loadFullsizeInThread_path) toTarget:self withObject:nil];
    }
}

- (void)unloadFullsize
{
   _fullsizeData = nil;
    _hasFullsizeLoaded = NO;
    fullsize = nil;
}
- (void)unloadThumbnail
{
    
}
- (void)didLoadFullsize
{
    //	FLog(@"gallery phooto did load fullsize!");
    if(delegate!=nil && [delegate respondsToSelector:@selector(zxy_didLoadFullsize:image:)])
        [delegate zxy_didLoadFullsize:_index image:fullsize];
}
- (void)loadFullsizeInThread_dev
{
    
    @autoreleasepool {
        NSString* filename=[m_pic_manager get_filename:_camid eventid:_eventid index:_index];
        if ([m_pic_manager is_file_exist:filename]==true) {
            fullsize = [UIImage imageWithContentsOfFile:filename];
        }
        else{
            int res=0;
            NSData* fullsize_data=[goe_Http cli_lib_get_event_pic:_hConnector eventid:_eventid index:_index type:_pictype res_code:&res];
            if (fullsize_data != nil) {
                if ([m_pic_manager save_jpg_file:fullsize_data camid:_camid eventid:_eventid index:_index]==true) {
                    [m_pic_manager add_item:_camid eventid:_eventid index:_index with_type:0];
                }
                fullsize = [UIImage imageWithData:fullsize_data];
            }
        }
        _hasFullsizeLoaded = YES;
        _isFullsizeLoading = NO;
        [self performSelectorOnMainThread:@selector(didLoadFullsize) withObject:nil waitUntilDone:YES];
    }
}
-(void)loadFullsizeInThread_path
{
    @autoreleasepool {
    
        NSString *path;
        if([[NSFileManager defaultManager] fileExistsAtPath:_fullsizeUrl])
        {
            path = _fullsizeUrl;
        }
        else {
            path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], _fullsizeUrl];
        }
    
        fullsize = [UIImage imageWithContentsOfFile:path];
    
        _hasFullsizeLoaded = YES;
        _isFullsizeLoading = NO;
    
        [self performSelectorOnMainThread:@selector(didLoadFullsize) withObject:nil waitUntilDone:YES];
    
    }
}

-(void)loadFullsizeInThread_file
{
    @autoreleasepool {
        
        NSString *path;
        if([[NSFileManager defaultManager] fileExistsAtPath:_fullsizeUrl])
        {
            path = _fullsizeUrl;
        }
        else {
            path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], _fullsizeUrl];
        }
        
        fullsize = [UIImage imageWithContentsOfFile:path];
        
        [self performSelectorOnMainThread:@selector(didLoadFullsize) withObject:nil waitUntilDone:YES];
        
    }
}
@end
