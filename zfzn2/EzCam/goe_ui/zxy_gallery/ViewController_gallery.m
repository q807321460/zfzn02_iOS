//
//  ViewController_gallery.m
//  ppview_zx
//
//  Created by zxy on 15-1-30.
//  Copyright (c) 2015年 vveye. All rights reserved.
//

#import "ViewController_gallery.h"
#import "vv_strings.h"
@interface ViewController_gallery ()

@end

@implementation ViewController_gallery
@synthesize _container;
@synthesize _innerContainer;
@synthesize _scroller;
@synthesize _toolbar;
@synthesize _nextButton;
@synthesize _prevButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_strings=[vv_strings getInstance];
    MyShareData = [zxy_share_data getInstance];
    m_photo_manager=[gallery_photo_manager getInstance];
    m_share_item=[share_item getInstance];
    m_pic_cache_manager=[pic_cache_list_manager getInstance];
    
    _photoViews	= [[NSMutableArray alloc] init];
    _currentIndex=-1;
    [self buildPhotoViews];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont systemFontOfSize:17];  //设置文本字体与大小
    //titleLabel.textColor = UIColorFromRGB(m_strings.text_gray);  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"自定义标题";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    leftButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(doClickBackAction:)];

    [self.navigationItem setLeftBarButtonItem:leftButton];
    _scroller.delegate	= self;
}
- (void)buildPhotoViews
{
    [_photoViews removeAllObjects];
    
    float dx = 0;
    NSUInteger i, count = [m_photo_manager numberOfPhotosForPhotoGallery];
    for (i = 0; i < count; i++) {
        zxy_gallery_photoview *photoView = [[zxy_gallery_photoview alloc] initWithFrame:CGRectMake(dx, 0 , MyShareData.screen_width, MyShareData.screen_height)];
        photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        photoView.autoresizesSubviews = YES;
        //photoView.scrollEnabled=false;
        //photoView.delegate=nil;
        [photoView setBackgroundColor:[UIColor grayColor]];
        [photoView.activity startAnimating];
        photoView.photoDelegate = self;
        //NSLog(@"buildPhotoViews-----%d, %@",i,[NSString stringWithFormat:@"%p", photoView]);
        [_scroller addSubview:photoView];
        [_photoViews addObject:photoView];
        dx += MyShareData.screen_width;
    }
}
-(void)release_self{
    [m_photo_manager set_delegate:nil];
    [m_photo_manager exit];
    _isActive=false;
    _scroller.delegate=nil;
    for (zxy_gallery_photoview *view in _photoViews) {
        [view removeFromSuperview];
    }
    [_photoViews removeAllObjects];
}
-(void)doClickBackAction:(id)sender
{
    [self release_self];
    NSLog(@"doClickBackAction.............");
    [[self navigationController] popViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    _isActive = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [self layoutViews];
    //[self reloadGallery];
    
    [m_photo_manager set_delegate:self];
    _currentIndex=[m_photo_manager start_index];
    if( _currentIndex == -1 )
        [self to_next];
    else
        [self gotoImageByIndex:_currentIndex animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isActive = NO;
    
    //[[UIApplication sharedApplication] setStatusBarStyle:_prevStatusStyle animated:animated];
}

- (void)layoutViews
{
    [self positionInnerContainer];
    [self positionScroller];
    [self positionToolbar];
    [self updateScrollSize];
    [self resizeImageViewsWithRect:_scroller.frame];
    //[self layoutButtons];
    [self moveScrollerToCurrentIndexWithAnimation:NO];
    //[_innerContainer bringSubviewToFront:_toolbar];
}
- (void)positionInnerContainer
{
    if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {//portrait  MyShareData.screen_width
        _innerContainer.frame = CGRectMake( 0, 0, MyShareData.screen_width, MyShareData.screen_height);
    }
    else
    {// landscape
        _innerContainer.frame = CGRectMake( 0, 0, MyShareData.screen_height,MyShareData.screen_width);
    }
}
- (void)positionScroller
{
    if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {//portrait
        _scroller.frame=CGRectMake( 0, 0, MyShareData.screen_width, MyShareData.screen_height);
    }
    else
    {//landscape
        _scroller.frame=CGRectMake( 0, 0, MyShareData.screen_height,MyShareData.screen_width);
    }
}
- (void)positionToolbar
{
    _toolbar.frame = CGRectMake( 0, _scroller.frame.size.height-40, _scroller.frame.size.width, 40 );
}
- (void)updateScrollSize
{
    float contentWidth = _scroller.frame.size.width * [m_photo_manager numberOfPhotosForPhotoGallery];
    [_scroller setContentSize:CGSizeMake(contentWidth, _scroller.frame.size.height)];
    //[_scroller setContentSize:CGSizeMake(contentWidth, 0)];
}
- (void)resizeImageViewsWithRect:(CGRect)rect
{
    // resize all the image views
    NSUInteger i, count = [_photoViews count];
    float dx = 0;
    for (i = 0; i < count; i++) {
        zxy_gallery_photoview * photoView = [_photoViews objectAtIndex:i];
        photoView.frame = CGRectMake(dx, 0, rect.size.width, rect.size.height );
        dx += rect.size.width;
    }
}
- (void)resetImageViewZoomLevels
{
    // resize all the image views
    NSUInteger i, count = [_photoViews count];
    for (i = 0; i < count; i++) {
        zxy_gallery_photoview * photoView = [_photoViews objectAtIndex:i];
        [photoView resetZoom];
    }
}
- (void)moveScrollerToCurrentIndexWithAnimation:(BOOL)animation
{
    int xp = _scroller.frame.size.width * _currentIndex;
    _scroller.contentOffset = CGPointMake(xp, 0);
   // [_scroller scrollRectToVisible:CGRectMake(xp, 0, _scroller.frame.size.width, _scroller.frame.size.height) animated:animation];
    _isScrolling = animation;
}

- (void)enterFullscreen
{
    
        _isFullscreen = YES;
        
        [self disableApp];
        
        UIApplication* application = [UIApplication sharedApplication];
        if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
        } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
        }
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView beginAnimations:@"galleryOut" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(enableApp)];
        _toolbar.alpha = 0.0;
        [UIView commitAnimations];

}
- (void)exitFullscreen
{
    _isFullscreen = NO;
    
    [self disableApp];
    
    UIApplication* application = [UIApplication sharedApplication];
    if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView beginAnimations:@"galleryIn" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(enableApp)];
    _toolbar.alpha = 1.0;
    [UIView commitAnimations];
}



