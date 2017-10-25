//
//  AddRoomTableViewCell.m
//  Smart360
//
//  Created by michael on 15/12/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "AddRoomTableViewCell.h"

@implementation AddRoomTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
        
    }
    return self;
    
}

-(void)createSubView{
    self.seleRightImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.seleRightImageView];
    
    WS(weakSelf);
    [self.seleRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.size.mas_equalTo(IMAGE(@"dev_Ico_Hook").size);
    }];
    
    self.seleRightImageView.image = IMAGE(@"dev_Ico_Hook");
    self.seleRightImageView.hidden = YES;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
