//
//  MatchResultModel.h
//  Smart360
//
//  Created by michael on 15/12/28.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MatchInfoModel.h"


@interface MatchResultModel : NSObject

@property (nonatomic) BOOL isCurrentSucc;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) MatchInfoModel *matchInfoModel;

@end