- (void)enableApp
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (BOOL)didDoubleTapPhotoView:(zxy_gallery_photoview*)photoView
{
    //如果为鱼眼， 返回false,由外部处理双击事件。否则内部自行处理
    if (m_share_item.cur_alarm_item.m_video_fishtype<=0) {
        return true;
    }
    else{
        m_share_item.cur_playpic_src=1;
        m_share_item.cur_fish_jpgname=[m_pic_cache_manager get_filename:m_share_item.cur_cam_list_item.m_id eventid:m_share_item.cur_alarm_item.m_eventid index:(int)_currentIndex];
        ViewController_fishpic* destview=nil;
        destview = [[ViewController_fishpic alloc]initWithNibName:@"ViewController_fishpic" bundle:nil];
        [self presentViewController:destview animated:YES completion:nil];
        return false;
    }
}
- (void)didTapPhotoView:(zxy_gallery_photoview*)photoView
{
    NSLog(@"didTapPhotoView......");
    
}

- (void)updateTitle
{
    titleLabel.text=[NSString stringWithFormat:@"%i %@ %i", _currentIndex+1, NSLocalizedString(@"of", @"") , [m_photo_manager numberOfPhotosForPhotoGallery]];
}

- (void)updateButtons
{
    _prevButton.enabled = ( _currentIndex <= 0 ) ? NO : YES;
    _nextButton.enabled = ( _currentIndex >= [m_photo_manager numberOfPhotosForPhotoGallery]-1 ) ? NO : YES;
}

