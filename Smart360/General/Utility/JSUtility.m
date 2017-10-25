//
//  JSUtility.m
//  Smart360
//
//  Created by nimo on 15/8/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSUtility.h"
//#import "AppDelegate.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation JSUtility

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)jsonStringWithObj:(id)obj error:(NSError *)error {
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//正则表达式检查是否输入的为手机号码
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber {
    if ( phoneNumber ) {
        NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:@"^[1][3-8]\\d{9}$"options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:phoneNumber options:NSMatchingReportProgress range:NSMakeRange(0, phoneNumber.length)];
        
        if(numberofMatch > 0) {
            return YES;
        }
    }
    
    return NO;
    
}

+ (UIImage *)stretcheImage:(UIImage *)img {
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5 topCapHeight:img.size.height * 0.6];
}

+ (UIImage *)resizableImage:(UIImage *)img {
 return [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height * 0.4, img.size.width * 0.4, img.size.height * 0.4, img.size.width * 0.4) resizingMode:UIImageResizingModeStretch];
}


+ (NSString *)screenShotDirectory {
    return [self createDirectoryWithDirName:@"ScreenShot"];
}

+ (NSString *)voiceFileDirectory {
    return [self createDirectoryWithDirName:@"VoiceRecord"];
}

+ (NSString *)createDirectoryWithDirName:(NSString *)DirName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *storeDirectory  = [basePath stringByAppendingPathComponent:DirName];
    if (![fileManager fileExistsAtPath:storeDirectory]) {
        [fileManager createDirectoryAtPath:storeDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return storeDirectory;
}

//反转数组
+ (NSArray *)reversedArrayFromArray:(NSArray *)originalArray {
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:originalArray];
    
    int count = (int)newArray.count;
    
    if(count>1)
    {
        for(int i=0; i<count/2; i++)
        {
            int targetIndex = count-1-i;
            if(i!=targetIndex)
            {
                [newArray exchangeObjectAtIndex:i withObjectAtIndex:targetIndex];
            }
        }
    }
    return newArray;
}


//+ (NSData *)returnDataWithDictionary:(NSDictionary *)dict {
//    NSMutableData* data = [[NSMutableData alloc]init];
//    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:dict forKey:@"talkData"];
//    [archiver finishEncoding];
//    return data;
//}


#pragma mark - 设置不同字体颜色
//设置不同字体颜色
+ (void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
    
}

#pragma mark - 根据给定字体大小和宽度计算文本高度
+ (CGFloat)heightForText:(NSString *)text labelWidth:(CGFloat)width fontOfSize:(CGFloat)size {
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    return [text boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attrbute context:nil].size.height;

}


#pragma mark - 获得当前显示的VC
//获得当前显示的VC
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

#pragma  mark - getFilePath
+ (NSString *)getFilePathWithFileName:(NSString *)fileName {
    //(1)获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //(2)获取存储的文件路径(拼接)
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:fileName];
    return newFilePath;

}

@end
