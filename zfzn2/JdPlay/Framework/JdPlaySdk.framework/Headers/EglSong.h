//
//  EglSong.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/14.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JdBaseModel.h"

@interface EglSong : JdBaseModel

@property (nonatomic,copy) NSString * albumId;
@property (nonatomic,copy) NSString * albumName;
@property (nonatomic,copy) NSString * imgPath;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * path;
@property (nonatomic,copy) NSString * singer;
@property (nonatomic,copy) NSString * songId;
@property (nonatomic,assign) int isDownloaded;
@property (nonatomic,assign) int  isLocal;
@property (nonatomic,assign) int  isPlayed;
@property (nonatomic,assign) int  sourceType;
@property (nonatomic,strong) id  ext1;


+(EglSong *)songWithDict:(NSDictionary *)dict;


@end