- (void)scrollingHasEnded {
    
    _isScrolling = NO;
    
    NSUInteger newIndex = floor( _scroller.contentOffset.x / _scroller.frame.size.width );
    
    // don't proceed if the user has been scrolling, but didn't really go anywhere.
    if( newIndex == _currentIndex )
        return;
    
    // clear previous
    //[self unloadFullsizeImageWithIndex:_currentIndex];
    
    _currentIndex = newIndex;
    [self updateTitle];
    [self updateButtons];
    [self gotoImageByIndex:_currentIndex animated:NO];
    //[self loadFullsizeImageWithIndex:_currentIndex];
    
}
#pragma mark - UIScrollView Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scroller==scrollView) {
        //NSLog(@"scrollViewDidScroll");
        _isScrolling = YES;
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
        
        if (scrollView.contentOffset.y > 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
    }
    else{
        NSLog(@"scrollViewDidScroll-----not me, %@",[NSString stringWithFormat:@"%p", scrollView]);
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (_scroller==scrollView) {
        //NSLog(@"scrollViewDidEndDragging");
        if( !decelerate )
        {
            [self scrollingHasEnded];
        }
    }
    else{
        NSLog(@"scrollViewDidEndDragging-----not me");
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self scrollingHasEnded];
    if (_scroller==scrollView) {
        //NSLog(@"scrollViewDidEndDecelerating");
        [self scrollingHasEnded];
    }
    else{
        NSLog(@"scrollViewDidEndDecelerating-----not me");
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

-(void)to_next
{
    NSUInteger numberOfPhotos = [m_photo_manager numberOfPhotosForPhotoGallery];
    NSUInteger nextIndex = _currentIndex+1;
    
    // don't continue if we're out of images.
    if( nextIndex <= numberOfPhotos )
    {
        [self gotoImageByIndex:nextIndex animated:NO];
    }

}
- (IBAction)next:(id)sender {
    NSUInteger numberOfPhotos = [m_photo_manager numberOfPhotosForPhotoGallery];
    NSUInteger nextIndex = _currentIndex+1;
    
    // don't continue if we're out of images.
    if( nextIndex <= numberOfPhotos )
    {
        [self gotoImageByIndex:nextIndex animated:NO];
    }
}

- (IBAction)previous:(id)sender {
    NSUInteger prevIndex = _currentIndex-1;
    [self gotoImageByIndex:prevIndex animated:NO];
}
/*
 "img_get_err_1"="获取失败:客户端句柄不存在";
 "img_get_err_2"="获取失败:库未初始化";
 "img_get_err_3"="获取失败:连接句柄不存在";
 "img_get_err_4"="获取失败:发送数据失败";
 "img_get_err_5"="获取失败:接收回复失败";
 "img_get_err_6"="获取失败:接收回复超时";
 "img_get_err_7"="获取失败:接收到错误的回复";
 "img_get_err_203"="获取失败:认证失败";
 "img_get_err_204"="获取失败:设备未就绪";
 "img_get_err_205"="获取失败:设备不支持";
 "img_get_err_404"="获取失败:图片不存在";
 "img_get_err_503"="获取失败:网络问题下载失败";
 */
-(NSString*)get_img_err_msg:(int)errcode
{
    NSString* msg=@"";
    switch (errcode) {
        case -1:
            msg=NSLocalizedString(@"img_get_err_1", @"");
            break;
        case -2:
            msg=NSLocalizedString(@"img_get_err_2", @"");
            break;
        case -3:
            msg=NSLocalizedString(@"img_get_err_3", @"");
            break;
        case -4:
            msg=NSLocalizedString(@"img_get_err_4", @"");
            break;
        case -5:
            msg=NSLocalizedString(@"img_get_err_5", @"");
            break;
        case -6:
            msg=NSLocalizedString(@"img_get_err_6", @"");
            break;
        case -7:
            msg=NSLocalizedString(@"img_get_err_7", @"");
            break;
        case 203:
            msg=NSLocalizedString(@"img_get_err_203", @"");
            break;
        case 204:
            msg=NSLocalizedString(@"img_get_err_204", @"");
            break;
        case 205:
            msg=NSLocalizedString(@"img_get_err_205", @"");
            break;
        case 404:
            msg=NSLocalizedString(@"img_get_err_404", @"");
            break;
        case 503:
            msg=NSLocalizedString(@"img_get_err_503", @"");
            break;
        default:
             msg=NSLocalizedString(@"img_get_err_unknow", @"");
            
            break;
    }
    return msg;
}
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSUInteger numPhotos = [m_photo_manager numberOfPhotosForPhotoGallery];
    
    // constrain index within our limits
    if( index >= numPhotos ) index = numPhotos - 1;
    
    
    if( numPhotos == 0 ) {
        
        // no photos!
        _currentIndex = -1;
    }
    else {
        
        // clear the fullsize image in the old photo
        //[self unloadFullsizeImageWithIndex:_currentIndex];
        
        _currentIndex = index;
        [self moveScrollerToCurrentIndexWithAnimation:animated];
        [self updateTitle];
        
        if( !animated )	{
            if ([m_photo_manager is_image_available:(int)_currentIndex]==true) {
                int res=[m_photo_manager get_image_errcode:(int)_currentIndex];
                if (res==200) {
                    [m_photo_manager start_load_fullsize:(int)_currentIndex];
                }
                else{
                    zxy_gallery_photoview * photoView = [_photoViews objectAtIndex:index];
                    if([photoView.activity isAnimating]==true){
                        [photoView.activity stopAnimating];
                    }
                    [OMGToast showWithText:[self get_img_err_msg:res] duration:1];
                }
            }
            
        }
    }
    [self updateButtons];
    //[self updateCaption];
}


#pragma mark - FGalleryPhoto Delegate Methods
- (void)zxy_LoadFullsize_err:(int)index errcode:(int)errcode
{
    zxy_gallery_photoview * photoView = [_photoViews objectAtIndex:index];
    [photoView.activity stopAnimating];
    [OMGToast showWithText:[self get_img_err_msg:errcode] duration:1];
}
- (void)zxy_didLoadFullsize:(int)index image:(UIImage*)image
{
    //NSLog(@"controller,zxy_didLoadFullsize.............%d",index);
    zxy_gallery_photoview * photoView = [_photoViews objectAtIndex:index];
    //if(photoView.b_fullloaded==false && image!=nil){
    if(photoView.b_fullloaded==false){
        photoView.b_fullloaded=true;
        [photoView.activity stopAnimating];
    }
    
    if( _currentIndex == index )
    {
        photoView.imageView.image = image;
    }
    // otherwise, we don't need to keep this image around
    else
        [m_photo_manager unload_fullsize:index];
}
@end

