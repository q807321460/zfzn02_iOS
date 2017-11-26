//
//  TableViewCell_sensor.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TableViewCell_sensor.h"

@implementation TableViewCell_sensor
@synthesize label_sensor_name;
@synthesize label_sensor_mode;
@synthesize label_sensor_id;
@synthesize img_new_flag;
@synthesize img_sensor_type;
@synthesize delegate;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)config_cell:(NSString*)item_name item_model:(NSString*)item_model item_id:(NSString*)item_id sensor_type:(int)sensor_type isnew:(int)isnew with_tag:(NSString*)tag with_pos:(int)pos
{
    m_tag_id=tag;
    m_pos=pos;
    
    if (isnew==0) {
        img_new_flag.hidden=true;
    }
    else{
        img_new_flag.hidden=false;
    }
    label_sensor_name.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"m_name", @""),item_name];
    label_sensor_mode.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"m_model", @""),item_model];
    label_sensor_id.text=[NSString stringWithFormat:@"(ID:%@)",item_id];
    /*
     "m_sensor_type_1"="门磁";
     "m_sensor_type_2"="红外";
     "m_sensor_type_3"="烟感";
     "m_sensor_type_4"="煤气";
     "m_sensor_type_5"="水浸";
     "m_sensor_type_6"="振动";
     "m_sensor_type_7"="遥控器";
     "m_sensor_type_8"="幕帘";
     "m_sensor_type_F1"="智能开关";
     "m_sensor_type_F2"="插座";
     "m_sensor_type_F9"="窗帘";
     "m_sensor_type_unknown"="未知";
     */
    switch (sensor_type) {
        case 0x01:
            img_sensor_type.image=[UIImage imageNamed:@"sensor_menci.png"];
            break;
        case 0x07:
            img_sensor_type.image=[UIImage imageNamed:@"sensor_remote_ctrl.png"];
            break;
        case 0x08:
            img_sensor_type.image=[UIImage imageNamed:@"sensor_mulian.png"];
            break;
        case 0x09:
            img_sensor_type.image=[UIImage imageNamed:@"sensor_sos.png"];
            break;
        default:
            img_sensor_type.image=[UIImage imageNamed:@"sensor_unknown.png"];
            break;
    }

}

- (IBAction)button_sensor_item_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_sensor_item_button_click:pos:)]) {
        [delegate on_sensor_item_button_click:m_tag_id pos:m_pos];
    }
}
@end
