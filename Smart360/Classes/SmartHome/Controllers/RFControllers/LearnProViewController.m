//
//  LearnProViewController.m
//  Smart360
//
//  Created by michael on 16/1/22.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import "LearnProViewController.h"
#import "ProStudyButtonView.h"
#import "ApplianceModel.h"
#import "FuncProModel.h"
#import "SBApplianceEngineMgr.h"

#define kLearnProVC_GuideLabel_ParagraphSpace 5

@interface LearnProViewController ()<ProStudyButtonViewDelegate>

@property (nonatomic, strong) NSMutableArray *funcArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) CGFloat heightStr;
@property (nonatomic, strong) UILabel *guideLabel;
@property (nonatomic, strong) ProStudyButtonView *proStudyButtonView;
@property (nonatomic, strong) UIView *upperView;

@property (nonatomic, strong) NSDictionary *markDict;
@property (nonatomic, strong) NSMutableDictionary *saveDict;

@end

@implementation LearnProViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titleVC = self.applianceModel.deviceType;
    
    [self setNavigationItemWithTitle:titleVC];
    [self setNavigationItemRightButtonWithTitle:@"保存"];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    [self createUIContent];
    [self getContentData];
    
 }

-(void)createUIContent{
    
    UIImageView *backImageViewPro = [[UIImageView alloc] init];
    [self.view addSubview:backImageViewPro];
    backImageViewPro.image = IMAGE(@"yk_bg");
    [backImageViewPro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
    }];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
    }];
    
    
    
    NSString *deviceStr = [NSString stringWithFormat:@"目前支持的设备开关为品牌：第三女神\n"];
    deviceStr = @"\n";
    NSString *strStep1 = [NSString stringWithFormat:@"步骤1：点击下方%@控制按键\n",self.applianceModel.deviceType];
//    @"步骤1：点击下方电视控制按键\n";
    NSString *strStep2 = [NSString stringWithFormat:@"步骤2：当按键处于高亮状态时，将%@遥控器对准博联智能遥控器\n",self.applianceModel.deviceType];
//    @"步骤2：当按键处于高亮状态时，将电视遥控器对准博联智能遥控器\n";
    NSString *strStep3 = [NSString stringWithFormat:@"步骤3：按下%@遥控器上对应的按钮",self.applianceModel.deviceType];
    if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
        strStep1 = [NSString stringWithFormat:@"步骤1：%@\n",@"按住射频开关按键不放，8秒后，听到“滴”2声，释放按键（3秒内完成），表示开关进入学习状态"];
        strStep2 = [NSString stringWithFormat:@"步骤2：%@\n",@"按下下面的“学习”按钮"];
        strStep3 = [NSString stringWithFormat:@"步骤3：%@",@"听到“滴”1声长音，表示学习成功，听到“滴”3声，表示学习失败（如果失败，按照上述步骤重新再来一遍）"];
        [self setNavigationItemRightButtonWithTitle:@" "];
    }
    
    NSString *strGuide = [NSString stringWithFormat:@"%@%@%@",strStep1,strStep2,strStep3];
    _heightStr = [JSUtility heightForText:strGuide labelWidth:(SCREEN_WIDTH-40) fontOfSize:12];
    
    self.guideLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:self.guideLabel];
    self.guideLabel.textAlignment = NSTextAlignmentLeft;
    self.guideLabel.numberOfLines=0;
    CGFloat guideLabelTop = 20;
    if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
        UILabel *deviceLabel = [UILabel new];
        deviceLabel.text = deviceStr;
        deviceLabel.textColor = UIColorFromRGB(0x999999);
        deviceLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:deviceLabel];
        [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(guideLabelTop);
            make.centerX.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 30));
        }];
        guideLabelTop += 30;

        
    }
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(guideLabelTop);
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, _heightStr+10+2*kLearnProVC_GuideLabel_ParagraphSpace));
    }];
    
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] initWithString:strGuide];
    [muAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, strGuide.length)];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, strGuide.length)];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0a9bf7) range:NSMakeRange(0, 4)];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0a9bf7) range:NSMakeRange(strStep1.length, 4)];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0a9bf7) range:NSMakeRange(strStep1.length+strStep2.length, 4)];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setLineSpacing:5]; //调整行间距
    [paragraphStyle setParagraphSpacing:kLearnProVC_GuideLabel_ParagraphSpace]; //调整段间距
    [muAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strGuide.length)];
    
    self.guideLabel.attributedText = muAttStr;
    
}

