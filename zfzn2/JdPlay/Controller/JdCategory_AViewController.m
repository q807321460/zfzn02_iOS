//
//  JdCategory_AViewController.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdCategory_AViewController.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "JdCategory_BViewController.h"
#import "JdPlayCtrlBottomView.h"


@interface JdCategory_AViewController ()
{
    JdPlayCtrlBottomView* bview;
}
@end

@implementation JdCategory_AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"分类";
    bview = [JdPlayCtrlBottomView sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bview.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}





- (void)backBtnClick:(UIButton *)sender
{
    [super backBtnClick:sender];
    bview.hidden = YES;
}




- (void)refreshTableCell:(CategoryTableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    JdCategoryModel * model = self.dataArr[indexPath.row];
    [cell refreshDataWithModel:model];
}


-(void)tableCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    JdCategory_BViewController * vc = [[JdCategory_BViewController alloc] init];
    JdCategoryModel * model = self.dataArr[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
   
}


@end
