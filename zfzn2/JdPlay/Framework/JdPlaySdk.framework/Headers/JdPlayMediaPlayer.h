//
//  JdPlayMediaPlayer.h
//  JdPlayOpenSDK
//
//  Created by lys on 16/5/19.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#ifndef JdPlayMediaPlayer_h
#define JdPlayMediaPlayer_h


int publishMedia(char* targetId, char* topic, int action, char* payload, int compress);


/**
 *  播放播放列表中某位置歌曲
 *
 *  @param position 位置
 */
void JdPlayMediaPlayer_setDatasourceIndex(int position) ;


void JdPlayMediaPlayer_setDatasource(char* v);


/**
 *  播放
 */
void JdPlayMediaPlayer_play() ;

/**
 *  暂停
 */
void JdPlayMediaPlayer_pause() ;

/**
 *  下一曲
 */
void JdPlayMediaPlayer_next() ;

/**
 *  上一曲
 */
void JdPlayMediaPlayer_prev() ;

/**
 *  跳播
 *
 *  @param ms <#ms description#>
 */
void JdPlayMediaPlayer_seek(int ms) ;

/**
 *  获取播放状态
 *
 *  @param v <#v description#>
 */
void JdPlayMediaPlayer_getMediaStates(char* v);

/**
 *  获取歌单列表
 *
 *  @param v <#v description#>
 */
void JdPlayMediaPlayer_getPlaylist(char* v);

/**
 *  设置播放模式
 *
 *  @param mode <#mode description#>
 */
void JdPlayMediaPlayer_setPlayMode(char* mode);

/**
 *  设置媒体音量
 *
 *  @param volume <#volume description#>
 */
void JdPlayMediaPlayer_setVolume(int volume);

#endif /* JdPlayMediaPlayer_h */
