//
//  JDPayloadInfo.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/21.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdBaseModel.h"
#import "JdSongInfo.h"

@interface JdPayloadInfo : JdBaseModel

@property (nonatomic,assign) int  duration;
@property (nonatomic,strong) JdSongInfo * songInfo;
@property (nonatomic,copy) NSString * playmode;
@property (nonatomic,assign) int  playstate;
@property (nonatomic,assign) int  position;
@property (nonatomic,assign) int  volume;

+(instancetype)payLoadInfoWithDictionary:(NSDictionary *)dictionary;


@end
