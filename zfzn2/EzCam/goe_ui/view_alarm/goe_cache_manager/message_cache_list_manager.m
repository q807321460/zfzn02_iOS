//
//  message_cache_list_manager.m
//  ppview_zx
//
//  Created by zxy on 15-2-4.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "message_cache_list_manager.h"
//#include "PCM2Wav.h"
#define  ABSULATE_PATH_MES                  @"jws_mes_cache";
@implementation message_cache_list_manager
static message_cache_list_manager* instance;

-(id)init{
    self = [super init];
    m_mes_array = [NSMutableArray new];
    m_mes_dictionary = [NSMutableDictionary dictionary];
    m_max_mes_num=30;
    [self init_file_path];
    [self read_meslist_file];
    return self;
}
+(message_cache_list_manager*) getInstance{
    if(instance==nil)
    {
        instance = [[message_cache_list_manager alloc] init];
    }
    return instance;
}
-(NSString*)get_filename:(NSString*)camid mesid:(NSString*)mesid index:(int)index
{
    NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.mes",m_path_mes,camid,mesid,index];
    return  filename;
}
-(BOOL)is_file_exist:(NSString*)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return[fileManager fileExistsAtPath:filename];
}
-(void)add_item:(NSString*)camid mesid:(NSString*)mesid index:(int)index with_type:(int)type
{
    if (mesid==nil) {
        return;
    }
    @synchronized(self){
        NSLog(@"m_mes_array.count===%d",m_mes_array.count);
        if (m_mes_array.count>=m_max_mes_num) {
            zx_message_cache_item* cur_item=[m_mes_array objectAtIndex:0];
            if (cur_item != nil) {
                [self delete_mes_file:cur_item.str_camid mesid:cur_item.str_mesid index:index];
                [m_mes_array removeObject:cur_item];
                //[m_pic_dictionary removeObjectForKey:cur_item.str_picid];
            }
        }
        zx_message_cache_item* cur_item = [zx_message_cache_item new];
        cur_item.str_mesid=mesid;
        cur_item.m_index=index;
        cur_item.m_mes_type=type;
        cur_item.str_camid=camid;
        //cur_item.str_picid=NSString stringWithFormat:@""
        [m_mes_array addObject:cur_item];
        //[m_pic_dictionary setObject:cur_item forKey:cur_item.str_picid];
        [self save_meslist_file];
    }
}


-(BOOL)save_to_file:(NSData*)data
{
    if (data==nil) {
        return false;
    }
    
    NSString* m_path= m_path_mes;
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
    NSString *filename=[NSString stringWithFormat:@"%@/%@.txt",m_path,@"meslist"];
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
-(void)save_meslist_file
{
    NSMutableArray *array_pics=[[NSMutableArray alloc]init];
    for (zx_message_cache_item* pic_item in m_mes_array){
        NSMutableDictionary* dic_pic = [[NSMutableDictionary alloc]init];
        [dic_pic setObject:pic_item.str_mesid forKey:@"mesid"];
        [dic_pic setObject:pic_item.str_camid forKey:@"camid"];
        [dic_pic setObject:[NSNumber numberWithInt:pic_item.m_index] forKey:@"index"];
        [dic_pic setObject:[NSNumber numberWithInt:pic_item.m_mes_type] forKey:@"mestype"];
        [array_pics addObject:dic_pic];
    }
    NSMutableDictionary* dic_pics = [[NSMutableDictionary alloc]init];
    [dic_pics setObject:array_pics forKey:@"mess"];
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
        [m_mes_array removeAllObjects];
        [m_mes_dictionary removeAllObjects];
        if ([g_pic_dictionary objectForKey:@"mess"]) {
            for (NSDictionary* pic_item in [g_pic_dictionary objectForKey:@"mess"]) {
                zx_message_cache_item* cur_item = [zx_message_cache_item new];
                cur_item.str_mesid=[pic_item objectForKey:@"mesid"];
                cur_item.str_camid=[pic_item objectForKey:@"camid"];
                cur_item.m_index=[[pic_item objectForKey:@"index"]intValue];
                [m_mes_array addObject:cur_item];
                //[m_pic_dictionary setObject:cur_item forKey:cur_item.str_picid];
            }
        }
    }
    return true;
}
- (void)read_meslist_file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"read_camlist_file: %@",documentsDirectory);
    NSString* m_path= [documentsDirectory stringByAppendingPathComponent:@"jws_mes_cache"];
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
    m_absulate_path_mes=ABSULATE_PATH_MES;
    m_path_mes = [documentsDirectory stringByAppendingPathComponent:m_absulate_path_mes];
    // NSLog(@"m_path_jpg: %@",m_path_jpg);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:m_path_mes])
    {
        BOOL res=[fileManager createDirectoryAtPath:m_path_mes withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            //NSLog(@"文件夹创建成功m_path_jpg");
        }
        else{
            //NSLog(@"文件夹创建失败 m_path_jpg");
        }
    }
    return true;
    
}
-(BOOL)save_mes_file:(NSData*)mesdata camid:(NSString*)camid mesid:(NSString*)mesid index:(int)index
{
    if (mesdata==nil || mesid==nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //camdid_20150126_113043_3.jpg
    NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.wav",m_path_mes,camid,mesid,index];
    //NSString *filename = [filepath stringByAppendingPathComponent:name];
    BOOL res=[fileManager createFileAtPath:filename contents:nil attributes:nil];
    if (res) {
        //NSLog(@"文件创建成功: %@" ,filename);
    }else{
        //NSLog(@"文件创建失败");
        return FALSE;
    }
    //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)]
    [mesdata writeToFile:filename atomically:YES];
    return true;
}
-(void)delete_mes_file:(NSString*)camid mesid:(NSString*)mesid index:(int)index
{
    if (mesid==nil) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //camdid_20150126_113043_3.jpg
    NSString *filename=[NSString stringWithFormat:@"%@/%@_%@_%d.wav",m_path_mes,camid,mesid,index];
    [fileManager removeItemAtPath:filename error:nil];
    NSLog(@"delete===%@",filename);
}

@end
