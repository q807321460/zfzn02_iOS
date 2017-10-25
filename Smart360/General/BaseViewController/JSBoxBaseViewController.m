//
//  JSBoxBaseViewController.m
//  Smart360
//
//  Created by michael on 15/12/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBoxBaseViewController.h"


@interface JSBoxBaseViewController ()

@end

@implementation JSBoxBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
