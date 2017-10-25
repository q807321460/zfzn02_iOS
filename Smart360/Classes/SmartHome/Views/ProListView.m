//
//  ProListView.m
//  Smart360
//
//  Created by michael on 16/1/27.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "ProListView.h"
#import "ProRoomModel.h"

#define kProListView_Height 200


@interface ProListView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *proRoomArray;
@property (nonatomic, copy) NSString *currentRoomID;
@property (nonatomic, strong) UIView * viewContent;

@end


@implementation ProListView

-(instancetype)initCustomWithProListAray:(NSArray *)proArray roomID:(NSString *)roomID{
    if (self = [super init]) {
        self.proRoomArray = [NSArray arrayWithArray:proArray];
        self.currentRoomID = [NSString stringWithString:roomID];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.350];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:backView];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeProListView)];
        [backView addGestureRecognizer:tapG];
        
        [self createContentView];
    }
    return self;
}

-(void)createContentView{
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kProListView_Height, SCREEN_WIDTH, kProListView_Height)];
    self.viewContent.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.viewContent];
    
    UIView * headerView = [[UIView alloc] init];
    [self.viewContent addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewContent);
        make.centerX.equalTo(self.viewContent);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];    
    
    UILabel * headerLabel = [UILabel new];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"选择控制器";
    headerLabel.textColor = [UIColor blackColor];
    [headerView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
    UIView *lineView1= [UIView new];
    lineView1.backgroundColor = UIColorFromRGB(0xd5d5d5);
    [headerView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
    
    UITableView * tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
//    tableView.backgroundColor = [UIColor clearColor];
    //去除多余的分割线
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.viewContent addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.centerX.equalTo(self.viewContent);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kProListView_Height-100));
    }];
    
    UIButton * footerViewButton = [[UIButton alloc] init];
    [footerViewButton setTitle:@"关闭" andTitleColor:[UIColor blackColor] andTitleFont:16];
    [footerViewButton setOnClickSelector:@selector(closeProListView) target:self];
    [self.viewContent addSubview:footerViewButton];
    [footerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom);
        make.centerX.equalTo(self.viewContent);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];

    UIView *lineView2= [UIView new];
    lineView2.backgroundColor = UIColorFromRGB(0xd5d5d5);
    [footerViewButton addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerViewButton);
        make.centerX.equalTo(footerViewButton);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proRoomArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProListViewTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProListViewTableViewCell"];
    }
    
    ProRoomModel *proRoomModel = [[ProRoomModel alloc] init];
    proRoomModel = self.proRoomArray[indexPath.row];
    if ([proRoomModel.proSN isEqualToString:@"123456789"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"小智内嵌射频控制器（%@）",proRoomModel.roomName];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"博联智能遥控器（%@）",proRoomModel.roomName];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"博联智能遥控器（%@）",proRoomModel.roomName];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProRoomModel *proRoomModel = [[ProRoomModel alloc] init];
    proRoomModel = self.proRoomArray[indexPath.row];
    
    
    if ([self.delegate respondsToSelector:@selector(selecteOneProListViewCurrentRoomID:ProRoomModel:)]) {
        [self.delegate selecteOneProListViewCurrentRoomID:self.currentRoomID ProRoomModel:proRoomModel];
    }
    [self closeProListView];
}


//展示视图
-(void)showProListView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

//关闭视图
- (void)closeProListView {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
