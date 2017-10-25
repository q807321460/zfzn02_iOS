//
//  RoomApplianceCollectionViewCell.m
//  Smart360
//
//  Created by michael on 15/12/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "RoomApplianceCollectionViewCell.h"

@implementation RoomApplianceCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;

}


- (void)createView {
    
    CGFloat btnWidth = self.bounds.size.width - 5;
    
    WS(weakSelf);
    
    self.applianceButton = [UIButton new];
    [self.contentView addSubview:self.applianceButton];
    
    [self.applianceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(btnWidth, 1.5*btnWidth));
    }];

}


-(void)setApplianceModel:(ApplianceModel *)applianceModel{
    
    
}






@end
