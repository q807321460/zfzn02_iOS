//
//  wifi_manager.h
//  ppview_zx
//
//  Created by zxy on 15-3-5.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "item_wifi.h"
@interface wifi_manager : NSObject
{
    NSMutableArray* m_wifi_array;
    NSString* cur_wifi_name;
    int cur_wifi_pass;  //是否密码
    int cur_wifi_signal;//信号强度
}
+(wifi_manager*) getInstance;
-(BOOL)setJsonData:(NSData*)wifidata type:(int)type;
-(void)clean;
-(int)getCount;
-(item_wifi*)getItem:(int)position;
-(item_wifi*)getItemByID:(NSString*)itemid;
-(NSString*)cur_wifi_name;
-(int)cur_wifi_pass;
-(int)cur_wifi_signal;
@end
