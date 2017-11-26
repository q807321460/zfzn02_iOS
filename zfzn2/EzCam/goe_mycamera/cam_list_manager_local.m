//
//  cam_list_manager_local.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "cam_list_manager_local.h"

@implementation cam_list_manager_local
@synthesize delegate;

@synthesize nsDIDsFromVV;
@synthesize nsAliasFromVV;

static cam_list_manager_local* instance;

-(id)init{
    self = [super init];
    bPushServiceOK=false;
    g_chan_dictionary = [NSMutableDictionary dictionary];
    g_chan_array = [NSMutableArray new];
    g_online_devs_array= [NSMutableArray new];
    g_push_devs_array=[NSMutableArray new];
    m_file_manager=[pic_file_manager getInstance];
    [m_file_manager init_file_path];
    goe_Http=[ppview_cli getInstance];
    goe_Http.cli_c2d_preconnect_delegate=self;
    goe_Http_v2=[ppview_cli_v2 getInstance];
    m_language= [self getCurrentLanguage];
    m_lockstr = [[NSString alloc]initWithFormat:@"hello"];  ;
    
    if ([m_language hasPrefix:@"zh"]==true) {
        m_language=@"zh";
        
    }
    else
        m_language=@"en";
    
    return self;
}

-(void)register_push_ok
{
    bPushServiceOK=true;
    [self update_push_alias_dids];
}
- (NSString*)getCurrentLanguage
{
    NSArray *langArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    return langArray[0];
}


+ (cam_list_manager_local*) getInstance{
    if(instance==nil){
        instance = [[cam_list_manager_local alloc] init ];
    }
    return instance;
}
-(void)self_release
{
    [g_chan_dictionary removeAllObjects];
    [g_chan_array removeAllObjects];
    [g_cam_dictionary  removeAllObjects];
    [g_online_devs_array removeAllObjects];
    [g_push_devs_array removeAllObjects];
    bPushServiceOK=false;
}

