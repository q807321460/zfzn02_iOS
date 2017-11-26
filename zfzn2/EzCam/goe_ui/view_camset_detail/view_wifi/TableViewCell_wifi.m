//
//  TableViewCell_wifi.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TableViewCell_wifi.h"

@implementation TableViewCell_wifi
@synthesize view_main;
@synthesize button_bg;
@synthesize label_name;
@synthesize img_pass;
@synthesize img_signal;
@synthesize delegate;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)config_cell:(NSString*)tag pos:(int)pos name:(NSString*)name ispass:(int)ispass signal:(int)signal
{
    m_tag_id=tag;
    m_pos=pos;
    label_name.text=name;
    if (ispass==0) {
        img_pass.hidden=true;
    }
    else{
        img_pass.hidden=false;
    }
    switch (signal) {
        case 0:
            img_signal.image=[UIImage imageNamed:@"png_wifi1.png"];
            break;
        case 1:
            img_signal.image=[UIImage imageNamed:@"png_wifi2.png"];
            break;
        case 2:
            img_signal.image=[UIImage imageNamed:@"png_wifi3.png"];
            break;
        case 3:
            img_signal.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
        default:
            img_signal.image=[UIImage imageNamed:@"png_wifi4.png"];
            break;
    }
}

- (IBAction)on_item_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_item_wifi_click:pos:)]) {
        if([delegate on_item_wifi_click:m_tag_id pos:m_pos]==true){
        }
    }
}
@end
