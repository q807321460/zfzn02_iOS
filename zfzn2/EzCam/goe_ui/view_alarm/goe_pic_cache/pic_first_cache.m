//
//  pic_first_cache.m
//  P2PONVIF_PRO
//
//  Created by goe209 on 14-4-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "pic_first_cache.h"

@implementation pic_first_cache
static pic_first_cache* instance;

-(id)init{
    self = [super init];
    g_pic_cache = [NSMutableDictionary dictionary];
    max_num=10;
    myLock = [NSLock new];
    return self;
}
+ (pic_first_cache*) getInstance{
    if(instance==nil){
        instance = [[pic_first_cache alloc] init ];
    }
    return instance;
}
- (void) setCacheNum:(int)num{
    max_num=num;
}
- (BOOL) addItem:(NSString*)picid picdata:(NSData*)data{
    if (picid==nil || data==nil) {
        return true;
    }
    [myLock lock];
    [g_pic_cache setObject:data forKey:picid];
    [myLock unlock];
    return true;
}
- (NSData*) getItem:(NSString*)picid{
    NSData* curdata=[g_pic_cache objectForKey:picid];
    return curdata;
}
-(void)clean
{
    [myLock lock];
    [g_pic_cache removeAllObjects];
    [myLock unlock];
}
@end
