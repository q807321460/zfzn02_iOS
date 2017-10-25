//
//  MyWifi.m
//  zfzn
//
//  Created by Hanwen Kong on 16/9/16.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

#import "MyWifi.h"
#import "getgateway.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/socket.h>
#import <SystemConfiguration/CaptiveNetwork.h>
//#import "zfzn-swift.h"

@implementation MyWifi
//+ (NSString *)getWifiName
//{
//    NSString *wifiName = nil;
//    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
//    if (!wifiInterfaces) {
//        return nil;
//    }
//    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
//    for (NSString *interfaceName in interfaces) {
//        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
//        if (dictRef) {
//            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
//            NSLog(@"network info -> %@", networkInfo);
//            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
//            CFRelease(dictRef);
//        }
//    }
//    CFRelease(wifiInterfaces);
//    return wifiName;
//}

#pragma mark - 获取路由器地址
+ (NSString *) routerIp {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        /*/
         int i=255;
         while((i--)>0)
         //*/
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    //routerIP----192.168.1.255 广播地址
//                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
//                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
//                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
//                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    
    
    in_addr_t i =inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x =&i;
    
    
    unsigned char *s=getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],255];//s[3]
    free(s);
    return ip;
}

@end

