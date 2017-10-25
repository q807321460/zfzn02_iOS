//
//  JSWebViewController.h
//  Smart360
//
//  Created by sun on 15/9/28.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseViewController.h"

@interface JSWebViewController : JSBaseViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *enterType;
@property (nonatomic, assign) BOOL isHandleURL;

@end
