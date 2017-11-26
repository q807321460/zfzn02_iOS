//
//  libonvif_interface.h
//  P2PONVIF_PRO
//
//  Created by goe209 on 14-4-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libvvonvif_def.h"

@protocol register_interface <NSObject>
@optional
-(void)cli_lib_CheckUser_CALLBACK:(int)HttpRes with_usr:(NSString*)usr;
-(void)cli_lib_Register_CALLBACK:(int)HttpRes;
@end

@protocol vercode_interface <NSObject>
@optional
-(void)cli_lib_GetPicVcode_CALLBACK:(int)HttpRes picdata:(NSData*)data;
-(void)cli_lib_CheckPicVcode_CALLBACK:(int)HttpRes with_vercode:(NSString*)vcode;
-(void)cli_lib_GetSmsVcode_CALLBACK:(int)HttpRes;
-(void)cli_lib_GetMailVcode_CALLBACK:(int)HttpRes;
-(void)cli_lib_CheckSmsVcode_CALLBACK:(int)HttpRes with_vercode:(NSString*)vcode mobile:(NSString*)mobile;
@end

@protocol login_interface <NSObject>
@optional
-(void)cli_lib_login_callback:(int)HttpRes;
-(void)cli_lib_GetAccessUrl_CALLBACK:(int)HttpRes cli_url:(NSString *)cliurl dev_url:(NSString*)devurl event_url:(NSString*)eventurl;
-(void)cli_lib_GetRegiserType_CALLBACK:(int)HttpRes type:(int)reg_type;
@end

@protocol cameralist_interface <NSObject>
@optional
-(void)cli_lib_GetCamlistSn_CALLBACK:(int)HttpRes sn:(short)list_sn;
-(void)cli_lib_GetCamlist_CALLBACK:(int)HttpRes data:(NSData*)data;
-(void)cli_lib_ModifyCamName_CALLBACK:(int)HttpRes camid:(NSString*)cam_id cam_name:(NSString*)camname parentid:(NSString*)parent_id my_sn:(int)sn;
-(void)cli_lib_DeleteCam_CALLBACK:(int)HttpRes camid:(NSString*)cam_id devid:(NSString*)devid my_sn:(int)sn;
-(void)cli_lib_DeleteShareCam_CALLBACK:(int)HttpRes camid:(NSString*)cam_id devid:(NSString*)devid my_sn:(int)sn;
-(void)cli_lib_ModifyGroupName_CALLBACK:(int)HttpRes groupid:(NSString*)group_id new_name:(NSString*)newname parentid:(NSString*)parent_id my_sn:(int)sn;
-(void)cli_lib_AddNewGroup_CALLBACK:(int)HttpRes groupid:(NSString*)group_id parentid:(NSString*)parent_id new_name:(NSString*)newname my_sn:(int)sn;
-(void)cli_lib_Deletegroup_CALLBACK:(int)HttpRes groupid:(NSString*)group_id my_sn:(int)sn;
-(void)cli_lib_MoveGroup_CALLBACK:(int)HttpRes groupid:(NSString*)group_id old_parid:(NSString*)oldparid new_parid:(NSString*)newparid my_sn:(int)sn;
-(void)cli_lib_MoveCamera_CALLBACK:(int)HttpRes camid:(NSString*)cam_id old_parid:(NSString*)parent_old new_parid:(NSString*)parent_new my_sn:(int)sn;
-(void)cli_lib_SetCamAlert_CALLBACK:(int)HttpRes camid:(NSString*)cam_id status:(int)status;
-(void)cli_lib_SetCamsAlert_CALLBACK:(int)HttpRes status:(int)status;
-(void)cli_lib_SetCamPrivate_CALLBACK:(int)HttpRes camid:(NSString*)cam_id status:(int)status;
-(void)cli_lib_MoveGroup_to_newgroup_CALLBACK:(int)HttpRes groupid:(NSString*)group_id old_parid:(NSString*)oldparid new_groupname:(NSString*)new_groupname new_groupid:(NSString*)new_groupid new_group_par_id:(NSString*)new_group_par_id my_sn:(int)sn;
-(void)cli_lib_MoveCamera_to_newgroup_CALLBACK:(int)HttpRes camid:(NSString*)cam_id old_parid:(NSString*)parent_old new_groupname:(NSString*)new_groupname new_groupid:(NSString*)new_groupid new_group_par_id:(NSString*)new_group_par_id my_sn:(int)sn;
@end

@protocol devlist_interface <NSObject>
@optional
-(void)cli_lib_GetDevList_CALLBACK:(int)HttpRes data:(NSData*)data;
@end

@protocol dev_set_interface <NSObject>
@optional
-(void)cli_lib_devsetpass_CALLBACK:(int)HttpRes devid:(NSString*)dev_id;
@end

@protocol dev_delete_interface <NSObject>
@optional
-(void)cli_lib_deleteDev_CALLBACK:(int)HttpRes devid:(NSString*)dev_id;
@end

@protocol add_dev_interface <NSObject>
@optional
-(void)cli_lib_search_callback:(NSArray*)searchres my_sess:(NSString*)searchsess;
-(void)cli_lib_vv_search_callback:(NSData*)searchdata;
-(void)cli_lib_binduser_callback:(int)result my_sess:(NSString*)bindsess;
-(void)cli_lib_getdevinfo_callback:(int)result with_data:(NSData*)jsondata;
-(void)cli_lib_binduser_offline_callback:(int)result devid:(NSString*)devid;
@end


