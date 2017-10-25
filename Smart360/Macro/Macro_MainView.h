//
//  Macro_MainView.h
//  Smart360
//
//  Created by sun on 15/7/29.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_MainView_h
#define Smart360_Macro_MainView_h

#pragma mark - BannerView

#define kBannerView_Width SCREEN_WIDTH
#define kBannerView_Height SCREEN_WIDTH * kBannerView_Scalele
#define kBannerView_Scalele (146.000 / 320.000)
#define kBannerImageView_Gap 3
#define kPageControl_Width (SCREEN_WIDTH * 0.75)
#define kPageControl_Height 15

#pragma mark - MainImageView1
#define kButtonImageView_BounceGap (0.02 * SCREEN_WIDTH)
#define kButtonImageView_Width (0.47 * SCREEN_WIDTH)
#define kButtonImageView_Height (0.875 * kButtonImageView_Width)
#define kButtonImageView_Gap (SCREEN_WIDTH - kButtonImageView_BounceGap * 2 - kButtonImageView_Width * 2)
#define kTitleLabel_Width kButtonImageView_Width
#define kTitleLabel_Height 16


#pragma mark - MainImageView2
#define kMainCellItem_BounceGap 13
#define kMainCellItem_Width (SCREEN_WIDTH - kMainCellItem_BounceGap - 5) / 2
#define kMainCellItem_Height kMainCellItem_Width * kMainCell_Scale
#define kMainCellItem_Gap  5
#define kMainCell_Scale (250.000 / 302.000)

#endif
