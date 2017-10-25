//
//  RoomTableViewCell.m
//  Smart360
//
//  Created by michael on 15/11/3.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "RoomTableViewCell.h"

#import "RoomContainApplianceModel.h"
#import "RoomModel.h"
#import "ApplianceModel.h"
#import "PlugModel.h"
#import "BrandAccountModel.h"
#import "ChannelModel.h"
#import "DevicesOfBrandModel.h"
#import "DeviecNameTypeModel.h"


#import "ApplianceModel.h"
#import "PlugModel.h"

#import "SBAEngineDataMgr.h"



@interface RoomTableViewCell ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView *headLineView;

@property (nonatomic, strong) UIView *devicesView;



@end

@implementation RoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUIView];
        
    }
    return self;
    
}

-(void)createUIView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 56+88)];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    
    self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-35-15, 0, 70, 2)];
    self.headLineView.backgroundColor = UIColorFromRGB(0xfe6869);
    [self.backView addSubview:self.headLineView];
    
    
    self.roomNameButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-35-15, 15, 70, 16)];
    ////    [[UILabel alloc] initWithFrame:CGRectMake(35, 15, SCREEN_WIDTH-100, 16)];
    //    self.roomNameLabel.textColor = UIColorFromRGB(0x333333);
    //    self.roomNameLabel.textAlignment = NSTextAlignmentCenter;
    //    self.roomNameLabel.font = [UIFont systemFontOfSize:16];
    //    self.roomNameLabel.text = self.roomContainApplianceModel.roomModel.name;
    [self.roomNameButton addTarget:self action:@selector(changeRoomNameClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:self.roomNameButton];
    
}


-(void)showDataWithModel:(RoomContainApplianceModel *)roomContainApplianceModel{
    
    self.roomContainApplianceModel = roomContainApplianceModel;
    
    self.backView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 56+88*((roomContainApplianceModel.applianceModelArray.count/4)+1));
    
    [self.roomNameButton setTitle:roomContainApplianceModel.roomModel.name andTitleColor:UIColorFromRGB(0x333333) andTitleFont:16];
    NSLog(@"ProSN: %@",roomContainApplianceModel.roomModel.ProSN);
    
    
    if (self.devicesView) {
        [self.devicesView removeFromSuperview];
    }
    self.devicesView = nil;
    
    self.devicesView = [UIView new];
    [self.backView addSubview:self.devicesView];
    self.devicesView.frame = CGRectMake(0, 46, self.backView.bounds.size.width, self.backView.bounds.size.height);
    
    
    CGFloat spaceWidth = (SCREEN_WIDTH-280)/3.0 +55;
    
    for (int i = 0; i < roomContainApplianceModel.applianceModelArray.count+1; i++) {
        
        UIButton *button = [UIButton new];
        button.tag = 1000+i;
        button.frame = CGRectMake(15+spaceWidth*(i%4), 88*(i/4), 55, 76);
        [self.devicesView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        //调试 button image title 位置 使用以下代码
        //        button.layer.masksToBounds = YES;
        //        button.layer.cornerRadius = 2;
        //        button.layer.borderWidth = 1;
        //        button.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){ 0, 0, 1, 1 });
        //        // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
        
        if (i == roomContainApplianceModel.applianceModelArray.count) {
            
            [button setImage:IMAGE(@"Home_Ico_add") forState:UIControlStateNormal];
            NSString *strTitle = @"添加";
            [button setTitle:strTitle andTitleColor:UIColorFromRGB(0x999999) andTitleFont:12];
#warning 注意屏幕适配
            
            CGFloat widthTitle = [NSString widthForText:strTitle fontOfSize:12 width:55];
            
            
            button.titleEdgeInsets = UIEdgeInsetsMake(55+9, -IMAGE(@"Home_Ico_add").size.width, 0, 0);  //top left bottom right
            button.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, -widthTitle);
            
            
//            //            button.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0); //此行也行
//            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        }else{
            
            ApplianceModel *applianceModel = roomContainApplianceModel.applianceModelArray[i];
            [button setImage:[SBAEngineDataMgr matchIconNameWithApplianceName:applianceModel] forState:UIControlStateNormal];
            
            NSString *strATitle = [SBAEngineDataMgr matchNameWithApplianceModel:applianceModel];
            [button setTitle:strATitle andTitleColor:UIColorFromRGB(0x999999) andTitleFont:12];
#warning 注意屏幕适配
            
            
            
            CGFloat widthTitle = [NSString widthForText:strATitle fontOfSize:12 width:55];
            
            
            button.titleEdgeInsets = UIEdgeInsetsMake(55+9,  -IMAGE(@"Home_Ico_add").size.width, 0, 0);  //top left bottom right
            button.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, -widthTitle);
            //            button.contentEdgeInsets
            //            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            //            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        }
        
    }
    
}





