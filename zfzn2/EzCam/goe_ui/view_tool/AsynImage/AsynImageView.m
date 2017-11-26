//
//  AsynImageView.m
//  AsynImage
//
//  Created by administrator on 13-3-5.
//  Copyright (c) 2013年 enuola. All rights reserved.
//

#import "AsynImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AsynImageView

@synthesize camID;
@synthesize placeholderImage = _placeholderImage;
@synthesize svr_url;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 2.0;
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

//重写placeholderImage的Setter方法
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if(placeholderImage != _placeholderImage)
    {
        _placeholderImage =nil;
        
        _placeholderImage = placeholderImage;
        self.image = _placeholderImage;    //指定默认图片
    }
}


-(void)ShowPic:(NSData*)data{
    
    self.image=[UIImage imageWithData:data];
    if (self.image != nil) {
        //[gPicCache addItem:camID picdata:data];
        pic_file_manager* m_file_manager=[pic_file_manager getInstance];
        [m_file_manager save_png_file:data with_name:camID];
    }
}
-(void)SendData{
    
    NSData* returnData=[Http cli_lib_GetCamThumbnail:camID];
    if (returnData != nil) {
        picdata=returnData;
        [self performSelectorOnMainThread:@selector(ShowPic:) withObject:returnData waitUntilDone:YES];
    }
}
-(void)loadImageByCamID
{
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        [NSThread detachNewThreadSelector:@selector(SendData) toTarget:self withObject:nil];
       
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}
-(void)set_id:(NSString*)cam_id with_picid:(NSString*)pic_id
{
    //NSLog(@"set_id,  cam_id=%@,   pic_id=%@",cam_id,pic_id);
    
    if(camID != cam_id)
    {
        self.image = _placeholderImage;    //指定默认图片
        camID = cam_id;
    }
    
    if(camID)
    {
        //NSLog(@"set_id----2");
        pic_file_manager* m_file_manager=[pic_file_manager getInstance];
        NSString* file_path=[m_file_manager get_png_file_path];
        NSString* file_name=[NSString stringWithFormat:@"%@/%@.jpg", file_path, camID];
        if([[NSFileManager defaultManager] fileExistsAtPath:file_name])
        {
            //NSLog(@"imageWithContentsOfFile....%@",cam_id);
            self.image = [UIImage imageWithContentsOfFile:file_name];
        }
        else
        {
            if (pic_id==nil || pic_id.length<=0) {
                return;
            }
            //NSLog(@"loadImageByImageID....%@",cam_id );
            Http= [ppview_cli getInstance];
            svr_url= [Http getCliAddr];
            //gPicCache= [pic_first_cache getInstance];
            [self loadImageByCamID];
        }
    }
}


@end
