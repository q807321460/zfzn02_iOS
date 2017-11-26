//
//  AsynImageView.h
//  AsynImage
//
//  Created by administrator on 13-3-5.
//  Copyright (c) 2013年 enuola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "pic_file_manager.h"
@interface AsynImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *loadData;
    ppview_cli* Http;
    //pic_first_cache *gPicCache;
    NSData* picdata;
    NSString* m_path;
    NSString* m_absulate_path;
}
//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;

//请求网络图片的id
@property (nonatomic, retain) NSString *camID;
@property (retain) NSString *svr_url;

-(void)set_id:(NSString*)cam_id with_picid:(NSString*)pic_id;
@end
