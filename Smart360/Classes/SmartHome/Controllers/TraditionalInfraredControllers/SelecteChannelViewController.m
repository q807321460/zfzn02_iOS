//
//  SelecteChannelViewController.m
//  Smart360
//
//  Created by sun on 15/12/30.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SelecteChannelViewController.h"
#import "ChannelView.h"
#import "CustomSelectedChannelView.h"
#import "ChannelModel.h"
#import "SelecteSinatvView.h"
#import "SBApplianceEngineMgr.h"
#import "DeviecNameTypeModel.h"
#import "ApplianceModel.h"

@interface SelecteChannelViewController ()<ChannelViewDelegate,SelecteSinatvViewDelegate>
{
    NSInteger currentselectedChannelViewTag;
    BOOL isBack;
}

@property (nonatomic, strong) NSMutableArray *channelDataArray;
@property (nonatomic, strong) ChannelView *selecteChannelView;
@property (nonatomic, strong) SelecteSinatvView *selecteSinatvView;
@property (nonatomic, strong) NSArray *allSinatvArray;
@property (nonatomic, strong) NSMutableArray *selectedSinatvArray;
@property (nonatomic, strong) NSMutableDictionary *selectedSinatvDic;
@property (nonatomic, strong) NSMutableArray *sinatvArray;

@end

@implementation SelecteChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    if (self.isFirstAdd) {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)",self.deviceNameTypeModel.deviceType,self.brandName] withFont:kTitleLabel_Font withTitleColor:kTitleLabel_Color];

    }else{
        [self setTitle:[NSString stringWithFormat:@"%@(%@)",self.applianceModel.deviceType,self.applianceModel.brandName] withFont:kTitleLabel_Font withTitleColor:kTitleLabel_Color];

    }
    
    
//    [self setNavigationItemRightButtonWithTitle:@"保存"];
    [self createSelecteChannelView];
    
}

- (void)createSelecteChannelView {
    //第一次添加设备
    if (self.isFirstAdd) {
        for (int i = 0; i < kChannelCount; i ++) {
            ChannelModel *channelData = [[ChannelModel alloc] init];
            [self.channelDataArray addObject:channelData];
        }

    } else {
        [self getSinatvDataFromWeb];
    }
    
    self.selecteChannelView = [[ChannelView alloc] initWithChanndelArray:self.channelDataArray];
    self.selecteChannelView.channelViewDelegate = self;
    [self.view addSubview:_selecteChannelView];
    
}

- (void)getSinatvDataFromWeb {
    self.channelDataArray = [NSMutableArray arrayWithArray:self.applianceModel.channelArray];
    [self machChannelDataArrayAndSelectedSinatvDic];
}

- (void)machChannelDataArrayAndSelectedSinatvDic {
    if (self.channelDataArray.count > 0) {
        for (int i = 0; i < kChannelCount; i ++) {
            if (i <= self.channelDataArray.count - 1) {
                [self.selectedSinatvDic setObject:self.channelDataArray[i] forKey:[NSString stringWithFormat:@"%d",300 + i]];
            } else {
                ChannelModel *channelData = [[ChannelModel alloc] init];
                [self.channelDataArray addObject:channelData];
            }
        }
    } else {
        for (int i = 0; i < kChannelCount; i ++) {
            ChannelModel *channelData = [[ChannelModel alloc] init];
            [self.channelDataArray addObject:channelData];
        }

    }

}

#pragma mark - ChannelViewDelegate

- (void)clickChangeViewWithMarkTag:(NSInteger)markTag {
    isBack = NO;
    [self setNavigationItemRightButtonWithTitle:@"  "];
    currentselectedChannelViewTag = markTag;
    self.sinatvArray = [NSMutableArray arrayWithArray:self.allSinatvArray];
    if (self.selectedSinatvDic.count > 0) {
        NSArray *selectdeArray = [self.selectedSinatvDic allValues];
        NSMutableArray *mutSelectdeArray = [NSMutableArray array];
        for (ChannelModel *channleData in selectdeArray) {
            NSString *selectedChannelName = channleData.name;
            [mutSelectdeArray addObject:selectedChannelName];
        }
        [self.sinatvArray removeObjectsInArray:mutSelectdeArray];
    }
    
    self.selecteSinatvView = [[SelecteSinatvView alloc] initWithSinatvDataArray:self.sinatvArray];
    self.selecteSinatvView.sinagvDelegate = self;
    [self.selecteSinatvView showSinatvView];
}


#pragma mark - SelecteSinatvViewDelegate

- (void)selectedSinatv:(NSString *)sinatv {
    isBack = YES;
    [self setNavigationItemRightButtonWithTitle:@"保存"];
        CustomSelectedChannelView *selectedChannelView = (CustomSelectedChannelView *)
    [self.selecteChannelView viewWithTag:currentselectedChannelViewTag];
    UIButton *channelNameBtn = (UIButton *)[selectedChannelView viewWithTag:201];
    [channelNameBtn setTitle:sinatv forState:UIControlStateNormal];
    UITextField *channelNumberTextField = (UITextField *)[selectedChannelView viewWithTag:200];
    NSString *channelNumber = channelNumberTextField.text;
    ChannelModel *selectChannelModel = [[ChannelModel alloc] init];
    selectChannelModel.name = sinatv;
    if (channelNumber.length == 0) {
        selectChannelModel.channel = @"0";
    } else {
        selectChannelModel.channel = channelNumber;
    }
    [self.selectedSinatvDic setObject:selectChannelModel forKey:[NSString stringWithFormat:@"%ld",(long)currentselectedChannelViewTag]];
    [self.selecteSinatvView closeSinatvView];
}

