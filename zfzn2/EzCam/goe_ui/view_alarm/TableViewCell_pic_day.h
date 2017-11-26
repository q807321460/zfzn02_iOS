//
//  TableViewCell_pic_day.h
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"

@protocol TableViewCell_pic_day_interface <NSObject>
@optional
-(void)on_button_refuse_click:(NSString*)item_id pos:(int)pos;
@end

@interface TableViewCell_pic_day : UITableViewCell
{
    vv_strings* m_strings;
    float f_frame_width;
    float f_frame_height;
    NSString* m_tag_id;
    int m_pos;
}
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIImageView *img_left;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_day;

-(void)config_cell:(NSString*)str_date with_tag:(NSString*)tag with_pos:(int)pos expand:(BOOL)expand;
@end
