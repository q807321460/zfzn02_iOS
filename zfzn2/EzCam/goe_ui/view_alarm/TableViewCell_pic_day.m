//
//  TableViewCell_pic_day.m
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "TableViewCell_pic_day.h"

@implementation TableViewCell_pic_day
@synthesize view_main;
@synthesize img_left;
@synthesize label_title;
@synthesize label_day;
- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    m_strings=[vv_strings getInstance];
    label_title.text=NSLocalizedString(@"m_get_day", @"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)config_cell:(NSString*)str_date with_tag:(NSString*)tag with_pos:(int)pos expand:(BOOL)expand
{
    label_day.text=str_date;
    m_tag_id=tag;
    m_pos=pos;
    if (expand==true) {
        [img_left setImage:[UIImage imageNamed:@"zx_pre_level_gray.png"]];
    }
    else{
        [img_left setImage:[UIImage imageNamed:@"zx_next_level_gray.png"]];
    }
}
@end
