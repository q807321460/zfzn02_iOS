//
//  JdCategoryModel.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdBaseModel.h"

@interface JdCategoryModel : JdBaseModel

@property (nonatomic,copy) NSString * name;
@property (nonatomic,assign) int nextlevel;
@property (nonatomic,assign) int nextType;
@property (nonatomic,assign) int songListType;
@property (nonatomic,assign) BOOL showIndexNum;
@property (nonatomic,copy) NSString * imagePath;
@property (nonatomic,strong) id ext1;
@property (nonatomic,copy) NSString * groupID;
@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,copy) NSString * id;


+(JdCategoryModel *)categoryWithDictionary:(NSDictionary *)dic;
+(NSDictionary *)categoryModelToDict:(JdCategoryModel *)model;

@end
