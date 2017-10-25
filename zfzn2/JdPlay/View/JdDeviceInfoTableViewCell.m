//
//  JdDeviceInfoTableViewCell.m
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/20.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdDeviceInfoTableViewCell.h"

@implementation JdDeviceInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deviceStatus.layer.cornerRadius = 4;
    self.deviceStatus.layer.masksToBounds = YES;
    self.deviceStatus.layer.borderColor = [UIColor colorWithRed:139.0/255 green:39.0/255 blue:114.0/255 alpha:1.0].CGColor;
    self.deviceStatus.layer.borderWidth = 1;
    [self.mark setImage:[UIImage imageNamed:@"check_nol"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDeviceModel:(JdDeviceInfo *)deviceModel
{
    _deviceModel = deviceModel;
    
    self.deviceName.text = deviceModel.name;
    if (deviceModel.onlineStatus) {
        self.deviceStatus.text = @"在线";
    }else{
        self.deviceStatus.text = @"离线";
    }
   
}

@end
