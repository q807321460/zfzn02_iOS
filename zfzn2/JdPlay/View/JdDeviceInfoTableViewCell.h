//
//  JdDeviceInfoTableViewCell.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/20.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JdPlaySdk/JdPlaySdk.h>

@interface JdDeviceInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) JdDeviceInfo * deviceModel;

/**
 *  设备名
 */
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
/**
 *  设备状态（是否在线）
 */
@property (weak, nonatomic) IBOutlet UILabel *deviceStatus;
/**
 *  标记选中的设备
 */
@property (weak, nonatomic) IBOutlet UIImageView *mark;

@end