-(int)getCount
{
    return (int)g_chan_array.count;
}
-(cam_list_item*)getItemByIndex:(int)index
{
    if (index<0|| index>g_chan_array.count) {
        //NSLog(@"getItemByIndex, index=%d, g_chan_array.count=%d",index,(int)g_chan_array.count);
        return nil;
    }
    cam_list_item* cur_item=[g_chan_array objectAtIndex:index];
    //NSLog(@"getItemByIndex, devid=%@, state=%d",cur_item.m_devid,cur_item.m_state);
    return cur_item;
}
-(BOOL)is_dev_exist:(NSString*)devid
{
    if (devid==nil) {
        return false;
    }
    for(cam_list_item* cur_item in g_chan_array)
    {
        if ([cur_item.m_devid isEqualToString:devid]==true) {
            return true;
        }
    }
    return false;
}
-(void)update_push_alias_dids
{
    @synchronized(m_lockstr)
    {
        [g_push_devs_array removeAllObjects];
        for(cam_list_item* cur_item in g_chan_array)
        {
            vv_dev_item* cur_dev_item = [vv_dev_item new];
            cur_dev_item.m_devid=cur_item.m_devid;
            cur_dev_item.m_name=cur_item.m_title;
            cur_dev_item.m_chl=cur_item.m_chlid;
            [g_push_devs_array addObject:cur_dev_item];
        }
        [goe_Http_v2 cli_lib_push_devs:g_push_devs_array lange:m_language];
    }

}
-(void)start_push_devs_to_svr
{
    [goe_Http_v2 cli_lib_push_devs:g_push_devs_array lange:m_language];
}
-(void)add_cam_item:(cam_list_item*)cam
{
    //NSLog(@"cam_list_manager_local--------0");
    if (cam==nil) {
        //NSLog(@"cam_list_manager_local--------1");
        return;
    }
    if ([self is_cam_exist:cam.m_id]==true) {
        //NSLog(@"cam_list_manager_local--------2");
        return;
    }
    //NSLog(@"add_cam_item, cam.m_state=%d",cam.m_state);
    [g_chan_array addObject:cam];
    [g_chan_dictionary setObject:cam forKey:cam.m_id];
    //NSLog(@"cam_list_manager_local--------add ok");
    //[self save];
}
-(BOOL)save_camlist_file:(NSData*)data
{
    if (data==nil) {
        return false;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"app_home_doc: %@",documentsDirectory);
    NSString* m_path= [documentsDirectory stringByAppendingPathComponent:@"ppviewinfo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:m_path])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            //NSLog(@"文件夹创建成功m_path_jpg");
        }
        else{
            //NSLog(@"文件夹创建失败 m_path_jpg");
        }
    }
    NSString *filename=[NSString stringWithFormat:@"%@/%@.txt",m_path,@"camlist"];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_camlist_file,文件创建成功: %@" ,filename);
    }else{
       
        return FALSE;
    }
    [data writeToFile:filename atomically:YES];
    return true;
}
- (void)read_camlist_file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"read_camlist_file: %@",documentsDirectory);
    NSString* m_path= [documentsDirectory stringByAppendingPathComponent:@"ppviewinfo"];
    NSString *filename=[NSString stringWithFormat:@"%@/%@.txt",m_path,@"camlist"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filename];
    [self setJsonData:data];
    NSString* readstring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"readstring=%@",readstring);
}
-(void)save
{
    NSMutableArray *array_cams=[[NSMutableArray alloc]init];
    for (cam_list_item* cam_item in g_chan_array){
        NSMutableDictionary* dic_cam = [[NSMutableDictionary alloc]init];
        [dic_cam setObject:cam_item.m_id forKey:@"id"];
        [dic_cam setObject:cam_item.m_title forKey:@"name"];
        [dic_cam setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        [dic_cam setObject:[NSNumber numberWithInt:cam_item.m_play_type] forKey:@"play_type"];
        [dic_cam setObject:cam_item.m_devid forKey:@"devid"];
        [dic_cam setObject:[NSNumber numberWithInt:cam_item.m_chlid] forKey:@"chlid"];
        [dic_cam setObject:cam_item.m_dev_user forKey:@"dev_user"];
        [dic_cam setObject:cam_item.m_dev_pass forKey:@"dev_pass"];
        if(cam_item.m_firmware==nil)
            cam_item.m_firmware=@"";
        [dic_cam setObject:cam_item.m_firmware forKey:@"firmware"];
        [dic_cam setObject:cam_item.m_model forKey:@"model"];

        [dic_cam setObject:[NSNumber numberWithInt:cam_item.m_ptz] forKey:@"ptz"];
        [dic_cam setObject:[NSNumber numberWithInt:cam_item.m_alert_status] forKey:@"alert_status"];
        [dic_cam setObject:[NSNumber numberWithInt:cam_item.voicetalk_type] forKey:@"voicetalk_type"];
        [dic_cam setObject:[NSNumber numberWithInt:cam_item.m_fisheyetype] forKey:@"fisheyetype"];

        //
        NSMutableArray *array_streams=[[NSMutableArray alloc]init];
        for (stream_item* stream_item in cam_item.m_streamarray) {
            NSMutableDictionary* dic_stream = [[NSMutableDictionary alloc]init];
            [dic_stream setObject:[NSNumber numberWithInt:stream_item.stream_id] forKey:@"stream_id"];
            [dic_stream setObject:[NSNumber numberWithInt:stream_item.width] forKey:@"width"];
            [dic_stream setObject:[NSNumber numberWithInt:stream_item.height] forKey:@"height"];
            [dic_stream setObject:[NSNumber numberWithInt:stream_item.frame_rate] forKey:@"frame_rate"];
            NSMutableDictionary *fishpara= [[NSMutableDictionary alloc]init];
            [fishpara setObject:[NSNumber numberWithInt:stream_item.m_fish_left] forKey:@"l"];
            [fishpara setObject:[NSNumber numberWithInt:stream_item.m_fish_right] forKey:@"r"];
            [fishpara setObject:[NSNumber numberWithInt:stream_item.m_fish_top] forKey:@"t"];
            [fishpara setObject:[NSNumber numberWithInt:stream_item.m_fish_bottom] forKey:@"b"];
            [dic_stream setObject:fishpara forKey:@"fisheye_params"];
            
            [array_streams addObject:dic_stream];
        }
        [dic_cam setObject:array_streams forKey:@"streams"];
        [array_cams addObject:dic_cam];

    }
    NSMutableDictionary* dic_cams = [[NSMutableDictionary alloc]init];
    [dic_cams setObject:array_cams forKey:@"cams"];
    NSData* savedata = [NSJSONSerialization dataWithJSONObject:dic_cams options:NSJSONWritingPrettyPrinted error:nil];
    if (savedata != nil) {
        NSLog(@"save camelist:%@  count=%d",dic_cams, [g_chan_array count]);
        [self save_camlist_file:savedata];
    }
    
}

- (BOOL)setJsonData:(NSData*)camdata{
    if (camdata==NULL) {
        return false;
    }
    @synchronized(self){
        nsDIDsFromVV=@"";
        nsAliasFromVV=@"";
        g_cam_data=camdata;
        NSError* reserr;
        if (g_cam_dictionary!=nil) {
            [g_cam_dictionary removeAllObjects];
        }
        g_cam_dictionary = [NSJSONSerialization JSONObjectWithData: g_cam_data options:NSJSONReadingMutableContainers error:&reserr];
        if (g_cam_dictionary==nil) {
            return false;
        }
        [g_chan_dictionary removeAllObjects];
        [g_chan_array removeAllObjects];
        [g_online_devs_array removeAllObjects];
        if ([g_cam_dictionary objectForKey:@"cams"]) {
            for (NSDictionary* camd_item in [g_cam_dictionary objectForKey:@"cams"]) {
                cam_list_item* cur_item = [cam_list_item new];
                cur_item.m_item_type=1;
                cur_item.m_title=[camd_item objectForKey:@"name"];
                cur_item.m_title_pinyin=cur_item.m_title;
                cur_item.m_title_pinyin_headchar=cur_item.m_title;
                cur_item.m_title_pinyin =[cur_item.m_title_pinyin lowercaseString];
                cur_item.m_title_pinyin_headchar= [cur_item.m_title_pinyin_headchar lowercaseString];
                cur_item.m_id=[camd_item objectForKey:@"id"];
                cur_item.m_firmware=[camd_item objectForKey:@"firmware"];
                cur_item.m_model=[camd_item objectForKey:@"model"];
                cur_item.m_type=[[camd_item objectForKey:@"type"]intValue];
                cur_item.m_play_type=[[camd_item objectForKey:@"play_type"]intValue];
                cur_item.m_fisheyetype=[[camd_item objectForKey:@"fisheyetype"]intValue];
                cur_item.m_devid=[camd_item objectForKey:@"devid"];
                cur_item.m_chlid=[[camd_item objectForKey:@"chlid"]intValue];
                cur_item.m_dev_user=[camd_item objectForKey:@"dev_user"];
                cur_item.m_dev_pass=[camd_item objectForKey:@"dev_pass"];
                cur_item.m_ptz=[[camd_item objectForKey:@"ptz"]intValue];
                cur_item.m_alert_status=[[camd_item objectForKey:@"alert_status"]intValue]?YES:NO;
                cur_item.voicetalk_type = [[camd_item objectForKey:@"voicetalk_type"]intValue];
                
                
                cur_item.cam_state_mode=0;
                cur_item.b_snap=false;
                cur_item.group_state_mode=0;
                cur_item.is_stream_process=false;
                //cur_item.m_shared=false;
                cur_item.m_parentid=@"";
                cur_item.m_picid=@"";
                
                cur_item.m_state=0;
                //NSLog(@"1--------item.m_state=%d",cur_item.m_state);
                cur_item.m_streamarray=[NSMutableArray new];
                
                for(NSDictionary* stream_item_dic in [camd_item objectForKey:@"streams"])
                {
                    stream_item *cur_stream = [stream_item new];
                    cur_stream.width = [[stream_item_dic objectForKey:@"width"]intValue];
                    cur_stream.height = [[stream_item_dic objectForKey:@"height"]intValue];
                    cur_stream.frame_rate=[[stream_item_dic objectForKey:@"frame_rate"]intValue];
                    cur_stream.stream_id = [[stream_item_dic objectForKey:@"stream_id"]intValue];
                    
                    if (cur_item.m_fisheyetype>=1) {
                        NSDictionary *fishpara=[stream_item_dic objectForKey:@"fisheye_params"];
                        if (fishpara!=nil)
                        {
                            cur_stream.m_fish_left=[[fishpara objectForKey:@"l"]floatValue];
                            cur_stream.m_fish_right=[[fishpara objectForKey:@"r"]floatValue];
                            cur_stream.m_fish_top=[[fishpara objectForKey:@"t"]floatValue];
                            cur_stream.m_fish_bottom=[[fishpara objectForKey:@"b"]floatValue];
                        }
                        else{
                            cur_stream.m_fish_left=(cur_stream.width-cur_stream.height)/2;
                            cur_stream.m_fish_right=cur_stream.m_fish_left;
                            if (cur_item.m_fisheyetype==1) {
                                cur_stream.m_fish_top=0;
                                cur_stream.m_fish_bottom=0;
                            }
                            else if(cur_item.m_fisheyetype==2){
                                cur_stream.m_fish_top=-cur_stream.height/4;
                                cur_stream.m_fish_bottom=-cur_stream.height/4;
                            }
                        }
                        
                    }
                    [cur_item.m_streamarray addObject:cur_stream];
                }
                
                if ([self is_dev_exist:cur_item.m_devid]==false) {
                    vv_dev_item* cur_dev_item = [vv_dev_item new];
                    cur_dev_item.m_devid=cur_item.m_devid;
                    cur_dev_item.m_p2p_pass=@"";
                    [g_online_devs_array addObject:cur_dev_item];
                }
                [g_chan_array addObject:cur_item];
                [g_chan_dictionary setObject:cur_item forKey:cur_item.m_id];
                            }
        }
       //[self start_pre_connect];
    }
    if (bPushServiceOK==true) {
        [self update_push_alias_dids];
    }
    
    return true;
}
-(NSMutableArray*)getChanList{
    return g_chan_array;
}
- (void)editpass_cam_byid:(NSString*)camid with_newpass:(NSString*)newpass
{
    if (camid==nil) {
        return;
    }
    @synchronized(self){
        
        for(cam_list_item* item in g_chan_array) {
            if ([item.m_devid isEqualToString:camid]==true) {
                item.m_dev_pass=newpass;
            }
        }
        [self save];
    }
}
- (void)edit_cam_byid:(NSString*)camid with_newpass:(NSString*)newpass newname:(NSString*)newname
{
    if (camid==nil) {
        return;
    }
    BOOL bNewName=false;
    @synchronized(self){
        
        for(cam_list_item* item in g_chan_array) {
            if ([item.m_id isEqualToString:camid]==true) {
                if ([item.m_title isEqualToString:newname]==false) {
                    bNewName=true;
                    item.m_title=newname;
                }
                item.m_dev_pass=newpass;
                
                [self save];
               
                break;
            }
        }
        
        if (bNewName==true && delegate!=nil && [delegate respondsToSelector:@selector(cli_lib_camlist_change_callback)]) {
            //[self mapToAPNsWithDID];
            if (bPushServiceOK==true) {
                [self update_push_alias_dids];
            }
            [delegate cli_lib_camlist_change_callback];
            
            
        }
    }
}
-(BOOL)is_cam_exist:(NSString*)camid
{
    if (camid==nil) {
        return true;
    }
    cam_list_item *cur_cam_item=[g_chan_dictionary objectForKey:camid];
    if (cur_cam_item==nil) {
        return false;
    }
    return true;
}
- (void)delete_cam_byid:(NSString*)camid
{
    if (camid==nil) {
        return;
    }
    @synchronized(self){
    cam_list_item *cur_cam_item=[g_chan_dictionary objectForKey:camid];
    if (cur_cam_item==nil) {
        return;
    }
    [g_chan_dictionary removeObjectForKey:cur_cam_item.m_id];
    [g_chan_array removeObject:cur_cam_item];
    }
}
-(cam_list_item*)getCamItem:(NSString*)camid{
    if (camid==nil) {
        return nil;
    }
    cam_list_item *cur_cam_item=[g_chan_dictionary objectForKey:camid];
    return cur_cam_item;
}
-(cam_list_item*)getCamItem_devid:(NSString*)devid
{
    if (devid==nil) {
        return false;
    }
    int i=0;
    for(cam_list_item* cur_item in g_chan_array)
    {
        cur_item.nIndex=i;
        if ([cur_item.m_devid isEqualToString:devid]==true) {
            return cur_item;
        }
        i++;
    }
    return nil;
}
- (void)item_state_change_bydeviid:(NSString*)devid with_state:(int)state{
    if (devid==nil) {
        return;
    }
    @synchronized(self){
     for(cam_list_item* item in g_chan_array) {
         if ([item.m_devid isEqualToString:devid]==true) {
             if (item.m_streamarray.count>0) {
                 item.m_state=state;
             }
             else{
                 item.m_state=0;
             }
             //NSLog(@"0--------item.m_state=%d",item.m_state);
         }
     }
    }
}
-(BOOL)rename_camera:(NSString*)camid with_newname:(NSString*)newname
{
    if (camid==nil || newname==nil) {
        return false;
    }
    @synchronized(self){
    cam_list_item *cur_cam_item=[g_chan_dictionary objectForKey:camid];
    if (cur_cam_item==nil) {
        return false;
    }
    cur_cam_item.m_title=newname;
    cur_cam_item.m_title_pinyin=cur_cam_item.m_title;
    cur_cam_item.m_title_pinyin_headchar=cur_cam_item.m_title;
    [self save];
    return true;
    }
}

-(void)add_dev:(NSData*)jsondata with_user:(NSString*)devuser with_pass:(NSString*)devpass with_name:(NSString*)devname
{
    if (jsondata == nil || jsondata.length <= 0)
        return;
    NSError* reserr;
    NSMutableDictionary* tmp_dev_dictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&reserr];
    if (tmp_dev_dictionary==nil) {
        return;
    }
    NSLog(@"add_dev:%@",tmp_dev_dictionary);
    NSString* devid=[tmp_dev_dictionary objectForKey:@"dev_id"];
    if (devid==nil || devid.length<=0) {
        return;
    }
    
    @synchronized(self){
        BOOL bOK=true;
        for(NSDictionary* channel_item_dic in [tmp_dev_dictionary objectForKey:@"channels"])
        {
            if (channel_item_dic != nil) {
                //bOK=false;
                cam_list_item * cur_cam_item= [cam_list_item new];
                cur_cam_item.m_item_type=1;
                
                if (devname==nil || devname.length<=0) {
                    cur_cam_item.m_title= [channel_item_dic objectForKey:@"name"];
                }
                else
                    cur_cam_item.m_title=devname;//[channel_item_dic objectForKey:@"name"];
                
                cur_cam_item.m_id=[channel_item_dic objectForKey:@"uid"];
                cur_cam_item.m_type=0;
                cur_cam_item.m_play_type=[[channel_item_dic objectForKey:@"play_type"]intValue];
                cur_cam_item.m_fisheyetype=[[channel_item_dic objectForKey:@"fisheyetype"]intValue];
                cur_cam_item.m_firmware=[tmp_dev_dictionary objectForKey:@"firmware"];
                if(cur_cam_item.m_firmware==nil)
                    cur_cam_item.m_firmware=@"";
                cur_cam_item.m_model=[tmp_dev_dictionary objectForKey:@"model"];
                if (cur_cam_item.m_model==nil) {
                    cur_cam_item.m_model=@"";
                }

                cur_cam_item.m_devid=devid;
                cur_cam_item.m_chlid=[[channel_item_dic objectForKey:@"chl_id"]intValue];
 
                cur_cam_item.m_dev_user=devuser;
                cur_cam_item.m_dev_pass=devpass;
                cur_cam_item.m_state=0;
                cur_cam_item.m_ptz=[[channel_item_dic objectForKey:@"ptz"]intValue]?YES:NO;
                cur_cam_item.m_alert_status=[[channel_item_dic objectForKey:@"alert_status"]intValue]?YES:NO;

                cur_cam_item.b_snap=false;

                cur_cam_item.is_stream_process=false;
                cur_cam_item.voicetalk_type = [[channel_item_dic objectForKey:@"voicetalk_type"]intValue];
                cur_cam_item.m_streamarray=[NSMutableArray new];
                
                int cur_width=0;
                int cur_height=0;
                bOK=true;
                
                for(NSDictionary* stream_item_dic in [channel_item_dic objectForKey:@"streams"])
                {
                    
                    cur_width=[[stream_item_dic objectForKey:@"width"]intValue];
                    cur_height=[[stream_item_dic objectForKey:@"height"]intValue];
                    if (cur_width<=0 || cur_height<=0) {
                        //NSLog(@"cur_stream  not exist==%@",cur_cam_item.m_title);
                        [cur_cam_item.m_streamarray removeAllObjects];
                        bOK=false;
                        break;
                    }
                    stream_item *cur_stream = [stream_item new];
                    cur_stream.width = cur_width;
                    cur_stream.height = cur_height;
                    cur_stream.frame_rate=[[stream_item_dic objectForKey:@"frame_rate"]intValue];
                    cur_stream.stream_id = [[stream_item_dic objectForKey:@"stream_id"]intValue];
                    
                    if (cur_cam_item.m_fisheyetype>=1) {
                        NSDictionary *fishpara=[stream_item_dic objectForKey:@"fisheye_params"];
                        if (fishpara!=nil)
                        {
                            cur_stream.m_fish_left=[[fishpara objectForKey:@"l"]floatValue];
                            cur_stream.m_fish_right=[[fishpara objectForKey:@"r"]floatValue];
                            cur_stream.m_fish_top=[[fishpara objectForKey:@"t"]floatValue];
                            cur_stream.m_fish_bottom=[[fishpara objectForKey:@"b"]floatValue];
                        }
                        else{
                            cur_stream.m_fish_left=(cur_stream.width-cur_stream.height)/2;
                            cur_stream.m_fish_right=cur_stream.m_fish_left;
                            if (cur_cam_item.m_fisheyetype==1) {
                                cur_stream.m_fish_top=0;
                                cur_stream.m_fish_bottom=0;
                            }
                            else if(cur_cam_item.m_fisheyetype==2){
                                cur_stream.m_fish_top=-cur_stream.height/4;
                                cur_stream.m_fish_bottom=-cur_stream.height/4;
                            }
                        }
                        
                    }

                    
                    [cur_cam_item.m_streamarray addObject:cur_stream];
                }
                if ([self is_dev_exist:cur_cam_item.m_devid]==false) {
                    vv_dev_item* cur_dev_item = [vv_dev_item new];
                    cur_dev_item.m_devid=cur_cam_item.m_devid;
                    cur_dev_item.m_p2p_pass=@"";
                    [g_online_devs_array addObject:cur_dev_item];
                }
                
                [self add_cam_item:cur_cam_item];
                
            }
        }
        
        [self save];
        
        [self start_pre_connect];
    }
    //[self mapToAPNsWithDID];
    if (bPushServiceOK==true) {
        [self update_push_alias_dids];
    }
    if (delegate!=nil && [delegate respondsToSelector:@selector(cli_lib_camlist_change_callback)]) {
        
        [delegate cli_lib_camlist_change_callback];
        
    }
}
-(void)delete_dev:(NSString*)devid
{
    if (devid==nil) {
        return;
    }
    @synchronized(self){
        BOOL bChange=false;
        NSString* m_cam_jpg_name=@"";
        for(cam_list_item* item in g_chan_array) {
            if ([item.m_devid isEqualToString:devid]==true) {
                m_cam_jpg_name= [m_file_manager get_cam_thumbil_filename:item.m_id];
                if([[NSFileManager defaultManager] fileExistsAtPath:m_cam_jpg_name])
                {
                    [m_file_manager delete_folder:m_cam_jpg_name];
                }
                [g_chan_array removeObject:item];
                [g_chan_dictionary removeObjectForKey:item.m_id];
                bChange=true;
                break;
            }
        }

        if (bChange==true)
        {
            for(vv_dev_item* item in g_online_devs_array) {
                if ([item.m_devid isEqualToString:devid]==true) {
                    [g_online_devs_array removeObject:item];
                    break;
                }
            }
            [self save];
            
            [self start_pre_connect];
            //[self mapToAPNsWithDID];
            if (bPushServiceOK==true) {
                [self update_push_alias_dids];
            }
            if (delegate!=nil && [delegate respondsToSelector:@selector(cli_lib_camlist_change_callback)]) {
                
                [delegate cli_lib_camlist_change_callback];
                
            }
        }
        
    }
}
- (BOOL)dev_preconnect_change_bydevid:(NSString*)devid with_state:(int)state{
    if (devid==nil) {
        return false;
    }
    @synchronized(self){
        BOOL bChange=false;
        for(cam_list_item* item in g_chan_array) {
            if ([item.m_devid isEqualToString:devid]==true && item.m_state!=state) {
                item.m_state=state;
                bChange=true;
                NSLog(@"0--------dev_preconnect_change_bydeviid, id=%@, item.m_state=%d",item.m_devid,item.m_state);
            }
        }
        return bChange;
    }
}
-(void)dev_preconnect_change_mainthread:(cam_list_manager_req*)req
{
    NSString* devid=req.str_tag1;
    int status=req.int_tag1;
    NSLog(@"dev_preconnect_change_mainthread,status=%d",status);
    if ([self dev_preconnect_change_bydevid:devid with_state:status]==true) {
        if (delegate!=nil && [delegate respondsToSelector:@selector(cli_lib_camlist_change_callback)]) {
            [delegate cli_lib_camlist_change_callback];
            
        }
    }
    
}
-(void)cli_lib_pre_devconnect_CALLBACK:(int)msg_id connector:(int)h_connector result:(int)res devid:(NSString*)devid;
{
    cam_list_manager_req* cur_req= [cam_list_manager_req new];
    cur_req.str_tag1=devid;
    if (res==1) {
        cur_req.int_tag1=1;
    }
    else
        cur_req.int_tag1=0;
    [self performSelectorOnMainThread:@selector(dev_preconnect_change_mainthread:) withObject:cur_req waitUntilDone:YES];
}

-(void)start_pre_connect
{
    [goe_Http cli_lib_set_preconnects:g_online_devs_array];
}

-(void)release_pre_connect
{
    for(cam_list_item* item in g_chan_array) {
        item.m_state=0;
    }
    [goe_Http cli_lib_set_preconnects:nil];
    
}




@end
