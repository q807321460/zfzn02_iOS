//
//  JdPushPlayListManager.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/14.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JdCategoryModel.h"

@interface JdPushPlayListManager : NSObject

+(JdPushPlayListManager *)sharedInstance;

- (void)pushDouBanListWithCategory:(JdCategoryModel *)model;

-(void)pushPlayListWithInfos:(NSArray *)models withIndex:(int)index;

@end
