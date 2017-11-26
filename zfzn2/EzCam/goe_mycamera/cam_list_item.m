//
//  cam_item.m
//  P2PONVIF_PRO
//
//  Created by goe209 on 14-4-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "cam_list_item.h"

@implementation cam_list_item
@synthesize m_item_type;//0 group  1cam
@synthesize m_pos;
@synthesize m_type;
@synthesize m_play_type;
@synthesize m_chlid;
@synthesize cam_state_mode;
@synthesize group_state_mode;
@synthesize m_state;
@synthesize m_ptz;
@synthesize m_alert_status;
//@synthesize m_shared;
@synthesize is_stream_process;
@synthesize m_title_pinyin;
@synthesize m_title_pinyin_headchar;
@synthesize m_id;
@synthesize m_title;
@synthesize m_parentid;
@synthesize m_devid;
@synthesize m_picid;
@synthesize m_dev_user;
@synthesize m_dev_pass;
@synthesize m_streamarray;
@synthesize  main_stream;
@synthesize sub_stream;
@synthesize Dev_Thumbnil;
@synthesize firstFrame;
@synthesize cam_mode_pos;
@synthesize group_mode_pos;
@synthesize m_cam_index_path;
@synthesize m_group_index_path;
@synthesize b_snap;
@synthesize m_private_status;
@synthesize voicetalk_type;

@synthesize expanded;
@synthesize item_level;

@synthesize expanded_groupset;
@synthesize item_level_groupset;
@synthesize m_parentid_groupset;
@synthesize b_selected;
@synthesize group_type;

@synthesize m_id_cam1;
@synthesize m_id_cam2;
@synthesize m_id_cam3;
@synthesize m_id_cam4;

@synthesize m_devtype;
@synthesize b_alarm_in;
@synthesize m_fisheyetype;
@synthesize m_state_svr;
@synthesize nRowID;
@synthesize m_firmware;
@synthesize m_model;
@synthesize nIndex;

-(void)process_stream
{
    //NSLog(@"process_stream---0");
    if (is_stream_process==true) {
        return;
    }
    //NSLog(@"process_stream---1");
    is_stream_process = true;
    if (m_streamarray == Nil || [m_streamarray count] <= 0) {
        return;
    }
    //NSLog(@"process_stream---2");
    stream_item* cur_item = [m_streamarray objectAtIndex:0];
    main_stream = cur_item;
    sub_stream = cur_item;
    int main_pre_size = cur_item.width;//cur_item.width * cur_item.height;
    int sub_pre_size = main_pre_size;
    int cur_size = 0;
    for(stream_item* item in m_streamarray) {
        if (item != nil) {
            //NSLog(@"process_stream---item.widht=%d, height=%d",item.width, item.height);
            cur_size = item.width;//item.width * item.height;
            if (main_pre_size < cur_size) {
                main_stream = item;
                main_pre_size = cur_size;
            }
            if (sub_pre_size > cur_size) {
                sub_stream = item;
                sub_pre_size = cur_size;
            }
        }
    }
    //NSLog(@"process_stream, main_stream, widht=%d, height=%d",main_stream.width, main_stream.height);
    //NSLog(@"process_stream, sub_stream, widht=%d, height=%d",sub_stream.width, sub_stream.height);
}
@end
