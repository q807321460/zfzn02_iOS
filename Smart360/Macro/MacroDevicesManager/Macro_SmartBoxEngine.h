//
//  Macro_SmartBoxEngine.h
//  Smart360
//
//  Created by michael on 15/10/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_SmartBoxEngine_h
#define Smart360_Macro_SmartBoxEngine_h


//设置返回值类型
#define kResult long
//不包含助手时，封装SBEngine函数的返回值
#define Invalid_Return_Value -1
// OC字符串变C字符串
#define CstringFromOC(NSString) [NSString UTF8String]
//数据库路径
#define kFilePath @""


//通知消息
#define kNotifi_SBEngineCallBack_Event_BoxInfo_LIST @"box_List_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_Bind @"bind_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_Unbind @"unbind_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_OnOffLine @"OnOffLine_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_SetParam @"setParam_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_AssistantOnline @"assistantOnline_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_AssistantOffline @"assistantOffline_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_GetVersionInfo @"getVersionInfo_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_UpdateVersion @"updateVersion_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_GetDeviceWifiInfo @"getDeviceWifiInfo_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_SetDefaultBox @"setDefaultBox_SBEngine"

#define kNotifi_SBEngineCallBack_Event_BoxInfo_SetDeviceWifi @"setDeviceWifi_SBEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_GetMemos @"GetMemos__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_UpdateMemo @"UpdateMemo__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_DeleteMemos @"DeleteMemos__SBApplianceEngine"

#define kSBEngine_EventId @"SBEngine_EventId"
#define kSBEngine_ErrCode @"SBEngine_ErrCode"
#define kSBEngine_ErrMsg @"SBEngine_ErrMsg"
#define kSBEngine_CallBackReserveParam1 @"SBEngine_CallBackReserveParam1"
#define kSBEngine_CallBackReserveParam2 @"SBEngine_CallBackReserveParam2"
#define kSBEngine_Data @"SBEngine_Data"
#define kSBEngine_isNewAddBox @"SBEngine_isNewAddBox"
#define kSBEngine_isHaveMe @"SBEngine_isHaveMe"


#define DefaultBoxNSUserDefaultsKey @"DefaultBoxSN"
#define TempDefaultBoxNSUserDefaultsKey @"TempDefaultBoxSN"

#define kBoxCountOnlinePost @"BoxCountOnlinePost_DefaultBoxHelper"


#endif
