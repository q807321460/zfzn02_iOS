//
//  JDSongInfo.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/21.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdBaseModel.h"

@interface JdSongInfo : JdBaseModel

@property (nonatomic,copy) NSString * albumurl;
@property (nonatomic,copy) NSString * creator;
@property (nonatomic,copy) NSString * songID;
@property (nonatomic,copy) NSString * mime;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * uri;


+(instancetype)songInfoWithDictionary:(NSDictionary *)dictionary;


@end
