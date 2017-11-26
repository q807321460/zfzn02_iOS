//
//  TableViewCell_pic_info.h
//  ppview_zx
//
//  Created by zxy on 14-12-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"
@interface TableViewCell_pic_info : UITableViewCell
{
    vv_strings* m_strings;
    float f_frame_width;
    float f_frame_height;
    NSString* m_tag_id;
    int m_pos;
}
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_num;

-(void)config_cell_pic:(NSString*)str_date type:(NSString*)type num:(int)num with_tag:(NSString*)tag with_pos:(int)pos;
-(void)config_cell_video:(NSString*)str_date type:(NSString*)type num:(int)num with_tag:(NSString*)tag with_pos:(int)pos;
@end
