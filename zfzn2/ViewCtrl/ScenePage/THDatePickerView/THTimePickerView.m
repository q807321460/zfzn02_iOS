//
//  THDatePickerView.m
//  rongyp-company
//
//  Created by Apple on 2016/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "THTimePickerView.h"

@interface THTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间

@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSMutableArray *secondArr; // 秒数组
@property (strong, nonatomic) NSArray *timeArr; // 当前时间数组

@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分
@property (copy, nonatomic) NSString *second; //选中秒

@end

#define THColorRGB(rgb)    [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]

@implementation THTimePickerView

#pragma mark - init
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.hourArr];
        [self.dataArray addObject:self.minuteArr];
        [self.dataArray addObject:self.secondArr];
        
        [self configToolView];
        [self configPickerView];
    }
    return self;
}
#pragma mark - 配置界面
/// 配置工具条
- (void)configToolView {
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    [self addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [saveBtn setImage:[UIImage imageNamed:@"情景_时间选择器_确认"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"情景_时间选择器_取消"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = THColorRGB(34);
    [self.toolView addSubview:self.titleLbl];
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height - 44)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)show {
    self.hour = [NSString stringWithFormat:@"%ld时", [self.timeArr[0] integerValue]];
    self.minute = self.minuteArr[self.minuteArr.count / 2];
    self.second = self.secondArr[self.secondArr.count / 2];
    
    [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:0 animated:YES];
    [self.pickerView selectRow:self.minuteArr.count / 2 inComponent:1 animated:YES];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    
    NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
    NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
    NSString *second = self.second.length == 3 ? [NSString stringWithFormat:@"%ld", self.second.integerValue] : [NSString stringWithFormat:@"0%ld", self.second.integerValue];

    self.selectStr = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
        [self.delegate timePickerViewSaveBtnClickDelegate:self.selectStr];
    }
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
        [self.delegate timePickerViewCancelBtnClickDelegate];
    }
}
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.dataArray[component] count] * 200;
}

/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger time_integerValue = [self.timeArr[component] integerValue];
    switch (component) {
        case 0: { // 时
            // 如果选择的时小于当前时，就刷新到当前时
            if ([self.hourArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[0] integerValue]) {
                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                // 如果选择的时大于当前时，就直接赋值
            } else {
                self.hour = self.hourArr[row%[self.dataArray[component] count]];
            }
        } break;
        case 1: { // 分
            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
        } break;
        case 2: { // 秒
            self.second = self.secondArr[row%[self.dataArray[component] count]];
        } break;
        default: break;
    }
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSLog(@"%@", view);
        
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];

    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i <= 59; i ++) {
            [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
        }
    }
    return _minuteArr;
}

/// 获取秒数
- (NSMutableArray *)secondArr {
    if (!_secondArr) {
        _secondArr = [NSMutableArray array];
        for (int i = 0; i <= 59; i ++) {
            [_secondArr addObject:[NSString stringWithFormat:@"%d秒", i]];
        }
    }
    return _secondArr;
}

// 获取当前的时分秒
- (NSArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH时,mm分,ss秒"];
        NSDate *date = [NSDate date];
        NSString *time = [formatter stringFromDate:date];
        _timeArr = [time componentsSeparatedByString:@","];
    }
    return _timeArr;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH时,mm分,ss秒"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

@end