@protocol set_interface <NSObject>
@optional
-(void)cli_lib_ResetPassword_CALLBACK:(int)HttpRes with_vercode:(NSString*)vercode;
-(void)cli_lib_ModifyPassword_CALLBACK:(int)HttpRes newpass:(NSString*)new_pass;
-(void)cli_lib_GetUsrInfo_CALLBACK:(int)HttpRes type:(int)type mobile:(NSString*)mobile email:(NSString*)email nick:(NSString*)nickname;
-(void)cli_lib_ResetPassword_sms_CALLBACK:(int)HttpRes with_vercode:(NSString*)vercode;
-(void)cli_lib_ResetPassword_mail_CALLBACK:(int)HttpRes with_mail:(NSString*)mail;
-(void)cli_lib_ModifyNick_CALLBACK:(int)HttpRes newnick:(NSString*)new_nick;
-(void)cli_lib_ModifyMail_CALLBACK:(int)HttpRes newmail:(NSString*)new_mail;
-(void)cli_lib_GetUsr_CALLBACK:(int)HttpRes usr:(NSString*)usr phone:(NSString*)phone;
@end


@protocol dev_connect_interface <NSObject>
@optional
-(void)cli_lib_devconnect_CALLBACK:(int)msg_id connector:(int)h_connector result:(int)res;
-(void)cli_lib_getdevinfo_callback:(int)result with_data:(NSData*)jsondata devid:(NSString*)devid;
@end

@protocol pre_connect_interface <NSObject>
@optional
-(void)cli_lib_pre_devconnect_CALLBACK:(int)msg_id connector:(int)h_connector result:(int)res devid:(NSString*)devid;
@end

@protocol dev_netif_interface <NSObject>
@optional
-(void)cli_lib_netif_get_CALLBACK:(int)res with_data:(NSData*)net_data;
-(void)cli_lib_netif_set_CALLBACK:(int)res;

-(void)cli_lib_netif_cli_get_CALLBACK:(int)res with_data:(NSData*)net_data;
-(void)cli_lib_netif_cli_set_CALLBACK:(int)res;
@end

@protocol get_camlist_sp_interface <NSObject>
@optional
-(void)cli_lib_get_camlist_sp_callback:(int)res with_data:(NSData*)data;
@end

@protocol set_camlist_sp_interface <NSObject>
@optional
-(void)cli_lib_set_camlist_sp_callback:(int)res with_sn:(short)new_sn;
@end

@protocol get_devlist_sp_interface <NSObject>
@optional
-(void)cli_lib_get_devlist_sp_callback:(int)res with_data:(NSData*)data;
@end

@protocol set_devlist_sp_interface <NSObject>
@optional
-(void)cli_lib_set_devlist_sp_callback:(int)res with_sn:(short)new_sn;
@end

@protocol sn_list_sp_interface <NSObject>
@optional
-(void)cli_lib_get_list_sn_sp_callback:(int)res with_camsn:(short)cam_sn with_devsn:(short)dev_sn;
@end

@protocol vvpush_msg_interface <NSObject>
@optional
-(void)cli_lib_push_register_callback:(int)res;
-(void)cli_lib_push_unregister_callback:(int)res;
-(void)cli_lib_devstatus_change_callback:(NSString*)devid status:(int)status;
-(void)cli_lib_devlist_change_callback;
-(void)cli_lib_eventpic_change_callback:(NSString*)eventid;
-(void)cli_lib_camlist_change_callback:(short)sn;
-(void)cli_lib_alarm_callback:(NSDictionary*)event;
-(void)cli_lib_alert_change_callback:(NSString*)camid status:(int)status;
-(void)cli_lib_disable_alert_event_callback:(NSString*)camid;
-(void)cli_lib_disable_lowpower_event_callback:(NSString*)camid;
-(void)cli_lib_camprivate_change_callback:(NSString*)camid status:(int)status;
-(void)cli_lib_req_cam_sharenum_change_callback:(int)num;
-(void)cli_lib_user_relations_changed_callback:(NSDictionary*)dic;
//-(void)cli_lib_qrcode_bind_callback:(int)res devid:(NSString*)devid dev_ower:(NSString*)dev_ower;
@end

@protocol vvpush_msg_interface_ex <NSObject>
@optional
-(void)cli_lib_qrcode_bind_callback:(int)res devid:(NSString*)devid dev_ower:(NSString*)dev_ower;

@end

@protocol c2s_msg_interface <NSObject>
@optional
-(void)cli_lib_unreadeventcount_callback:(int)res count:(int)count;
-(void)cli_lib_newevents_callback:(int)res event_id:(NSString*)event_id events:(NSData*)events;
-(void)cli_lib_events_callback:(int)res event_id:(NSString*)event_id events:(NSData*)events;
-(void)cli_lib_set_allevents_read_callback:(int)res;
-(void)cli_lib_disable_alert_event_callback:(int)res camid:(NSString*)camid;
-(void)cli_lib_disable_lowpower_event_callback:(int)res camid:(NSString*)camid;
@end

@protocol c2s_cam_msg_interface <NSObject>
@optional
-(void)cli_lib_cam_newevents_callback:(int)res cam_id:(NSString*)cam_id event_id:(NSString*)event_id events:(NSData*)events;
-(void)cli_lib_cam_events_callback:(int)res cam_id:(NSString*)cam_id event_id:(NSString*)event_id events:(NSData*)events;
@end

