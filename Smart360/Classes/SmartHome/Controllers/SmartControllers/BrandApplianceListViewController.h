//
//  BrandApplianceListViewController.h
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"

@interface BrandApplianceListViewController : JSBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *applianceArray;

@property (nonatomic) int brandID;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, copy) NSString *roomID;

@end
