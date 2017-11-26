//
//  zxy_gallery_photo.h
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "pic_cache_list_manager.h"

@protocol zxy_gallery_photo_Delegate<NSObject>
@optional
- (void)zxy_LoadFullsize_err:(int)index errcode:(int)errcode;
- (void)zxy_didLoadFullsize:(int)index image:(UIImage*)image;
- (void)zxy_willLoadFullsizeFromDev:(int)index;
- (void)zxy_willLoadFullsizeFromPath:(int)index;
- (void)zxy_didLoadThumbnail:(int)index image:(UIImage*)image;
- (void)zxy_willLoadThumbnailFromDev:(int)index;
- (void)zxy_willLoadThumbnailFromPath:(int)index;
@end

@interface zxy_gallery_photo : NSObject
{
    BOOL _useNetwork;
    BOOL _useConnector;
    
    long _hConnector;
    NSString*_eventid;
    NSString*_camid;
    int _index;
    int _pictype;
    
    BOOL _isThumbLoading;
    BOOL _hasThumbLoaded;
    
    BOOL _isFullsizeLoading;
    BOOL _hasFullsizeLoaded;
    
    NSMutableData *_thumbData;
    NSMutableData *_fullsizeData;
    
    NSString *_thumbUrl;
    NSString *_fullsizeUrl;
    
    ppview_cli* goe_Http;
    pic_cache_list_manager* m_pic_manager;
    
    NSString* m_uuid;
    
    int m_errcode;
}

@property (assign) id<zxy_gallery_photo_Delegate> delegate;
@property (assign) BOOL isThumbLoading;
@property (assign) BOOL hasThumbLoaded;
@property (assign) BOOL isFullsizeLoading;
@property (assign) BOOL hasFullsizeLoaded;
@property (retain, nonatomic) UIImage *thumbnail;
@property (retain, nonatomic) UIImage *fullsize;

@property (assign) BOOL b_image_ready;
@property (assign) int m_errcode;
- (id)initWithThumbnailVV:(long)connector camid:(NSString*)camid eventid:(NSString*)eventid index:(int)index type:(int)type ;
- (id)initWithThumbnailPath:(NSString*)thumb fullsizePath:(NSString*)fullsizepath index:(int)index type:(int)type;

- (void)loadThumbnail;
- (void)loadFullsize;
- (int)loadFullsize_vv;

- (void)unloadFullsize;
- (void)unloadThumbnail;

-(void)set_image_ready_state:(BOOL)bReady;
-(void)set_errcode:(int)errcode;

@end
