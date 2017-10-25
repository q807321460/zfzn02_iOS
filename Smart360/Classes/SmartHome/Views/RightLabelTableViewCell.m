//
//  RightLabelTableViewCell.m
//  Smart360
//
//  Created by michael on 15/12/8.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "RightLabelTableViewCell.h"

@implementation RightLabelTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
        
    }
    return self;
    
}

-(void)createSubView{
    
    self.rightLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.rightLabel];
    
    WS(weakSelf);
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.textLabel);
        make.width.mas_equalTo(160);
    }];
    
    self.rightLabel.textColor = UIColorFromRGB(0x999999);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.font = self.textLabel.font;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
