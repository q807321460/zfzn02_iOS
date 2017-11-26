//
//  TableViewCell_search_dev.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TableViewCell_search_dev.h"

@implementation TableViewCell_search_dev
@synthesize delgate;
@synthesize label_devid;
@synthesize label_devip;
@synthesize label_exist;
@synthesize button_bg;
- (void)awakeFromNib {
    // Initialization code
    label_exist.text=NSLocalizedString(@"m_exist",@"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)config_cell:(NSString*)devid devip:(NSString*)devip exist:(BOOL)exist pos:(int)pos tag:(NSString*)tag
{
    m_pos=pos;
    m_tag=tag;
    label_devid.text=devid;
    label_devip.text=devip;
    if (exist==true) {
        label_exist.hidden=false;
        button_bg.enabled=false;
    }
    else{
        label_exist.hidden=true;
        button_bg.enabled=true;
    }
}
- (IBAction)button_dev_select:(id)sender {
    if (delgate!=nil && [delgate respondsToSelector:@selector(on_add_dev_select_click:tag:)]) {
        [delgate on_add_dev_select_click:m_pos tag:m_tag];
    }
}
@end