-(void)getContentData{
    if (!self.funcArray) {
        self.funcArray = [[NSMutableArray alloc] init];
    }
    if (!self.saveDict) {
        self.saveDict = [[NSMutableDictionary alloc] init];
    }
    if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
        FuncProModel *funcModel = [[FuncProModel alloc] init];
        funcModel.funcName = @"学习";
        funcModel.funcCode = @"";
        funcModel.isStudyed = NO;
        [self.funcArray addObject:funcModel];
        [self createProStudyUIView];
        [self createUpperView];

        
    } else {
        [self showHud];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetProStudyResult:) name:kNotifi_SBApplianceEngineCallBack_Event_GetProStudyResult object:nil];
        [SBApplianceEngineMgr getProStudyResult:self.applianceModel.deviceID];

    }
    
    
}
-(void)notifiGetProStudyResult:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetProStudyResult object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        self.funcArray = [NSMutableArray arrayWithArray:dict[kSBEngine_Data]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self createProStudyUIView];
            [self createUpperView];
        });
        
        [self getSaveDictContent];
        
    }else{
        
        JSError(@"GetProStudyResult", @"notifiGetProStudyResult fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"获取失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
}

-(void)getSaveDictContent{
    
    for (FuncProModel *funcProModel in self.funcArray) {
        if (YES == funcProModel.isStudyed) {
            [self.saveDict setValue:funcProModel forKey:funcProModel.funcName];
        }
    }

}


#pragma mark - StudyButton delegate
-(void)funcClickDelegate:(NSInteger)markTag button:(UIButton *)btn{
    NSDictionary *dict = @{@"MarkTag":@(markTag),@"Button":btn};
    [self btnChangeToStudyingState:dict];
    
    self.markDict = [NSDictionary dictionaryWithDictionary:dict];
    
    FuncProModel *funcProModel = self.funcArray[markTag];
    if ([self.applianceModel.controlledByProSN isEqualToString:@"123456789"]) {
        NSString *code;
        if (self.applianceModel.learnCode.length > 0) {
            code = self.applianceModel.learnCode;
        } else {
            code = @"";
        }
        NSDictionary *dic = @{@"commandType":@"assistantProDevStudyStartCmd",@"brandId":@"1",@"brand":@"第三女神",@"applianceId":self.applianceModel.controlledByProSN,@"applianceType":@"rf",@"type":@"rf",@"devNameType":self.applianceModel.deviceType,@"id":self.applianceModel.deviceID,@"devName":self.applianceModel.name,@"functionName":funcProModel.funcName,@"code":code};
        [SBApplianceEngineMgr smallzhiRFStudyWithDic:dic withSuccessBlock:^(NSArray *result) {
            [self btnChangeToStudySuccState:self.markDict];
//            [self.view makeToast:@"学习命令已发送"];
            [self.view makeToast:@"学习命令已发送" duration:1.0 position:CSToastPositionCenter];
        } withFailBlock:^(NSString *msg) {
            [self btnChangeToStudyFailedState:self.markDict];
            [self.view makeToast:@"学习命令发送失败"];
        }];
      
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiProStudyByStep:) name:kNotifi_SBApplianceEngineCallBack_Event_ProStudyByStep object:nil];
    [SBApplianceEngineMgr proStudy:self.applianceModel.deviceID ProSN:self.applianceModel.controlledByProSN deviceName:self.applianceModel.name devType:self.applianceModel.deviceType functionName:funcProModel.funcName];
    
    
//    [self performSelector:@selector(btnChangeToStudyFailedState:) withObject:dict afterDelay:2];
}

-(void)notifiProStudyByStep:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_ProStudyByStep object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self btnChangeToStudySuccState:self.markDict];
        });
        FuncProModel *funcProModel = dict[kSBEngine_Data][0];
        [self.saveDict setValue:funcProModel forKey:funcProModel.funcName];
        
    }else{
        
        JSError(@"ProStudyByStep", @"notifiProStudyByStep fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self btnChangeToStudyFailedState:self.markDict];
        });
        
    }
}





//创建学习按键UI
-(void)createProStudyUIView{
    if (!self.proStudyButtonView) {
        self.proStudyButtonView = [[ProStudyButtonView alloc] initWithFuncArray:self.funcArray];
        self.proStudyButtonView.proStudyButtonViewDelegate = self;
        [self.scrollView addSubview:self.proStudyButtonView];
        
        
        CGFloat scrSizeHeight = 20+ _heightStr+10+2*kLearnProVC_GuideLabel_ParagraphSpace +30+self.proStudyButtonView.bounds.size.height+10;
        if ( scrSizeHeight > (SCREEN_HEIGHT-64) ) {
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrSizeHeight);
        }
        
        WS(weakSelf);
        [self.proStudyButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.guideLabel.mas_bottom).offset(30);
            make.centerX.equalTo(weakSelf.scrollView);
            make.size.mas_equalTo(weakSelf.proStudyButtonView.bounds.size);
        }];
    }
    
}

