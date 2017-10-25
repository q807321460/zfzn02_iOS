//
//  JdDeviceListContract.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/9/19.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeviceListView <NSObject>
/**
 *  当JDPlay设备状态发生改变时回调，设备状态包括设备发现、上线、离线等
 *
 *  @param infos JDPlay设备信息列表
 */
-(void)onJdDeviceInfoChange:(NSArray *)infos;

@end


@protocol DeviceListPresenter <NSObject>

/**
 *  选中JDPlay设备作为当前操作设备，因为局域网内可能存在多个JDPlay设备
 *
 *  @param uuid JDPlay设备ID
 */
-(void)selectDevice:(NSString *)uuid;

/**
 *  获取当前选中JDPlay设备的id
 *
 *  @return JDPlay设备的id
 */
-(NSString *)getSelectedDeviceUuid;

@end


@interface JdDeviceListContract : NSObject


@end
