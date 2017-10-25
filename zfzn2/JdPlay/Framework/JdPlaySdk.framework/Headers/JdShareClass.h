//
//  JDShareClass.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/25.
//  Copyright © 2016年 x-focus. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "JdPlayListModel.h"
#import "JdPayloadInfo.h"
#import "JdSongsModel.h"
#import "JdDeviceInfo.h"

@interface JdShareClass : NSObject

@property (nonatomic,copy) NSString * mPlayListJson;

/**
 *  当前播放模式 0：顺序播放 1：单曲循环 2：随机播放
 */
@property(nonatomic)int playOrder;
/**
 *  播放状态
 */
@property (nonatomic) BOOL playState;
/**
 *  标志当前设备id
 */
@property (nonatomic,copy) NSString * currentDeviceID;

/**
 *  当前选中设备
 */
@property (nonatomic,strong) JdDeviceInfo * deviceInfo;
/**
 *  播放列表模型
 */
@property (nonatomic,strong) JdPlayListModel * playListModel;
/**
 *  当前播放的歌曲id
 */
@property (nonatomic,copy) NSString * currentPlaySongId;
/**
 *  当前播放音量
 */
@property (nonatomic,assign) int volume;
/**
 *  当期歌曲播放总时间
 */
@property (nonatomic,assign) int totalTime;
/**
 *  当前播放的歌曲在播放列表中的位置
 */
@property (nonatomic,assign) int  position;
/**
 *  播放详情
 */
@property (nonatomic,strong) JdPayloadInfo * payloadInfo;
/**
 *  歌曲详情
 */
@property (nonatomic,strong) JdSongInfo * songInfo;

+(JdShareClass *)sharedInstance;


@end
