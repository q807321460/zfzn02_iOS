//
//  AddRedSatelliteViewController.m
//  Smart360
//
//  Created by michael on 15/11/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "AddRedSatelliteViewController.h"

#import "StepView.h"
#import "SBApplianceEngineMgr.h"

#import "AddRedSatelliteGuideView.h"
#import "ZCZBarViewController.h"
//#import "AppDelegate.h"


#define kStepView_Height 79
#define kIntroduceViewToStepViewBottom_Height 15
#define kGuideImageViewToIntroduceViewTop_Height 30
#define kStepLabelToGuideImageViewBottom_Height 10
#define kStepLabelBottomToIntroduceViewBottom_Height 10
#define kButtonToIntroduceViewBottom_Height 18




@interface AddRedSatelliteViewController ()

@property (nonatomic, strong) UIView *stepView;
@property (nonatomic, strong) UIView *viewIntroduce;

@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UILabel *stepLabel;

@property (nonatomic, copy) NSString *explanStr;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *retryBtn;
@property (nonatomic, strong) NSMutableAttributedString *AttributedStr;


@property (nonatomic, copy) NSString *redSatelliteID;

@end

@implementation AddRedSatelliteViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemWithTitle:@"红卫星"];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
    [self createUI];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AddRedSatelliteGuideViewPromptAgain"]) {
        //bool为yes不再提示
    }else{
//        //bool为no时重复提示（包括第一次进来时）
//        AddRedSatelliteGuideView *guideView = [[AddRedSatelliteGuideView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//        [self.view addSubview:guideView];
        
    }
    
}


-(void)createUI{
    
    self.stepView = [[StepView alloc] initWithStepNameArray:@[@"设备状态",@"指示灯状态"] stepNumber:1];
    [self.view addSubview:self.stepView];
    
    self.explanStr = @"*请确认红卫星已连接电源并开启，状态指示灯呈红色间隔闪烁，点击扫描二维码添加红卫星。\n如状态指示灯不闪烁，请戳红卫星底部reset孔至初始状态。";
    NSString *headText = @"*请确认红卫星已连接电源并开启，状态指示灯呈红色间隔闪烁，点击扫描二维码添加红卫星。";
    
    CGFloat heightStepLabel = [JSUtility heightForText:self.explanStr labelWidth:(SCREEN_WIDTH-20) fontOfSize:14];
    
    JSDebug(@"StepLabel", @"StepLabelText height%f",heightStepLabel);
    
    self.viewIntroduce = [[UIView alloc] initWithFrame:CGRectMake(0, 64+kStepView_Height+kIntroduceViewToStepViewBottom_Height, SCREEN_WIDTH, kGuideImageViewToIntroduceViewTop_Height+IMAGE(@"RedSatellite_light01").size.height + kStepLabelToGuideImageViewBottom_Height+ heightStepLabel+25 + kStepLabelBottomToIntroduceViewBottom_Height)];
    [self.view addSubview:self.viewIntroduce];
    self.viewIntroduce.backgroundColor = [UIColor whiteColor];
    
    
    //指导图片
    self.guideImageView = [[UIImageView alloc] init];
    [self.viewIntroduce addSubview:self.guideImageView];
    self.guideImageView.image = IMAGE(@"RedSatellite_light01");
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewIntroduce).offset(kGuideImageViewToIntroduceViewTop_Height);
        make.centerX.equalTo(self.viewIntroduce);
        make.size.mas_equalTo(IMAGE(@"RedSatellite_light01").size);
    }];
    
    
    self.stepLabel = [[UILabel alloc] init];
//    [[UILabel alloc] initWithFrame:CGRectMake(10, kStepLabelToGuideImageViewBottom_Height, SCREEN_WIDTH-20, heightStepLabel+25)];
    [self.viewIntroduce addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideImageView.mas_bottom).offset(kStepLabelToGuideImageViewBottom_Height);
        make.centerX.equalTo(self.viewIntroduce);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, heightStepLabel+25));
    }];
    
    self.stepLabel.textAlignment = NSTextAlignmentLeft;
    self.stepLabel.numberOfLines=0;
    
    [self getStepLabelText:self.explanStr aheadText:headText];

    
    self.button = [UIButton new];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewIntroduce.mas_bottom).with.offset(kButtonToIntroduceViewBottom_Height);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [self.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = UIColorFromRGB(0xff6868);
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 8;
    [self.button setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:15];

}

