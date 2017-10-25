//
//  JdPlayControlPresenter.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/9/18.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JdPlayControlContract.h"

@protocol PlayCtrlDelegate <NSObject>

- (void)onCurrentPlaySongChange:(NSString *)title;

- (void)onCurrentPlayStatusChange:(BOOL)state;

@end

@interface JdPlayControlPresenter : NSObject<PlayCtrlPresenter>

@property (nonatomic,weak) id<PlayCtrlView>delegate;
@property (nonatomic,weak) id<PlayCtrlDelegate> ctrlDelgate;


/**
    初始化
 */
+(instancetype)sharedManager;

/**
 *  媒体类信息的回调
 *  @param payLoadInfoStr 详细信息
 */
-(void)getCurrentPlayInfoWithType:(int)type action:(int)action payload:(char *)payLoadInfoStr;


@end
