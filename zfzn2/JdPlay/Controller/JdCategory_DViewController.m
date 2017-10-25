//
//  JdCategory_DViewController.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/14.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdCategory_DViewController.h"
#import "JdMusicPlayViewController.h"


@interface JdCategory_DViewController ()


@end

@implementation JdCategory_DViewController

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
    if (_isSongLast == 1) {
        
        EglSong * song = self.dataArr[indexPath.row];
        
        [cell refrehDataWithSong:song];
    
    }else{
        
        JdCategoryModel * model = self.dataArr[indexPath.row];
        [cell refreshDataWithModel:model];
    }
    
}


-(void)tableCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    if (_isSongLast == 1) {
        
        [mPresenter playWithEglSongs:self.dataArr pos:(int)indexPath.row];
        JdMusicPlayViewController * vc = [[JdMusicPlayViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }

}


@end
