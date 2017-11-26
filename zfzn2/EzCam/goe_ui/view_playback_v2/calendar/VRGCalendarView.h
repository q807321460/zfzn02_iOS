//
//  VRGCalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

//#define kVRGCalendarViewTopBarHeight 60
//#define kVRGCalendarViewWidth 244

//#define kVRGCalendarViewDayWidth 30
//#define kVRGCalendarViewDayHeight 32

@protocol VRGCalendarViewDelegate;
@interface VRGCalendarView : UIView {
    id <VRGCalendarViewDelegate> delegate;
    
    NSDate *currentMonth;
    
    UILabel *labelCurrentMonth;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedColors;
    
    float kVRGCalendarViewTopBarHeight_vv;
    float kVRGCalendarViewWidth_vv;
    
    float kVRGCalendarViewDayWidth_vv;
    float kVRGCalendarViewDayHeight_vv;
    
    BOOL bDrawFlag;
}

@property (nonatomic, retain) id <VRGCalendarViewDelegate> delegate;
@property (nonatomic, retain) NSDate *currentMonth;
@property (nonatomic, retain) UILabel *labelCurrentMonth;
@property (nonatomic, retain) UIImageView *animationView_A;
@property (nonatomic, retain) UIImageView *animationView_B;
@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain) NSArray *markedColors;
@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;

-(id)init:(float)width with_height:(float)height ;
-(void)selectDate:(int)date;
-(void)reset;

-(void)draw_day_flag;
-(void)markDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;
-(NSString*)get_cur_month_str;
@end

@protocol VRGCalendarViewDelegate <NSObject>
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate*)month targetHeight:(float)targetHeight animated:(BOOL)animated;
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date;
-(NSMutableArray*)calendarView:(VRGCalendarView *)calendarView getDaysFlag:(NSDate*)date;
@end
