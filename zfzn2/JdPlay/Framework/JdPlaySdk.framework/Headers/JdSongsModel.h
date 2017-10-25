//
//  JDSongsModel.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/24.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdBaseModel.h"

@interface JdSongsModel : JdBaseModel

@property (nonatomic,copy) NSString * album_id;
@property (nonatomic,assign) int islocal;
@property (nonatomic,copy) NSString * pic_url;
@property (nonatomic,copy) NSString * singers;
@property (nonatomic,copy) NSString * song_id;
@property (nonatomic,copy) NSString * song_name;
@property (nonatomic,copy) NSString * song_url;
@property (nonatomic,assign) int  source;

+(instancetype)songsModelWithDictionary:(NSDictionary *)dictionary;

@end
