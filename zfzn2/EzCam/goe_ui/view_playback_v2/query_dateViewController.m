//
//  dh_playbackViewController.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-6-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "query_dateViewController.h"


@interface query_dateViewController ()

@end

@implementation query_dateViewController


@synthesize view_main1;
@synthesize view_main1_top_tool;
@synthesize view_main1_top_button_return;
@synthesize view_main1_top_label;
@synthesize view_main1_top_button_ok;

@synthesize view_date;
@synthesize lable_date_title;
@synthesize lable_date_value;
@synthesize img_date;

@synthesize view_start_time;
@synthesize lable_start_time_title;
@synthesize lable_start_time_value;
@synthesize img_start_time;

@synthesize view_end_time;
@synthesize lable_end_time_title;
@synthesize lable_end_time_value;
@synthesize img_end_time;

@synthesize view_picker;
@synthesize m_picker;

@synthesize gesture_date;
@synthesize gesture_start_time;
@synthesize gesture_end_time;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cur_date_type=0;
    MyShareData=[zxy_share_data getInstance];
    m_strings=[vv_strings getInstance];
    f_picker_height=162;
    
      
    m_width=MyShareData.screen_width;
    m_height=MyShareData.screen_height-MyShareData.status_bar_height-MyShareData.screen_y_offset;
    m_y_offset=MyShareData.screen_y_offset;
    
    f_view_top_tool_height=44;
   
    
    
    view_main1.frame=CGRectMake(0, m_y_offset, m_width, m_height);
    view_main1_top_tool.frame=CGRectMake(0, 0, m_width, f_view_top_tool_height);
    [view_main1_top_tool setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    
    view_main1_top_button_return.frame=CGRectMake(0, 0, f_view_top_tool_height, f_view_top_tool_height);
    view_main1_top_button_ok.frame=CGRectMake(m_width-f_view_top_tool_height, 0, f_view_top_tool_height, f_view_top_tool_height);
    view_main1_top_label.frame=CGRectMake(f_view_top_tool_height, 0, m_width-f_view_top_tool_height*2, f_view_top_tool_height);
    
    [view_main1_top_label setTextColor:UIColorFromRGB(m_strings.text_gray)];
    view_main1_top_label.text=NSLocalizedString(@"m_query_record_list", @"");
    
    
    str_date=@"";
    str_start_time=@"";
    str_end_time=@"";
    view_date.frame=CGRectMake(0, f_view_top_tool_height, m_width, f_view_top_tool_height);
    lable_date_title.frame=CGRectMake(0, 0, 100, f_view_top_tool_height);
    lable_date_title.text=NSLocalizedString(@"m_select_date", @"");
    lable_date_value.frame=CGRectMake(100, 0, 150, f_view_top_tool_height);
    lable_date_value.text=str_date;
    img_date.frame=CGRectMake(m_width-f_view_top_tool_height, (f_view_top_tool_height-30)/2, 30, 30);
    
    lable_start_time_title.frame=CGRectMake(0, 0, 100, f_view_top_tool_height);
    lable_start_time_title.text=NSLocalizedString(@"m_start_time", @"");
    lable_start_time_value.frame=CGRectMake(100, 0, 150, f_view_top_tool_height);
    lable_start_time_value.text=str_start_time;
    img_start_time.frame=CGRectMake(m_width-f_view_top_tool_height, (f_view_top_tool_height-30)/2, 30, 30);
    
    lable_end_time_title.frame=CGRectMake(0, 0, 100, f_view_top_tool_height);
    lable_end_time_title.text=NSLocalizedString(@"m_end_time", @"");
    lable_end_time_value.frame=CGRectMake(100, 0, 150, f_view_top_tool_height);
    lable_end_time_value.text=str_end_time;
    img_end_time.frame=CGRectMake(m_width-f_view_top_tool_height, (f_view_top_tool_height-30)/2, 30, 30);
    [self display_with_type];
    [m_picker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    currentDate = self.m_picker.date;
    m_picker.maximumDate = currentDate;
    date_date=currentDate;
    start_date=currentDate;
    end_date=currentDate;
    
    dateFormat= [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    timeFormat= [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:00"];
    
    dateFormat_vv= [[NSDateFormatter alloc] init];
    [dateFormat_vv setDateFormat:@"yyyyMMdd"];
    str_date_vv=[self get_date_string:date_date with_format:dateFormat_vv];
    
    str_date= [self get_date_string:date_date with_format:dateFormat];
    lable_date_value.text=str_date;

}

-(NSString*)get_date_string:(NSDate*)date with_format:(NSDateFormatter*)format
{
    NSString *DateStr = [format stringFromDate:date];
    return DateStr;
}

-(void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{

    switch (cur_date_type) {
        case 1:
            date_date=paramDatePicker.date;
            str_date= [self get_date_string:date_date with_format:dateFormat];
            lable_date_value.text=str_date;
            str_date_vv=[self get_date_string:date_date with_format:dateFormat_vv];
            break;
        case 2:
            start_date=paramDatePicker.date;
            str_start_time= [self get_date_string:start_date with_format:timeFormat];
            lable_start_time_value.text=str_start_time;
            
            end_date=[end_date laterDate:start_date];
            str_end_time= [self get_date_string:end_date with_format:timeFormat];
            lable_end_time_value.text=str_end_time;
            break;
        case 3:
            end_date=paramDatePicker.date;
            str_end_time= [self get_date_string:end_date with_format:timeFormat];
            lable_end_time_value.text=str_end_time;
            
            start_date=[start_date earlierDate:end_date];
            str_start_time= [self get_date_string:start_date with_format:timeFormat];
            lable_start_time_value.text=str_start_time; 
            break;
            
        default:
            break;
    }
    
}
-(void)display_with_type
{
    switch (cur_date_type) {
        case 0:
            [self display_type_0];
            break;
        case 1:
            [self display_type_1];
            break;
        case 2:
            [self display_type_2];
            break;
        case 3:
            [self display_type_3];
            break;
            
        default:
            break;
    }
}
-(void)display_type_0
{
    float f_cur_height=f_view_top_tool_height*2;
    
    f_cur_height += 1;
    view_start_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    f_cur_height +=f_view_top_tool_height;
    
    f_cur_height += 1;
    view_end_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    
    
    view_picker.hidden=true;
    
}
-(void)display_type_1
{
    
    float f_cur_height=f_view_top_tool_height*2;
    view_picker.frame=CGRectMake(0, f_cur_height, m_width, f_picker_height);
    m_picker.frame=CGRectMake(0, 0, m_width, f_picker_height);
    m_picker.datePickerMode=UIDatePickerModeDate;
    f_cur_height  += f_picker_height;
    view_start_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    f_cur_height +=f_view_top_tool_height;
    
    f_cur_height += 1;
    view_end_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    view_picker.hidden=false;
}
-(void)display_type_2
{
    float f_cur_height=f_view_top_tool_height*2;
    
    f_cur_height += 1;
    view_start_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    f_cur_height +=f_view_top_tool_height;
    
    view_picker.frame=CGRectMake(0, f_cur_height, m_width, f_picker_height);
    m_picker.frame=CGRectMake(0, 0, m_width, f_picker_height);
    m_picker.datePickerMode=UIDatePickerModeTime;
    f_cur_height  += f_picker_height;
    view_end_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    view_picker.hidden=false;
}
-(void)display_type_3
{
    float f_cur_height=f_view_top_tool_height*2;
    
    f_cur_height += 1;
    view_start_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    f_cur_height +=f_view_top_tool_height;
    
    f_cur_height += 1;
    view_end_time.frame=CGRectMake(0, f_cur_height, m_width, f_view_top_tool_height);
    f_cur_height += f_view_top_tool_height;
    view_picker.frame=CGRectMake(0, f_cur_height, m_width, f_picker_height);
    m_picker.frame=CGRectMake(0, 0, m_width, f_picker_height);
    m_picker.datePickerMode=UIDatePickerModeTime;
    view_picker.hidden=false;
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    cur_date = control.date;
    /*添加你自己响应代码*/
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSDate *)cc_dateByMovingToBeginningOfDay:(NSDate*)date with_hour:(int)hour{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:hour];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
    
}

- (IBAction)button_date_ok_click:(id)sender {
    
    /*
    if ([delegate respondsToSelector:@selector(on_query_date_select:with_end_date:)]) {
        [delegate on_query_date_select:start_date with_end_date:end_date];
    }
     */
    if ([delegate respondsToSelector:@selector(on_query_date_select_vv:with_date:with_date_str1:)]) {
        [delegate on_query_date_select_vv:str_date_vv with_date:date_date with_date_str1:str_date];
    }
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
    }];
}



- (IBAction)view_on_click:(id)sender {
  
    if (sender==gesture_date) {
        if (cur_date_type==1) {
            cur_date_type=0;
        }
        else{
            cur_date_type=1;
            if (str_date.length<=0) {
                str_date=[self get_date_string:date_date with_format:dateFormat];
                lable_date_value.text=str_date;
            }
        }
    }
    else if(sender==gesture_start_time){
        if (cur_date_type==2) {
            cur_date_type=0;
        }
        else{
            cur_date_type=2;
            if (str_start_time.length<=0) {
                str_start_time=[self get_date_string:start_date with_format:timeFormat];
                lable_start_time_value.text=str_start_time;
            }
            if (str_end_time.length<=0) {
                str_end_time=[self get_date_string:end_date with_format:timeFormat];
                lable_end_time_value.text=str_end_time;
            }
        }
        
    }
    else if(sender==gesture_end_time){
        if (cur_date_type==3) {
            cur_date_type=0;
        }
        else{
            cur_date_type=3;
            if (str_end_time.length<=0) {
                str_end_time=[self get_date_string:date_date with_format:timeFormat];
                lable_end_time_value.text=str_end_time;
            }
            if (str_start_time.length<=0) {
                str_start_time=[self get_date_string:end_date with_format:timeFormat];
                lable_start_time_value.text=str_start_time;
            }
        }
    }
    [self display_with_type];
}



- (IBAction)button_main1_return:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^(){
        //[m_tree_group_list reset];
    }];
}



- (IBAction)button_main1_return_click:(id)sender {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

@end
