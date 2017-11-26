//
//  pic_file_item.h
//  ppview_zx
//
//  Created by zxy on 15-1-28.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pic_file_item : NSObject
@property (retain, nonatomic) NSString* m_eventid;
@property (retain, nonatomic) NSString* m_camid;
@property (retain, nonatomic) NSString* m_file_path;
@property (assign) long h_connector;
@property (assign) int m_index;
@property (assign) int m_type;
@property (assign) BOOL b_exist;
@end
