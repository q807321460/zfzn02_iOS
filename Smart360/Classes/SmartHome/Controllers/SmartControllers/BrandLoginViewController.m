//
//  BrandLoginViewController.m
//  Smart360
//
//  Created by michael on 15/11/4.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "BrandLoginViewController.h"

#import "SBApplianceEngineMgr.h"
#import "BrandAccountModel.h"

#import "BrandApplianceListViewController.h"

@interface BrandLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTf;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@end

@implementation BrandLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    self.view.backgroundColor = kDevicesManager_BackgroundColor;
    
#ifdef __SBApplianceEngine__HaveData__
    [self setNavigationItemWithTitle:[NSString stringWithFormat:@"%@账号",self.devicesOfBrandModel.brandName]];
#else
    [self setNavigationItemWithTitle:@"请输入账号"];
#endif
    
    //先create UI 再getData
    [self createLoginView];
    
    [self showHud];
    
    [self getData];
    
}

-(void)getData{
    
    
#ifdef __SBApplianceEngine__HaveData__
    [SBApplianceEngineMgr getRegistedBrandAccount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiGetRegBrandAccount:) name:kNotifi_SBApplianceEngineCallBack_Event_GetRegistedBrandAccount object:nil];
    
#else
    [self hideHud];
    
#endif
    
}

-(void)notifiGetRegBrandAccount:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_GetRegistedBrandAccount object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        NSArray *array = [NSArray new];
        array = dict[kSBEngine_Data];
        JSDebug(@"BrandAccount", @"brand count: %lu",(unsigned long)array.count);
        
        for (BrandAccountModel *accountModel  in array) {
            if ([accountModel.brandName isEqualToString:self.devicesOfBrandModel.brandName]) {
                self.account = accountModel.userName;
                self.password = accountModel.password;
                break;
            }
        }
        
        if ( !self.account || (self.account.length == 0) ) {
            //没有账号信息
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self hideHud];
                [self.view makeToast:@"请输入账号" duration:1.0 position:CSToastPositionCenter];
            });
            
        }else{
            //有账号信息（可能为空字符串）
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self hideHud];
                self.accountTf.text = self.account;
                self.passwordTf.text = self.password;
                
            });
            
        }
        
    }else if ( 2001 == [dict[kSBEngine_ErrCode] intValue]){
        
        JSDebug(@"BrandAccount", @"have no account, errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"请输入账号" duration:1.0 position:CSToastPositionCenter];
        });
    
    }else{
        
        JSError(@"BrandAccount", @"get BrandAccount fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"获取数据失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        });
        
    }
    
}



- (void)createLoginView {
    UIImageView *bacImageView1 = [[UIImageView alloc] init];
    bacImageView1.image = IMAGE(@"bgkuang");
    [self.view addSubview:bacImageView1];
    UIImageView *smallImageView1 = [[UIImageView alloc] init];
    smallImageView1.image = IMAGE(@"Home_Ico_user");
    //    smallImageView1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:smallImageView1];
    
    _accountTf = [[UITextField alloc] init];
    //    _accountTf.layer.borderColor = [UIColor grayColor].CGColor;
    //    _accountTf.layer.borderWidth = 1.f;
    _accountTf.placeholder = @"请输入账号";
    _accountTf.delegate = self;
    _accountTf.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_accountTf];
    UIImage *smallImage =  IMAGE(@"Login_Ico_PW");
    UIImageView *bacImageView2 = [[UIImageView alloc] init];
    bacImageView2.image = IMAGE(@"bgkuang");
    [self.view addSubview:bacImageView2];
    UIImageView *smallImageView2 = [[UIImageView alloc] init];
    smallImageView2.image = smallImage;
    //    smallImageView2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:smallImageView2];
    _passwordTf = [[UITextField alloc] init];
    //    _passwordTf.layer.borderColor = [UIColor grayColor].CGColor;
    //    _passwordTf.layer.borderWidth = 1.f;
    _passwordTf.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTf.placeholder = @"请输入密码";
    _passwordTf.delegate = self;
    _passwordTf.secureTextEntry = YES; //密码
    [self.view addSubview:_passwordTf];
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = UIColorFromRGB(0xff6868);
    [_loginBtn setOnClickSelector:@selector(buttonClick:) target:self];
    [self.view addSubview:_loginBtn];
    
    
    [bacImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    [smallImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(smallImage.size);
        make.centerY.equalTo(bacImageView1);
        make.left.equalTo(bacImageView1).offset(15);
    }];
    
    [_accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(bacImageView1);
        make.left.equalTo(smallImageView1.mas_right).offset(15);
        make.right.equalTo(bacImageView1);
    }];
    
    [bacImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(bacImageView1.mas_bottom).offset(-1);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    [smallImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(smallImage.size);
        make.centerY.equalTo(bacImageView2);
        make.left.equalTo(bacImageView1).offset(15);
    }];
    
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(bacImageView2);
        make.left.equalTo(smallImageView2.mas_right).offset(15);
        make.right.equalTo(bacImageView2);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(bacImageView2.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    
}
-(void)buttonClick:(UIButton *)btn{

    if ( (self.accountTf.text.length == 0) || [self.accountTf.text isEmptyOrNull] ) {
        
        [self.view makeToast:@"请输入账号" duration:1.0 position:CSToastPositionCenter];
        
        return;
    }
    
    if ( (self.passwordTf.text.length == 0) || [self.passwordTf.text isEmptyOrNull] ) {
        
        [self.view makeToast:@"请输入密码" duration:1.0 position:CSToastPositionCenter];
        
        return;
    }
    
    [self.view endEditing:YES];
    
    
    
#ifdef __SBApplianceEngine__HaveData__
    
//    if ([self.account isEqualToString:self.accountTf.text]&&[self.password isEqualToString:self.passwordTf.text]) {
//        //账号信息没变
//        
//        BrandApplianceListViewController *brandApplianceListVC = [[BrandApplianceListViewController alloc] init];
//        brandApplianceListVC.roomID = self.roomID;
//        brandApplianceListVC.brandID = self.devicesOfBrandModel.brandID;
//        
//        [self.navigationController pushViewController:brandApplianceListVC animated:YES];
//        
//        
//    }else{
    
        //账号信息变化
    
    [self showHud];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiSetBrandAccount:) name:kNotifi_SBApplianceEngineCallBack_Event_SetBrandAccount object:nil];
    
        [SBApplianceEngineMgr setBrandAccount:self.devicesOfBrandModel.brandID userName:self.accountTf.text password:self.passwordTf.text];
    

//    }
    
#else
    
    BrandApplianceListViewController *brandApplianceListVC = [[BrandApplianceListViewController alloc] init];
    [self.navigationController pushViewController:brandApplianceListVC animated:YES];
    
#endif
    
}

-(void)notifiSetBrandAccount:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_SetBrandAccount object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {

        dispatch_async(dispatch_get_main_queue(), ^(void){
                
            [self hideHud];
            [self.view makeToast:@"账号正确" duration:1.0 position:CSToastPositionCenter];
            
            BrandApplianceListViewController *brandApplianceListVC = [[BrandApplianceListViewController alloc] init];
            brandApplianceListVC.roomID = self.roomID;
            brandApplianceListVC.brandID = self.devicesOfBrandModel.brandID;
            [self.navigationController pushViewController:brandApplianceListVC animated:YES];
            
        });
        
        

    }else{
        
        JSError(@"SetBrandAccount", @"set BrandAccount fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            [self.view makeToast:@"账号信息错误，请重新输入" duration:1.0 position:CSToastPositionCenter];
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
