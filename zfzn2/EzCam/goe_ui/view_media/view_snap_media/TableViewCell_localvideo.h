//
//  TableViewCell_localvideo.h
//  ppview_zx
//
//  Created by zxy on 15-2-7.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableViewCell_localvideo_interface <NSObject>
@optional
-(BOOL)on_cell_localvideo_click:(int)pos cell:(id)cell;
@end

@interface TableViewCell_localvideo : UITableViewCell
{
    float f_frame_width;
    float f_frame_height;
    NSString* m_tag_id;
    int m_pos;
}
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIView *view_right;
@property (weak, nonatomic) IBOutlet UIImageView *img_thumbil;
@property (weak, nonatomic) IBOutlet UIImageView *img_play;
@property (weak, nonatomic) IBOutlet UIButton *button_item_bg;
@property (weak, nonatomic) IBOutlet UILabel *label_title1;
@property (weak, nonatomic) IBOutlet UILabel *label_title2;
@property (weak, nonatomic) IBOutlet UIImageView *img_right;
@property (assign) id<TableViewCell_localvideo_interface> delegate;

-(void)config_cell:(NSString*)str_date time:(NSString*)time thumbil_file:(NSString*)filename mode:(int)mode selected:(BOOL)selected with_tag:(NSString*)tag with_pos:(int)pos;

- (IBAction)item_click:(id)sender;
@end
