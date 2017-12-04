//
//  UIDevice+LeChange.m
//  LCIphone
//
//  Created by Hanwen Kong on 17/1/14.
//  Copyright © 2017年 zfzn. All rights reserved.
//  

#import "UIDevice+LeChange.h"
#import "OpenApiService.h"
#import "RestApiInfo.h"
#import "RestApiService.h"
#include <sys/mount.h>
#include <sys/param.h>
#import "zfzn2-Swift.h"

@implementation UIDevice (LeChange)

+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

+ (void)lc_setRotateToSatusBarOrientation
{
    UIInterfaceOrientation deviceOri = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(statusBarOri)) {
        //解锁后,可能会导致设备方向与状态栏方向不一致,强制先让设备旋转到状态栏方向
        if (statusBarOri != deviceOri) {
            [self lc_setOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }

        [self lc_setOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [self lc_setOrientation:UIInterfaceOrientationLandscapeLeft];
    }
}

+ (void)GetLechangeToken:(NSString*)phonenumber
{
    __block BOOL bRunning = YES;
    __block RestApiService* restApiService = [RestApiService shareMyInstance];
    __block DataControl* gDC = DataControl.sharedInstance;
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    LCOpenSDK_Api* m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    if (nil != m_hc && nil != gDC.m_sCameraToken) {
        [restApiService initComponent:m_hc Token:gDC.m_sCameraToken];
    }
    else {
        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
    }
    dispatch_queue_t get_userToken = dispatch_queue_create("get_userToken", nil);
    dispatch_async(get_userToken, ^{
        NSString* acessTok;
        NSString* errCode;
        NSString* errMsg;
        OpenApiService* openApi = [[OpenApiService alloc] init];
        NSInteger ret = [openApi getUserToken:@"openapi.lechange.cn" port:443 appId:gDC.m_sLechangeID appSecret:gDC.m_sLechangeSecret phone:phonenumber token:&acessTok errcode:&errCode errmsg:&errMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (-1 == ret) {
                DataControl.sharedInstance.m_sCameraToken = @"-1";
                bRunning = NO;
                return;
            }
            if (0 == ret) {
                DataControl.sharedInstance.m_sCameraToken = acessTok;
                bRunning = NO;
                return;
            }
            if (nil == errCode && nil == errMsg) {
                DataControl.sharedInstance.m_sCameraToken = @"timeout";
                bRunning = NO;
                return;
            }
            if (![errCode isEqualToString:@"TK1004"]) {
                DataControl.sharedInstance.m_sCameraToken = errMsg;
                bRunning = NO;
                return;
            }
        });
    });
    while (bRunning == YES) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

//+ (void)GetLechangeUsingToken:(NSString*)phonenumber
//{
//    __block BOOL bRunning = YES;
//    __block RestApiService* restApiService = [RestApiService shareMyInstance];
//    __block DataControl* gDC = DataControl.sharedInstance;
//    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
//    LCOpenSDK_Api* m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
//    if (nil != m_hc && nil != gDC.m_sCameraToken) {
//        [restApiService initComponent:m_hc Token:gDC.m_sCameraToken];
//    }
//    else {
//        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
//    }
//    dispatch_queue_t get_userToken = dispatch_queue_create("get_userToken", nil);
//    dispatch_async(get_userToken, ^{
//        NSString* acessTok;
//        NSString* errCode;
//        NSString* errMsg;
//        OpenApiService* openApi = [[OpenApiService alloc] init];
//        NSInteger ret = [openApi getUserToken:@"openapi.lechange.cn" port:443 appId:gDC.m_sLechangeID appSecret:gDC.m_sLechangeSecret phone:phonenumber token:&acessTok errcode:&errCode errmsg:&errMsg];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (-1 == ret) {
//                DataControl.sharedInstance.m_sCameraToken = @"-1";
//                bRunning = NO;
//                return;
//            }
//            if (0 == ret) {
//                DataControl.sharedInstance.m_sCameraToken = acessTok;
//                bRunning = NO;
//                return;
//            }
//            if (nil == errCode && nil == errMsg) {
//                DataControl.sharedInstance.m_sCameraToken = @"timeout";
//                bRunning = NO;
//                return;
//            }
//            if (![errCode isEqualToString:@"TK1004"]) {
//                DataControl.sharedInstance.m_sCameraToken = errMsg;
//                bRunning = NO;
//                return;
//            }
//        });
//    });
//    while (bRunning == YES) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//}

//这个是正在使用的token，可能属于第三者，不一定是当前用户自己的
+(void)GetLechangeCameraList:(NSString*)cameraID
{
    __block BOOL bRunning = YES;
    __block RestApiService* restApiService = [RestApiService shareMyInstance];
    __block NSMutableArray* m_devList = [[NSMutableArray alloc] init];
    __block DataControl* gDC = DataControl.sharedInstance;
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    LCOpenSDK_Api* m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    if (nil != m_hc && nil != gDC.m_sCameraToken) {
//        NSString* str = gDC.m_sCameraToken;
        [restApiService initComponent:m_hc Token:gDC.m_sCameraToken];
    }
    else {
        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
    }
    dispatch_queue_t get_devList = dispatch_queue_create("get_devList", nil);
    dispatch_async(get_devList, ^{
        if (![restApiService getDevList:m_devList Begin:DEV_BEGIN End:DEV_END]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"网络超时");
            });
            bRunning = NO;
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 == m_devList.count) {
                NSLog(@"DeviceViewController getDevList NULL");
                bRunning = NO;
            }
            else {
                NSLog(@"成功获取到了摄像头列表");
                NSInteger i = 0;
                for (DeviceInfo* dev in m_devList) {
                    if ([dev->ID isEqualToString:cameraID]) {
                        NSLog(@"找到了对应的ID：%@",dev->ID);
                        //将对应的摄像头信息保存到全局变量中，但是需要将NSInteger类型转化为NSString类型
                        NSInteger cameraFoot = [self locateDevKeyIndex:i array:m_devList];
                        gDC.mCameraInfo.m_sCameraFoot = [NSString stringWithFormat:@"%ld", (long)cameraFoot];
                        NSInteger channelFoot = [self locateDevChannelKeyIndex:i array:m_devList];
                        gDC.mCameraInfo.m_sChannelFoot = [NSString stringWithFormat: @"%ld", (long)channelFoot];
                        gDC.mCameraInfo.m_sID = dev->ID;
                        gDC.mCameraInfo.m_sAbility = dev->ability;
                        gDC.mCameraInfo.m_sChannel = [NSString stringWithFormat:@"%ld", dev->channelId[channelFoot]];
                        NSLog(@"%@", gDC.mCameraInfo.m_sChannel);
                        NSLog(@"onLive device[%@],channel[%@]", gDC.mCameraInfo.m_sID, gDC.mCameraInfo.m_sChannel);
                        break;
                    }
                    i++;
                }
                bRunning = NO;
            }
        });
    });
    while (bRunning == YES) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSLog(@"GetLechangeCameraList finished!");
}

