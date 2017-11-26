//
//  pic_file_manager.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "pic_file_manager.h"
#define  ABSULATE_PATH_JPG                    @"ppviewjpg";
#define  ABSULATE_PATH_PNG                    @"ppviewpng";
#define  ABSULATE_PATH_PNG_LOCAL              @"ppviewpnglocal";

#define  TMP_ABSULATE_PATH_PNG                @"ppviewpng_tmp";
#define  ABSULATE_PATH_PNG_PRESET             @"ppviewpngpreset";

//static NSString *m_path_jpg;

@implementation pic_file_manager

static pic_file_manager* instance = nil;
- (id)init
{
    @synchronized(self) {
        self = [super init];
        bInit=false;
        return self;
    }
}

+(pic_file_manager*)getInstance
{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(BOOL)init_file_path
{
    if (bInit==true) {
        return true;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
 
    m_absulate_path_jpg=ABSULATE_PATH_JPG;
//    m_path_jpg = [NSString stringWithFormat:@"%@/%@", documentsDirectory, m_absulate_path_jpg];
    m_path_jpg = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_jpg];
    if(![fileManager fileExistsAtPath:m_path_jpg])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path_jpg withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功m_path_jpg");
        }
        else{
            NSLog(@"文件夹创建失败 m_path_jpg");
        }
    }
    
    
    m_absulate_path_png=ABSULATE_PATH_PNG;
    m_path_png = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_png];
   // NSLog(@"m_path_png: %@",m_path_jpg);
    
    if(![fileManager fileExistsAtPath:m_path_png])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path_png withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功 m_path_png");
        }
        else{
            NSLog(@"文件夹创建失败 m_path_png");
        }
    }
    m_absulate_path_png=ABSULATE_PATH_PNG_LOCAL;
    m_path_png_local = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_png];
    if(![fileManager fileExistsAtPath:m_path_png_local])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path_png_local withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功 m_path_png");
        }
        else{
            NSLog(@"文件夹创建失败 m_path_png");
        }
    }
    
    m_absulate_path_png_tmp=TMP_ABSULATE_PATH_PNG;
    m_path_png_tmp = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_png_tmp];
    if(![fileManager fileExistsAtPath:m_path_png_tmp])
    {
        [fileManager createDirectoryAtPath:m_path_png_tmp withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    m_absulate_path_png_preset=ABSULATE_PATH_PNG_PRESET
    m_path_png_preset=[documentsDirectory stringByAppendingPathComponent:m_absulate_path_png_preset];
    [fileManager createDirectoryAtPath:m_path_png_preset withIntermediateDirectories:YES attributes:nil error:nil];
    bInit=true;
    return true;
    
}

-(BOOL)is_event_file_exist:(NSString*)filename_event
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:@"event"];
    if(![fileManager fileExistsAtPath:filepath])
    {
        return false;
    }
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr subpathsOfDirectoryAtPath:filepath error:nil];
    BOOL isfolder=true;
    for (NSString* fileName in tempArray)
    {
        //NSLog(@"fileName=%@",fileName);
        NSString* full_filename=[filepath stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:full_filename isDirectory:&isfolder]) {
            if (isfolder==false && [full_filename isEqualToString:filename_event]==true) {
                return true;
            }
        }
        
    }
    return false;
}

-(NSString*)get_event_filepath:(NSString*)filename
{
   
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:@"event"];
    NSString* filename_event=[NSString stringWithFormat:@"%@/%@.jpg",filepath,filename];
    return filename_event;

}
-(BOOL)save_event_file:(NSData*)jpgdata with_name:(NSString*)name
{
    if (jpgdata==nil || name==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:@"event"];
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=name;
    
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"文件创建成功: %@" ,filename);
    }else{
        return FALSE;
    }
    [jpgdata writeToFile:filename atomically:YES];
    NSLog(@"save_event_file ok===>%@",filename);
    return true;
}

-(NSString*)get_file_path
{
    return m_path_jpg;
}

-(NSString*)get_png_file_path
{
    return m_path_png;
}
-(NSString*)get_png_file_path_local
{
    return m_path_png_local;
}
-(NSString*)get_tmp_png_file_path
{
    return m_path_png_tmp;
}
-(NSString*)get_file_path_preset
{
    return m_path_png_preset;
}

