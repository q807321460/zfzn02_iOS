//
//  Macro_MyMusic.h
//  Smart360
//
//  Created by sun on 15/10/15.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_MyMusic_h
#define Smart360_Macro_MyMusic_h

//喜马拉雅参数
//旧的AppKey5b576fe6dd63b4c16759849af2d611cd
//AppSecret:71895f5d8837231c23e9e6db5139b7c8
#define XiMaLaMaYa_AppKey @"e51c9547df6a1ebd803a484a87759602"
#define XiMaLaMaYa_AppSecret @"bd452707f7873c71f9f892dc939e74e6"
#define XiMaLaMaYa_ServerAuthenticateStaticKey @"iyicdxCH"


//红蜻蜓参数
#define QingTing_ClientSecret @"ODg1YjJhOWItNDQzNC0zNzM0LWI0ZmItNmVjMzI1Zjc0MzZi"
#define QingTing_ClientID @"YjM1NmVjMjAtNzk1MS0xMWU1LTkyM2YtMDAxNjNlMDAyMGFk"

#define QingTing_GetAccesstoken @"http://api.open.qingting.fm/access?grant_type=client_credentials"
//获取点播所有分类
#define QingTing_Categories(accessToken) [NSString stringWithFormat:@"http://api.open.qingting.fm/v6/media/categories?access_token=%@",accessToken]
//获取分类下的所有电台或直播电台
#define QingTing_CategoriesChannel(categoriesId,accessToken,currentPage) [NSString stringWithFormat:@"http://api.open.qingting.fm/v6/media/categories/%@/channels/order/0/curpage/%d/pagesize/30?access_token=%@",categoriesId,currentPage,accessToken]
//获取点播电台下的点播节目
#define QingTing_Categorieschannelondemands(channel_id,accessToken,currentPage) [NSString stringWithFormat:@"http://api.open.qingting.fm/v6/media/channelondemands/%@/programs/curpage/%d/pagesize/30?access_token=%@",categoriesId,currentPage,accessToken]
//蜻蜓播放url拼接时以type为准
//点播(OnDemand)
#define QINGTING_AUDIO_PROGRAM_ONDEMAND_TYPE  @"program_ondemand"
//直播(Live)
#define QINGTING_AUDIO_CHANNEL_LIVE_TYPE  @"channel_live"
//
#define QINGTING_AUDIO_PROGRAM_TEMP_TYPE  @"program_temp"

//工程师爸爸参数

#define Iengine_AppID   @"iengine000000001"
#define Iengine_ServiceKey @"XgtYxEPpUW0c2hdQHZK6vwTjJLBmOa13"
#define Iengine_List @"http://open.idaddy.cn/audio/v2/list"


//MyMusic
#define kMusicHeaderView_Top 15
#define kMusicHeaderViewLabel_Height 30

#define kMusicIconView_Heigth 100
#define kMusicIconView_Top 10
#define kMusicIconView_Left 10
#define kMusicLabel_Height 25

//音乐
#define kMusicListBottomViewButton_Height 50
#define kMusicListBottomViewButton_Top 20
#define kMusicListBottomViewCloseButton_Height 50

#define kMusicListBottomView_Height  (kMusicListBottomViewButton_Height + kMusicListBottomViewButton_Top + kMusicListBottomViewCloseButton_Height)

#define kToggleViewButton_Height 80
#define kToolBarButton_Height (54.0000 / 667) * SCREEN_HEIGHT
#define kToggleImageView_Width (220.0000 / 320.0000) * SCREEN_WIDTH
#define kToggleProgressLable_Width 50
#define kToggleProgressSlider_Width (SCREEN_WIDTH - kToggleProgressLable_Width * 2)
#define kToggleProgressSlider_Height 40
#define kToggleProgressSliderAndImag_Gap 15.0000

#define kMusicCategoriesIconView_Heigth 80
#define kMusicCategoriesIconView_Gap 10
#define kMusicCategoriesLabel_Height 30

//第三方音乐源分类
#define kThirdPartView_Left 10
#define kThirdPartCellIcon_Gap 15
#define kThirdPartTitleLabel_Height 40 
#define kThirdPartTitleLabel_Width (SCREEN_WIDTH - kThirdPartView_Left * 2) / 2
#define kThirdPartCellIcon_Width (SCREEN_WIDTH - kThirdPartView_Left * 2 - 2 * kThirdPartCellIcon_Gap) / 3

//
#define kThirdPartAblumMusicTitleLabel_Height 20
#define kThirdPartAblumMusicTitleLabel_Width (SCREEN_WIDTH - kThirdPartView_Left * 2 - kThirdPartCellIcon_Gap - kThirdPartCellIcon_Width)
#define kThirdPartAblumMusicCellIcon_Width 59
#define kThirdPartAblumListCellIcon_Width 50

//喜马拉雅banner

#define kXMLYBannerView_Width SCREEN_WIDTH
#define kXMLYBannerView_Height SCREEN_WIDTH * kBannerView_Scalele
#define kXMLYBannerView_Scalele (130.000 / 320.000)
#define kXMLYBannerImageView_Gap 3
#define kXMLYPageControl_Width (SCREEN_WIDTH * 0.75)
#define kXMLYPageControl_Height 15







#endif
