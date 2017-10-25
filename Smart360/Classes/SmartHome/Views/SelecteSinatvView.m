//
//  SelecteSinatvView.m
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SelecteSinatvView.h"

@interface SelecteSinatvView ()<UITableViewDataSource,UITableViewDelegate>

{
    CGFloat contentViewHeight;
}

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) NSArray *sinatvDataArray;

@end

@implementation SelecteSinatvView

- (instancetype)initWithSinatvDataArray:(NSArray *)sinatvArray {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _sinatvDataArray = sinatvArray;
        contentViewHeight = SCREEN_HEIGHT - 64;
        [self createSinatvTableView];
    }
    return self;

}

- (void)createSinatvTableView {
    [self addSubview:self.viewContent];
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.viewContent addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewContent);
        make.left.equalTo(_viewContent);
        make.right.equalTo(_viewContent);
        make.bottom.equalTo(_viewContent);
    }];
    
}

#pragma mark - UITableView

#pragma mark - Table view data source

//设置每个分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.sinatvDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinatvCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SinatvCell"];
    }
    if (self.sinatvDataArray.count > 0) {
        cell.textLabel.text = self.sinatvDataArray[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma  mark - Table view delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [BalanceTableViewCell heightForBalanceCell];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sinagvDelegate respondsToSelector:@selector(selectedSinatv:)]) {
        [self.sinagvDelegate selectedSinatv:self.sinatvDataArray[indexPath.row]];
    }
}




#pragma mark - 视图的展示和移除
//内容视图
- (UIView *)viewContent {
    if (!_viewContent) {
        _viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, contentViewHeight)];
        _viewContent.backgroundColor = [UIColor whiteColor];
    }
    return _viewContent;
}

//关闭视图
- (void)closeSinatvView {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewContent.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, contentViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

//展示视图
- (void)showSinatvView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewContent.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - contentViewHeight, SCREEN_WIDTH, contentViewHeight);
    } completion:^(BOOL finished) {
        
    }];

}

@end
