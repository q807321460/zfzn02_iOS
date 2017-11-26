//
//  zxy_gallery_photoview.h
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>


@class zxy_gallery_photoview;

@protocol zxy_gallery_photoview_Delegate<NSObject>
- (void)didTapPhotoView:(zxy_gallery_photoview*)photoView;
- (BOOL)didDoubleTapPhotoView:(zxy_gallery_photoview*)photoView;
@end

@interface zxy_gallery_photoview : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIActivityIndicatorView *_activity;
    UIButton *_button;
    BOOL _isZoomed;
    NSTimer *_tapTimer;
}


@property (nonatomic,assign) NSObject <zxy_gallery_photoview_Delegate> *photoDelegate;
@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,readonly) UIActivityIndicatorView *activity;
@property (assign) BOOL b_fullloaded;


- (UIImage*)createHighlightImageWithFrame:(CGRect)rect;
- (void)startTapTimer;
- (void)stopTapTimer;

- (void)killActivityIndicator;
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
- (void)resetZoom;
- (void)self_release;
@end
