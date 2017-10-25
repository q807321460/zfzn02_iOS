//
//  Header.h
//  appDemo
//
//  Created by chenjian on 15/5/25.
//  Copyright (c) 2015年 yao_bao. All rights reserved.
//

#ifndef LCOpenSDKDemo_RestApiService_h
#define LCOpenSDKDemo_RestApiService_h

#import "LCOpenSDK_Api.h"
#import "RestApiInfo.h"

@interface RestApiService : NSObject

+ (RestApiService*)shareMyInstance;

- (void)initComponent:(LCOpenSDK_Api*)hc Token:(NSString*)accessTok_In;

- (BOOL)getDevList:(NSMutableArray*)info_Out Begin:(NSInteger)beginIndex_In End:(NSInteger)endIndex_In;

- (BOOL)checkDeviceOnline:(NSString*)devID_In;

- (BOOL)checkDeviceBindOrNot:(NSString*)devID_In;

- (BOOL)bindDevice:(NSString*)devID_In Desc:(NSString**)errMsg_Out;

- (BOOL)unBindDevice:(NSString*)devID_In Desc:(NSString**)errMsg_Out;

- (BOOL)getBindDeviceInfo:(NSString*)devID_In Info_out:(DeviceInfo*)info_out;

- (BOOL)getAlarmMsg:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Msg:(NSMutableArray*)msgInfo_Out Count:(NSInteger)count_In;

- (BOOL)deleteAlarmMsg:(int64_t)alarmId;

- (NSInteger)getRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Desc:(NSString**)errMsg_Out;

- (BOOL)getRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out;

- (NSInteger)getCloudRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Bengin:(NSString*)beginTime_In End:(NSString*)endTime_In Desc:(NSString**)errMsg_Out;

- (BOOL)getCloudRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out;

- (BOOL)controlPTZ:(NSString*)devID_In Chnl:(NSInteger)iCh_In Operate:(NSString*)strOperate_In Horizon:(double)iHorizon_In Vertical:(double)iVertical_In Zoom:(double)iZoom_In Duration:(NSInteger)iDuration_In;

- (BOOL)modifyDeviceAlarmStatus:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(BOOL)enable_In;

- (BOOL)setStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In;

- (BOOL)setAllStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In;

@end
#endif
