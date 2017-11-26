//
//  wired_net_info.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-6-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "wired_net_info.h"

@implementation wired_net_info
@synthesize  token;//网卡标记
@synthesize ip_type;//1:静态  2：dhcp
@synthesize ip;
@synthesize mask;
@synthesize gate;
@synthesize dns_type;
@synthesize dns1;
@synthesize dns2;
@end
