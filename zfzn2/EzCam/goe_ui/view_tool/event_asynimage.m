//
//  event_asynimage.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "event_asynimage.h"
#import <QuartzCore/QuartzCore.h>

@implementation event_asynimage

@synthesize eventID;
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
    if (self.image!=nil) {
        pic_file_manager* m_file_manager=[pic_file_manager getInstance];
        [m_file_manager save_tmp_png_file:data with_name:eventID];
    }
}

-(void)SendData{
    
    NSData* returnData=[Http cli_lib_GetEventThumbnail:nil eventid:eventID];
    if (returnData != nil) {
        picdata=returnData;
        [self performSelectorOnMainThread:@selector(ShowPic:) withObject:returnData waitUntilDone:YES];
    }
    
}
-(void)loadImageByEventID
{
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        //self.image=[UIImage imageNamed:@"png_carempic.png"];
        [NSThread detachNewThreadSelector:@selector(SendData) toTarget:self withObject:nil];
        
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}
-(void)set_id:(NSString*)event_id
{
    //NSLog(@"set_id,  event_id=%@",event_id);
    if (event_id==nil || event_id.length<=0) {
        return;
    }
    self.image = _placeholderImage; 
    if(eventID != event_id)
    {
        //self.image = _placeholderImage;    //指定默认图片
        eventID = event_id;
    }
    
    if(eventID)
    {
        pic_file_manager* m_file_manager=[pic_file_manager getInstance];
        NSString* file_path=[m_file_manager get_tmp_png_file_path];
        NSString* file_name=[NSString stringWithFormat:@"%@/%@.jpg", file_path, eventID];
        if([[NSFileManager defaultManager] fileExistsAtPath:file_name])
        {
            //NSLog(@"imageWithContentsOfFile....%@",eventID);
            UIImage *tmp_image=[UIImage imageWithContentsOfFile:file_name];
            if (tmp_image != nil) {
                self.image = [UIImage imageWithContentsOfFile:file_name];
            }
            
        }
        else
        {
            //NSLog(@"loadImageByImageID....%@",event_id );
            Http= [ppview_cli getInstance];
            svr_url= [Http getCliAddr];
            [self loadImageByEventID];
        }
    }
    
}

@end
