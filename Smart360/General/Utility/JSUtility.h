//
//  JSUtility.h
//  Smart360
//
//  Created by nimo on 15/8/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSUtility : NSObject

//post请求
+ (NSString *)jsonStringWithObj:(id)obj error:(NSError *)error;

//正则表达式检查是否输入的为手机号码
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber ;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//图像拉伸
+ (UIImage *)stretcheImage:(UIImage *)img;
+ (UIImage *)resizableImage:(UIImage *)img;

//截图目录
+ (NSString *)screenShotDirectory;
//录音文件目录
+ (NSString *)voiceFileDirectory;

//反转数组
+ (NSArray *)reversedArrayFromArray:(NSArray *)originalArray;


#pragma mark - 设置不同字体颜色
+ (void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
#pragma mark - 根据给定字体大小和宽度计算文本高度
+ (CGFloat)heightForText:(NSString *)text labelWidth:(CGFloat)width fontOfSize:(CGFloat)size;

//获取手机ip
+ (NSString *)getIPAddress;

//获得当前显示的VC
+ (UIViewController *)getCurrentVC;

#pragma  mark - getFilePath
+ (NSString *)getFilePathWithFileName:(NSString *)fileName;

@end