@protocol c2d_cam_query_record_interface <NSObject>
@optional
-(void)cli_lib_cam_record_min_callback:(int)res timelists:(NSMutableArray*)lists;
-(void)cli_lib_cam_record_date_callback:(int)res days:(NSString*)days with_date:(NSString*)str_date;
@end

@protocol c2s_usr_relations_interface <NSObject>
@optional
-(void)cli_lib_GetUsrRelations_CALLBACK:(int)HttpRes data:(NSData*)data;
-(void)cli_lib_AddUsrRelations_CALLBACK:(int)HttpRes relation_usr:(NSString*)relation_usr relation_type:(int)relation_type;
-(void)cli_lib_ModifyUsrRelations_CALLBACK:(int)HttpRes relation_usr:(NSString*)relation_usr relation_type:(int)relation_type memo:(NSString*)memo;
-(void)cli_lib_DeleteUsrRelations_CALLBACK:(int)HttpRes relation_usr:(NSString*)relation_usr;
@end

@protocol c2s_share_cams_interface <NSObject>
@optional
-(void)cli_lib_GetShareCams_CALLBACK:(int)HttpRes relation_user:(NSString*)relation_usr data:(NSData*)data;
-(void)cli_lib_SetShareCams_CALLBACK:(int)HttpRes relation_usr:(NSString*)relation_usr;
-(void)cli_lib_ReqShareDev_CALLBACK:(int)HttpRes devid:(NSString*)devid;
-(void)cli_lib_GetDevBelong_CALLBACK:(int)HttpRes devid:(NSString*)devid belongto:(NSString*)belong_usr;
-(void)cli_lib_GetCam_shareusrs_CALLBACK:(int)HttpRes camid:(NSString*)camid data:(NSData*)data;
-(void)cli_lib_SetShareFriends_CALLBACK:(int)HttpRes camid:(NSString*)camid;
@end

@protocol c2s_share_req_interface <NSObject>
@optional
-(void)cli_lib_GetShareReqs_CALLBACK:(int)HttpRes data:(NSData*)data;
-(void)cli_lib_ResponseShareReq_CALLBACK:(int)HttpRes reqid:(NSString*)reqid;
@end

@protocol c2s_share_reqcount_interface <NSObject>
@optional
-(void)cli_lib_reqcount_callback:(int)res count:(int)count;
@end

@protocol c2s_sensors_interface <NSObject>
@optional
-(void)cli_lib_get_sensors_callback:(int)res data:(NSData*)data;
-(void)cli_lib_sensor_codding_callback:(int)res data:(NSData*)data;
-(void)cli_lib_sensor_delete_callback:(int)res sensor_id:(NSString*)sensor_id;
-(void)cli_lib_sensor_set_callback:(int)res tag:(int)tag sensorid:(NSString*)sensorid name:(NSString*)name preset:(int)preset isalarm:(int)isalarm;
-(void)cli_lib_get_sensors_switch_callback:(int)res data:(NSData*)data;
-(void)cli_lib_sensor_subchl_remote_ctrl_callback:(int)res sensor_id:(NSString*)sensor_id chlid:(int)chlid status:(int)status;
-(void)cli_lib_sensor_subchl_set_callback:(int)res tag:(NSString*)tag sensorid:(NSString*)sensorid chlid:(int)chlid name:(NSString*)name alarm_linkage:(int)alarm_linkage;
@end

@protocol c2s_arm_config_interface <NSObject>
@optional
-(void)cli_lib_arm_config_get_callback:(int)res with_config:(NSData*)config_json;
-(void)cli_lib_arm_config_set_callback:(int)res;
@end

@protocol c2s_sdcard_interface <NSObject>
@optional
-(void)cli_lib_sdcard_info_get_callback:(int)res status:(int)status total_space:(int)total_space free_space:(int)free_space;
-(void)cli_lib_sdcard_format_callback:(int)res;
-(void)cli_lib_sdcard_format_progress_callback:(int)progress;
@end

@protocol c2s_arm_events_interface <NSObject>
@optional
-(void)cli_lib_arm_events_get_callback:(int)res type:(int)type data:(NSData*)data;
@end

@protocol c2s_record_config_interface <NSObject>
@optional
-(void)cli_lib_record_config_get_callback:(int)res with_config:(NSData*)config_json;
-(void)cli_lib_record_config_set_callback:(int)res;
@end

@protocol c2s_dev_wifi_interface <NSObject>
@optional
-(void)cli_lib_get_wifi_list_callback:(int)res data:(NSData*)data;
-(void)cli_lib_set_wifi_callback:(int)res;
@end

@protocol c2s_dev_firmware_interface <NSObject>
@optional
-(void)cli_lib_get_dev_firmware_callback:(int)res cur_ver:(NSString*)cur_ver new_ver:(NSString*)new_ver firm_url:(NSString*)firm_url firm_hash:(NSString*)firm_hash model:(NSString*)model;
-(void)cli_lib_upgrade_firmware_callback:(int)msgid progress_tag1:(int)progress_tag1 progress_tag2:(int)progress_tag2;
@end

@protocol c2s_mirror_config_interface <NSObject>
@optional
-(void)cli_lib_mirror_config_get_callback:(int)res with_config:(int)config;
-(void)cli_lib_mirror_config_set_callback:(int)res;
@end

