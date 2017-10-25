#import <UIKit/UIKit.h>

@interface UIImage (wrapper)

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image withSize:(CGSize)size;  //压缩

+ (NSString *)writeUserPhoto:(UIImage *)image;

+ (UIImage *)readerUserPhoto:(NSString *)dateStr;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
