//
//  FGalleryShared.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGalleryShared : NSObject
+(FGalleryShared*)getInstance;
@property (assign) BOOL bThumbViewShowing;
@property (assign) int nDefaultIndex;
@end