-(void)getStepLabelText:(NSString *)allStr aheadText:(NSString *)aheadText{
    
#warning 置为nil？？？？
    self.AttributedStr = nil;
    
    self.AttributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [self.AttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:14.0]
                               range:NSMakeRange(0, aheadText.length)];
    [self.AttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:12.0]
                               range:NSMakeRange(aheadText.length, allStr.length-aheadText.length)];
    
    [self.AttributedStr addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:NSMakeRange(0, 1)];
    
    [self.AttributedStr addAttribute:NSForegroundColorAttributeName
                               value:kBindCode_Describ_Color
                               range:NSMakeRange(1, allStr.length-1)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setLineSpacing:5]; //调整行间距
    [paragraphStyle setParagraphSpacing:15]; //调整段间距
    [self.AttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, allStr.length)];
    
    self.stepLabel.attributedText = self.AttributedStr;
}



-(void)btnClick:(UIButton *)btn{
    
    if ([self.button.titleLabel.text isEqualToString:@"确定"]) {
        
#ifdef __SBApplianceEngine__HaveData__
        
        [self showHud];
        
        [SBApplianceEngineMgr addRedSatellite:self.roomID devID:self.redSatelliteID withSuccessBlock:^(NSString *result) {
            [self hideHud];
            //            [self.view makeToast:@"添加红卫星成功" duration:1.0 position:CSToastPositionCenter];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }

        } withFailBlock:^(NSString *msg) {
            [self hideHud];
            
            [self.view makeToast:@"添加红卫星失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];

        }];
        
        return;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddRedSatellite:) name:kNotifi_SBApplianceEngineCallBack_Event_AddRedSatellite object:nil];
        
        [SBApplianceEngineMgr addRedSatellite:self.roomID devID:self.redSatelliteID devName:@"红卫星" devAlias:@"红卫星"];
        
#else
        
#endif
        
    }
    
    if ([self.button.titleLabel.text isEqualToString:@"扫描二维码"]) {
        
        [self scanCode];
        
    }
    
}



-(void)scanCode{
    
    //摄像头是否可用，权限是否被禁用
    BOOL isHaveCamera= [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]; //判断是否有摄像头
    BOOL isAvailRear = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]; //判断后置摄像头是否可用
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]; //查询该应用摄像头权限
    
    if (isHaveCamera) {
        //有摄像头
        if (authStatus == AVAuthorizationStatusDenied) {
            //没有权限
            [self.view makeToast:@"请在iPhone的“设置-隐私-相机”中允许访问相机" duration:2.0 position:CSToastPositionCenter];
            
        }else{
            //有权限
            if (!isAvailRear) {
                //后置不可用
                [self.view makeToast:@"您的后置摄像头不可用" duration:1.0 position:CSToastPositionCenter];
                
            }else{
                //后置可用
#warning 扫一扫
                ZCZBarViewController *zbar=[[ZCZBarViewController alloc]initWithBlock:^(NSString *str, BOOL isSucceed) {
                    if (isSucceed) {
                        
                        self.redSatelliteID = str;
                        JSInfo(@"Config RedSatellite", @"添加红卫星界面RedSatelliteID: %@",self.redSatelliteID);
                        [self configSucceedUIChange];
                        
                    }else{
                        JSError(@"Scan QR Code RedStar", @" RedStar scan QR Code failed");
                        [self.view makeToast:@"没有扫描到信息" duration:1.0 position:CSToastPositionCenter];
                    }
                    
                }];
                
//                [self presentViewController:zbar animated:YES completion:nil];
                [self.navigationController pushViewController:zbar animated:YES];
            }
            
        }
        
    }else{
        //没有摄像头
        [self.view makeToast:@"您的手机没有摄像头" duration:1.0 position:CSToastPositionCenter];
    }
    
    
}


