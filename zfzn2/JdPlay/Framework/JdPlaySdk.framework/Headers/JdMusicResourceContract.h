//
//  JdMusicSourceContract.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JdCategoryModel.h"

@protocol MusicResourceView <NSObject>


/**
 请求音乐源成功的回调

 @param infos 资源数组
 @param last  是否是最后一级目录
 @param loadMore 是否加载更多
 */
- (void)setMusicResource:(NSMutableArray *)infos isLast:(BOOL)last loadMore:(BOOL)loadMore;

/**
 请求音乐源失败的回调
 
 @param erroCode 错误Code
 @param errMsg  错误消息
 */
- (void)onGetMusicResourceFail:(int)erroCode errMsg:(NSString *)errMsg;

@end

@protocol MusicResourcePresenter <NSObject>


/**
 根据model，获取音乐源
 @param model 音乐源种类模型
 */
- (void)getMusicResource:(JdCategoryModel *)model;


/**
 播放歌曲
 @param songs 歌曲数组
 @param pos 当前播放歌曲在数组中的下标
 */
- (void)playWithEglSongs:(NSArray *)songs pos:(int)pos;


/**
 播放歌曲

 @param model 分类模型
 */
- (void)playWithCategory:(JdCategoryModel *)model;


/**
 加载更多音乐源
 */
- (void)getMusicResourceMore;


@end

@interface JdMusicResourceContract : NSObject



@end
