//
//  JdCategoryBaseViewController.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/15.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdCategoryBaseViewController.h"
#import "JdMusicPlayViewController.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "MJRefresh.h"
#import "UIView+Frame.h"
#import "TopAlertView.h"
#import "JdFailTipView.h"


@interface JdCategoryBaseViewController ()<UITableViewDelegate,UITableViewDataSource,MusicResourceView>
{
    JdFailTipView * tipView;
}
@end

@implementation JdCategoryBaseViewController


#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mPresenter = [JdMusicSourcePresenter sharedManager];
    [self createUI];
    [self createDataSource];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mPresenter.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
        tb.delegate = self;
        tb.dataSource = self;
        tb.tableFooterView = [[UIView alloc] init];
        [tb registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView = tb;
    }
    
    return _tableView;
}

//向左的button返回按钮
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"album_back_nol"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}

-(UILabel *)titleL {
    if (_titleL == nil) {
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        l.centerX = self.view.centerX;
        l.centerY = 40;
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        _titleL = l;
    }
    
    return _titleL;
}


-(UIView *)topView {
    if (_topView == nil) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        view.backgroundColor = [UIColor colorWithRed:139/255.0 green:39/255.0 blue:114/255.0 alpha:1];//紫色，和主色搭配
        _topView = view;
    }
    
    return _topView;
}




-(NSMutableArray *)dataArr{
    
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


#pragma mark -    

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.titleL];
    
    self.titleL.text = self.model.name;
    
}


- (void)createDataSource {
    
    int isOnline = 0;
    JdShareClass * shareObj = [JdShareClass sharedInstance];
    if (shareObj.deviceInfo) {
        isOnline = shareObj.deviceInfo.onlineStatus;
        if (!isOnline) {
            [TopAlertView showWithType:TopAlertTypeTip text:@"设备离线，请选择在线设备!" parentView:self.view];
            return;
        }
    }
    
    loadView = [CHLoadingView showWithView:self.view];
   [mPresenter getMusicResource:self.model];
}


- (void)showFailAlertWithStr:(NSString *)str {
    
    __weak JdCategoryBaseViewController * weakSelf = self;
    
    tipView = [JdFailTipView viewWithParentView:self.view tip:str];
    
    [tipView showWithparentView:self.view];
    
    tipView.ensureBlock = ^{
        [weakSelf createDataSource];
    };
}


- (void)refreshFooter {
    
    [mPresenter getMusicResourceMore];
}


#pragma mark - MusicResourceView代理方法

- (void)setMusicResource:(NSMutableArray *)infos isLast:(BOOL)last loadMore:(BOOL)loadMore
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (tipView) {
            [tipView removeFromParentView];
        }
        
        if (loadMore) {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            self.tableView.mj_footer = nil;
        }
        [self.dataArr addObjectsFromArray:infos];
        
        if (last) {
            
            if (infos.count > 0) {
                if ([infos[0] isKindOfClass:[JdCategoryModel class]]) {
                    _isSongLast = 0;
                }else{
                    _isSongLast = 1;
                }
            }
        }else{
            _isSongLast = 2;
        }
        [loadView dismiss];
        [self.tableView reloadData];
        
        if (self.tableView.mj_footer != nil) {
             [self.tableView.mj_footer endRefreshing];
        }
    });
    
}


- (void)onGetMusicResourceFail:(int)erroCode errMsg:(NSString *)errMsg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadView dismiss];
        [self showFailAlertWithStr:errMsg];
    });
}




#pragma mark - 公开的父类方法
- (void)refreshTableCell:(CategoryTableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{

}


-(void)tableCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{

}


- (void)backBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [self refreshTableCell:cell WithIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableCellSelectedWithIndexPath:indexPath];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 67;
}

@end
