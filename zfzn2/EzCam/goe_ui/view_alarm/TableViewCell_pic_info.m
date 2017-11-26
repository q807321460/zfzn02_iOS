//
//  TableViewCell_pic_info.m
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "TableViewCell_pic_info.h"

@implementation TableViewCell_pic_info
@synthesize view_main;
@synthesize label_title;
@synthesize label_num;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
   
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config_cell_pic:(NSString*)str_date type:(NSString*)type num:(int)num with_tag:(NSString*)tag with_pos:(int)pos
{
    m_tag_id=tag;
    m_pos=pos;
    label_title.text=[NSString stringWithFormat:@"%@  %@",str_date,type];
    label_num.text=[NSString stringWithFormat:@"%d%@",num,NSLocalizedString(@"m_zhang", @"")];
}
-(void)config_cell_video:(NSString*)str_date type:(NSString*)type num:(int)num with_tag:(NSString*)tag with_pos:(int)pos
{
    m_tag_id=tag;
    m_pos=pos;
    label_title.text=[NSString stringWithFormat:@"%@  %@",str_date,type];
    label_num.text=[NSString stringWithFormat:@"%d%@",num,NSLocalizedString(@"m_second", @"")];
}
@end
