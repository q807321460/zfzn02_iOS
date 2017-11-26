//
//  stream_item.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-4-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stream_item : NSObject{
    
}
@property (assign) int stream_id;
@property (assign) int width;
@property (assign) int height;
@property (assign) int frame_rate;
@property (assign) float m_fish_left;
@property (assign) float m_fish_right;
@property (assign) float m_fish_top;
@property (assign) float m_fish_bottom;

@property (retain) NSString* stream_url;
@end
