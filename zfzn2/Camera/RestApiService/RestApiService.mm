//
//  RestApiService.m
//  appDemo
//
//  Created by chenjian on 15/5/25.
//  Copyright (c) 2015年 yao_bao. All rights reserved.
//

#import "RestApiService.h"

#import "LCOpenApiClientSDK/LCOpenApi/BindDevice.h"
#import "LCOpenApiClientSDK/LCOpenApi/BindDeviceInfo.h"
#import "LCOpenApiClientSDK/LCOpenApi/CheckDeviceBindOrNot.h"
#import "LCOpenApiClientSDK/LCOpenApi/ControlPTZ.h"
#import "LCOpenApiClientSDK/LCOpenApi/DeleteAlarmMessage.h"
#import "LCOpenApiClientSDK/LCOpenApi/DeviceList.h"
#import "LCOpenApiClientSDK/LCOpenApi/DeviceOnline.h"
#import "LCOpenApiClientSDK/LCOpenApi/GetAlarmMessage.h"
#import "LCOpenApiClientSDK/LCOpenApi/ModifyDeviceAlarmStatus.h"
#import "LCOpenApiClientSDK/LCOpenApi/QueryCloudRecordNum.h"
#import "LCOpenApiClientSDK/LCOpenApi/QueryCloudRecords.h"
#import "LCOpenApiClientSDK/LCOpenApi/QueryLocalRecordNum.h"
#import "LCOpenApiClientSDK/LCOpenApi/QueryLocalRecords.h"
#import "LCOpenApiClientSDK/LCOpenApi/SetAllStorageStrategy.h"
#import "LCOpenApiClientSDK/LCOpenApi/SetStorageStrategy.h"
#import "LCOpenApiClientSDK/LCOpenApi/UnBindDevice.h"

#define ACCESSTOKEN_LEN 256

@interface RestApiService () {
    LCOpenSDK_Api* m_hc;
    char m_accessToken[ACCESSTOKEN_LEN];
}
@end

@implementation RestApiService

static RestApiService* _instance = nil;
+ (RestApiService*)shareMyInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initPrivate];
    });
    return _instance;
}

+ (instancetype)alloc
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super alloc];
    });
    return _instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}

- (instancetype)init
{
    return [[self class] shareMyInstance];
}

- (void)initComponent:(LCOpenSDK_Api*)hc Token:(NSString*)accessTok_In
{
    if (nil != hc) {
        m_hc = hc;
    }
    if (nil != accessTok_In) {
        strncpy(m_accessToken, [accessTok_In UTF8String], sizeof(m_accessToken) - 1);
    }
}

