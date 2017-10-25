//
//  RoomTableViewCell.h
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RoomContainApplianceModel.h"
#import "RoomModel.h"


@protocol RoomTableViewCellDelegate <NSObject>

- (void)clickApplianceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel number:(NSInteger)number isDevice:(BOOL)isDevice;
- (void)clickChangeRoomNameDelegate:(RoomContainApplianceModel *)roomContainApplianceModel;

@end


@interface RoomTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *roomNameButton;

@property (nonatomic, strong) RoomContainApplianceModel *roomContainApplianceModel;

@property (nonatomic, weak) id<RoomTableViewCellDelegate>delegate;


- (void)showDataWithModel:(RoomContainApplianceModel *)roomContainApplianceModel;


@end
