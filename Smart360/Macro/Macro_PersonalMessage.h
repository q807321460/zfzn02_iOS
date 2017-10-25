//
//  Macro_PersonalMessage.h
//  Smart360
//
//  Created by sun on 15/7/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_PersonalMessage_h
#define Smart360_Macro_PersonalMessage_h
//右侧栏显示宽度
#define kRightSide_Width SCREEN_WIDTH - kRightSide_Gap
#define kRightSide_Gap 40

//左侧栏
#define kPersonnalMessageCell_Height 44

#define kPersonnalMessageTitleLabe_Left 0.1875 * SCREEN_WIDTH
#define kPersonnalMessageTitleLabe_Width kRightSide_Width
#define kPersonnalMessageTitleLabe_Height kPersonnalMessageCell_Height - 10

#define kPersonnalMessageIconLeftImag_Left 0.07 * SCREEN_WIDTH
#define kPersonnalMessageIconRightImag_Right 0.0625 * SCREEN_WIDTH

#define kPersonnalMessagePhoto_Width 99
#define kPersonnalMessagePhotoAndButton_Gap 0.025 * SCREEN_HEIGHT
#define kPersonnalMessageButton_Bottom 0.045 * SCREEN_HEIGHT
#define kPersonnalMessageButton_Width 0.35 * SCREEN_WIDTH
#define kPersonnalMessageButton_Height (0.25 * kPersonnalMessageButton_Width)

#define kPersonnalMessageHeaderView_Height (kPersonnalMessagePhoto_Width + kPersonnalMessagePhotoAndButton_Gap + kPersonnalMessageButton_Bottom + kPersonnalMessageButton_Height + 20)

//服务类型
#define kServiceTypeBackView_Left 0.032 * SCREEN_WIDTH
#define kServiceTypeBackView_Right kServiceTypeBackView_Left

#define kServiceTypeGap 1.3 * kServiceTypeBackView_Left
#define kServiceTypeTitleLabel_Width 150
#define kServiceTypeTitleLabel_Height 30
#define kServiceTypeContentLabel_Width 0.625 * SCREEN_WIDTH
#define kEditMessageCell_Height 50

//编辑资料
#define kEditMessageTitleLabe_Left 20
#define kEditMessageTitleLabe_Width 0.35 * SCREEN_WIDTH
#define kEditMessageTitleLabe_Height kEditMessageCell_Height - 10

//#define kEditMessageTextField_Left 5
#define kEditMessageTextField_Width 0.25 * SCREEN_WIDTH
#define kEditMessageTextField_Height kEditMessageCell_Height - 10


#define kEditMessageHeaderView_Height 0.275 * SCREEN_WIDTH
#define kEditMessageFootView_Height (SCREEN_HEIGHT - kEditMessageCell_Height * 4 - kEditMessageHeaderView_Height - 64)

//设置界面
#define kSettingHeaderView_Height 55
#define kMessageCenterHeaderView_Height 70

#define kFreePaymentsView_Height 60
#define kFreePaymentsTextLabel_Height 50
#define kFreePaymentsTextLabel_Width   0.70 * SCREEN_WIDTH
#define kFreePaymentsSwitchButton_Width  0.15 * SCREEN_WIDTH
#define kFreePaymentsButtonAndLabe_Gap (SCREEN_WIDTH - kFreePaymentsTextLabel_Height - kFreePaymentsTextLabel_Width)

//
#define kVouchersLabel_Width 0.75 * SCREEN_WIDTH
#define kVouchersLabel_Height 20
#define kVouchersImageView_Width 0.75 * SCREEN_WIDTH
#define kVouchersImageView_Height 80

//
#define kBalanceRoundView_Width 100
#define kBalanceLabel_Width kBalanceRoundView_Width
#define kBalanceLabel_Height 25
//#define kBalanceLabel_Top 5

//
#define kRechargeLabel_Height 40
#define kRechargeLabel_Width 0.35 * SCREEN_WIDTH
#define kRechargeTexeField_Width (SCREEN_WIDTH - 0.35 * SCREEN_WIDTH - 10)

//订单管理
#define kOrderLabel_Top 30
#define kOrderLabel_Width 0.5 * SCREEN_WIDTH
#define kOrderLabel_Height 40
#define kOrderTableViewCell_Height 45
#define kOrderTableView_Width 0.65 * SCREEN_WIDTH
#define kOrderTableView_Height kOrderTableViewCell_Height * 3

#define kCreditCardHeaderView_Height 40


//相册选择
#define kGallerySelectedCell_Height 50
#define kGallerySelected_Gap 20
#define kGallerySelectedCoverImage_Height kGallerySelectedCell_Height
#define kGallerySelectedCoverImage_Width kGallerySelectedCell_Height
#define kGallerySelectedNameLabel_Width (SCREEN_WIDTH - kGallerySelectedCoverImage_Width - kGallerySelected_Gap * 2)
#define kGallerySelectedNameLabel_Height 40
//#define kGallerySelectedNumberLabel_Width kGallerySelectedNameLabel_Width
//#define kGallerySelectedNumberLabel_Height kGallerySelectedNameLabel_Height

//头像选择
#define kPhotoSelectedItem_Width (SCREEN_WIDTH - 2) / 3
#define kPhotoSelectedItemSize CGSizeMake(kPhotoSelectedItem_Width,kPhotoSelectedItem_Width)
//#define kPhotoSelectedItemGap (SCREEN_WIDTH - 3 * kPhotoSelectedItem_Width) / 3.00

//选择标签
#define kSelectedViewItem_Width (SCREEN_WIDTH) / 3
#define kSelectedViewItem_Height 50

//消息中心
//#define kMessageCenterLabel_Width 
#define kMessageCenterLabel_Height 25
#define kMessageCenterDateLabel_Width 95
#define kMessageCenter_Gap (68 - kMessageCenterLabel_Height * 2) / 2

//地址管理
#define kAddressManageNameLabel_Width 100
#define kAddressManageNameLabel_Hight 20
#define kAddressPhoneNumberLabel_Width 120
#define kAddressPhoneNumberLabel_Hieht 20
#define kAddressTypeLabel_Hieht 17
//支付密码
#define kPaymentPasswordField_Width SCREEN_WIDTH - 50.0f
#define kPaymentPasswordField_Height 45.0f
#define kPaymentPasswordField_Left 25
#define kPaymentPasswordField_Top 50
#define kPaymentPasswordLabel_Top 40




#endif