- (BOOL)getDevList:(NSMutableArray*)info_Out Begin:(NSInteger)beginIndex_In End:(NSInteger)endIndex_In
{
    DeviceListRequest* req;
    DeviceListResponse* resp;
    NSInteger ret = 0;
    NSString* sRange = [NSString stringWithFormat:@"%ld-%ld", (long)beginIndex_In, (long)endIndex_In];
    req = LCOPENAPI_INIT(DeviceListRequest);
    resp = LCOPENAPI_INIT(DeviceListResponse);

    req->data.token = CS(m_accessToken);
    req->data.queryRange = CS([sRange UTF8String]);

    ret = [m_hc request:req resp:resp timeout:10];
    NSLog(@"getDevList ret[%ld]", (long)ret);
    BOOL bret = NO;
    if (0 == ret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                for (int i = 0; i < resp->data.devices.size; i++) {
                    DeviceInfo* i_deviceInfo = [[DeviceInfo alloc] init];

                    NSLog(@"getDevList deviceid[%s],ability[%s],online[%d],name[%s]", resp->data.devices.array[i].deviceId.cstr, resp->data.devices.array[i].ability.cstr, resp->data.devices.array[i].status, resp->data.devices.array[i].name.cstr);
                    if (resp->data.devices.array[i].deviceId.cstr) {
                        i_deviceInfo->ID = [NSString stringWithUTF8String:resp->data.devices.array[i].deviceId.cstr];
                    }
                    if (resp->data.devices.array[i].ability.cstr) {
                        i_deviceInfo->ability = [NSString stringWithUTF8String:resp->data.devices.array[i].ability.cstr];
                    }
                    i_deviceInfo->devOnline = resp->data.devices.array[i].status;
                    i_deviceInfo->channelSize = resp->data.devices.array[i].channels.size;

                    for (int channelIndex = 0; channelIndex < resp->data.devices.array[i].channels.size && channelIndex < CHANNEL_MAX; channelIndex++) {
                        NSLog(@"getDevList channelId=%d", resp->data.devices.array[i].channels.array[channelIndex].channelId);
                        i_deviceInfo->channelId[channelIndex] = resp->data.devices.array[i].channels.array[channelIndex].channelId;

                        NSLog(@"getDevList channelonline=%d", resp->data.devices.array[i].channels.array[channelIndex].channelOnline);
                        i_deviceInfo->isOnline[channelIndex] = resp->data.devices.array[i].channels.array[channelIndex].channelOnline;

                        NSLog(@"getDevList channelAlarmStatus=%d", resp->data.devices.array[i].channels.array[channelIndex].alarmStatus);

                        i_deviceInfo->alarmStatus[channelIndex] = (AlarmStatus)resp->data.devices.array[i].channels.array[channelIndex].alarmStatus;

                        NSLog(@"getDevList channelCsStatus=%d", resp->data.devices.array[i].channels.array[channelIndex].csStatus);

                        i_deviceInfo->csStatus[channelIndex] = (CloudStorageStatus)resp->data.devices.array[i].channels.array[channelIndex].csStatus;

                        if (resp->data.devices.array[i].channels.array[channelIndex].channelAbility.cstr) {
                            NSLog(@"getDevList channelAbility=%s", resp->data.devices.array[i].channels.array[channelIndex].channelAbility.cstr);
                            i_deviceInfo->channelAbility[channelIndex] = [NSString stringWithUTF8String:resp->data.devices.array[i].channels.array[channelIndex].channelAbility.cstr];
                        }
                        if (resp->data.devices.array[i].channels.array[channelIndex].channelPicUrl.cstr) {
                            NSLog(@"getDevList channelPicUrl=%s", resp->data.devices.array[i].channels.array[channelIndex].channelPicUrl.cstr);
                            i_deviceInfo->channelPic[channelIndex] = [NSString stringWithUTF8String:resp->data.devices.array[i].channels.array[channelIndex].channelPicUrl.cstr];
                        }
                        if (resp->data.devices.array[i].channels.array[channelIndex].channelName.cstr) {
                            NSLog(@"getDevList channelname=%s", resp->data.devices.array[i].channels.array[channelIndex].channelName.cstr);
                            i_deviceInfo->channelName[channelIndex] = [NSString stringWithUTF8String:resp->data.devices.array[i].channels.array[channelIndex].channelName.cstr];
                        }
                    }
                    [info_Out addObject:i_deviceInfo];
                }
                bret = YES;
            }
        }
    }

    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);

    return bret;
}

- (BOOL)checkDeviceOnline:(NSString*)devID_In
{
    DeviceOnlineRequest* req;
    DeviceOnlineResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    req = LCOPENAPI_INIT(DeviceOnlineRequest);
    resp = LCOPENAPI_INIT(DeviceOnlineResponse);

    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);

    iret = [m_hc request:req resp:resp timeout:10];
    NSLog(@"checkDeviceOnline ret[%ld]", (long)iret);

    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"checkDeviceOnline success");
                if (resp->data.onLine.cstr) {
                    bret = strcmp(resp->data.onLine.cstr, "0") ? YES : NO;
                }
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)checkDeviceBindOrNot:(NSString*)devID_In;
{
    CheckDeviceBindOrNotRequest* req;
    CheckDeviceBindOrNotResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    req = LCOPENAPI_INIT(CheckDeviceBindOrNotRequest);
    resp = LCOPENAPI_INIT(CheckDeviceBindOrNotResponse);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.token = CS(m_accessToken);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"checkDeviceBindOrNot bMine[%d],bIsBind[%d]",
                    resp->data.isMine, resp->data.isBind);
                bret = resp->data.isBind;
            }
        }
    }
    return bret;
}

