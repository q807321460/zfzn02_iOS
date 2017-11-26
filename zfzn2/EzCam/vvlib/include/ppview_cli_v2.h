//
//  ppview_cli_v2.h
//  pano360
//
//  Created by zxy on 2017/2/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libvvonvif_def.h"


@protocol push_devs_interface_v2 <NSObject>
@optional
-(void)cli_lib_push_devs_callback:(int)HttpRes;
@end



@interface ppview_cli_v2 : NSObject

@property (assign) id<push_devs_interface_v2>cli_pushdevs_delegate;


+ (ppview_cli_v2*) getInstance;
-(void)setAppInfo_v2:(NSString*)app_id vendorpass:(NSString*)vendor_pass pushsvr:(NSString*)pushsvr development:(BOOL)isdevelopment with_cer_path:(NSString*)cerPath cer_type:(int)cer_type;
+(void)cli_lib_vv_registerForPush_types_v2:(int)types launchingOption:(NSDictionary *)launchOptions;
+(void)cli_lib_vv_registerDeviceToken_v2:(NSData *)deviceToken;

//-(int)cli_lib_login_v2:(NSString*)loguser pass:(NSString*)logpass;//0x8000
-(int)cli_lib_push_devs:(NSArray*)devs_array lange:(NSString*)lang;//0x8001
@end