//解绑需要使用自己的token解绑，如果失败说明权限不足
+ (void)UnbindLechangeCamera:(NSString*)cameraID
{
    __block BOOL bRunning = YES;
    __block RestApiService* restApiService = [RestApiService shareMyInstance];
    __block DataControl* gDC = DataControl.sharedInstance;
//    [gDC.m_arrayCameraList removeAllObjects];
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    LCOpenSDK_Api* m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    if (nil != m_hc && nil != gDC.m_sCameraToken) {
        [restApiService initComponent:m_hc Token:gDC.m_sCameraToken];
    }
    else {
        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
    }
    dispatch_queue_t unbind_device = dispatch_queue_create("unbind_device", nil);
    dispatch_async(unbind_device, ^{
        NSString* destOut;
        if (![restApiService unBindDevice:cameraID Desc:&destOut]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"camera解绑失败");
                gDC.m_sUnbindSuccess = @"false";
            });
            bRunning = NO;
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"camera解绑成功");
            gDC.m_sUnbindSuccess = @"true";
            bRunning = NO;
        });
    });
    while (bRunning == YES) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSLog(@"UnbindLechangeCamera finished!");
}

+ (NSInteger)locateDevKeyIndex:(NSInteger)index array:(NSMutableArray*)array
{
//    DataControl* gDC = DataControl.sharedInstance;
    int iChCount = 0;
    int i = 0;
    for (DeviceInfo* dev in array) {
        if (nil == dev->ID) {
            break;
        }
        iChCount += dev->channelSize;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
    return (iChCount >= index + 1) ? i : -1;
}

+ (NSInteger)locateDevChannelKeyIndex:(NSInteger)index array:(NSMutableArray*)array
{
//    DataControl* gDC = DataControl.sharedInstance;
    int iChCount = 0;
    int i = 0;
    for (DeviceInfo* dev in array) {
        
        if (nil == dev->ID) {
            break;
        }
        iChCount += dev->channelSize;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
    return (iChCount >= index + 1) ? (index - iChCount + ((DeviceInfo*)[array objectAtIndex:i])->channelSize) : -1;
}


@end



