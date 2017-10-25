//
//  RoomApplianceCollectionViewCell.h
//  Smart360
//
//  Created by michael on 15/12/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceModel.h"

@interface RoomApplianceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *applianceButton;

@property (nonatomic, strong) ApplianceModel *applianceModel;

@end
