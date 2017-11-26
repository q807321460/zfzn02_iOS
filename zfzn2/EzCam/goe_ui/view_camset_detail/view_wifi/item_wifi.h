//
//  item_wifi.h
//  ppview_zx
//
//  Created by zxy on 15-3-5.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface item_wifi : NSObject
@property (retain) NSString* m_wifi_name;
@property (assign) int m_pass;  //是否密码
@property (assign) int m_signal;//信号强度
@end
