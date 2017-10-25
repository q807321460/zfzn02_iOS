#import "UIImage+wrapper.h"
#define PI 3.14159265358979323846

@implementation UIImage (wrapper)

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image withSize:(CGSize)size
{
    UIImage *newImage;
    if (!image) {
        newImage = nil;
    } else {
        CGSize oldSize = image.size;
        CGRect rect;
        if (size.width / size.height > oldSize.width / oldSize.height) {
            rect.size.width = size.height * oldSize.width / oldSize.height;
            rect.size.height = size.height;
            rect.origin.x = (size.width - rect.size.width) / 2;
            rect.origin.y = 0;
        } else {
            rect.size.width = size.width;
            rect.size.height = size.width * oldSize.height / oldSize.width;
            rect.origin.x = 0;
            rect.origin.y = (size.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, size.width, size.height));//clear background
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (NSString *)writeUserPhoto:(UIImage *)image {
    NSData *data;
    NSString *imageFilePath;
    if (UIImagePNGRepresentation(image)==nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
        
    }else {
        data = UIImagePNGRepresentation(image);
        
    }
    NSDate *currentDate = [NSDate date];
    NSString *dateStr = [NSDate secondFtpFileDateFormatterWithDate:currentDate];
    //    NSLog(@"%@",dateStr);
    NSString *fileStr = [NSString stringWithFormat:@"/%@.png",dateStr];
    //
    //    NSString *imagePathStr = [NSString stringWithFormat:@"/image/%@%@",dateStr,@"/image.png"];
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:fileStr] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,fileStr];
    
//    NSLog(@"imageFile存储路径: %@",imageFilePath);
    [data writeToFile:imageFilePath atomically:YES];
    
    return dateStr;
}

+ (UIImage *)readerUserPhoto:(NSString *)dateStr {
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //得到选择后沙盒中图片的完整路径
    NSString *fileStr = [NSString stringWithFormat:@"/%@.png",dateStr];
    NSString *imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,fileStr];;
    //imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,fileStr];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (image) {
        return image;
    } else {
        return [UIImage imageNamed:@"EditPhotos"];
    }
}


@end