-(BOOL)save_img_file_ad:(NSData*)jpgdata
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png_preset;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            return FALSE;
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/advertise.jpg",filepath];
    if(jpgdata==nil && [fileManager fileExistsAtPath:filename]==true){
        [fileManager removeItemAtPath:filename error:nil];
        return false;
    }
    
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        [jpgdata writeToFile:filename atomically:YES];
        return true;
    }
    return FALSE;
    
}
-(NSString*)get_img_file_ad
{
    NSString *filename=[NSString stringWithFormat:@"%@/advertise.jpg",m_path_png_preset];
    return filename;
}
-(BOOL)save_img_file_preset:(UIImage*)image with_camid:(NSString*)camid with_pos:(int)pos
{
    if (image==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png_preset;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            return FALSE;
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@-%d.jpg",filepath,camid, pos];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:filename atomically:YES];
        return true;
    }
    return FALSE;
    
}
-(BOOL)save_img_file:(UIImage*)image with_name:(NSString*)name
{
    if (image==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_img_file,文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"save_img_file,文件创建失败");
        return FALSE;
    }
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filename atomically:YES];
    return true;
}
-(NSString*)get_cam_thumbil_filename:(NSString*)camid
{
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",m_path_png,camid];
    return filename;
}
-(BOOL)save_png_file_local:(NSData*)jpgdata with_name:(NSString*)name
{
    if (jpgdata==nil || name==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png_local;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_png_file,文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"save_png_file,文件创建失败");
        return FALSE;
    }
    //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)]
    [jpgdata writeToFile:filename atomically:YES];
    return true;
}
-(BOOL)save_tmp_png_file:(NSData*)jpgdata with_name:(NSString*)name
{
    if (jpgdata==nil || name==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png_tmp;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_png_file,文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"save_png_file,文件创建失败");
        return FALSE;
    }
    //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)]
    [jpgdata writeToFile:filename atomically:YES];
    return true;
}
-(BOOL)save_png_file:(NSData*)jpgdata with_name:(NSString*)name
{
    if (jpgdata==nil || name==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=m_path_png;
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_png_file,文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"save_png_file,文件创建失败");
        return FALSE;
    }
    //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)]
    [jpgdata writeToFile:filename atomically:YES];
    return true;
}
-(NSString*)get_jpg_filename:(NSString*)date with_name:(NSString*)name
{
    if (date==nil || name==nil) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:date];
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    
    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    return  filename;
}
-(BOOL)save_jpg_file:(NSData*)jpgdata with_date:(NSString*)date with_name:(NSString*)name
{
    if (jpgdata==nil || date==nil || name==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:date];
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }

    NSString *filename=[NSString stringWithFormat:@"%@/%@.jpg",filepath,name];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"文件创建失败");
        return FALSE;
    }
    //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)]
    [jpgdata writeToFile:filename atomically:YES];
    return true;
}
-(NSString*)get_filename_video:(BOOL)isFish fishtag:(NSString*)fishtag
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    //[formater setDateFormat:@"yyyy.MM.dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    [formater setDateFormat:@"yyyyMMdd"];//这里去掉 具体时间 保留日期
    NSString * curFolderTime = [formater stringFromDate:curDate];
    [formater setDateFormat:@"yyyyMMddHHmmss"];//这里去掉 具体时间 保留日期
    NSString * curFileTime = [formater stringFromDate:curDate];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filepath=[m_path_jpg stringByAppendingPathComponent:curFolderTime];
    if(![fileManager fileExistsAtPath:filepath])
    {
        BOOL res=[fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res==FALSE) {
            //NSLog(@"文件夹创建失败:%@",filepath);
            return FALSE;
        }
        else{
            //NSLog(@"文件夹创建成功:%@",filepath);
        }
    }
    if (isFish==false) {
        NSString *filename=[NSString stringWithFormat:@"%@/%@.vvi",filepath,curFileTime];
        return filename;
    }
    else{
        if (fishtag != nil) {
            NSString *filename=[NSString stringWithFormat:@"%@/%@%@.fishvvi",filepath,curFileTime,fishtag];
            return filename;
        }
        else{
            NSString *filename=[NSString stringWithFormat:@"%@/%@.fishvvi",filepath,curFileTime];
            return filename;
        }
    }
}

-(void)delete_folder:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

-(void)delete_tmp_img_folder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    m_absulate_path_png_tmp=TMP_ABSULATE_PATH_PNG;
    m_path_png_tmp = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_png_tmp];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:m_path_png_tmp])
        [fileManager removeItemAtPath:m_path_png_tmp error:nil];
}
@end
