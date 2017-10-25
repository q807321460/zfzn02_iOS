
//
//  Macro_Config.h
//  FingerTips
//
//  Created by sky on 14-6-12.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#ifndef Smart360_Macro_Config_h
#define Smart360_Macro_Config_h


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

//
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define IS_IOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define IS_IOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)? (YES):(NO))
#define IS_4INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



// log规范
#define LogMgr(level, tag, fmt, ...) NSLog(@"[%@] %@: %s --> " fmt, level, tag, __FUNCTION__, ##__VA_ARGS__)
#define JSError(tag, fmt, ...)  LogMgr(@"ERROR", tag, fmt, ##__VA_ARGS__)
#define JSWarn(tag, fmt, ...)   LogMgr(@"WARN", tag, fmt, ##__VA_ARGS__)
#define JSInfo(tag, fmt, ...)   LogMgr(@"INFO", tag, fmt, ##__VA_ARGS__)
#define JSDebug(tag, fmt, ...)  LogMgr(@"DEBUG", tag, fmt, ##__VA_ARGS__)
////析构函数
#define JSTrace  DestructorHelper *destructorHelper = [[DestructorHelper alloc] initWithFunctionName:__FUNCTION__]



#ifdef DEBUG
#define JSlog(fmt, ...) NSLog(@"customLog:<%@ %s>:%@, %@", NSStringFromClass([self class]), __FUNCTION__, fmt, [NSThread currentThread]);
#else
#define JSlog(fmt, ...)
#endif

//分享地址
#define ShareFriendUrl  @"http://smallzhi.com/sp/download.jsp"

#endif