@protocol c2d_timezone_interface <NSObject>
@optional
-(void)cli_lib_timezone_get_callback:(int)res;
-(void)cli_lib_timezone_set_callback:(int)res timezone:(int)timezone;
@end

@protocol c2d_trchl_interface <NSObject>
@optional
-(void)cli_lib_trchl_receive_callback:(int)trchlhandle data:(NSData*)data datalen:(int)datalen;
@end

@protocol s2c_usr_interface <NSObject>
@optional
-(void)cli_lib_usrpass_changed_callback:(NSString*)tag;
@end

@protocol c2d_arm_interface <NSObject>
@optional
-(void)cli_lib_c2d_armstatus_get_callback:(int)res;
-(void)cli_lib_c2d_armstatus_set_callback:(int)res status:(int)status;
@end

@interface ppview_cli : NSObject
@property (assign) id<register_interface>cli_register_delegate;
@property (assign) id<vercode_interface>cli_vercode_delegate;
@property (assign) id<login_interface>cli_login_delegate;
@property (assign) id<cameralist_interface>cli_camlist_delegate;
@property (assign) id<devlist_interface>cli_devlist_delegate;
@property (assign) id<dev_set_interface>cli_devset_delegate;
@property (assign) id<dev_delete_interface>cli_devdelete_delegate;
@property (assign) id<add_dev_interface>cli_devadd_delegate;
@property (assign) id<set_interface>cli_set_delegate;
@property (assign) id<dev_connect_interface>cli_devconnect_single_delegate;
@property (assign) id<dev_connect_interface>cli_devconnect_list_delegate;
@property (assign) id<dev_netif_interface>cli_netif_delegate;
@property (assign) id<get_camlist_sp_interface>cli_get_camlist_sp_delegate;
@property (assign) id<set_camlist_sp_interface>cli_set_camlist_sp_delegate;
@property (assign) id<get_devlist_sp_interface>cli_get_devlist_sp_delegate;
@property (assign) id<set_devlist_sp_interface>cli_set_devlist_sp_delegate;
@property (assign) id<sn_list_sp_interface>cli_listsn_delegate;
@property (assign) id<c2s_msg_interface>cli_c2s_msg_delegate;
@property (assign) id<c2s_cam_msg_interface>cli_c2s_cam_msg_delegate;
@property (assign) id<vvpush_msg_interface>cli_c2s_push_msg_delegate;
@property (assign) id<vvpush_msg_interface_ex>cli_c2s_push_msg_ex_delegate;
@property (assign) id<c2d_cam_query_record_interface>cli_c2d_query_record_delegate;
@property (assign) id<c2s_usr_relations_interface>cli_c2s_usrrelations_delegate;
@property (assign) id<c2s_share_cams_interface>cli_c2s_sharecams_delegate;
@property (assign) id<c2s_share_req_interface>cli_c2s_sharereqs_delegate;
@property (assign) id<c2s_share_reqcount_interface>cli_c2s_sharereqcount_delegate;
@property (assign) id<c2s_sensors_interface>cli_c2s_sensors_delegate;
@property (assign) id<c2s_arm_config_interface>cli_c2s_arm_config_delegate;
@property (assign) id<c2s_sdcard_interface>cli_c2s_sdcard_delegate;
@property (assign) id<c2s_arm_events_interface>cli_c2s_arm_events_delegate;
@property (assign) id<c2s_record_config_interface>cli_c2s_record_config_delegate;
@property (assign) id<c2s_dev_wifi_interface>cli_c2s_dev_wifi_delegate;
@property (assign) id<c2s_dev_firmware_interface>cli_c2s_dev_firmware_delegate;
@property (assign) id<c2s_mirror_config_interface>cli_c2s_mirror_config_delegate;
@property (assign) id<c2d_timezone_interface>cli_c2d_timezone_delegate;
@property (assign) id<c2d_trchl_interface>cli_c2d_trchl_delegate;
@property (assign) id<s2c_usr_interface>cli_s2c_usr_delegate;
@property (assign) id<pre_connect_interface>cli_c2d_preconnect_delegate;
@property (assign) id<c2d_arm_interface>cli_c2d_armstatus_delegate;


+ (ppview_cli*) getInstance;
-(void)lib_will_release;
-(void)lib_will_reinit;

-(void)setAppInfo:(NSString*)cli_url devurl:(NSString*)dev_url eventurl:(NSString*)event_url appid:(NSString*)app_id vendorpass:(NSString*)vendor_pass
        with_p2p_svr:(NSString*)p2psvr with_p2p_port:(int)p2p_port with_secret:(NSString*)secret;
-(void)setUserInfo:(NSString*)loginuser loginpass:(NSString*)loginpass;
-(void)setUrlInfo:(NSString*)cli_url devurl:(NSString*)dev_url eventur:(NSString*)event_url;


-(NSString*)getCliAddr;
-(NSString*)getSvrAddr;

