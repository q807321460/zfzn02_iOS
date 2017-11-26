//
//  wifi_manager.m
//  ppview_zx
//
//  Created by zxy on 15-3-5.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "wifi_manager.h"

@implementation wifi_manager
static wifi_manager* instance;

-(id)init{
    self = [super init];
    
    m_wifi_array= [NSMutableArray new];
    cur_wifi_name=@"";
    cur_wifi_pass=0;  //是否密码
    cur_wifi_signal=0;//信号强度
    return self;
}


+(wifi_manager*) getInstance{
    if(instance==nil){
        instance = [[wifi_manager alloc] init ];
    }
    return instance;
}
-(void)clean
{
    @synchronized(self){
        [m_wifi_array removeAllObjects];
        cur_wifi_name=@"";
        cur_wifi_pass=0;
        cur_wifi_signal=0;
    }
}
-(BOOL)setJsonData:(NSData*)wifidata type:(int)type
{
    if (wifidata==NULL) {
        return false;
    }
    @synchronized(self){
        NSError* reserr;
        NSMutableDictionary* share_dictionary = [NSJSONSerialization JSONObjectWithData:wifidata options:NSJSONReadingMutableContainers error:&reserr];
        if (share_dictionary==nil) {
            return false;
        }
        //NSLog(@"wiflist=%@",share_dictionary);
        [m_wifi_array removeAllObjects];
        
        if ([share_dictionary objectForKey:@"wifi_list"]) {
            for (NSDictionary* item_dic in [share_dictionary objectForKey:@"wifi_list"])
            {
                if (type==0) {
                    int isConn=[[item_dic objectForKey:@"is_conn"]intValue];
                    if (isConn==1) {
                        cur_wifi_name=[item_dic objectForKey:@"ssid"];
                        cur_wifi_pass=[[item_dic objectForKey:@"is_secu"]intValue];
                        cur_wifi_signal=[[item_dic objectForKey:@"signel"]intValue]/25;
                    }
                    else{
                        item_wifi* cur_item= [item_wifi alloc];
                        cur_item.m_wifi_name=[item_dic objectForKey:@"ssid"];
                        //cur_item.m_wifi_name= [cur_item.m_wifi_name stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
                        cur_item.m_pass=[[item_dic objectForKey:@"is_secu"]intValue];
                        cur_item.m_signal=[[item_dic objectForKey:@"signel"]intValue]/25;
                        [m_wifi_array addObject:cur_item];
                    }
                }
                else{
                    item_wifi* cur_item= [item_wifi alloc];
                    cur_item.m_wifi_name=[item_dic objectForKey:@"ssid"];
                    //cur_item.m_wifi_name= [cur_item.m_wifi_name stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
                    cur_item.m_pass=[[item_dic objectForKey:@"is_secu"]intValue];
                    cur_item.m_signal=[[item_dic objectForKey:@"signel"]intValue]/25;
                    [m_wifi_array addObject:cur_item];
                }
               
            }
            NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"m_signal" ascending:NO];
            [m_wifi_array sortUsingDescriptors:[NSArray arrayWithObject:sortByA]];
        }
        return true;
    }

}
-(int)getCount
{
    return m_wifi_array.count;
}
-(item_wifi*)getItem:(int)position
{
    return [m_wifi_array objectAtIndex:position];
}
-(item_wifi*)getItemByID:(NSString*)itemid
{
    for (item_wifi* cur_item in m_wifi_array)
    {
        if ([cur_item.m_wifi_name isEqualToString:itemid]==true) {
            return cur_item;
        }
    }
    return nil;
}
-(NSString*)cur_wifi_name
{
    return cur_wifi_name;
}
-(int)cur_wifi_pass
{
    return cur_wifi_pass;
}
-(int)cur_wifi_signal
{
    return cur_wifi_signal;
}
@end
