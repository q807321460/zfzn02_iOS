//
//  wired_net_info.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-6-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wired_net_info : NSObject
@property (retain) NSString* token;//网卡标记
@property (assign) int ip_type;//1:静态  2：dhcp
@property (retain) NSString* ip;
@property (retain) NSString* mask;
@property (retain) NSString* gate;
@property (assign) int dns_type;
@property (retain) NSString* dns1;
@property (retain) NSString* dns2;
@end
