//
//  pic_file_manager.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface pic_file_manager : NSObject
{
    NSString* m_path_jpg;
    NSString* m_absulate_path_jpg;
    NSString* m_path_png;
    NSString* m_path_png_local;
    NSString* m_absulate_path_png;
    
    NSString* m_path_png_tmp;
    NSString* m_absulate_path_png_tmp;
    
    NSString* m_path_png_preset;
    NSString* m_absulate_path_png_preset;
    
    NSString* m_path_event;
    NSString* m_absulate_path_event;
    
    BOOL bInit;
    
}
+(pic_file_manager*)getInstance;
-(BOOL)init_file_path;
-(NSString*)get_file_path;
-(NSString*)get_png_file_path;
-(NSString*)get_png_file_path_local;
-(NSString*)get_tmp_png_file_path;
-(NSString*)get_file_path_preset;

-(BOOL)save_jpg_file:(NSData*)jpgdata with_date:(NSString*)date with_name:(NSString*)name;
-(BOOL)save_png_file:(NSData*)jpgdata with_name:(NSString*)name;
-(BOOL)save_png_file_local:(NSData*)jpgdata with_name:(NSString*)name;
-(BOOL)save_img_file:(UIImage*)image with_name:(NSString*)name;
-(BOOL)save_img_file_preset:(UIImage*)image with_camid:(NSString*)camid with_pos:(int)pos;
-(BOOL)save_event_file:(NSData*)jpgdata with_name:(NSString*)name;

-(BOOL)save_tmp_png_file:(NSData*)jpgdata with_name:(NSString*)name;
-(void)delete_folder:(NSString*)path;
-(void)delete_tmp_img_folder;

-(NSString*)get_jpg_filename:(NSString*)date with_name:(NSString*)name;
-(NSString*)get_filename_video:(BOOL)isFish fishtag:(NSString*)fishtag;
-(NSString*)get_cam_thumbil_filename:(NSString*)camid;

-(BOOL)is_event_file_exist:(NSString*)filename_event;
-(NSString*)get_event_filepath:(NSString*)filename;

-(BOOL)save_img_file_ad:(NSData*)jpgdata;
-(NSString*)get_img_file_ad;
@end