#pragma  mark - leftItemClicked
- (void)leftItemClicked:(id)sender {
    if (isBack) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self setNavigationItemRightButtonWithTitle:@"保存"];
        [self.selecteSinatvView closeSinatvView];
        isBack = YES;
    }
}

#pragma  mark - rightItemClicked 保存选择的频道
- (void)rightItemClicked:(id)sender {
    if (isBack) {
        for (int i = 0; i < kChannelCount; i ++) {
            CustomSelectedChannelView *selectedChannelView = (CustomSelectedChannelView *)[self.selecteChannelView viewWithTag:300 + i];
            UIButton *channelNameBtn = (UIButton *)[selectedChannelView viewWithTag:201];
            
            UITextField *channelNumberTextField = (UITextField *)[selectedChannelView viewWithTag:200];
            
            NSString *channelName = channelNameBtn.titleLabel.text;
            NSString *channelNumber = channelNumberTextField.text;
            if ([channelNumber intValue] > 0 && channelName.length > 0) {
                ChannelModel *channelModel = [[ChannelModel alloc] initWithChannelNumber:channelNumber channelName:channelName];
                NSLog(@"%@",channelModel);
                [self.selectedSinatvArray addObject:channelModel];
                
            }
            
        }
        
        //调接口
//        if (self.isFirstAdd) {
            //添加
            [self showHud];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiAddTVInfrared:) name:kNotifi_SBApplianceEngineCallBack_Event_AddInfrared object:nil];
//            
//            [SBApplianceEngineMgr addInfraredDevice:self.roomID brandName:self.brandName deviceName:self.deviceNameTypeModel.deviceName devAlias:self.deviceNameTypeModel.deviceName devType:self.deviceNameTypeModel.deviceType channelArray:self.selectedSinatvArray];
            
            [SBApplianceEngineMgr modifyDevNormalChannelsBrandName:self.applianceModel.brandName deviceName:self.deviceNameTypeModel.deviceName devType:self.deviceNameTypeModel.deviceType devID:self.applianceModel.deviceID channelArray:self.selectedSinatvArray withSuccessBlock:^(NSString *result) {
                [self hideHud];
                [self.navigationController popViewControllerAnimated:YES];
            } withFailBlock:^(NSString *msg) {
                [self hideHud];
                [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];

            }];
    }
    
}


#pragma mark - 添加电视机



#pragma mark - 懒加载
//
- (NSMutableArray *)channelDataArray {
    if (!_channelDataArray) {
        _channelDataArray = [NSMutableArray array];
    }
    
    return _channelDataArray;
}

- (NSArray *)allSinatvArray {
    if (!_allSinatvArray) {
        _allSinatvArray = @[@"央视一套",@"央视二套",@"央视三套",@"央视四套",@"央视五套",@"央视六套",@"央视七套",@"央视八套",@"央视九套",@"央视十套",@"央视十一套",@"央视十二套",@"央视少儿",@"央视音乐",@"央视英语",@"央视新闻",@"东方卫视",@"湖南卫视",@"北京卫视",@"浙江卫视",                        @"山东卫视",@"江苏卫视",@"贵州卫视",@"湖北卫视",@"深圳卫视",@"天津卫视",@"重庆卫视",@"安徽卫视",@"四川卫视",@"河南卫视",@"吉林卫视",@"云南卫视",@"辽宁卫视",@"黑龙江卫视",@"东南卫视",@"广西卫视",@"旅游卫视",@"河北卫视",@"江西卫视",@"内蒙古卫视",@"山西卫视",@"广东卫视", @"青海卫视",@"甘肃卫视",@"宁夏卫视",@"厦门卫视",@"兵团卫视",@"西藏卫视",@"陕西卫视"];
        
    }
    return _allSinatvArray;
}

- (NSMutableArray *)selectedSinatvArray {
    if (!_selectedSinatvArray) {
        _selectedSinatvArray = [NSMutableArray array];
    }
    
    return _selectedSinatvArray;

}

- (NSMutableArray *)sinatvArray {
    if (!_sinatvArray) {
        _sinatvArray = [NSMutableArray array];
    }
    
    return _sinatvArray;

}

- (NSMutableDictionary *)selectedSinatvDic {
    if (!_selectedSinatvDic) {
        _selectedSinatvDic = [NSMutableDictionary dictionary];
    }
    return _selectedSinatvDic;
}










// 接口方法  房间推送
//注意dict中model可能为空
-(void)updateRoomNotifi:(NSMutableDictionary *)notifiDict{
    
}


// 接口方法  家电设备推送
//注意dict中model可能为空
-(void)updateDeviceNotifi:(NSMutableDictionary *)notifiDict{
    
    if (!self.isFirstAdd) {
    //详情
        
        ApplianceModel *notifiApplianceModel = [[ApplianceModel alloc] init];
        notifiApplianceModel = notifiDict[kNotifi_UpdateRoom_Notifi_ApplianceModel];
        
        if (notifiApplianceModel) {
            self.applianceModel = notifiApplianceModel;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self getSinatvDataFromWeb];
                
            });
        }
        

    }
    
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
