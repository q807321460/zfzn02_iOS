//
//  cam_list_manager_local.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cam_list_item.h"
#import "stream_item.h"
#import "ppview_cli.h"
#import "ppview_cli_v2.h"
#import "cam_list_manager_req.h"
#import "vv_dev_item.h"
#import "pic_file_manager.h"

@protocol camlist_interface <NSObject>
@optional
-(void)cli_lib_camlist_change_callback;

@end

@interface cam_list_manager_local : NSObject<pre_connect_interface>
{
    //NSMapTable
   
    NSMutableDictionary *g_cam_dictionary;//json解析出的源数据
    NSMutableDictionary *g_chan_dictionary;//存储所有摄像头 cam_list_item
    NSMutableArray* g_chan_array;//cam_list_item
    NSMutableArray* g_online_devs_array;//vv_dev_item
    NSMutableArray* g_push_devs_array;//vv_dev_item
    NSData *g_cam_data;
    
    ppview_cli* goe_Http;
    ppview_cli_v2* goe_Http_v2;
    pic_file_manager* m_file_manager;
    
    
    NSString* m_language;
    NSString* m_lockstr;
    BOOL bPushServiceOK;
}
@property (assign) id<camlist_interface>delegate;
@property (retain) NSString* nsDIDsFromVV;
@property (retain) NSString* nsAliasFromVV;


+ (cam_list_manager_local*) getInstance;
-(BOOL) setJsonData:(NSData*)camdata;
- (NSMutableArray*)getChanList;
- (cam_list_item*)getCamItem:(NSString*)camid;
- (void)add_cam_item:(cam_list_item*)cam;
- (void)delete_cam_byid:(NSString*)camid;
- (BOOL)is_cam_exist:(NSString*)camid;
- (void)self_release;
- (void)item_state_change_bydeviid:(NSString*)devid with_state:(int)state;
- (void)save;
- (void)read_camlist_file;
- (BOOL)rename_camera:(NSString*)camid with_newname:(NSString*)newname;
- (void)editpass_cam_byid:(NSString*)camid with_newpass:(NSString*)newpass;
-(BOOL)is_dev_exist:(NSString*)devid;
-(void)add_dev:(NSData*)jsondata with_user:(NSString*)devuser with_pass:(NSString*)devpass with_name:(NSString*)devname;
-(void)delete_dev:(NSString*)devid;
-(cam_list_item*)getCamItem_devid:(NSString*)devid;

-(void)start_pre_connect;
-(void)release_pre_connect;
//////////////////////
-(int)getCount;
-(cam_list_item*)getItemByIndex:(int)index;

- (void)edit_cam_byid:(NSString*)camid with_newpass:(NSString*)newpass newname:(NSString*)newname;

-(void)update_push_alias_dids;
-(void)register_push_ok;
@end