-(void)buttonClick:(UIButton *)btn {
    
    BOOL isDevice;
    if (self.roomContainApplianceModel.applianceModelArray.count+1000 == btn.tag) {
        //不是设备
        isDevice = NO;
    }else{
        //是设备
        isDevice = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(clickApplianceDelegate:number:isDevice:)]) {
        [self.delegate clickApplianceDelegate:self.roomContainApplianceModel number:(btn.tag-1000) isDevice:isDevice];
    }
    
    
    JSDebug(@"SmartHomeVC_Cell", @"redSatelliteID:%@ , roomName:%@ ",self.roomContainApplianceModel.roomModel.redSatelliteID,self.roomContainApplianceModel.roomModel.name);
    
    
}

-(void)changeRoomNameClick:(UIButton *)btn{
    
    JSDebug(@"changeRoomName", @"click");
    
    if ([self.delegate respondsToSelector:@selector(clickChangeRoomNameDelegate:)]) {
        [self.delegate clickChangeRoomNameDelegate:self.roomContainApplianceModel];
    }
}




//
//- (void)setRoomContainApplianceModel:(RoomContainApplianceModel *)roomContainApplianceModel {
//    if (_roomContainApplianceModel != roomContainApplianceModel) {
//        _roomContainApplianceModel = roomContainApplianceModel;
//    }
//    
//    
//    self.backView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 56+88*((roomContainApplianceModel.applianceModelArray.count/4)+1));
//    
//    [self.roomNameButton setTitle:roomContainApplianceModel.roomModel.name andTitleColor:UIColorFromRGB(0x333333) andTitleFont:16];
//    
//    
//    
//    if (self.devicesView) {
//        [self.devicesView removeFromSuperview];
//    }
//    self.devicesView = nil;
//    
//    self.devicesView = [UIView new];
//    [self.backView addSubview:self.devicesView];
//    self.devicesView.frame = CGRectMake(0, 46, self.backView.bounds.size.width, self.backView.bounds.size.height);
//    
//    
//    
//    
//    CGFloat spaceWidth = (SCREEN_WIDTH-280)/3.0 +55;
//    
//    for (int i = 0; i < roomContainApplianceModel.applianceModelArray.count+1; i++) {
//        
//        UIButton *button = [UIButton new];
//        button.tag = 1000+i;
//        button.frame = CGRectMake(15+spaceWidth*(i%4), 88*(i/4), 55, 76);
//        [self.devicesView addSubview:button];
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        //        //调试 button image title 位置 使用以下代码
//        //        button.layer.masksToBounds = YES;
//        //        button.layer.cornerRadius = 2;
//        //        button.layer.borderWidth = 1;
//        //        button.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){ 0, 0, 1, 1 });
//        //        // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
//        
//        if (i == roomContainApplianceModel.applianceModelArray.count) {
//            
//            [button setImage:IMAGE(@"Home_Ico_add") forState:UIControlStateNormal];
//            [button setTitle:@"" forState:UIControlStateNormal];
//#warning 注意屏幕适配
//            //            button.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0); //此行也行
//            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        }else{
//            
//            ApplianceModel *applianceModel = roomContainApplianceModel.applianceModelArray[i];
//            [button setImage:[self matchIconNameWithApplianceName:applianceModel.name] forState:UIControlStateNormal];
//            [button setTitle:applianceModel.name andTitleColor:UIColorFromRGB(0x999999) andTitleFont:12];
//#warning 注意屏幕适配
//            button.titleEdgeInsets = UIEdgeInsetsMake(55+9, -55, 0, 0);  //top left bottom right
//            button.imageEdgeInsets = UIEdgeInsetsMake(-20, -20, 0, -55);
//            //            button.contentEdgeInsets
//            //            button.titleLabel.textAlignment = NSTextAlignmentCenter;
//            //            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//        }
//        
//    }
//    
//    
//    
//}



