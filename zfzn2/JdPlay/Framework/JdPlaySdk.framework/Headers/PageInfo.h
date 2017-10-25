//
//  PageInfo.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/16.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdBaseModel.h"

@interface PageInfo : JdBaseModel

@property (nonatomic) NSInteger pageIndex;
@property  (nonatomic) NSInteger pageSize;
@property  (nonatomic) BOOL availablePage;

@end
