//
//  JDPlayListModel.h
//  JdPlayOpenSDK
//
//  Created by 沐阳 on 16/5/24.
//  Copyright © 2016年 x-focus. All rights reserved.
//

#import "JdBaseModel.h"

@interface JdPlayListModel : JdBaseModel

@property (nonatomic,assign) int  bind_key;
@property (nonatomic,copy) NSString * ext1;
@property (nonatomic,copy) NSString * md5;
@property (nonatomic,assign) int  pos;
@property (nonatomic,copy) NSString * song_list_id;
@property (nonatomic,copy) NSString * song_list_name;
@property (nonatomic,copy) NSString * song_list_type;


@property (nonatomic,strong) NSMutableArray * songsArr;

+(instancetype)playListModelWithDictionary:(NSDictionary *)dictionary;

@end
