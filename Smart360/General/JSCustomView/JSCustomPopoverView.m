//
//  JSCustomPopoverView.m
//  Smart360
//
//  Created by sun on 15/8/5.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSCustomPopoverView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define kPopoverViewRow_Gap 2.f
#define kPopoverViewRow_Height 44.f
#define TITLE_FONT [UIFont systemFontOfSize:16]
#define kPopoverView_Right SCREEN_WIDTH - 5


@interface JSCustomPopoverView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) UIButton *handerView;

@property (nonatomic, strong) UIImageView *markIcon;

@end


@implementation JSCustomPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderColor = RGB(200, 199, 204);
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    if (_currentIndexPath != currentIndexPath) {
        _currentIndexPath = currentIndexPath;
    }
    [self.tableView reloadData];
}

- (void)setImageArray:(NSArray *)imageArray {
    if (_imageArray != imageArray) {
        _imageArray = imageArray;
    }
    self.frame = [self getViewFrame];
    CGRect rect = self.frame;
    rect.origin.x = kPopoverViewRow_Gap;
    rect.origin.y = kArrowHeight + kPopoverViewRow_Gap;
    rect.size.width -= kPopoverViewRow_Gap * 2;
    rect.size.height -= (kPopoverViewRow_Gap - kArrowHeight);
    
    self.tableView.frame = rect;
    [self.tableView reloadData];
}

//初始化下拉框要显示的文字,位置和图片

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images isOnNav:(BOOL)isOnNav {
    self = [super init];
    if (self) {
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        self.isOnNav = isOnNav;
        self.frame = [self getViewFrame];
//        self.backgroundColor = [UIColor cyanColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [JSUtility stretcheImage:IMAGE(@"dev_bg_Box")];
        [self addSubview:imageView];
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(CGRect)getViewFrame {
    CGRect frame = CGRectZero;
    
    frame.size.height = [self.titleArray count] * kPopoverViewRow_Height + kPopoverViewRow_Gap + kArrowHeight;
    
    for (NSString *title in self.titleArray) {
//        CGFloat width =  [title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByCharWrapping].width;
        //设置计算文本时字体的大小,以什么标准来计算
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGFloat width = [title boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.width;
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] == [self.imageArray count]) {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 40;
    }else{
        frame.size.width = 10 + frame.size.width + 40;
    }
    
    if (self.isOnNav) {
        frame.origin.x = self.showPoint.x  - frame.size.width;
        frame.origin.y = 66;
    } else {
        frame.origin.x = self.showPoint.x - frame.size.width/2;
        frame.origin.y = self.showPoint.y;
    }
    
    
    //左间隔最小5x
    if (frame.origin.x < 5) {
        frame.origin.x = 5;
    }
    //右间隔最小5x
    if (self.isOnNav) {
        if (frame.origin.x  > kPopoverView_Right) {
            frame.origin.x = kPopoverView_Right ;
        }
    } else {
        if ((frame.origin.x + frame.size.width) > kPopoverView_Right) {
            frame.origin.x = kPopoverView_Right - frame.size.width;
        }
    }
    
    return frame;
}


-(void)show
{
    //屏幕大小的button,
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    //将视图添加到window上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];

    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

//移除下拉框
-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}


#pragma mark - UITableView

- (UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = kPopoverViewRow_Gap;
    rect.origin.y = kArrowHeight + kPopoverViewRow_Gap;
    rect.size.width -= kPopoverViewRow_Gap * 2;
    rect.size.height -= (kPopoverViewRow_Gap - kArrowHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];

    return _tableView;
}

- (UIImageView *)markIcon {
    if (!_markIcon) {
        UIImage *icon = IMAGE(@"dev_Ico_Hook");
        _markIcon = [[UIImageView alloc] init];
        _markIcon.image = icon;
    }
    return _markIcon;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    if (indexPath.row == self.currentIndexPath.row) {
        UIImage *icon = IMAGE(@"dev_Ico_Hook");
        self.markIcon.hidden = NO;
        //    self.markIcon.image = icon;
        [cell.contentView addSubview:self.markIcon];
        [_markIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).with.offset(-5);
            make.size.mas_equalTo(icon.size);
        }];

    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //block传值
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPopoverViewRow_Height;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [self.borderColor set]; //设置线条颜色
//    
//    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
//    
//    float xMin = CGRectGetMinX(frame);
//    float yMin = CGRectGetMinY(frame);
//    
//    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame);
//    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
//    
//    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
//    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
//    
//    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
//    [popoverPath addCurveToPoint:arrowPoint
//                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
//                   controlPoint2:arrowPoint];//actual arrow point
//    
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
//    /********************向上的箭头**********************/
//    
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
//    
//    //填充颜色
//    [RGB(245, 245, 245) setFill];
//    [popoverPath fill];
//    
//    [popoverPath closePath];
//    [popoverPath stroke];
//}

@end