- (BOOL)bindDevice:(NSString*)devID_In Desc:(NSString**)errMsg_Out
{
    BindDeviceRequest* req;
    BindDeviceResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    req = LCOPENAPI_INIT(BindDeviceRequest);
    resp = LCOPENAPI_INIT(BindDeviceResponse);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.token = CS(m_accessToken);

    iret = [m_hc request:req resp:resp timeout:10];
    NSLog(@"bindDevice ret[%ld]", (long)iret);

    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"bindDevice success");
                bret = YES;
            }
        }
        if (resp->base.ret_msg.cstr) {
            *errMsg_Out = [NSString stringWithUTF8String:resp->base.ret_msg.cstr];
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)unBindDevice:(NSString*)devID_In Desc:(NSString**)errMsg_Out
{
    UnBindDeviceRequest* req;
    UnBindDeviceResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    req = LCOPENAPI_INIT(UnBindDeviceRequest);
    resp = LCOPENAPI_INIT(UnBindDeviceResponse);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.token = CS(m_accessToken);

    iret = [m_hc request:req resp:resp timeout:10];
    NSLog(@"unBindDevice ret[%ld]", (long)iret);

    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"unBindDevice success");
                bret = YES;
            }
        }
        if (resp->base.ret_msg.cstr) {
            *errMsg_Out = [NSString stringWithUTF8String:resp->base.ret_msg.cstr];
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)getBindDeviceInfo:(NSString*)devID_In Info_out:(DeviceInfo*)info_out
{
    BindDeviceInfoRequest* req;
    BindDeviceInfoResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    req = LCOPENAPI_INIT(BindDeviceInfoRequest);
    resp = LCOPENAPI_INIT(BindDeviceInfoResponse);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.token = CS(m_accessToken);

    iret = [m_hc request:req resp:resp timeout:10];
    NSLog(@"getBindDeviceInfo ret[%ld]", (long)iret);

    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"getBindDeviceInfo success");
                for (int channelIndex = 0; channelIndex < resp->data.channels.size && channelIndex < CHANNEL_MAX; channelIndex++) {
                    NSLog(@"getBindDevInfo channelname=%s", resp->data.channels.array[channelIndex].channelName.cstr);
                    NSLog(@"getBinddDevInfo channelonline=%d", resp->data.channels.array[channelIndex].channelOnline);
                    info_out->alarmStatus[channelIndex] = (AlarmStatus)resp->data.channels.array[channelIndex].alarmStatus;
                    info_out->csStatus[channelIndex] = (CloudStorageStatus)resp->data.channels.array[channelIndex].csStatus;
                }

                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)getAlarmMsg:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Msg:(NSMutableArray*)msgInfo_Out Count:(NSInteger)count_In
{
    GetAlarmMessageRequest* req;
    GetAlarmMessageResponse* resp;
    BOOL bret = NO;
    NSInteger iret = 0;
    char strCh[10] = { 0 };
    char strCount[10] = { 0 };
    snprintf(strCount, sizeof(strCount) - 1, "%ld", (long)count_In);
    snprintf(strCh, sizeof(strCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(GetAlarmMessageRequest);
    resp = LCOPENAPI_INIT(GetAlarmMessageResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(strCh);
    req->data.beginTime = CS([beginTime_In UTF8String]);
    req->data.endTime = CS([endTime_In UTF8String]);
    req->data.count = CS(strCount);
    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                for (int i = 0; i < resp->data.alarms.size; i++) {
                    AlarmMessageInfo* i_alarmMessageInfo = [[AlarmMessageInfo alloc] init];
                    if (resp->data.alarms.array[i].deviceId.cstr) {
                        i_alarmMessageInfo->deviceId = [NSString stringWithUTF8String:resp->data.alarms.array[i].deviceId.cstr];
                    }
                    i_alarmMessageInfo->channel = atoi(resp->data.alarms.array[i].channelId.cstr);
                    if (resp->data.alarms.array[i].name.cstr) {
                        i_alarmMessageInfo->channelName = [NSString stringWithUTF8String:resp->data.alarms.array[i].name.cstr];
                    }
                    i_alarmMessageInfo->alarmId = resp->data.alarms.array[i].alarmId;
                    if (resp->data.alarms.array[i].thumbUrl.cstr) {
                        i_alarmMessageInfo->thumbnail = [NSString stringWithUTF8String:resp->data.alarms.array[i].thumbUrl.cstr];
                    }
                    for (int j = 0; j < resp->data.alarms.array[i].picurlArray.size && j < PIC_ARRAY_MAX; j++) {
                        if (resp->data.alarms.array[i].picurlArray.array[j].cstr) {
                            i_alarmMessageInfo->picArray[j] = [NSString stringWithUTF8String:resp->data.alarms.array[i].picurlArray.array[j].cstr];
                        }
                    }
                    if (resp->data.alarms.array[i].localDate.cstr) {
                        i_alarmMessageInfo->localDate = [NSString stringWithUTF8String:resp->data.alarms.array[i].localDate.cstr];
                    }
                    [msgInfo_Out addObject:i_alarmMessageInfo];
                }
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)deleteAlarmMsg:(int64_t)alarmId
{
    DeleteAlarmMessageRequest* req;
    DeleteAlarmMessageResponse* resp;
    NSInteger iret = 0;
    BOOL bret = NO;
    char indexId[50] = { 0 };
    snprintf(indexId, sizeof(indexId) - 1, "%lld", alarmId);
    req = LCOPENAPI_INIT(DeleteAlarmMessageRequest);
    resp = LCOPENAPI_INIT(DeleteAlarmMessageResponse);
    req->data.token = CS(m_accessToken);
    req->data.indexId = CS(indexId);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"deleteAlarmMsg [%lld] success", alarmId);
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (NSInteger)getRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Desc:(NSString**)errMsg_Out
{
    QueryLocalRecordNumRequest* req;
    QueryLocalRecordNumResponse* resp;
    NSInteger iTotalNum = 0;
    NSInteger iret = 0;
    char strCh[10] = { 0 };
    snprintf(strCh, sizeof(strCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(QueryLocalRecordNumRequest);
    resp = LCOPENAPI_INIT(QueryLocalRecordNumResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);

    req->data.channelId = CS(strCh);
    req->data.beginTime = CS([beginTime_In UTF8String]);
    req->data.endTime = CS([endTime_In UTF8String]);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                NSLog(@"getRecordNum num[%d]", resp->data.recordNum);
                iTotalNum = resp->data.recordNum;
            }
        }
        if (resp->base.ret_msg.cstr) {
            *errMsg_Out = [NSString stringWithUTF8String:resp->base.ret_msg.cstr];
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return iTotalNum;
}

- (BOOL)getRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out
{
    QueryLocalRecordsRequest* req;
    QueryLocalRecordsResponse* resp;

    NSInteger iret = 0;
    char strCh[10] = { 0 };
    char strRange[100] = { 0 };
    snprintf(strCh, sizeof(strCh) - 1, "%ld", (long)iCh_In);
    snprintf(strRange, sizeof(strRange) - 1, "%ld-%ld", (long)beginIndex_In, (long)endIndex_In);
    req = LCOPENAPI_INIT(QueryLocalRecordsRequest);
    resp = LCOPENAPI_INIT(QueryLocalRecordsResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(strCh);
    req->data.beginTime = CS([beginTime_In UTF8String]);
    req->data.endTime = CS([endTime_In UTF8String]);
    req->data.queryRange = CS(strRange);

    BOOL bret = NO;
    iret = [m_hc request:req resp:resp timeout:60];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                for (int i = 0; i < resp->data.records.size; i++) {
                    RecordInfo* i_recordInfo = [[RecordInfo alloc] init];
                    if (resp->data.records.array[i].recordId.cstr) {
                        i_recordInfo->name = [NSString stringWithUTF8String:resp->data.records.array[i].recordId.cstr];
                        NSLog(@"getRecords[%@],[%d]", i_recordInfo->name, i);
                    }
                    if (resp->data.records.array[i].beginTime.cstr) {
                        i_recordInfo->beginTime = [NSString stringWithUTF8String:resp->data.records.array[i].beginTime.cstr];
                        NSLog(@"getRecords[%@],[%d]", i_recordInfo->beginTime, i);
                    }
                    if (resp->data.records.array[i].endTime.cstr) {
                        i_recordInfo->endTime = [NSString stringWithUTF8String:resp->data.records.array[i].endTime.cstr];
                        NSLog(@"getRecords[%@],[%d]", i_recordInfo->endTime, i);
                    }
                    [info_Out addObject:i_recordInfo];
                }
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (NSInteger)getCloudRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Bengin:(NSString*)beginTime_In End:(NSString*)endTime_In Desc:(NSString**)errMsg_Out
{
    QueryCloudRecordNumRequest* req;
    QueryCloudRecordNumResponse* resp;

    NSInteger iret = 0;
    NSInteger iTotalNum = 0;
    char iCh[20] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(QueryCloudRecordNumRequest);
    resp = LCOPENAPI_INIT(QueryCloudRecordNumResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(iCh);
    req->data.beginTime = CS([beginTime_In UTF8String]);
    req->data.endTime = CS([endTime_In UTF8String]);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                iTotalNum = resp->data.recordNum;
                NSLog(@"getCloudRecordNum [%ld]", (long)iTotalNum);
            }
        }
        if (resp->base.ret_msg.cstr) {
            *errMsg_Out = [NSString stringWithUTF8String:resp->base.ret_msg.cstr];
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return iTotalNum;
}

- (BOOL)getCloudRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out
{
    QueryCloudRecordsRequest* req;
    QueryCloudRecordsResponse* resp;
    NSInteger iret = 0;
    char iCh[20] = { 0 };
    char strRange[50] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    snprintf(strRange, sizeof(strRange) - 1, "%ld-%ld", (long)beginIndex_In, (long)endIndex_In);
    req = LCOPENAPI_INIT(QueryCloudRecordsRequest);
    resp = LCOPENAPI_INIT(QueryCloudRecordsResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(iCh);
    req->data.type = CS("All");
    req->data.queryRange = CS(strRange);
    req->data.beginTime = CS([beginTime_In UTF8String]);
    req->data.endTime = CS([endTime_In UTF8String]);

    BOOL bret = NO;
    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                for (int i = 0; i < resp->data.records.size; i++) {
                    RecordInfo* i_recordInfo = [[RecordInfo alloc] init];
                    if (resp->data.records.array[i].endTime.cstr && resp->data.records.array[i].beginTime.cstr) {
                        i_recordInfo->beginTime = [NSString stringWithUTF8String:resp->data.records.array[i].beginTime.cstr];
                        NSLog(@"beginTime getRecords[%@],[%d]", i_recordInfo->beginTime, i);

                        i_recordInfo->endTime = [NSString stringWithUTF8String:resp->data.records.array[i].endTime.cstr];
                        NSLog(@"endTime getRecords[%@],[%d]", i_recordInfo->endTime, i);

                        i_recordInfo->name = [NSString stringWithFormat:@"%@-%@", i_recordInfo->beginTime, i_recordInfo->endTime];
                    }
                    if (resp->data.records.array[i].thumbUrl.cstr) {
                        i_recordInfo->thumbUrl = [NSString stringWithUTF8String:resp->data.records.array[i].thumbUrl.cstr];
                        NSLog(@"thumUrl getRecords[%@],[%d]", i_recordInfo->thumbUrl, i);
                    }
                    if (resp->data.records.array[i].size.cstr) {
                        i_recordInfo->size = [NSString stringWithUTF8String:resp->data.records.array[i].size.cstr];
                        NSLog(@"size getRecords[%@]", i_recordInfo->size);
                    }
                    i_recordInfo->recId = resp->data.records.array[i].recordId;
                    NSLog(@"recId getRecords[%lld]", i_recordInfo->recId);
                    [info_Out addObject:i_recordInfo];
                }
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)controlPTZ:(NSString*)devID_In Chnl:(NSInteger)iCh_In Operate:(NSString*)strOperate_In Horizon:(double)iHorizon_In Vertical:(double)iVertical_In Zoom:(double)iZoom_In Duration:(NSInteger)iDuration_In
{
    ControlPTZRequest* req;
    ControlPTZResponse* resp;

    NSInteger iret = 0;
    BOOL bret = NO;
    char iCh[10] = { 0 };
    char strDuration[10] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    snprintf(strDuration, sizeof(strDuration) - 1, "%ld", (long)iDuration_In);
    req = LCOPENAPI_INIT(ControlPTZRequest);
    resp = LCOPENAPI_INIT(ControlPTZResponse);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.duration = CS(strDuration);
    req->data.channelId = CS(iCh);
    req->data.h = iHorizon_In;
    req->data.v = iVertical_In;
    req->data.z = iZoom_In;
    req->data.operation = CS([strOperate_In UTF8String]);
    req->data.token = CS(m_accessToken);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)modifyDeviceAlarmStatus:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(BOOL)enable_In
{
    ModifyDeviceAlarmStatusRequest* req;
    ModifyDeviceAlarmStatusResponse* resp;

    NSInteger iret = 0;
    BOOL bret = NO;
    char iCh[10] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(ModifyDeviceAlarmStatusRequest);
    resp = LCOPENAPI_INIT(ModifyDeviceAlarmStatusResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(iCh);
    req->data.enable = enable_In;

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)setStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In
{
    SetStorageStrategyRequest* req;
    SetStorageStrategyResponse* resp;

    NSInteger iret = 0;
    BOOL bret = NO;
    char iCh[10] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(SetStorageStrategyRequest);
    resp = LCOPENAPI_INIT(SetStorageStrategyResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(iCh);
    req->data.status = CS([enable_In UTF8String]);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

- (BOOL)setAllStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In
{
    SetAllStorageStrategyRequest* req;
    SetAllStorageStrategyResponse* resp;

    NSInteger iret = 0;
    BOOL bret = NO;
    char iCh[10] = { 0 };
    snprintf(iCh, sizeof(iCh) - 1, "%ld", (long)iCh_In);
    req = LCOPENAPI_INIT(SetAllStorageStrategyRequest);
    resp = LCOPENAPI_INIT(SetAllStorageStrategyResponse);
    req->data.token = CS(m_accessToken);
    req->data.deviceId = CS([devID_In UTF8String]);
    req->data.channelId = CS(iCh);
    req->data.status = CS([enable_In UTF8String]);

    iret = [m_hc request:req resp:resp timeout:10];
    if (0 == iret) {
        int code = resp->base.code;
        NSString* ret_code;
        if (resp->base.ret_code.cstr) {
            ret_code = [NSString stringWithUTF8String:resp->base.ret_code.cstr];
        }
        if (HTTP_OK == code) {
            if ([ret_code isEqualToString:@"0"]) {
                bret = YES;
            }
        }
    }
    LCOPENAPI_DESTROY(req);
    LCOPENAPI_DESTROY(resp);
    return bret;
}

@end
