//
//  UIDevice+LeChange.h
//  LCIphone
//
//  Created by dh on 16/1/14.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenApiService.h"
#import "RestApiInfo.h"
#import "RestApiService.h"

@interface UIDevice (LeChange)

/*!
 *  @author peng_kongan, 16-01-14 20:01:00
 *  @brief  强制设置屏幕方向
 *  @param orientation 将要设置的屏幕方向
 */
+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation;

/**
 *  强制设备旋转到状态栏方向，解决设备方向与状态栏方向不一致的情况
 */
+ (void)lc_setRotateToSatusBarOrientation;

/**
 *  判断是否已经绑定过乐橙的账号
 */
+ (void)GetLechangeToken:(NSString*)phonenumber;

/**
 *  计算当前账号phonenumber下的token
 */
//+ (void)GetLechangeUsingToken:(NSString*)phonenumber;

/**
 *  获取乐橙摄像头列表，并从中找到当前点击的那一个
 */
+ (void)GetLechangeCameraList:(NSString*)cameraID;

/**
 *  解绑当前的摄像头
 */
+ (void)UnbindLechangeCamera:(NSString*)cameraID;

+ (NSInteger)locateDevKeyIndex:(NSInteger)index array:(NSMutableArray*)array;
+ (NSInteger)locateDevChannelKeyIndex:(NSInteger)index array:(NSMutableArray*)array;

@end

