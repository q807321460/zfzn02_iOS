//
//  JdCategoryBaseViewController.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/15.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewCell.h"
#import "CHLoadingView.h"
#import <JdPlaySdk/JdPlaySdk.h>

@interface JdCategoryBaseViewController : UIViewController

{
    JdMusicSourcePresenter * mPresenter;
    CHLoadingView * loadView;
    int _isSongLast;  //标志最后一级目录歌单类型是否是song  = 0不是 =1是 =2 不是最后一级目录
}

@property (nonatomic,strong) JdCategoryModel * model;
@property (nonatomic,strong) NSMutableArray * dataArr;


@property (strong, nonatomic)  UIButton * backBtn;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UILabel *titleL;
@property (strong, nonatomic)  UIView * topView;

//对外接口
- (void)refreshTableCell:(CategoryTableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath;
-(void)tableCellSelectedWithIndexPath:(NSIndexPath *)indexPath;
- (void)backBtnClick:(UIButton *)sender;

@end
