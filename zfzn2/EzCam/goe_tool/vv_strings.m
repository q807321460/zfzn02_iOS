//
//  vv_strings.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-4-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "vv_strings.h"
NSString* m_path;
@implementation vv_strings

//color
@synthesize background_play;
@synthesize background_blue;
@synthesize item_blue;
@synthesize background_light_blue;
@synthesize background_green;
@synthesize background_yellow;
@synthesize red;
@synthesize dlg_light;
@synthesize item_light_blue;
@synthesize item_blue2;
@synthesize text_light_gray;

@synthesize button_gray;
@synthesize yellow;
@synthesize black;
@synthesize background_gray;
@synthesize white;
@synthesize blue;
@synthesize orange;
@synthesize pink;
@synthesize gray;
@synthesize light_gray;
@synthesize text_gray;
@synthesize top_gray;
@synthesize viewfinder_frame;
@synthesize viewfinder_laser;
@synthesize viewfinder_mask;
@synthesize result_view;
@synthesize log_title_gray;
@synthesize alarm_backgound_gray;
@synthesize alarm_label_gray;
@synthesize b_en;
@synthesize background_gray1;
@synthesize ruler_blue;
static vv_strings* instance = nil;


- (id)init
{
    @synchronized(self) {
        self = [super init];
        
        //color
        log_title_gray=0x959595;
        background_play=0x373737;
        background_blue=0x2ca7ea;
        item_blue=0xd6effc;
        background_light_blue=0x01A9D6;
        background_green=0x6C9D06;
        background_yellow=0xFF9A00;
        red=0xFF6666;
        dlg_light=0x29FC04;
        item_light_blue=0x66ffff;
        item_blue2=0x01CBFE;
        button_gray=0xbfbfbf;
        yellow=0xFFFF00;
        black=0x000000;
        background_gray=0x454545;
        background_gray1=0x999999;
        white=0xFFFFFF;
        blue=0x0066FF;
        orange=0xf6940f;
        pink=0xff7c7d;
        gray=0x686868;
        light_gray=0x9b9b9b;
        text_gray=0x5e5e5e;
        top_gray=0xebebeb;
        viewfinder_frame=0xff000000;
        viewfinder_laser=0xffff0000;
        viewfinder_mask=0x60000000;
        result_view=0xb0000000;
        
        alarm_backgound_gray=0xe6e6e6;
        alarm_label_gray=0xb4b4b4;
        text_light_gray=0x898989;
        ruler_blue=0x3b6e99;
        
        //m_path=test;
        NSString* m_language= [[[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"]objectAtIndex:0];
        if ([m_language hasPrefix:@"ko"]==true) {
            m_path=[[NSBundle mainBundle] pathForResource:@"ko" ofType:@"lproj"];
        }
        else if([m_language hasPrefix:@"zh"]==true){
            m_path=[[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        }
        else{
            m_path=[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        }
        return self;
    }
}

+(vv_strings*)getInstance{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}




@end
