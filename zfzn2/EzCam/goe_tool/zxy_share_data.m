//
//  zxy_share_data.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-4-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "zxy_share_data.h"
#import "vv_strings.h"
#import "ppview_cli.h"
#import <SystemConfiguration/CaptiveNetwork.h>




#define     APP_KEY           @"C181906C-57D9-4FAE-95D9-2CCF462FF1BF"
#define     FACTORY_KEY       @"1ShusYdObYTfDzkH"
#define     TRANSACTION_URL   @"http://ppview.vveye.com:3000/webapi/device/"
#define     URL               @"http://ppview.vveye.com:3000/webapi/client/"
#define     EVENT_URL         @"http://ppview.vveye.com:3000/webapi/page"
#define     DEFAULT_URL       @"http://ppview.vveye.com:3000/webapi/client/"
#define     P2P_URL           @"nat.vveye.net"
//#define     P2P_URL           @"p2p.engletek.cn"

#define     P2P_SECRET        @""
#define     P2P_PORT          8000
#define     SVR_URL           @"www.apple.com"

#define     PUSH_SVR          @"https://120.76.138.115"
#define     PUSH_SVR_PORT     7000
#define     PUSH_KEY          @"C767115F-0ED0-0001-3451-1DC0D520ECB0"
#define     PUSH_PASS         @"9aaa8e3fea97081839f7515cb3426359"



@implementation zxy_share_data

@synthesize screen_y_offset;
@synthesize screen_height;
@synthesize screen_width;
@synthesize m_cur_device;
@synthesize status_bar_height;
@synthesize default_url;
@synthesize cli_url;
@synthesize dev_url;
@synthesize event_url;
@synthesize m_app_key;
@synthesize m_vendor_pass;
@synthesize playarray;
@synthesize content_scale;

@synthesize cur_device_version;
@synthesize m_sys_version;

@synthesize p2p_server;
@synthesize p2p_port;
@synthesize p2p_secret;

@synthesize net_status;
@synthesize svr_url;

@synthesize push_svr;
@synthesize push_svr_port;
@synthesize m_push_key;
@synthesize m_push_pass;

@synthesize m_language;
@synthesize bPlaying;
@synthesize m_playing_devid;

static zxy_share_data* instance = nil;



- (id)init
{
    //[self fetchSSIDInfo];
    @synchronized(self) {
        self = [super init];
        //struct utsname systemInfo;
        //uname(&systemInfo);
        //NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        net_status=FALSE;
        bPlaying=false;
       
       
        CGRect status_bar_rect  = [[UIApplication sharedApplication] statusBarFrame];
        
        status_bar_height = status_bar_rect.size.height;
        if (status_bar_height>0) {
            status_bar_height=20;
        }
        //screen_width=rect.size.width;
        cur_device_version=[[[UIDevice currentDevice] systemVersion]intValue];
        screen_y_offset = (cur_device_version >= 7 )?20:0;
        if (screen_y_offset>0) {
            status_bar_height=0;
        }
        
        UIScreen* mainscr = [UIScreen mainScreen];
        
        m_sys_version = [[[UIDevice currentDevice] systemVersion] floatValue];
        // You can't detect screen resolutions in pre 3.2 devices, but they are all 320x480
        if (m_sys_version >= 3.2f)
        {
            //CGRect rect=[[UIScreen mainScreen] bounds];
            
            int w = mainscr.currentMode.size.width;
            //int h = mainscr.currentMode.size.height;
            if (w==640)
            {
                content_scale=2.0f;
            }
            else
                content_scale=1.0f;
            //1024*768
        }
        else
            content_scale=1.0f;
        CGRect rect=[mainscr bounds];
        screen_width=rect.size.width;
        screen_height = rect.size.height;//iphone5?548:460;
        m_cur_device=1;
        if(screen_width==320&& screen_height==480){
            m_cur_device=0;
        }
        else if(screen_width==320&& screen_height==568){
            m_cur_device=1;
        }
        else if(screen_width==375&& screen_height==667){
            m_cur_device=2;
        }
        else if(screen_width==414&& screen_height==736){
            m_cur_device=3;
        }
        svr_url=SVR_URL;
        default_url=DEFAULT_URL;
        cli_url=URL;
        dev_url=TRANSACTION_URL;
        event_url=EVENT_URL;
        m_app_key=APP_KEY;
        m_vendor_pass=FACTORY_KEY;
        
        push_svr=PUSH_SVR;
        push_svr_port=PUSH_SVR_PORT;
        m_push_key=PUSH_KEY;
        m_push_pass=PUSH_PASS;
        
        playarray=[NSMutableArray new];
       
       
        
        p2p_server=P2P_URL;
        p2p_port=P2P_PORT;
        p2p_secret=P2P_SECRET;
        
        m_language= [self getCurrentLanguage];
        
        if ([m_language hasPrefix:@"zh"]==true) {
            m_language=@"zh";
            
        }
        else
            m_language=@"en";
        
        return self;
    }
}

- (NSString*)getCurrentLanguage
{
    NSArray *langArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    return langArray[0];
}


-(id) copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id) allocWithZone:(NSZone *)zone{
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}


+(zxy_share_data*)getInstance{
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
