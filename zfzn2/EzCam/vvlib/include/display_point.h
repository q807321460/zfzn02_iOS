//
//  display_point.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-7-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLAYMODE_BALL 0
#define PLAYMODE_BOWL 1
#define PLAYMODE_CYLINDER 2
#define PLAYMODE_PLANE 3

@interface display_point : NSObject
@property (assign) float point0_x;
@property (assign) float point0_y;
@property (assign) float point1_x;
@property (assign) float point1_y;
@property (assign) float point2_x;
@property (assign) float point2_y;
@property (assign) float point3_x;
@property (assign) float point3_y;
@end