-(int)cli_lib_GetRegisterType;//0x8001
-(int)cli_lib_GetSmsVcode:(NSString*)mobile bCheck:(int)bcheckexist;//0x8033
-(int)cli_lib_GetMailVcode:(NSString*)mail language:(NSString*)language bCheck:(int)bcheckexist;
-(int)cli_lib_GetUsrInfo:(NSString*)user;//0x8034
-(int)cli_lib_CheckSmsVcode:(NSString*)vcode mobile:(NSString*)mobile;
-(int)cli_lib_Register:(NSString*)reguser regpass:(NSString*)regpass vcode:(NSString*)vcode mail:(NSString*)mail mobile:(NSString*)mobile myses:(NSString*)sess with_nick:(NSString*)nick_name;//0x8005
-(int)cli_lib_ModifyPassword:(NSString*)oldpass new_pass:(NSString*)newpass;//0x8018
-(int)cli_lib_ModifyPassword_v2:(NSString*)usr oldpass:(NSString*)oldpass new_pass:(NSString*)newpass;
-(int)cli_lib_user_resetpass_email:(NSString*)user with_sess:(NSString*)sess with_vcode:(NSString*)vcode;//0x8019
-(int)cli_lib_user_resetpass_email_v2:(NSString*)email language:(NSString*)language;
-(int)cli_lib_user_resetpass_mobile:(NSString*)user with_mobile:(NSString*)mobile with_vcode:(NSString*)vcode new_pass:(NSString*)newpass;//0x8035
-(int)cli_lib_ModifyNick:(NSString*)newnick;//0x8037
-(int)cli_lib_ModifyMail:(NSString*)newmail;//0x8038

-(int)cli_lib_Advertise_version;
-(int)cli_lib_login:(NSString*)loguser pass:(NSString*)logpass;//0x8000
-(int)cli_lib_GetCamlist:(NSString*)loguser pass:(NSString*)logpass;//0x8006
-(int)cli_lib_getcamlist_ex;//0x8006
//-(NSString*)cli_lib_GetCamPicPostData:(NSString*)camid;//0x8007
-(int)cli_lib_ModifyCamName:(NSString*)camid new_name:(NSString*)newname sn:(int)sn parentid:(NSString*)parent_id;//0x8008
//-(int)cli_lib_DeleteCamera:(NSString*)devid camid:(NSString*)camid sn:(int)cursn;//0x8036
-(int)cli_lib_ModifyGroupName:(NSString*)groupid new_name:(NSString*)newname with_parid:(NSString*)parid sn:(int)sn;//0x8009
-(int)cli_lib_AddNewGroup:(NSString*)P_groupid new_name:(NSString*)newname sn:(int)sn;//0x8010
-(int)cli_lib_DeleteGroup:(NSString*)groupid sn:(int)sn;//0x8011
-(int)cli_lib_MoveGroup:(NSString*)groupid oldparid:(NSString*)old_parid destgroupid:(NSString*)destgroupid sn:(int)sn;//0x8012
-(int)cli_lib_MoveCamera:(NSString*)camid cam_type:(int)cam_type old_groupid:(NSString*)oldgroupid destgroupid:(NSString*)destgroupid sn:(int)sn;//0x8013
-(int)cli_lib_MoveGroup_to_newgroup:(NSString*)groupid oldparid:(NSString*)old_parid new_groupname:(NSString*)new_groupname newgroup_parid:(NSString*)newgroup_parid sn:(int)sn;//0x8057
-(int)cli_lib_MoveCamera_to_newgroup:(NSString*)camid cam_type:(int)cam_type old_groupid:(NSString*)oldgroupid new_groupname:(NSString*)new_groupname newgroup_parid:(NSString*)newgroup_parid sn:(int)sn;//0x8058
-(int)cli_lib_GetDevList;//0x8014
-(int)cli_lib_GetAccessUrl:(NSString*)loguser;//0x8015
-(int)cli_lib_GetCamlistSn;//0x8016
-(int)cli_lib_ModifyCamAlertStatus:(NSString*)camid devid:(NSString*)devid status:(int)status;//8031
-(int)cli_lib_ModifyCamsAlertStatus:(NSArray*)cams status:(int)status;//8039
-(int)cli_lib_DeleteDevice:(NSString*)devid;//0x8017
-(NSData*)cli_lib_GetCamThumbnail:(NSString*)camid;
-(NSData*)cli_lib_GetEventThumbnail:(NSString*)camid eventid:(NSString*)eventid;

-(int)cli_lib_getcamlist_sp:(NSString*)loguser pass:(NSString*)logpass;//0x8020
-(int)cli_lib_getdevlist_sp;//0x8021
-(int)cli_lib_setcamlist_sp:(NSData*)cam_json;//0x8022
-(int)cli_lib_setdevlist_sp:(NSData*)dev_json;//0x8023
-(int)cli_lib_getsnlist_sp;//0x8024

-(int)cli_lib_get_unreadevent_count;//8025
-(int)cli_lib_get_newevent_list:(NSString*)event_id;//8026
-(int)cli_lib_get_event_list:(NSString*)event_id items_count:(int)items_count;//8027,page从1开始
-(int)cli_lib_set_all_events_readed;//8028
-(int)cli_lib_get_cam_newevent_list:(NSString*)cam_id event_id:(NSString*)event_id;//8029
-(int)cli_lib_get_cam_event_list:(NSString*)cam_id event_id:(NSString*)event_id items_count:(int)items_count;//8030,page从1开始
-(NSString*)cli_lib_GetEventUrl:(NSString*)event_id fisheye_type:(int)type top:(float)top bottom:(float)bottom left:(float)left right:(float)right;