-(void)configSucceedUIChange{
    
    [self.stepView removeFromSuperview];
    self.stepView = nil;
    self.stepView = [[StepView alloc] initWithStepNameArray:@[@"设备状态",@"指示灯状态"] stepNumber:2];
    [self.view addSubview:self.stepView];

    self.guideImageView.image = IMAGE(@"RedSatellite_light02");
    
    
    self.explanStr = @"*请观察状态指示灯是否变更为蓝色长亮5秒后熄灭，如状态正常请点击确认后添加红卫星成功。\n状态指示灯如还是红色间隔闪烁，请点击重试。";
    NSString *headText = @"*请观察状态指示灯是否变更为蓝色长亮5秒后熄灭，如状态正常请点击确认后添加红卫星成功。";

    CGFloat heightStepLabel = [JSUtility heightForText:self.explanStr labelWidth:(SCREEN_WIDTH-20) fontOfSize:14];
    
    JSDebug(@"StepLabel", @"StepLabelText height, Second %f",heightStepLabel);
    
    [self.viewIntroduce setFrame:CGRectMake(0, 64+kStepView_Height+kIntroduceViewToStepViewBottom_Height, SCREEN_WIDTH, kGuideImageViewToIntroduceViewTop_Height+IMAGE(@"RedSatellite_light01").size.height + kStepLabelToGuideImageViewBottom_Height+ heightStepLabel+25 + kStepLabelBottomToIntroduceViewBottom_Height)];
    
    [self.stepLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideImageView.mas_bottom).offset(kStepLabelToGuideImageViewBottom_Height);
        make.centerX.equalTo(self.viewIntroduce);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, heightStepLabel+25));
    }];
    
    
    [self getStepLabelText:self.explanStr aheadText:headText];
    
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    
    self.retryBtn = [UIButton new];
    [self.view addSubview:self.retryBtn];
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(18);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [self.retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.retryBtn.backgroundColor = [UIColor whiteColor];
    self.retryBtn.layer.masksToBounds = YES;
    self.retryBtn.layer.cornerRadius = 8;
    [self.retryBtn setTitle:@"重试" forState:UIControlStateNormal];
    [self.retryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.retryBtn.titleLabel.font=[UIFont systemFontOfSize:15];

    
}



-(void)retryBtnClick:(UIButton *)btn{
    
    [self.stepView removeFromSuperview];
    self.stepView = nil;
    self.stepView = [[StepView alloc] initWithStepNameArray:@[@"设备状态",@"指示灯状态"] stepNumber:1];
    [self.view addSubview:self.stepView];
    
    self.guideImageView.image = IMAGE(@"RedSatellite_light01");
    
    self.explanStr = @"*请确认红卫星已连接电源并开启，状态指示灯呈红色间隔闪烁，点击扫描二维码添加红卫星。\n如状态指示灯不闪烁，请戳红卫星底部reset孔至初始状态。";
    NSString *headText = @"*请确认红卫星已连接电源并开启，状态指示灯呈红色间隔闪烁，点击扫描二维码添加红卫星。";

    CGFloat heightStepLabel = [JSUtility heightForText:self.explanStr labelWidth:(SCREEN_WIDTH-20) fontOfSize:14];
    
    JSDebug(@"StepLabel", @"StepLabelText height, Retry %f",heightStepLabel);
    
    
    [self.viewIntroduce setFrame:CGRectMake(0, 64+kStepView_Height+kIntroduceViewToStepViewBottom_Height, SCREEN_WIDTH, kGuideImageViewToIntroduceViewTop_Height+IMAGE(@"RedSatellite_light01").size.height + kStepLabelToGuideImageViewBottom_Height+ heightStepLabel+25 + kStepLabelBottomToIntroduceViewBottom_Height)];
    
    [self.stepLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideImageView.mas_bottom).offset(kStepLabelToGuideImageViewBottom_Height);
        make.centerX.equalTo(self.viewIntroduce);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, heightStepLabel+25));
    }];
    
    [self getStepLabelText:self.explanStr aheadText:headText];
    
    
    [self.button setTitle:@"扫描二维码" forState:UIControlStateNormal];
    
    [self.retryBtn removeFromSuperview];
    self.retryBtn = nil;
}


//#pragma Config配置
//-(void)notifiRedSatelliteConfig:(NSNotification *)notifi{
//    
//    NSDictionary *dict = notifi.userInfo;
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_RedSatelliteConfig object:nil];
//    
//    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            
//            [self configSucceedUIChange];
//            
//            [self hideHud];
//        });
//        
//    }else{
//        
//        JSError(@"RedSatelliteConfig", @"Red Satellite config fail errorCode: %@",dict[kSBEngine_ErrCode]);
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            
//            [self hideHud];
//            
//            [self.view makeToast:@"配置红卫星失败，请再次扫描二维码配置" duration:1.0 position:CSToastPositionCenter];
//        });
//        
//    }
//    
//}


#pragma 添加红卫星
-(void)notifiAddRedSatellite:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_AddRedSatellite object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
//            [self.view makeToast:@"添加红卫星成功" duration:1.0 position:CSToastPositionCenter];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:NSClassFromString(@"SmartHomeViewController")]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
        });
        
    }else{
        
        JSError(@"AddRedSatellite", @"add RedSatellite fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            
            [self.view makeToast:@"添加红卫星失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
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