//#pragma mark - createCollectionView
//- (void)createCollectionView {
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    //滚动方向
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    //    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    //行间距(最小值)
//    flowLayout.minimumLineSpacing = 5;
//    //    //item 之间的间距(最小值)
//    flowLayout.minimumInteritemSpacing = 0;
//    //item大小
//    flowLayout.itemSize = CGSizeMake(kMainCellItem_Width , kMainCellItem_Height);
//    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 46, SCREEN_WIDTH - 60, 200) collectionViewLayout:flowLayout];
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    _collectionView.backgroundColor = UIColorFromRGB(0x3f3c51);
//    //    _collectionView.backgroundColor = [UIColor whiteColor];
//    [_collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"mainCollectionViewCell"];
//    //    _collectionView.backgroundColor = [UIColor cyanColor];
//    self.collectionView.scrollEnabled = NO;
//    [self.backView addSubview:_collectionView];
//    //    self.backgroundColor = [UIColor redColor];
//}







//-(void)changeRoomNameClick:(UIButton *)btn{
//    
//    JSDebug(@"changeRoomName", @"click");
//    
//    AddRoomViewController *addRoomVC = [[AddRoomViewController alloc] init];
//    
//    [self.homeVC.navigationController pushViewController:addRoomVC animated:YES];
//}

//-(void)buttonClick:(UIButton *)btn{
//    
//    if (self.roomContainApplianceModel.applianceModelArray.count+1000 == btn.tag) {
//        JSDebug(@"点击",@"点击添加家电");
//        
//#ifdef __SBApplianceEngine__HaveData__
//        if ([self isHaveRedSatellite]) {
//            //有红卫星
//            //电视
//            SelectDeviceTypeViewController *selectDevTypeVC = [[SelectDeviceTypeViewController alloc] init];
//            [self.homeVC.navigationController pushViewController:selectDevTypeVC animated:YES];
//            
//            
//        }else{
//            //没有红卫星
//            AddRedSatelliteViewController *addRedSatelliteVC = [[AddRedSatelliteViewController alloc] init];
//            addRedSatelliteVC.roomID = self.roomContainApplianceModel.roomModel.roomID;
//            [self.homeVC.navigationController pushViewController:addRedSatelliteVC animated:YES];
//        }
//#else
//        
//        
//#if 1
//        //电视
//        SelectDeviceTypeViewController *selectDevTypeVC = [[SelectDeviceTypeViewController alloc] init];
//        [self.homeVC.navigationController pushViewController:selectDevTypeVC animated:YES];
//#else
//        //红卫星
//        AddRedSatelliteViewController *addRedSatelliteVC = [[AddRedSatelliteViewController alloc] init];
//        addRedSatelliteVC.roomID = self.roomContainApplianceModel.roomModel.roomID;
//        [self.homeVC.navigationController pushViewController:addRedSatelliteVC animated:YES];
//        
//#endif
//#endif
//        
//        
//    }else{
//        
//        JSDebug(@"点击", @"点击进入家电");
//        
//        ApplianceModel *applianceModel = self.roomContainApplianceModel.applianceModelArray[btn.tag-1000];
//        
//        JSDebug(@"brandID_name", @"name:%@ , brandID: %d, btn.tag:%d",applianceModel.name,applianceModel.brandID,btn.tag-1000);
//        
//    }
//    
//    
//    
//}

//#pragma mark - 是否有红卫星
//-(BOOL)isHaveRedSatellite{
//    
//    ApplianceModel *applianceModel = [[ApplianceModel alloc] init];
//    
//    for (int i=0; i<self.roomContainApplianceModel.applianceModelArray.count; i++) {
//        
//        applianceModel = self.roomContainApplianceModel.applianceModelArray[i];
//        if ([applianceModel.deviceType isEqualToString:@"红卫星"]) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
