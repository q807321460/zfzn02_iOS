//
//  cam_item.h
//  P2PONVIF_PRO
//
//  Created by goe209 on 14-4-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stream_item.h"
@interface cam_list_item : NSObject{
    
}

@property (assign) int cam_mode_pos;
@property (assign) int group_mode_pos;
@property (assign) int m_item_type;
@property (assign) int m_pos;
@property (assign) int m_play_type;
@property (assign) int m_type;
@property (assign) int m_chlid;
@property (assign) BOOL cam_state_mode;
@property (assign) BOOL group_state_mode;
@property (assign) int m_state;
@property (assign) int m_state_svr;
@property (assign) int m_ptz;
@property (assign) int m_alert_status;
//@property (assign) BOOL m_shared;
@property (assign) BOOL is_stream_process;
@property (assign) BOOL firstFrame;
@property (assign) BOOL b_snap;
@property (assign) int m_private_status;
@property (retain) NSIndexPath* m_cam_index_path;
@property (retain) NSIndexPath* m_group_index_path;
@property (retain) NSString* m_title_pinyin;
@property (retain) NSString* m_title_pinyin_headchar;
@property (retain) NSString* m_id;
@property (retain) NSString* m_title;
@property (retain) NSString* m_parentid;
@property (retain) NSString* m_devid;
@property (retain) NSString* m_picid;
@property (retain) NSString* m_dev_user;
@property (retain) NSString* m_dev_pass;
@property (retain) NSMutableArray* m_streamarray;

@property (retain) stream_item*  main_stream;
@property (retain) stream_item* sub_stream;
@property (assign) int voicetalk_type;
@property (retain) NSData* Dev_Thumbnil;//摄像头图片数据



@property (assign) BOOL expanded;
@property (assign) int item_level;

@property (assign) int group_type;//自建分组 0  共享分组 1
//分组设置使用
@property (assign) BOOL expanded_groupset;
@property (assign) int item_level_groupset;
@property (retain) NSString* m_parentid_groupset;
@property (assign) BOOL b_selected;

//
@property (retain) NSString* m_id_cam1;
@property (retain) NSString* m_id_cam2;
@property (retain) NSString* m_id_cam3;
@property (retain) NSString* m_id_cam4;

@property (assign) int m_devtype;
@property (assign) int b_alarm_in;
@property (assign) int m_fisheyetype;

@property (assign) int nRowID;
@property (assign) int nIndex;
@property (retain) NSString* m_firmware;
@property (retain) NSString* m_model;
-(void)process_stream;
@end