//上面一层View
-(void)createUpperView{
    if (!self.upperView) {
        self.upperView = [[UIView alloc] init];
        self.upperView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        self.upperView.backgroundColor = [UIColor clearColor];
//        self.upperView.frame = self.proStudyButtonView.bounds;
        [self.view addSubview:self.upperView];
        self.upperView.userInteractionEnabled = NO;
    }
}

-(void)closeUpperView{
    if (self.upperView) {
        [self.upperView removeFromSuperview];
        self.upperView = nil;
    }
}



// btn未学习
-(void)btnChangeToNoStudyState:(NSDictionary *)dict{
    self.upperView.userInteractionEnabled = NO;
    JSDebug(@"ProStudyVC", @"btnChangeToNoStudyState");
    
    UIButton *btn = dict[@"Button"];
    NSNumber *numberTag = dict[@"MarkTag"];
    FuncProModel *funcProModel = self.funcArray[numberTag.intValue];
    [btn setBackgroundImage:IMAGE(@"yk_btn_bg01") forState:UIControlStateNormal];
    [btn setTitle:funcProModel.funcName andTitleColor:kProStudy_noStudy_Color andTitleFont:kProStudy_noStudy_TitleFont];
}
// btn学习中
-(void)btnChangeToStudyingState:(NSDictionary *)dict{
    self.upperView.userInteractionEnabled = YES;
    JSDebug(@"ProStudyVC", @"btnChangeToStudyingState");

    
    UIButton *btn = dict[@"Button"];
    [btn setBackgroundImage:IMAGE(@"yk_btn_bg03") forState:UIControlStateNormal];
    [btn setTitle:@"学习中" andTitleColor:kProStudy_DoStudy_Color andTitleFont:kProStudy_DoStudy_TitleFont];
}
// btn学习成功
-(void)btnChangeToStudySuccState:(NSDictionary *)dict{
    self.upperView.userInteractionEnabled = NO;
    JSDebug(@"ProStudyVC", @"btnChangeToStudySuccState");

    
    UIButton *btn = dict[@"Button"];
    NSNumber *numberTag = dict[@"MarkTag"];
    FuncProModel *funcProModel = self.funcArray[numberTag.intValue];
    [btn setBackgroundImage:IMAGE(@"yk_btn_bg02") forState:UIControlStateNormal];
    [btn setTitle:funcProModel.funcName andTitleColor:kProStudy_successStudy_Color andTitleFont:kProStudy_successStudy_TitleFont];
}
// btn学习失败
-(void)btnChangeToStudyFailedState:(NSDictionary *)dict{
    UIButton *btn = dict[@"Button"];
    [btn setBackgroundImage:IMAGE(@"yk_btn_bg04") forState:UIControlStateNormal];
    [btn setTitle:@"学习失败" andTitleColor:kProStudy_DoStudy_Color andTitleFont:kProStudy_DoStudy_TitleFont];
    [self performSelector:@selector(btnChangeToNoStudyState:) withObject:dict afterDelay:2];
}

-(void)rightItemClicked:(id)sender{
    
    //学习进行中 不能保存
    if (self.upperView.userInteractionEnabled) {
        return;
    }
    
    NSArray *keyArray = [self.saveDict allKeys];
    if (0 == keyArray.count) {
        [self.view makeToast:@"您还没有学习按键功能" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    [self showHud];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiSaveProStudyResult:) name:kNotifi_SBApplianceEngineCallBack_Event_SaveProStudyResult object:nil];
    
    NSArray *valuesArray = [NSArray arrayWithArray:[self.saveDict allValues]];
    JSDebug(@"saveProStudyResult:", @"controlledByProSN:%@ , result count:%lu",self.applianceModel.controlledByProSN,(unsigned long)valuesArray.count);
    
    [SBApplianceEngineMgr saveProStudyResult:self.applianceModel.deviceID ProSN:self.applianceModel.controlledByProSN funArray:valuesArray];
    
}
-(void)notifiSaveProStudyResult:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_SaveProStudyResult object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            if (self.isAddDevice == YES) {
                if ([self.applianceModel.deviceType isEqualToString:kApplianceDeviceType_Plug]) {
                    //插座
                    
                    
                }else{
                    //非插座
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
        
    }else{
        
        JSError(@"SaveProStudyResult", @"notifiSaveProStudyResult fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
        });
        
    }
}


#pragma  mark - leftItemClicked 返回
- (void)leftItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
