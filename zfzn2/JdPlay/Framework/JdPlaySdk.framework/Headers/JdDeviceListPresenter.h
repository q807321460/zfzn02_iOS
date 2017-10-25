//
//  JdDeviceListPresenter.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/9/19.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JdDeviceListContract.h"

@interface JdDeviceListPresenter : NSObject<DeviceListPresenter>

@property (nonatomic,weak) id<DeviceListView> delegate;
@property (nonatomic,strong) NSMutableArray * deviceListArr;

/**
 *  初始化
 *
 *  @return JdDeviceListPresenter实例
 */
+(instancetype)sharedManager;

/**
 *  获取当前设备信息
 */
-(void)getDeviceStateInfo:(char *)deviceInfoStr;

@end
