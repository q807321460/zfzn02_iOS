//
//  pic_first_cache.h
//  P2PONVIF_PRO
//
//  Created by goe209 on 14-4-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pic_first_cache : NSObject{
    NSMutableDictionary *g_pic_cache;
    int max_num;
    NSLock* myLock;
}
+ (pic_first_cache*) getInstance;
- (void) setCacheNum:(int)num;
-(BOOL) addItem:(NSString*)picid picdata:(NSData*)data;
- (NSData*) getItem:(NSString*)picid;
-(void)clean;
@end
