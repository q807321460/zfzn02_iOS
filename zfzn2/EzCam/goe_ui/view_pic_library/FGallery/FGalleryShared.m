//
//  FGalleryShared.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "FGalleryShared.h"

@implementation FGalleryShared
@synthesize bThumbViewShowing;
@synthesize nDefaultIndex;
static FGalleryShared* instance = nil;

-(id)init
{
    self=[super init];
    bThumbViewShowing=false;
    nDefaultIndex=0;
    return self;
}

+(FGalleryShared*)getInstance
{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}
@end
