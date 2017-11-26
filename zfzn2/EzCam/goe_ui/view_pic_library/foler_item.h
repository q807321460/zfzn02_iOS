//
//  foler_item.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface foler_item : NSObject
@property (retain) NSString* m_absolute_name;
@property (retain) NSString* m_full_name;
@property (retain) NSString* m_full_thumbil_name;
@property (assign) int m_file_type;//0=folder 1=jpg  2=video
@property (assign) int pos;
@property (assign) BOOL b_selected;
@end
