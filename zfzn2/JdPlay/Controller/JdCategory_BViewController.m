//
//  JdCategory_BViewController.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/14.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdCategory_BViewController.h"
#import "JdCategory_CViewController.h"
#import "JdMusicPlayViewController.h"

@interface JdCategory_BViewController ()


@end

@implementation JdCategory_BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (void)refreshTableCell:(CategoryTableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    JdCategoryModel * model = self.dataArr[indexPath.row];
    
    [cell refreshDataWithModel:model];
}


-(void)tableCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    JdCategoryModel * model = self.dataArr[indexPath.row];
    
    if (_isSongLast == 0) {
        
        [mPresenter playWithCategory:model];
        
        JdMusicPlayViewController * vc = [[JdMusicPlayViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        JdCategory_CViewController * vc = [[JdCategory_CViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}



@end
