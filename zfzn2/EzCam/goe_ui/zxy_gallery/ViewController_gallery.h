//
//  ViewController_gallery.h
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"
#import "zxy_share_data.h"
#import "gallery_photo_manager.h"
#import "zxy_gallery_photoview.h"
#import "zxy_gallery_photo.h"
#import "OMGToast.h"
#import "share_item.h"
#import "pic_cache_list_manager.h"
#import "ViewController_fishpic.h"
@interface ViewController_gallery : UIViewController<UIScrollViewDelegate,zxy_gallery_photo_Delegate,zxy_gallery_photoview_Delegate>
{
    zxy_share_data* MyShareData;
    vv_strings* m_strings;
    gallery_photo_manager* m_photo_manager;
    share_item* m_share_item;
    pic_cache_list_manager* m_pic_cache_manager;
    UILabel *titleLabel;
    UIBarButtonItem *leftButton;
    
    NSMutableArray *_photoViews;
    
    BOOL _isActive;
    BOOL _isFullscreen;
    BOOL _isScrolling;
    NSInteger _currentIndex;
}
@property (strong, nonatomic) IBOutlet UIView *_container;
@property (weak, nonatomic) IBOutlet UIView *_innerContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *_scroller;
@property (weak, nonatomic) IBOutlet UIToolbar *_toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *_nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *_prevButton;

- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;

@end
