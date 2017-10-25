//
//  SelecteAddTypeView.h
//  Smart360
//
//  Created by michael on 16/1/4.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomContainApplianceModel;


@protocol SelecteAddTypeViewDelegate <NSObject>

-(void)addInfraredDeviceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel;
-(void)addWiFiDeviceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel;
-(void)addRFDeviceDelegate:(RoomContainApplianceModel *)roomContainApplianceModel ProStarDict:(NSDictionary *)dict;

@end


@interface SelecteAddTypeView : UIView

@property (nonatomic, weak) id<SelecteAddTypeViewDelegate>delegate;

-(instancetype)initWithRoomContainApplianceModel:(RoomContainApplianceModel *)roomContainApplianceModel ProStarDict:(NSDictionary *)dict;

- (void)showSelecteAddTypeView;
- (void)closeSelecteAddTypeView;

@end