-(int)cli_lib_get_usr_relations;//0x8040
-(int)cli_lib_add_usr_relations:(NSString*)relation_usr relation_type:(int)relation_type; //0x8041
-(int)cli_lib_modify_usr_relations:(NSString*)relation_usr relation_type:(int)relation_type memo:(NSString*)memo;//0x8042
-(int)cli_lib_delete_usr_relations:(NSString*)relation_usr;//0x8043

-(int)cli_lib_get_shared_cams:(NSString*)relation_usr;//0x8044
-(int)cli_lib_set_shared_cams:(NSString*)relation_usr cam_json:(NSData*)cam_json;//0x8045
-(int)cli_lib_req_share_devid:(NSString*)devid with_msg:(NSString*)msg;//0x8046
-(int)cli_lib_get_dev_belong:(NSString*)devid;//0x8047
-(int)cli_lib_get_cam_shareusr_list:(NSString*)devid camid:(NSString*)camid;//0x8053

-(int)cli_lib_get_sharereqs_cams;//0x8048
-(int)cli_lib_response_sharereq_cam:(NSString*)reqid cmd:(int)cmd;//0x8049

//-(int)cli_lib_DeleteCamera:(NSString*)devid camid:(NSString*)camid sn:(int)cursn;//0x8036
-(int)cli_lib_delete_shared_camera:(NSString*)devid camid:(NSString*)camid sn:(int)cursn;//0x8050
-(int)cli_lib_get_sharecam_req_count;//0x8051
-(int)cli_lib_disable_cam_alert_event:(NSString*)devid camid:(NSString*)camid;//0x8052


-(int)cli_lib_disable_cam_lowpower_event:(NSString*)devid camid:(NSString*)camid;//0x8054
-(int)cli_lib_ModifyCamPrivateStatus:(NSString*)camid devid:(NSString*)devid status:(int)status;//8055
-(int)cli_lib_get_dev_firmware_info:(NSString*)devid;//8056
-(int)cli_lib_set_shared_friends:(NSString*)camid devid:(NSString*)devid friends_json:(NSData*)friends_json;//8059
-(int)cli_lib_getusr_fromphone:(NSString*)phone;//8060

-(long)cli_lib_createconnect:(NSString*)dev_id devuser:(NSString*)dev_user devpass:(NSString*)dev_pass tag:(NSString*)tag;
-(long)cli_lib_createconnect:(NSString*)dev_id devuser:(NSString*)dev_user devpass:(NSString*)dev_pass;
-(long)cli_lib_createconnect_ip:(NSString*)dev_ip devuser:(NSString*)dev_user devpass:(NSString*)dev_pass;
-(long)cli_lib_releaseconnect:(long)hconnector;
-(int)cli_lib_start_search;
-(int)cli_lib_start_search_sm;
-(int)cli_lib_stop_search;

-(int)cli_lib_bind:(long)hconnector devname:(NSString*)dev_name devusr:(NSString*)dev_usr devpass:(NSString*)dev_pass port:(int)onvif_port bind_sess:(NSString*)bindsess;
-(int)cli_lib_bind_lang:(long)hconnector devname:(NSString*)dev_name devusr:(NSString*)dev_usr devpass:(NSString*)dev_pass bind_sess:(NSString*)bindsess lang:(NSString*)lang;
-(int)cli_lib_bind_offline:(NSString*)dev_id devusr:(NSString*)dev_usr devpass:(NSString*)dev_pass devmodel:(NSString*)dev_model firmware:(NSString*)firmware channels:(NSString*)channels;//8032
-(int)cli_lib_wifi_start_config:(NSString*)ssid pass:(NSString*)passwd;
-(int)cli_lib_wifi_start_config_v2:(NSString*)ssid pass:(NSString*)passwd lang:(NSString*)lang;
-(void)cli_lib_wifi_stop_config;

-(int)cli_lib_ptzCtrl:(long)hconnector with_cid:(int)cid with_sid:(int)sid with_cmd:(int)cmd with_speed:(int)speed;
-(int)cli_lib_ptzCtrl_player:(long)handle with_cid:(int)cid with_sid:(int)sid with_cmd:(int)cmd with_speed:(int)speed times:(int)times;

-(int)cli_lib_setdevpass:(long)hconnector devuser:(NSString*)dev_usr devpass:(NSString*)dev_pass devnewpass:(NSString*)new_dev_pass;

-(int)cli_lib_get_devinfo:(long)hconnector with_usr:(NSString*)dev_user with_pass:(NSString*)dev_pass with_sess:(NSString*)sess with_type:(int)type tag:(NSString*)tag;

-(int)cli_lib_get_netif:(NSString*)dev_id devusr:(NSString*)dev_usr devpass:(NSString*)dev_pass devip:(NSString*)devip;
-(int)cli_lib_stop_getting_netif;
-(int)cli_lib_set_netif:(NSString*)dev_usr devpass:(NSString*)dev_pass devip:(NSString*)devip set_json:(NSData*)setjson;
-(int)cli_lib_stop_setting_netif;

-(int)cli_lib_create_rtspclient:(NSString *)rtsp_url devid:(NSString *)dev_id devuser:(NSString*)dev_user devpass:(NSString*)dev_pass stream_format_video:(int)video_stream_format stream_format_audio:(int)audio_stream_format;

-(int)cli_lib_create_playerclient:(int)chlid devid:(NSString *)dev_id devuser:(NSString*)dev_user devpass:(NSString*)dev_pass stream_format_video:(int)video_stream_format stream_format_audio:(int)audio_stream_format;
-(void)cli_lib_clear_player_cache;

