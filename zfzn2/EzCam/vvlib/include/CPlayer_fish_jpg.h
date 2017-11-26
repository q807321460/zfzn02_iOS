//
//  CPlayer_fish_jpg.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPlayer_fish_jpg : NSObject

-(id)init:(int)playindex;
-(void)set_surfaceview:(UIView*)view;
-(int)start_play:(NSString*)filename top:(float)top bottom:(float)bottom left:(float)left right:(float)right fisheyetype:(int)fisheyetype;
-(void)stop_play;

@end
