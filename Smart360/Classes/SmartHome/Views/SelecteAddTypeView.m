//
//  SelecteAddTypeView.m
//  Smart360
//
//  Created by michael on 16/1/4.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "SelecteAddTypeView.h"
#import "RoomContainApplianceModel.h"

@interface SelecteAddTypeView ()

@property (nonatomic, strong) UIView * viewContent;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *traditionalButton;
@property (nonatomic, strong) UIButton *WiFiButton;
@property (nonatomic, strong) UIButton *RFButton;


@property (nonatomic, strong) RoomContainApplianceModel * roomContainApplianceModel;
@property (nonatomic, strong) NSDictionary *proStarDict;

@end


@implementation SelecteAddTypeView


-(instancetype)initWithRoomContainApplianceModel:(RoomContainApplianceModel *)roomContainApplianceModel ProStarDict:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        
        self.roomContainApplianceModel = roomContainApplianceModel;
        self.proStarDict = [NSDictionary dictionaryWithDictionary:dict];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.350];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:backView];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelecteAddTypeView)];
        [backView addGestureRecognizer:tapG];
        
        [self configureSubViews];
    }
    return self;
}


//内容页子视图
- (void)configureSubViews
{
    self.viewContent=[[UIView alloc] init];
    
    NSArray *tempArray = [NSArray arrayWithArray:self.proStarDict[kAddType_ProRoomModelArray]];
    
    BOOL isCurrentRoomHavePro = [self.proStarDict[kAddType_CurrentRoom_DeviceControllerName] isEqualToString:kApplianceDeviceType_Pro];
    
    
    
    if ( (tempArray.count>0) || isCurrentRoomHavePro ) {
        //该机器人下有Pro
        self.viewContent.frame = CGRectMake(0, 0, 220, 260);
    }else{
        self.viewContent.frame = CGRectMake(0, 0, 220, 200);
    }
    
    self.viewContent.center=self.center;
    self.viewContent.backgroundColor = [UIColor whiteColor];
    self.viewContent.layer.masksToBounds = YES;
    self.viewContent.layer.cornerRadius = 5;
    [self addSubview:self.viewContent];
    
    //文字
    self.titleLabel=[UILabel new];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.text=@"请选择添加的设备类型";
    self.titleLabel.textColor=kLinkBoxWaitingViewTitle_Color;
    self.titleLabel.font=[UIFont systemFontOfSize:16];
    
    [self.viewContent addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewContent);
        make.top.equalTo(self.viewContent).offset(20);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.viewContent).offset(10);
        make.right.equalTo(self.viewContent).offset(-10);
    }];
    
    
    //传统家电
    self.traditionalButton =[UIButton new];
    [self addSubview:self.traditionalButton];
    [self.traditionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.viewContent).with.offset(20);
        make.right.equalTo(self.viewContent).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    [self.traditionalButton addTarget:self action:@selector(clickTraditionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.traditionalButton.layer.masksToBounds = YES;
    self.traditionalButton.layer.cornerRadius = 8;
    self.traditionalButton.layer.borderWidth = 1;
    self.traditionalButton.layer.borderColor = UIColorFromRGB(kSelecte_TraditionalColor).CGColor;
    [self.traditionalButton setTitle:@"传统电器" forState:UIControlStateNormal];
    [self.traditionalButton setTitleColor:UIColorFromRGB(kSelecte_TraditionalColor) forState:UIControlStateNormal];
    self.traditionalButton.titleLabel.font=[UIFont systemFontOfSize:15];
    
    //智能家电
    self.WiFiButton =[UIButton new];
    [self addSubview:self.WiFiButton];
    [self.WiFiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.traditionalButton.mas_bottom).with.offset(20);
        make.left.equalTo(self.viewContent).with.offset(20);
        make.right.equalTo(self.viewContent).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    [self.WiFiButton addTarget:self action:@selector(clickWiFiBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.WiFiButton.layer.masksToBounds = YES;
    self.WiFiButton.layer.cornerRadius = 8;
    self.WiFiButton.layer.borderWidth = 1;
    self.WiFiButton.layer.borderColor = UIColorFromRGB(kSelecte_WiFiColor).CGColor;
    [self.WiFiButton setTitle:@"智能设备" forState:UIControlStateNormal];
    [self.WiFiButton setTitleColor:UIColorFromRGB(kSelecte_WiFiColor) forState:UIControlStateNormal];
    self.WiFiButton.titleLabel.font=[UIFont systemFontOfSize:15];
    
    
    if ( (tempArray.count>0) || isCurrentRoomHavePro ){
        //RF家电
        self.RFButton =[UIButton new];
        [self addSubview:self.RFButton];
        [self.RFButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.WiFiButton.mas_bottom).with.offset(20);
            make.left.equalTo(self.viewContent).with.offset(20);
            make.right.equalTo(self.viewContent).with.offset(-20);
            make.height.mas_equalTo(@40);
        }];
        [self.RFButton addTarget:self action:@selector(clickRFBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.RFButton.layer.masksToBounds = YES;
        self.RFButton.layer.cornerRadius = 8;
        self.RFButton.layer.borderWidth = 1;
        self.RFButton.layer.borderColor = UIColorFromRGB(kSelecte_RFColor).CGColor;
        [self.RFButton setTitle:@"射频设备" forState:UIControlStateNormal];
        [self.RFButton setTitleColor:UIColorFromRGB(kSelecte_RFColor) forState:UIControlStateNormal];
        self.RFButton.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    
}

//传统家电
-(void)clickTraditionBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addInfraredDeviceDelegate:)]) {
        [self.delegate addInfraredDeviceDelegate:self.roomContainApplianceModel];
    }
    
    [self closeSelecteAddTypeView];
}

//智能家电
-(void)clickWiFiBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addWiFiDeviceDelegate:)]) {
        [self.delegate addWiFiDeviceDelegate:self.roomContainApplianceModel];
    }
    
    [self closeSelecteAddTypeView];
    
}

//RF设备
-(void)clickRFBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addRFDeviceDelegate:ProStarDict:)]) {
        [self.delegate addRFDeviceDelegate:self.roomContainApplianceModel ProStarDict:self.proStarDict];
    }
    
    [self closeSelecteAddTypeView];
}

//展示视图
-(void)showSelecteAddTypeView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

//关闭视图
- (void)closeSelecteAddTypeView {
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
