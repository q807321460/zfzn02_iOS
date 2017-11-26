//
//  event_asynimage.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppview_cli.h"
#import "pic_file_manager.h"
@interface event_asynimage : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *loadData;
    ppview_cli* Http;
    NSData* picdata;
    NSString* m_path;
    NSString* m_absulate_path;
}

//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;

//请求网络图片的id
@property (nonatomic, retain) NSString *eventID;
@property (retain) NSString *svr_url;

-(void)set_id:(NSString*)event_id;
@end
