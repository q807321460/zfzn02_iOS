//
//  TableViewCell_localvideo.m
//  ppview_zx
//
//  Created by zxy on 15-2-7.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "TableViewCell_localvideo.h"

@implementation TableViewCell_localvideo
@synthesize view_main;
@synthesize view_right;
@synthesize img_thumbil;
@synthesize img_play;
@synthesize button_item_bg;
@synthesize label_title1;
@synthesize label_title2;
@synthesize img_right;
@synthesize delegate;
- (void)awakeFromNib {
    // Initialization code
    f_frame_width=self.frame.size.width;
    f_frame_height=self.frame.size.height;
    //NSLog(@"f_frame_height=%f",f_frame_height);
    float view_main_height=f_frame_height-1;
    view_main.frame=CGRectMake(0, 0, f_frame_width, view_main_height);
    button_item_bg.frame=CGRectMake(0, 0, f_frame_width, view_main_height);
    float f_view_right_hight=view_main_height;
    float f_view_right_width=(f_view_right_hight*4)/3;
    view_right.frame=CGRectMake(0, 0, f_view_right_width, f_view_right_hight);
    img_thumbil.frame=CGRectMake(5, 5, f_view_right_width-10, f_view_right_hight-10);
    img_play.frame=CGRectMake((f_view_right_width-40)/2, (f_view_right_hight-40)/2, 40, 40);
    img_right.frame=CGRectMake(f_frame_width-35-10, (view_main_height-35)/2, 35, 35);
    label_title1.frame=CGRectMake(f_view_right_width+5, 0, f_frame_width-f_view_right_width-50, view_main_height/2);
    label_title2.frame=CGRectMake(f_view_right_width+5, view_main_height/2, f_frame_width-f_view_right_width-50, view_main_height/2);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)config_cell:(NSString*)str_date time:(NSString*)time thumbil_file:(NSString*)filename mode:(int)mode selected:(BOOL)selected with_tag:(NSString*)tag with_pos:(int)pos
{
    m_tag_id=tag;
    m_pos=pos;
    label_title1.text=str_date;
    label_title2.text=time;
    if (mode==0) {
        img_right.hidden=true;
    }
    else{
        img_right.hidden=false;
        if (selected==true) {
            img_right.image=[UIImage imageNamed:@"check_box_yes.png"];
        }
        else{
            img_right.image=[UIImage imageNamed:@"checkbox_no.png"];
        }
    }
    if (filename != nil && filename.length>0) {
        img_thumbil.image= [UIImage imageWithContentsOfFile:filename];
    }
    if (img_thumbil.image==nil) {
        img_thumbil.image=[UIImage imageNamed:@"png_carempic.png"];
    }
}

- (IBAction)item_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_cell_localvideo_click:cell:)]) {
        if([delegate on_cell_localvideo_click:m_pos cell:self]==true){
        }
    }
}
@end
