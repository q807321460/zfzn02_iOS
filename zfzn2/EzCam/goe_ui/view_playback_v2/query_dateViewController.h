//
//  dh_playbacklistViewController.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-6-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "zxy_share_data.h"
#import "vv_strings.h"
#import "share_item.h"


@protocol query_dateViewController_interface <NSObject>
@optional
-(void)on_query_date_select:(NSDate*)start_date with_end_date:(NSDate*)end_date;
-(void)on_query_date_select_vv:(NSString*)date_str with_date:(NSDate*)date with_date_str1:(NSString*)date_str1;
@end

@interface query_dateViewController : UIViewController
{
    
    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    
    
    float m_width;
    float m_height;
    float m_y_offset;
    float f_view_top_tool_height;
    
    NSDate* cur_date;
    
    int cur_date_type;//0 =无  1=日期 2=开始  3=结束
    float f_picker_height;
    NSDate *currentDate;
    
    NSDate* date_date;
    NSDate* start_date;
    NSDate* end_date;
    
    NSString* str_date;
    NSString* str_start_time;
    NSString* str_end_time;
    NSDateFormatter *dateFormat;
    NSDateFormatter *timeFormat;
    
    
    NSDateFormatter *dateFormat_vv;
    NSString* str_date_vv;
}

@property (assign) id<query_dateViewController_interface> delegate;
@property (weak, nonatomic) IBOutlet UIView *view_main1;
@property (weak, nonatomic) IBOutlet UIView *view_main1_top_tool;
@property (weak, nonatomic) IBOutlet UIButton *view_main1_top_button_return;
@property (weak, nonatomic) IBOutlet UILabel *view_main1_top_label;
@property (weak, nonatomic) IBOutlet UIButton *view_main1_top_button_ok;

@property (weak, nonatomic) IBOutlet UIView *view_date;
@property (weak, nonatomic) IBOutlet UILabel *lable_date_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_date_value;
@property (weak, nonatomic) IBOutlet UIImageView *img_date;

@property (weak, nonatomic) IBOutlet UIView *view_start_time;
@property (weak, nonatomic) IBOutlet UILabel *lable_start_time_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_start_time_value;
@property (weak, nonatomic) IBOutlet UIImageView *img_start_time;

@property (weak, nonatomic) IBOutlet UIView *view_end_time;
@property (weak, nonatomic) IBOutlet UILabel *lable_end_time_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_end_time_value;
@property (weak, nonatomic) IBOutlet UIImageView *img_end_time;

@property (weak, nonatomic) IBOutlet UIView *view_picker;
@property (weak, nonatomic) IBOutlet UIDatePicker *m_picker;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesture_date;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesture_start_time;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesture_end_time;


- (IBAction)view_on_click:(id)sender;
- (IBAction)button_main1_return:(id)sender;
- (IBAction)button_date_ok_click:(id)sender;

@end