-(int)cli_lib_set_rtsp_videoframevate:(long)rtsp_handle with_frame:(int)frame;

-(int)cli_lib_startplayurl_ex:(long)rtsp_handle;
-(int)cli_lib_startplay_player:(long)rtsp_handle stream_id:(int)stream_id;

-(int)cli_lib_suspend_startplay:(long)rtsp_handle;
-(int)cli_lib_suspend_startplay_private:(long)rtsp_handle;

-(int)cli_lib_stopplay:(long)rtsp_handle;
-(int)cli_lib_stopplay_private:(long)rtsp_handle;

-(int)cli_lib_audiostreamexists:(long)rtsp_handle;
-(int)cli_lib_audiostreamexists_private:(long)rtsp_handle;

-(int)cli_lib_setaudiostatus:(long)rtsp_handle status:(int)enabled;
-(int)cli_lib_setaudiostatus_private:(long)rtsp_handle status:(int)enabled;

-(int)cli_lib_p2ptalk_enable:(long)rtsp_handle;
-(int)cli_lib_p2ptalk_size:(long)rtsp_handle;
-(int)cli_lib_send_pcm_audio:(long)rtsp_handle with_buffer:(char*)buffer with_len:(int)len;

-(int)cli_lib_voicetalk_start:(long)hconnector with_chlid:(int)chl_id with_devusr:(NSString*)devusr with_devpass:(NSString*)devpass talktype:(int)type;
-(int)cli_lib_voicetalk_getparam:(TVVVoiceParams*)params;
-(int)cli_lib_voicetalk_stop;
-(int)cli_lib_voicetalk_send:(char*)buffer with_len:(int)len;
-(int)cli_lib_voicetalk_get:(char*)buffer with_len:(int)len;

//推送相关函数vv
+(void)cli_lib_vv_registerForPush_types:(int)types launchingOption:(NSDictionary *)launchOptions;
+(void)cli_lib_vv_registerDeviceToken:(NSData *)deviceToken;  // 向服务器上报Device Token
+(NSString*)cli_lib_vv_get_device_token;
-(BOOL)cli_lib_vv_setTags:(NSString*)user langurage:(NSString*)langeurage push_svr:(NSString*)push_svr push_svr_port:(int)push_svr_port push_key:(NSString*)push_key push_pass:(NSString*)push_pass client_type:(int)client_type;
-(BOOL)cli_lib_vv_setTags_ex:(NSString*)user language:(NSString*)language push_svr:(NSString*)push_svr push_svr_port:(int)push_svr_port push_key:(NSString*)push_key push_pass:(NSString*)push_pass client_type:(int)client_type version:(NSString*)version;
-(BOOL)cli_lib_vv_push_stop;
//音波通信相关函数
-(void)cli_lib_sonic_init;
-(void)cli_lib_sonic_release;
-(int)cli_lib_sonic_set_info:(NSString*)info_data;
-(int)cli_lib_sonic_get_buffer:(char*)outbuffer buffersize:(int)buffersize;

-(int)cli_lib_record_get_min_list:(long)hconnector with_chlid:(int)chlid with_rec_type:(int)rec_type with_date:(NSString*)date;
-(int)cli_lib_record_get_date_list:(long)hconnector with_chlid:(int)chlid with_rec_type:(int)rec_type with_date:(NSString*)date;
//回放接口
-(long)cli_lib_create_player_playback:(int)chlid devid:(NSString *)dev_id devuser:(NSString*)dev_user devpass:(NSString*)dev_pass stream_format_video:(int)video_stream_format stream_format_audio:(int)audio_stream_format;
-(int)cli_lib_startplay_player_playback:(long)rtsp_handle start_time:(NSString*)start_time;
-(int)cli_lib_suspend_playback:(long)rtsp_handle;
-(int)cli_lib_stopplay_playback:(long)rtsp_handle;
-(int)cli_lib_audiostreamexists_playback:(long)rtsp_handle;
-(int)cli_lib_setaudiostatus_playback:(long)rtsp_handle status:(int)enabled;
//本地播放接口
//回放接口
-(int)cli_lib_create_player_local:(int)audio_stream_format;
-(int)cli_lib_startplay_player_local:(int)rtsp_handle filename:(NSString*)filename;
-(int)cli_lib_play_local_seek:(int)rtsp_handle pos:(int)pos;
-(int)cli_lib_release_player_local:(int)rtsp_handle;
-(int)cli_lib_audiostreamexists_local:(int)rtsp_handle;
-(int)cli_lib_setaudiostatus_local:(int)rtsp_handle status:(int)enabled;

-(int)cli_lib_get_sensors:(long)hconnector with_chlid:(int)chlid sensor_type:(int)sensor_type;
-(int)cli_lib_coding_sensors:(long)hconnector with_chlid:(int)chlid;
-(int)cli_lib_delete_sensor:(long)hconnector with_chlid:(int)chlid sensorid:(NSString*)sensorid;
-(int)cli_lib_set_sensors:(long)hconnector with_chlid:(int)chlid with_id:(NSString*)sensorid name:(NSString*)name preset:(int)preset isalarm:(int)isalarm with_tag:(int)tag;
-(int)cli_lib_set_sensor_subchl:(long)hconnector with_chlid:(int)chlid with_id:(NSString*)sensorid subchl_id:(int)subchl_id name:(NSString*)name alarm_linkage:(int)alarm_linkage with_tag:(NSString*)tag;
-(int)cli_lib_get_sensors_switch:(long)hconnector with_chlid:(int)chlid;
-(int)cli_lib_sensor_remote_ctl:(long)hconnector sensor_id:(NSString*)sensor_id chlid:(int)chlid subchlid:(int)subchlid status:(int)status;

