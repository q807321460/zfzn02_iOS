//
//  TableViewCell_sensor.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"
@protocol TableViewCell_sensor_interface <NSObject>
@optional
-(void)on_sensor_item_button_click:(NSString*)item_id pos:(int)pos;
@end

@interface TableViewCell_sensor : UITableViewCell
{
    NSString* m_tag_id;
    int m_pos;
}

@property (weak, nonatomic) IBOutlet UILabel *label_sensor_name;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_mode;
@property (weak, nonatomic) IBOutlet UILabel *label_sensor_id;
@property (weak, nonatomic) IBOutlet UIImageView *img_new_flag;
@property (weak, nonatomic) IBOutlet UIImageView *img_sensor_type;
@property (assign) id<TableViewCell_sensor_interface> delegate;
-(void)config_cell:(NSString*)item_name item_model:(NSString*)item_model item_id:(NSString*)item_id sensor_type:(int)sensor_type isnew:(int)isnew with_tag:(NSString*)tag with_pos:(int)pos;
- (IBAction)button_sensor_item_click:(id)sender;

@end
