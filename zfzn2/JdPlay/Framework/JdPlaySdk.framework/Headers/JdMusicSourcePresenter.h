//
//  JdMusicSourcePresenter.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JdMusicResourceContract.h"

@interface JdMusicSourcePresenter : NSObject<MusicResourcePresenter>


@property (nonatomic,weak) id<MusicResourceView>delegate;



/**
 初始化
 */
+(instancetype)sharedManager;


/**
 设备端信息回调

 @param type  
 @param action <#action description#>
 @param payLoad <#payLoad description#>
 */
-(void)getDeviceBackInfoWithType:(int)type action:(int)action payload:(char *)payLoad;


/**
 向设备端发送命令

 @param action 命令
 @param args 命令参数
 */
- (void)sendCommendWithAction:(int)action args:(NSString *)args;



@end
