//
//  pic_list_manager.m
//  ppview_zx
//
//  Created by zxy on 14-12-4.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "pic_cache_list_manager.h"
#define  ABSULATE_PATH_PIC                   @"jws_pic_cache";

@implementation pic_cache_list_manager
static pic_cache_list_manager* instance;

-(id)init{
    self = [super init];
    m_pic_array = [NSMutableArray new];
    m_pic_dictionary = [NSMutableDictionary dictionary];
    m_max_pic_num=200;
    [self init_file_path];
    [self read_piclist_file];
    return self;
}
+(pic_cache_list_manager*) getInstance{
    if(instance==nil)
    {
        instance = [[pic_cache_list_manager alloc] init];
    }
    return instance;
}
-(NSString*)get_filename:(NSString*)camid eventid:(NSString*)eventid index:(int)index
{
    NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.jpg",m_path_pic,camid,eventid,index];
    return  filename;
}
-(BOOL)is_file_exist:(NSString*)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return[fileManager fileExistsAtPath:filename];
}
-(void)add_item:(NSString*)camid eventid:(NSString*)event_id index:(int)index with_type:(int)type
{
    if (event_id==nil) {
        return;
    }
    @synchronized(self){
        //NSLog(@"m_pic_array.count===%d",m_pic_array.count);
        if (m_pic_array.count>=m_max_pic_num) {
            zx_pic_item* cur_item=[m_pic_array objectAtIndex:0];
            if (cur_item != nil) {
                [self delete_jpg_file:cur_item.str_camid eventid:cur_item.str_eventid index:index];
                [m_pic_array removeObject:cur_item];
                //[m_pic_dictionary removeObjectForKey:cur_item.str_picid];
            }
        }
        zx_pic_item* cur_item = [zx_pic_item new];
        cur_item.str_eventid=event_id;
        cur_item.m_index=index;
        cur_item.m_pic_type=type;
        cur_item.str_camid=camid;
        //cur_item.str_picid=NSString stringWithFormat:@""
        [m_pic_array addObject:cur_item];
        //[m_pic_dictionary setObject:cur_item forKey:cur_item.str_picid];
        [self save_piclist_file];
    }
}


-(BOOL)save_to_file:(NSData*)data
{
    if (data==nil) {
        return false;
    }
    
    NSString* m_path= m_path_pic;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:m_path])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            //NSLog(@"文件夹创建成功m_path_jpg");
        }
        else{
            //NSLog(@"文件夹创建失败 m_path_jpg");
        }
    }
    NSString *filename=[NSString stringWithFormat:@"%@/%@.txt",m_path,@"piclist"];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"save_camlist_file,文件创建成功: %@" ,filename);
    }else{
        
        return FALSE;
    }
    [data writeToFile:filename atomically:YES];
    return true;
}
-(void)save_piclist_file
{
    NSMutableArray *array_pics=[[NSMutableArray alloc]init];
    for (zx_pic_item* pic_item in m_pic_array){
        if (pic_item.str_camid==nil) {
            continue;
        }
        NSMutableDictionary* dic_pic = [[NSMutableDictionary alloc]init];
        [dic_pic setObject:pic_item.str_eventid forKey:@"eventid"];
        [dic_pic setObject:pic_item.str_camid forKey:@"camid"];
        [dic_pic setObject:[NSNumber numberWithInt:pic_item.m_index] forKey:@"index"];
        [dic_pic setObject:[NSNumber numberWithInt:pic_item.m_pic_type] forKey:@"pictype"];
        [array_pics addObject:dic_pic];
    }
    NSMutableDictionary* dic_pics = [[NSMutableDictionary alloc]init];
    [dic_pics setObject:array_pics forKey:@"pics"];
    //NSLog(@"save_piclist_file, dic_pics===%@",dic_pics);
    NSData* savedata = [NSJSONSerialization dataWithJSONObject:dic_pics options:kNilOptions error:nil];
    if (savedata != nil) {
        [self save_to_file:savedata];
    }    
}


- (BOOL)setJsonData:(NSData*)picdata{
    if (picdata==NULL) {
        return false;
    }
    @synchronized(self){

        NSError* reserr;
        NSMutableDictionary *g_pic_dictionary = [NSJSONSerialization JSONObjectWithData: picdata options:NSJSONReadingMutableContainers error:&reserr];
        if (g_pic_dictionary==nil) {
            return false;
        }
        [m_pic_array removeAllObjects];
        [m_pic_dictionary removeAllObjects];
        if ([g_pic_dictionary objectForKey:@"pics"]) {
            for (NSDictionary* pic_item in [g_pic_dictionary objectForKey:@"pics"]) {
                zx_pic_item* cur_item = [zx_pic_item new];
                cur_item.str_eventid=[pic_item objectForKey:@"eventid"];
                cur_item.str_camid=[pic_item objectForKey:@"camid"];
                cur_item.m_index=[[pic_item objectForKey:@"index"]intValue];
                [m_pic_array addObject:cur_item];
                //[m_pic_dictionary setObject:cur_item forKey:cur_item.str_picid];
            }
        }
    }
    return true;
}
- (void)read_piclist_file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"read_camlist_file: %@",documentsDirectory);
    NSString* m_path= [documentsDirectory stringByAppendingPathComponent:m_absulate_path_pic];
    NSString *filename=[NSString stringWithFormat:@"%@/%@.txt",m_path,@"piclist"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filename];
    [self setJsonData:data];
    // NSString* readstring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"readstring=%@",readstring);
}


-(BOOL)init_file_path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"app_home_doc: %@",documentsDirectory);
    m_absulate_path_pic=ABSULATE_PATH_PIC;
    m_path_pic = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_pic];
    // NSLog(@"m_path_jpg: %@",m_path_jpg);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:m_path_pic])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path_pic withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            //NSLog(@"文件夹创建成功m_path_jpg");
        }
        else{
            //NSLog(@"文件夹创建失败 m_path_jpg");
        }
    }
    return true;
    
}
-(BOOL)save_jpg_file:(NSData*)jpgdata camid:(NSString*)camid eventid:(NSString*)eventid index:(int)index
{
    if (jpgdata==nil || eventid==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
   //camdid_20150126_113043_3.jpg
     NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.jpg",m_path_pic,camid,eventid,index];
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
-(void)delete_jpg_file:(NSString*)camid eventid:(NSString*)event_id index:(int)index
{
    if (event_id==nil) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //camdid_20150126_113043_3.jpg
    NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.jpg",m_path_pic,camid,event_id,index];
    [fileManager removeItemAtPath:filename error:nil];
    NSLog(@"delete===%@",filename);
}
@end
