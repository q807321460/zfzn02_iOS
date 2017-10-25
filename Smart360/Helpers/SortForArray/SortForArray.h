//
//  SortForArray.h
//  Smart360
//
//  Created by sun on 15/12/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortForArray : NSObject

- (instancetype)initWithDataArray:(NSArray *)dataArray;

@property (nonatomic, strong) NSDictionary *resultDataDic;
@property (nonatomic, strong) NSArray *resultKeysArray;
//- (NSDictionary *)fetchResultDic;
//- (NSArray *)fetchKeysArray;

@end
