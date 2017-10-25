//
//  Macro_SBApplianceEngine.h
//  Smart360
//
//  Created by michael on 15/11/9.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_SBApplianceEngine_h
#define Smart360_Macro_SBApplianceEngine_h


//通知消息
#define kNotifi_SBApplianceEngineCallBack_Event_GetDevices @"getDevices__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_GetRegistedBrandAccount @"getRegistedBrandAccount__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_GetRoomAndApplianceUserDefined @"getRoomAndApplianceUserDefined__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_GetUnregistDevicesOfOneBrand @"getUnregistDevicesOfOneBrand__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_SetBrandAccount @"setBrandAccount__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_AddInfrared @"addInfrared__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_GetRoomList @"GetRoomList__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_AddRoom @"AddRoom__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_GetSpecialBrandInfo @"GetSpecialBrandInfo__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_AddRedSatellite @"AddRedSatellite__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_InfraredModelSearch @"InfraredModelSearch__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_ConfirmInfraredModelSearch @"ConfirmInfraredModelSearch__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_RemoveRoom @"RemoveRoom__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_DeleteAppliance @"DeleteAppliance__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_AddWiFiDevice @"AddWiFiDevice__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_ReNameRoom @"ReNameRoom__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_DeviceChangeRoom @"DeviceChangeRoom__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_GetBrandListOfOneDeviceTypeInfrared @"GetBrandListOfOneDeviceTypeInfrared__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_RedSatelliteConfig @"RedSatelliteConfig__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_PlugChangeDevice @"PlugChangeDevice__SBApplianceEngine"

#define kNotifi_SBApplianceEngineCallBack_Event_StartMatchInfrared @"StartMatchInfrared__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_InfraredBoxDownload @"InfraredBoxDownload__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_MatchInfrared @"MatchInfrared__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_MatchResultInfrared @"MatchResultInfrared__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_ChangChannelsInfrared @"ChangChannelsInfrared__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_UpdateArchRoom @"UpdateArchRoom__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_UpdateArchApplianceDevice @"UpdateArchApplianceDevice__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_GetDevControlCmd @"GetDevControlCmd__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_AddRFDevice @"AddRFDevice__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_GetProStudyResult @"GetProStudyResult__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_SaveProStudyResult @"SaveProStudyResult__SBApplianceEngine"
#define kNotifi_SBApplianceEngineCallBack_Event_ProStudyByStep @"ProStudyByStep__SBApplianceEngine"



//家电推送 得到数据 dict 键值
#define kNotifi_UpdateRoom_Notifi_ApplianceModel @"UpdateRoom_Notifi_ApplianceModel"
#define kNotifi_UpdateRoom_Notifi_roomsUsedArray @"UpdateRoom_Notifi_roomsUsedArray"
#define kNotifi_UpdateRoom_Notifi_RoomContainApplianceModel @"UpdateRoom_Notifi_RoomContainApplianceModel"


//选择添加 传统家电 智能家电
#define kSelecte_TraditionalColor 0xff6868
#define kSelecte_WiFiColor 0x80c119
#define kSelecte_RFColor 0x0dbec5

// Pro学习过程文字颜色
#define kProStudy_noStudy_Color  UIColorFromRGB(0x9e9a9a)
#define kProStudy_noStudy_TitleFont  14
#define kProStudy_successStudy_Color  UIColorFromRGB(0x2ca1f6)
#define kProStudy_successStudy_TitleFont  14
#define kProStudy_DoStudy_Color  UIColorFromRGB(0xffffff)
#define kProStudy_DoStudy_TitleFont  12



//红外码库匹配过程
#define kInfraredMatchResult_Succ @"succ"
#define kInfraredMatchResult_Error @"error"
#define kInfraredMatchResult_Continue @"continue"



//家电  类型 红外 智能WiFi
#define kApplianceType_infrared @"infrared"
#define kApplianceType_wifi @"wifi"
#define kApplianceType_normal @"normal"  //添加插座时，插座上添加的设备 类型
#define kApplianceType_redstar @"redstar"  //红卫星只有type 没有deviceType（为空字符串）
#define kApplianceType_RF @"rf"
#define kApplianceType_ProInfrared @"proInfrared"


//家电 设备类型
#define kApplianceDeviceType_Plug @"插座"
#define kApplianceDeviceType_Pro @"pro"

#define kApplianceDeviceType_TV @"电视机"
#define kApplianceDeviceType_TV_0 @"电视"
#define kApplianceDeviceType_IPTV @"IPTV"
#define kApplianceDeviceType_SetTopBox @"机顶盒"

#define kApplianceDeviceType_AirConditioner @"空调"
#define kApplianceDeviceType_Light @"灯"
#define kApplianceDeviceType_InfraredLamp @"红外灯"
#define kApplianceDeviceType_Refrigerator @"冰箱"
#define kApplianceDeviceType_Fan @"电风扇"
#define kApplianceDeviceType_PowerAmplifier @"功放"
#define kApplianceDeviceType_InternetBox @"盒子"
#define kApplianceDeviceType_Oven @"烤箱"
#define kApplianceDeviceType_AirBox @"空气盒子"
#define kApplianceDeviceType_WaterHeater @"热水器"
#define kApplianceDeviceType_DigitalCamera @"数码相机"
#define kApplianceDeviceType_Projector @"投影仪"
#define kApplianceDeviceType_WashingMachine @"洗衣机"
#define kApplianceDeviceType_RemoteControlBao @"遥控宝"
#define kApplianceDeviceType_RemoteControlMachine @"遥控器"
#define kApplianceDeviceType_Host @"主机"
#define kApplianceDeviceType_DVD @"DVD"


//选择添加家电设备类型
#define kAddType_CurrentRoom_DeviceControllerName @"CurrentRoom_DeviceControllerName"
#define kAddType_ProRoomModelArray @"ProRoomModelArray"



#endif
