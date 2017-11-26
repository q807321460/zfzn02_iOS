//
//  vv_strings.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-4-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* m_path;
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface vv_strings : NSObject
//color
@property (assign) int background_play;
@property (assign) int background_blue;
@property (assign) int item_blue;
@property (assign) int background_light_blue;
@property (assign) int background_green;
@property (assign) int background_yellow;
@property (assign) int red;
@property (assign) int dlg_light;
@property (assign) int item_light_blue;
@property (assign) int item_blue2;

@property (assign) int button_gray;
@property (assign) int yellow;
@property (assign) int black;
@property (assign) int background_gray;
@property (assign) int background_gray1;
@property (assign) int white;
@property (assign) int blue;
@property (assign) int orange;
@property (assign) int pink;
@property (assign) int gray;
@property (assign) int text_light_gray;

@property (assign) int light_gray;
@property (assign) int text_gray;
@property (assign) int top_gray;
@property (assign) int viewfinder_frame;
@property (assign) int viewfinder_laser;
@property (assign) int viewfinder_mask;
@property (assign) int result_view;
@property (assign) int log_title_gray;

@property (assign) int alarm_backgound_gray;
@property (assign) int alarm_label_gray;
@property (assign) BOOL b_en;

@property (assign) int ruler_blue;

+(vv_strings*)getInstance;

@end