-(int)cli_lib_get_arm_config:(long)hconnector with_chlid:(int)chlid;
-(int)cli_lib_set_arm_config:(long)hconnector with_chlid:(int)chlid config:(NSString*)config_json;

-(int)cli_lib_get_sdcard_info:(long)hconnector;
-(int)cli_lib_format_sdcard:(long)hconnector;
-(int)cli_lib_dev_reboot:(long)hconnector;

-(int)cli_lib_get_events:(long)hconnector chanid:(int)chanid type:(int)type;
-(NSData*)cli_lib_get_event_pic:(long)hconnector eventid:(NSString*)eventid index:(int)index type:(int)type res_code:(int*)res_code;

-(int)cli_lib_get_record_config:(long)hconnector with_chlid:(int)chlid;
-(int)cli_lib_set_record_config:(long)hconnector with_chlid:(int)chlid config:(NSString*)config_json;

-(NSData*)cli_lib_get_message_file:(long)hconnector messageid:(NSString*)messageid index:(int)index type:(int)type;

-(int)cli_lib_start_record:(long)rtsp_handle rec_file:(NSString*)recfile thumbil_file:(NSString*)thumbile_file max_sec:(int)max_sec;
-(int)cli_lib_stop_record:(long)rtsp_handle;

-(int)cli_lib_get_wifi_lists:(long)hconnector;
-(int)cli_lib_set_dev_wireless:(long)hconnector net_type:(int)net_type ssid:(NSString*)ssid ssid_pass:(NSString*)ssid_pass lang:(NSString*)lang;
-(int)cli_lib_set_dev_net:(long)hconnector net_type:(int)net_type ip:(NSString*)ip net_mask:(NSString*)net_mask net_gate:(NSString*)net_gate
        net_dns:(NSString*)net_dns ssid:(NSString*)ssid ssid_pass:(NSString*)ssid_pass;
-(int)cli_lib_set_dev_net_addtousr:(long)hconnector net_type:(int)net_type ip:(NSString*)ip net_mask:(NSString*)net_mask net_gate:(NSString*)net_gate
                  net_dns:(NSString*)net_dns ssid:(NSString*)ssid ssid_pass:(NSString*)ssid_pass bindusr:(NSString*)bindusr usrpass:(NSString*)usrpass lang:(NSString*)lang;
-(int)cli_lib_upgrate_firmware:(long)hconnector firmware_url:(NSString*)firmware_url firmware_hash:(NSString*)firmware_hash;


-(int)cli_lib_get_stream_flow_info:(long)rtsp_handle total:(long long*)total avg:(int*)avg curr:(int*)curr;

-(int)cli_lib_cli_get_netif_settings:(long)hconnector;
-(int)cli_lib_cli_set_netif:(long)hconnector set_json:(NSData*)setjson;

-(int)cli_lib_cli_get_timezone:(long)hconnector;
-(int)cli_lib_cli_set_timezone:(long)hconnector timezone:(int)timezone;

-(int)cli_lib_get_mirror_config:(long)hconnector with_chlid:(int)chlid;
-(int)cli_lib_set_mirror_config:(long)hconnector with_chlid:(int)chlid state:(int)state;
-(int)cli_lib_cli_active_status:(int)status;
-(int)cli_lib_set_preconnects:(NSArray*)devs_array;
-(int)cli_lib_customer_cmd:(long)hconnector cmd_data:(char*)cmd_data data_len:(int)data_len;

-(NSString*)cli_lib_getwifi_qrcode:(NSString*)ssid ssidpass:(NSString*)pass lang:(NSString*)lang;

//透明通道
-(int)cli_lib_trchl_open:(long)hconnector;
-(int)cli_lib_trchl_send:(int)trchl_handle buffer:(char*)buffer size:(int)size;
-(int)cli_lib_trchl_close:(int)trchl_handle;

-(int)cli_lib_cli_c2d_get_arm_status:(long)hconnector;
-(int)cli_lib_cli_c2d_set_arm_status:(long)hconnector status:(int)status;
/////////////////////////////////////////////////////////////////////

int get_decoded_video(long rtsp_handle, TVideoParams *video_params);
int get_decoded_audio(long rtsp_handle, TAudioParams *audio_params);
int get_jpeg(int width, int height, int stride, char *y, char *u, char *v, char *jpeg_buffer);
int get_jpeg_file(int width, int height, int stride, char *y, char *u, char *v, char *filename);

int get_decoded_video_private(long rtsp_handle, TVideoParams *video_params);
int get_decoded_audio_private(long rtsp_handle, TAudioParams *audio_params);

int get_decoded_video_playback(long rtsp_handle, TVideoParams *video_params);
int get_decoded_audio_playback(long rtsp_handle, TAudioParams *audio_params);

int get_decoded_video_local(int rtsp_handle, TVideoParams *video_params);
int get_decoded_audio_local(int rtsp_handle, TAudioParams *audio_params);
@end


