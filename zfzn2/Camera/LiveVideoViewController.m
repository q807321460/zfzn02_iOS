//
//  LiveVideoViewController.m
//  LCOpenSDKDemo
//
//  Created by HanwenKong on 16/7/13.
//  Copyright © 2016年 zfzn. All rights reserved.
//

#import "LiveVideoViewController.h"
#import "UIDevice+Lechange.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MessageViewController.h"
#import "zfzn2-Swift.h"

#define LIVE_BAR_HEIGHT 40.0
#define SNAP_BTN_WIDTH 100.0
#define REPALY_BTN_WIDTH 100.0
@interface LiveVideoViewController () {
    CGRect m_screenFrame;
    CGFloat m_barDivideWidth;
    NSString* m_davPath;
    NSString* m_streamPath;
    BOOL m_isTalking; // 对讲状态
    NSInteger m_soundState; // 音频状态
    BOOL m_isEnalbePTZ; // 云台状态
    NSInteger m_nAreaListFoot;
    NSInteger m_nElectricListFoot;
}

@end

@implementation LiveVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWindowView];

    dispatch_queue_t playLive = dispatch_queue_create("playLive", nil);
    dispatch_async(playLive, ^{
        [self Play];
    });

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onResignActive:)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    DataControl* gDC = DataControl.sharedInstance;
    self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName;
}

- (void)initWindowView
{
    DataControl* gDC = DataControl.sharedInstance;
    self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName;
    m_screenFrame = [UIScreen mainScreen].bounds;
//    m_screenImg = [[UIImageView alloc] initWithImage:m_imgPicSelected];
    [m_screenImg setFrame:CGRectMake(0, 0, m_screenFrame.size.width,
                              m_screenFrame.size.width * 9 / 16)];
//    [self.view addSubview:m_screenImg];

    //刷新播放按钮
    m_replayBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(0, 0, REPALY_BTN_WIDTH, REPALY_BTN_WIDTH)];
    m_replayBtn.center = CGPointMake(m_screenImg.center.x, m_screenImg.center.y);
    [m_replayBtn setBackgroundImage:[UIImage imageNamed:@"videotape_icon_replay"]
                           forState:UIControlStateNormal];
    [m_replayBtn addTarget:self
                    action:@selector(onReplay)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_replayBtn];
    m_replayBtn.hidden = YES;

    //显示工具栏中的几个按钮
    [self layOutBar];
    
    //截图
    CGFloat snapBtnHeight = SNAP_BTN_WIDTH * 220 / 192;
    m_snapBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10, m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_snapBtn
        setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_screenshot_nor"]
                  forState:UIControlStateNormal];
    m_snapBtn.tag = 0;
    [m_snapBtn addTarget:self
                  action:@selector(onSnap)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_snapBtn];
    
    //对讲
    m_talkBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(self.view.center.x - SNAP_BTN_WIDTH / 2,
                          m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_talkBtn setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_speak_nor"]
                         forState:UIControlStateNormal];
    m_talkBtn.tag = 0;
    [m_talkBtn addTarget:self
                  action:@selector(onTalk)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_talkBtn];

    //录像
    m_recordBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(m_screenFrame.size.width - 10 - SNAP_BTN_WIDTH,
                          m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_recordBtn
        setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_video_nor"]
                  forState:UIControlStateNormal];
    m_isTalking = NO;
    m_recordBtn.tag = 0;
    [m_recordBtn addTarget:self
                    action:@selector(onRecord)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_recordBtn];

    //提示文本
    m_tipLab = [[UILabel alloc]
        initWithFrame:CGRectMake(10,
                          m_screenImg.frame.size.height + 48 + SNAP_BTN_WIDTH + 30,
                          m_screenFrame.size.width - 20, 20)];
    [m_tipLab setBackgroundColor:[UIColor clearColor]];
    m_tipLab.textAlignment = NSTextAlignmentCenter;
    [m_tipLab setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:m_tipLab];

    [self enableAllBtn:NO];

    m_talker = [[LCOpenSDK_AudioTalk alloc] init];
    m_play = [[VideoPlay alloc]
        initWithRect:CGRectMake(0, 0, m_screenFrame.size.width,
                         m_screenFrame.size.width * 9 / 16)
               Index:0];
    [m_play setSurfaceBGColor:[UIColor blackColor]];
    [self.view addSubview:[m_play getWindowView]];

    m_videoProgressInd = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_videoProgressInd.center = CGPointMake(m_screenImg.center.x, m_screenImg.center.y);
    [self.view addSubview:m_videoProgressInd];

    m_talkProgressInd = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_talkProgressInd.center = CGPointMake(m_talkBtn.center.x, m_talkBtn.center.y);
    [self.view addSubview:m_talkProgressInd];

    [self.view bringSubviewToFront:m_screenImg];
    [self.view bringSubviewToFront:m_replayBtn];
    [self.view bringSubviewToFront:livePlayBarView];
    [self.view bringSubviewToFront:m_videoProgressInd];
    [m_play setListener:(id<LCOpenSDK_EventListener>)self];
    NSLog(@"self = %p", self);

    signal(SIGPIPE, SIG_IGN);
}

- (void)layOutBar
{
    livePlayBarView = [[UIView alloc]
        initWithFrame:CGRectMake(0, m_screenImg.frame.size.height - LIVE_BAR_HEIGHT,
                          m_screenImg.frame.size.width, LIVE_BAR_HEIGHT)];
    [livePlayBarView setBackgroundColor:[UIColor grayColor]];
    livePlayBarView.alpha = 0.5;
    [self.view addSubview:livePlayBarView];

    //清晰度
    CGFloat liveBarWidth = LIVE_BAR_HEIGHT * 100 / 70;
    m_HDBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10, 0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_HDBtn setBackgroundImage:[UIImage imageNamed:@"video_fluent"]
                       forState:UIControlStateNormal];
    m_HDBtn.tag = 0;
    [m_HDBtn addTarget:self
                  action:@selector(onDefine)
        forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_HDBtn];

    //拖动视角
    m_barDivideWidth = (livePlayBarView.frame.size.width - 20 - 4 * liveBarWidth) / 3;
    m_PTZBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10 + liveBarWidth + m_barDivideWidth, 0,
                          liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_PTZBtn setBackgroundImage:[UIImage imageNamed:@"video_yuntai_off"]
                        forState:UIControlStateNormal];
    m_PTZBtn.tag = 0;
    m_isEnalbePTZ = NO;
    [m_PTZBtn addTarget:self
                  action:@selector(onPTZControl)
        forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_PTZBtn];

    //打开关闭声音
    m_soundBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10 + 2 * liveBarWidth + 2 * m_barDivideWidth, 0,
                          liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_soundBtn setBackgroundImage:[UIImage imageNamed:@"video_sound_on"]
                          forState:UIControlStateNormal];
    m_soundBtn.tag = 0;
    m_soundState = m_soundBtn.tag;
    [m_soundBtn addTarget:self
                   action:@selector(onSound)
         forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_soundBtn];

    //报警消息（动态监测）
    m_messageBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(livePlayBarView.frame.size.width - 10 - liveBarWidth,
                          0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_messageBtn
        setBackgroundImage:[UIImage imageNamed:@"list_icon_message_notext.png"]
                  forState:UIControlStateNormal];
    m_messageBtn.tag = 0;
    [m_messageBtn addTarget:self
                        action:@selector(onMessage)
              forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_messageBtn];
}

- (void)refreshSubView
{
    CGFloat liveBarWidth = LIVE_BAR_HEIGHT * 100 / 70;
    m_barDivideWidth = (livePlayBarView.frame.size.width - 20 - 4 * liveBarWidth) / 3;
    [m_HDBtn setFrame:CGRectMake(10, 0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_PTZBtn setFrame:CGRectMake(10 + liveBarWidth + m_barDivideWidth, 0,
                           liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_soundBtn setFrame:CGRectMake(10 + 2 * liveBarWidth + 2 * m_barDivideWidth,
                             0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_messageBtn
        setFrame:CGRectMake(livePlayBarView.frame.size.width - 10 - liveBarWidth,
                     0, liveBarWidth, LIVE_BAR_HEIGHT)];
}

- (void)enableAllBtn:(BOOL)bFalg
{
    m_HDBtn.enabled = bFalg;
    m_PTZBtn.enabled = bFalg;
    m_soundBtn.enabled = bFalg;
    m_messageBtn.enabled = bFalg;
    m_snapBtn.enabled = bFalg;
    m_talkBtn.enabled = bFalg;
    m_recordBtn.enabled = bFalg;
}

- (void)setInfo:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn Img:(UIImage*)img Abl:(NSString*)abl areaFoot:(NSInteger)areaFoot electricFoot:(NSInteger)electricFoot
{
    m_accessToken = [NSString stringWithString:token];
    m_strDevSelected = [NSString stringWithString:deviceId];
    m_devChnSelected = chn;
    m_imgPicSelected = img;
    m_devAbilitySelected = [NSString stringWithString:abl];
    m_nAreaListFoot = areaFoot;
    m_nElectricListFoot = electricFoot;
}

- (void)Play
{
    m_tipLab.text = @"ready play";
    [self showLoading:VIDEO_PROGRESS_IND];
    [m_play stopRtspReal];
    [m_play playRtspReal:m_accessToken
                   devID:m_strDevSelected
                 channel:m_devChnSelected
              definition:1];
}

- (void)onReplay
{
    m_replayBtn.hidden = YES;
    [self Play];
}

- (void)onPlayerResult:(NSString*)code
                  Type:(NSInteger)type
                 Index:(NSInteger)index
{
    // play
    NSLog(@"code = %@, type = %ld", code, (long)type);
    if (0 == type) {
        if ([RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"describe ready";
            });
        }
        else if ([RTSP_Result_String(STATE_RTSP_PLAY_READY)
                     isEqualToString:code]) {
            // labPlay.text = @"start to play";
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"rtsp connection closed";
                [self hideLoading:VIDEO_PROGRESS_IND];
                m_replayBtn.hidden = NO;
                m_screenImg.hidden = NO;
                [self enableAllBtn:NO];
                [m_play stopRtspReal];
                [m_play stopRecord];
                [m_talker stopTalk];
            });
        }
    }
    if (99 == type) {
        if ([code isEqualToString:@"-1000"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"rest timeout";
                [self hideLoading:VIDEO_PROGRESS_IND];
                m_replayBtn.hidden = NO;
                m_screenImg.hidden = NO;
                [self enableAllBtn:NO];
                [m_play stopRtspReal];
                [m_play stopRecord];
                [m_talker stopTalk];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = [NSString stringWithFormat:@"rest errcode[%@]", code];
                [self hideLoading:VIDEO_PROGRESS_IND];
                m_replayBtn.hidden = NO;
                m_screenImg.hidden = NO;
                [self enableAllBtn:NO];
                [m_play stopRtspReal];
                [m_play stopRecord];
                [m_talker stopTalk];
            });
        }
    }
}

- (void)onPlayBegan:(NSInteger)index
{
    NSLog(@"LiveVideoController onPlayBegan");
    dispatch_async(dispatch_get_main_queue(), ^{
        m_tipLab.text = @"start to play";
        m_screenImg.hidden = YES;
        [self hideLoading:VIDEO_PROGRESS_IND];
        [self enableAllBtn:YES];
        /* 高标清切换，音频原状态m_soundState为1（静音），关闭音频
     * m_soundState
     */
        if (1 == m_soundState) {
            [m_play stopAudio];
        }
        if (YES == m_isTalking) {
            [self onTalk];
        }
    });
}

- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index
{
    //    NSLog(@"retain count = %ld\n", CFGetRetainCount((__bridge
    //    CFTypeRef)(self)));
}

#pragma mark - TS/PS标准流数据回调
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index
{
    if (m_streamPath) {
        NSFileHandle* fileHandle =
            [NSFileHandle fileHandleForUpdatingAtPath:m_streamPath];

        [fileHandle seekToEndOfFile]; //将节点跳到文件的末尾

        [fileHandle writeData:data]; //追加写入数据

        [fileHandle closeFile];
        return;
    }
    NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
        NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory =
        [myDirectory stringByAppendingPathComponent:@"RTSPexportStream"];
    m_streamPath = [davDirectory stringByAppendingFormat:@"/%@.ps", strDate];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:davDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:m_streamPath]) //如果不存在
    {
        [data writeToFile:m_streamPath atomically:YES];
    }
}

- (IBAction)onBack:(id)sender
{
    if (m_play) {
        [m_play stopRtspReal];
    }
    if (m_talker) {
        [m_talker stopTalk];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEdit:(id)sender {
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditCameraViewCtrl* nextView = [currentBoard instantiateViewControllerWithIdentifier:@"editCameraViewCtrl"];
    [nextView SetInfo:m_nAreaListFoot electricFoot:m_nElectricListFoot];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)onDefine
{
    if (!m_play) {
        return;
    }
    if (1 == m_recordBtn.tag) {
        [self onRecord];
    }
    if (1 == m_talkBtn.tag) {
        [self onTalk];
        m_isTalking = YES;
    }
    [m_play stopRtspReal];
    // 高标清切换，先关闭对讲；若切换成功，再开启对讲

    NSInteger iStreamType;

    if (1 == m_HDBtn.tag) {
        [m_HDBtn setBackgroundImage:[UIImage imageNamed:@"video_fluent"]
                           forState:UIControlStateNormal];
        m_HDBtn.tag = 0;
        iStreamType = 1;
    }
    else {
        [m_HDBtn setBackgroundImage:[UIImage imageNamed:@"video_hd"]
                           forState:UIControlStateNormal];
        m_HDBtn.tag = 1;
        iStreamType = 0;
    }
    [self showLoading:VIDEO_PROGRESS_IND];
    [m_play playRtspReal:m_accessToken
                   devID:m_strDevSelected
                 channel:0
              definition:iStreamType];
    [self enableAllBtn:NO];
}

- (void)onPTZControl
{
    NSLog(@"LiveVideoController [%@]", m_devAbilitySelected);

    if ([m_devAbilitySelected rangeOfString:@"PTZ"].location == NSNotFound) {
        m_tipLab.text = @"Device don't have PTZ!";
        return;
    }
    if (NO == m_isEnalbePTZ) {
        m_isEnalbePTZ = YES;
        [m_PTZBtn setBackgroundImage:[UIImage imageNamed:@"video_yuntai_on"]
                            forState:UIControlStateNormal];
    }
    else {
        m_isEnalbePTZ = NO;
        [m_PTZBtn setBackgroundImage:[UIImage imageNamed:@"video_yuntai_off"]
                            forState:UIControlStateNormal];
    }
}

- (void)onSound
{
    if (YES == m_isTalking) {
        [NSThread detachNewThreadSelector:@selector(updateText:)
                                 toTarget:self
                               withObject:@"Talking, can't execute"];
        return;
    }
    if (!m_play) {
        return;
    }
    if (0 == m_soundBtn.tag) {
        [m_play stopAudio];
        [m_soundBtn setBackgroundImage:[UIImage imageNamed:@"video_sound_off"]
                              forState:UIControlStateNormal];
        m_soundBtn.tag = 1;
    }
    else {
        [m_play playAudio];
        [m_soundBtn setBackgroundImage:[UIImage imageNamed:@"video_sound_on"]
                              forState:UIControlStateNormal];
        m_soundBtn.tag = 0;
    }
    m_soundState = m_soundBtn.tag;
}

- (void)onMessage
{
//    [UIDevice lc_setRotateToSatusBarOrientation];
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController* nextView = [currentBoard instantiateViewControllerWithIdentifier:@"messageViewController"];
//    [nextView SetInfo:m_nAreaListFoot electricFoot:m_nElectricListFoot];
    [nextView setInfo:m_accessToken dev:m_strDevSelected chn:m_devChnSelected];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)onSnap
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
        NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* picDirectory =
        [myDirectory stringByAppendingPathComponent:@"picture"];

    NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
    NSString* datePath = [picDirectory stringByAppendingPathComponent:strDate];
    NSString* picPath = [datePath stringByAppendingString:@".jpg"];
    NSLog(@"test jpg name[%@]\n", picPath);

    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:picDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:picDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }

    [m_play snapShot:picPath];
    [m_snapBtn
        setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_screenshot_click"]
                  forState:UIControlStateNormal];
    m_snapBtn.tag = 1;
    [NSThread detachNewThreadSelector:@selector(updateText:)
                             toTarget:self
                           withObject:@"保存中..."];
    UIImage* image = [UIImage imageWithContentsOfFile:picPath];
    [self saveImageToPhone:image ImageUrl:picPath];
}

- (void)saveImageToPhone:(UIImage*)image ImageUrl:(NSString*)mediaUrl
{
    // 保存图片, 并且保存的图片不能再次被保存直到被删除
    NSString* key = [NSString stringWithFormat:@"assetUrl %@", mediaUrl];
    NSString* savedValue =
        [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSURL* url = [NSURL URLWithString:savedValue];

    if (url != nil) {
        PHFetchResult* result =
            [PHAsset fetchAssetsWithALAssetURLs:[NSArray arrayWithObject:url]
                                        options:nil];
        if (result.count) {
            NSLog(@"图片已存在");
            NSMutableArray* toDeleteAssets = [NSMutableArray new];

            for (PHAsset* asset in result) {
                [toDeleteAssets addObject:asset];
            }

            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest deleteAssets:toDeleteAssets];
            }
                completionHandler:^(BOOL success, NSError* error) {
                    if ((!success) && (error != nil)) {
                        NSLog(@"Error deleting asset: %@", [error description]);
                    }
                }];
        }
    }
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library
     writeImageToSavedPhotosAlbum:image.CGImage
     orientation:(ALAssetOrientation)image.imageOrientation
     completionBlock:^(NSURL* assetURL, NSError* error) {
                         [library assetForURL:assetURL
                             resultBlock:^(ALAsset* asset) {
                                 NSString* ass = [assetURL absoluteString];
                                 [[NSUserDefaults standardUserDefaults]
                                     setObject:ass
                                        forKey:key];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 NSLog(@"图片保存成功");
                                 [NSThread
                                     detachNewThreadSelector:@selector(updateText:)
                                                    toTarget:self
                                                  withObject:@"图片保存成功"];
                             }
                             failureBlock:^(NSError* error) {
                                 NSLog(@"图片保存失败，请确认是否限制了应用的权限");
                                 [NSThread
                                     detachNewThreadSelector:@selector(updateText:)
                                                    toTarget:self
                                                  withObject:@"图片保存失败，请确认是否限制了应用的权限"];
                             }];
                     }];
    UIImage* img = [UIImage imageNamed:@"livevideo_icon_screenshot_nor"];
    [m_snapBtn setBackgroundImage:img forState:UIControlStateNormal];
    m_snapBtn.tag = 0;
}

- (void)saveVideoToPhone:(NSString*)path
{
    // 保存图片, 并且保存的图片不能再次被保存直到被删除
    NSString* key = [NSString stringWithFormat:@"assetUrl %@", path];
    NSString* savedValue =
        [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSURL* url = [NSURL URLWithString:savedValue];

    if (url != nil) {
        PHFetchResult* result =
            [PHAsset fetchAssetsWithALAssetURLs:[NSArray arrayWithObject:url]
                                        options:nil];
        if (result.count) {
            NSLog(@"录像已存在");
            NSMutableArray* toDeleteAssets = [NSMutableArray new];

            for (PHAsset* asset in result) {
                [toDeleteAssets addObject:asset];
            }

            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest deleteAssets:toDeleteAssets];
            }
                completionHandler:^(BOOL success, NSError* error) {
                    if ((!success) && (error != nil)) {
                        NSLog(@"Error deleting asset: %@", [error description]);
                    }
                }];
        }
    }
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library
        writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path]
                           completionBlock:^(NSURL* assetURL, NSError* error) {
                               [library assetForURL:assetURL
                                   resultBlock:^(ALAsset* asset) {
                                       NSString* ass = [assetURL absoluteString];
                                       [[NSUserDefaults standardUserDefaults]
                                           setObject:ass
                                              forKey:key];
                                       [[NSUserDefaults standardUserDefaults]
                                           synchronize];
                                       NSLog(@"录像保存成功");
                                       [NSThread detachNewThreadSelector:@selector(updateText:)
                                                                toTarget:self
                                                              withObject:@"录像保存成功"];
                                   }
                                   failureBlock:^(NSError* error) {
                                       NSLog(@"录像保存失败，请确认是否限制了应用的权限");
                                       [NSThread detachNewThreadSelector:@selector(updateText:)
                                                                toTarget:self
                                                              withObject:@"录像保存失败，请确认是否限制了应用的权限"];
                                   }];
                           }];
}

- (void)onTalk
{
    if (0 == m_talkBtn.tag) {
        m_tipLab.text = @"prepare to talk";
        [self showLoading:TALK_PROGRESS_IND];
        NSInteger iretValue =
            [m_talker playTalk:m_accessToken devID:m_strDevSelected];
        if (iretValue < 0) {
            NSLog(@"talk failed");
            [self hideLoading:TALK_PROGRESS_IND];
            return;
        }
        [m_talker setListener:self];
        [m_talkBtn
            setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_speak_click"]
                      forState:UIControlStateNormal];
        m_talkBtn.tag = 1;
    }
    else {
        NSLog(@"onTalk ending====\n");
        m_tipLab.text = @"";
        if (m_talker) {
            if (YES == m_isTalking) {
                [m_talker setListener:nil];
                m_isTalking = NO;
                [m_talkBtn
                    setBackgroundImage:[UIImage imageNamed:@"livevideo_icon_speak_nor"]
                              forState:UIControlStateNormal];
                m_talkBtn.tag = 0;

                [m_talker stopTalk];
                // 关闭对讲，若对讲之前视频声音为开启状态，则重新打开音频
                if ((m_soundBtn.tag = m_soundState) == 0) {
                    if (m_play) {
                        [m_play playAudio];
                    }
                    UIImage* img = [UIImage imageNamed:@"video_sound_on"];
                    [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
                }
            }
            else {
                m_tipLab.text = @"talk is setting, please wait";
            }
        }
    }
}

- (void)onTalkResult:(NSString*)error TYPE:(NSInteger)type
{
    NSLog(@"error = %@, type = %ld", error, (long)type);
    if (0 == type) {
        if (nil != error &&
            [RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"talk ready";
            });
        }
        else if (nil != error && [RTSP_Result_String(STATE_RTSP_PLAY_READY)
                                     isEqualToString:error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"start to talk";
                UIImage* img = [UIImage imageNamed:@"video_sound_off"];
                [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
                [self hideLoading:TALK_PROGRESS_IND];
                m_soundBtn.tag = 1;
                m_isTalking = YES;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"talk rtsp connection closed";
                [self hideLoading:TALK_PROGRESS_IND];
                UIImage* img = [UIImage imageNamed:@"livevideo_icon_speak_nor"];
                [m_talkBtn setBackgroundImage:img forState:UIControlStateNormal];
                m_talkBtn.tag = 0;
                m_isTalking = NO;
            });
            [m_talker stopTalk];
            if ((m_soundBtn.tag = m_soundState) == 0) {
                if (m_play) {
                    [m_play playAudio];
                }
                UIImage* img = [UIImage imageNamed:@"video_sound_on"];
                [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
            }
        }
    }
    if (99 == type) {
        if ([error isEqualToString:@"-1000"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = @"rest timeout";
                UIImage* img = [UIImage imageNamed:@"livevideo_icon_speak_nor"];
                [m_talkBtn setBackgroundImage:img forState:UIControlStateNormal];
                [self hideLoading:TALK_PROGRESS_IND];
                m_talkBtn.tag = 0;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_tipLab.text = [NSString stringWithFormat:@"rest errcode[%@]", error];
                UIImage* img = [UIImage imageNamed:@"livevideo_icon_speak_nor"];
                [m_talkBtn setBackgroundImage:img forState:UIControlStateNormal];
                [self hideLoading:TALK_PROGRESS_IND];
                m_talkBtn.tag = 0;
            });
        }
    }
}

- (void)onRecord
{
    if (0 == m_recordBtn.tag) {
        if (!m_play) {
            return;
        }
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
            NSUserDomainMask, YES);
        NSString* libraryDirectory = [paths objectAtIndex:0];

        NSString* myDirectory =
            [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString* davDirectory =
            [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString* datePath = [davDirectory stringByAppendingPathComponent:strDate];
        m_davPath =
            [datePath stringByAppendingFormat:@"_video_%@.mp4", m_strDevSelected];
        NSLog(@"test record name[%@]\n", m_davPath);

        NSFileManager* fileManage = [NSFileManager defaultManager];
        NSError* pErr;
        BOOL isDir;
        if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:myDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:davDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        [m_play startRecord:m_davPath];

        UIImage* img = [UIImage imageNamed:@"livevideo_icon_video_click"];
        [m_recordBtn setBackgroundImage:img forState:UIControlStateNormal];
        m_recordBtn.tag = 1;
        [NSThread detachNewThreadSelector:@selector(updateText:)
                                 toTarget:self
                               withObject:@"录像中..."];
    }
    else {
        if (!m_play) {
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Record Save failed"];
            return;
        }
        [m_play stopRecord];
        NSLog(@"m_davPath = %@", m_davPath);
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(m_davPath)) {
            [self saveVideoToPhone:m_davPath];
        }
        else {
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Record Save failed"];
        }
        UIImage* img = [UIImage imageNamed:@"livevideo_icon_video_nor"];
        [m_recordBtn setBackgroundImage:img forState:UIControlStateNormal];
        m_recordBtn.tag = 0;
        return;
    }
}

- (void)updateText:(NSString*)text
{
    m_tipLab.text = text;
}

- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    NSLog(@"11111111111");
}

- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    livePlayBarView.hidden = !livePlayBarView.hidden;
}

- (void)onWindowLongPressBegin:(Direction)dir
                            dx:(CGFloat)dx
                            dy:(CGFloat)dy
                         Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iZ = 1;
        iDuration = -1;

        switch (dir) {
        case Left:
            iH = -5;
            iV = 0;
            break;
        case Right:
            iH = 5;
            iV = 0;
            break;
        case Up:
            iH = 0;
            iV = 5;
            break;
        case Down:
            iH = 0;
            iV = -5;
            break;
        case Left_up:
            iH = -5;
            iV = 5;
            break;
        case Left_down:
            iH = -5;
            iV = -5;
            break;
        case Right_up:
            iH = 5;
            iV = 5;
            break;
        case Right_down:
            iH = 5;
            iV = -5;
            break;
        default:
            break;
        }
        dispatch_queue_t long_press_begin = dispatch_queue_create("long_press_begin", nil);
        dispatch_async(long_press_begin, ^{
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration];
        });
    }
    else {
    }
}
- (void)onWindowLongPressEnd:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iZ = 1;
        iDuration = 0;
        dispatch_queue_t long_press_end = dispatch_queue_create("long_press_end", nil);
        dispatch_async(long_press_end, ^{
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration];
        });
    }
    else {
    }
}
- (bool)onSlipBegin:(Direction)dir
                 dx:(CGFloat)dx
                 dy:(CGFloat)dy
              Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iDuration = 100;
        iZ = 1;
        switch (dir) {
        case Left:
            iH = -5;
            iV = 0;
            break;
        case Right:
            iH = 5;
            iV = 0;
            break;
        case Up:
            iH = 0;
            iV = 5;
            break;
        case Down:
            iH = 0;
            iV = -5;
            break;
        case Left_up:
            iH = -5;
            iV = 5;
            break;
        case Left_down:
            iH = -5;
            iV = -5;
            break;
        case Right_up:
            iH = 5;
            iV = 5;
            break;
        case Right_down:
            iH = 5;
            iV = -5;
            break;
        default:
            break;
        }
        dispatch_queue_t slip_begin = dispatch_queue_create("slip_begin", nil);
        dispatch_async(slip_begin, ^{
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration];
        });
        return YES;
    }
    else {
        return FALSE;
    }
}
- (void)onSlipping:(Direction)dir
              preX:(CGFloat)preX
              preY:(CGFloat)preY
                dx:(CGFloat)currentX
                dy:(CGFloat)currentY
             Index:(NSInteger)index
{
    if (NO == m_isEnalbePTZ) {
        [m_play doTranslateX:currentX Y:currentY];
    }
}
- (void)onSlipEnd:(Direction)dir
               dx:(CGFloat)dx
               dy:(CGFloat)dy
            Index:(NSInteger)index
{
    NSLog(@"LiveVideoViewController onSlipEnd");
}

- (void)onZooming:(CGFloat)scale Index:(NSInteger)index
{
    if (NO == m_isEnalbePTZ) {
        [m_play doScale:scale];
    }
}
- (void)onZoomEnd:(ZoomType)zoom Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iDuration = 200;
        switch (zoom) {
        case Zoom_in:
            iZ = 0.1;
            break;
        case Zoom_out:
            iZ = 10;
            break;
        default:
            break;
        }
        dispatch_queue_t zoom_end = dispatch_queue_create("zoom_end", nil);
        dispatch_async(zoom_end, ^{
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration];
        });
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self layoutViews:toInterfaceOrientation force:NO];
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"do nothing, but rewrite method! ");
}

- (void)layoutViews:(UIInterfaceOrientation)InterfaceOrientation
              force:(BOOL)beForce
{
    CGFloat width = [[[UIDevice currentDevice] systemVersion] floatValue] < 7
        ? m_screenFrame.size.width - 20
        : m_screenFrame.size.width;
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation)) {
        [m_play setWindowFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,
                                   m_screenFrame.size.width * 9 / 16)];
        [m_screenImg
            setFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,
                         m_screenFrame.size.width * 9 / 16)];
        m_replayBtn.center = m_screenImg.center;
        m_videoProgressInd.center = m_screenImg.center;
        [livePlayBarView
            setFrame:CGRectMake(0, super.m_yOffset - LIVE_BAR_HEIGHT + m_screenImg.frame.size.height,
                         m_screenImg.frame.size.width, LIVE_BAR_HEIGHT)];
        [self refreshSubView];
        [m_messageBtn
            setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_fullscreen"]
                      forState:UIControlStateNormal];
//        super.m_navigationBar.hidden = NO;
    }
    else {
        [m_messageBtn setBackgroundImage:[UIImage imageNamed:@"video_smallscreen"]
                                   forState:UIControlStateNormal];

        [m_play setWindowFrame:CGRectMake(0, 0, m_screenFrame.size.height, width)];

        m_screenImg.frame = CGRectMake(0, 0, m_screenFrame.size.height, width);
        m_replayBtn.center = m_screenImg.center;
        m_videoProgressInd.center = m_screenImg.center;
        livePlayBarView.frame = CGRectMake(
            0, width - LIVE_BAR_HEIGHT, m_screenFrame.size.height, LIVE_BAR_HEIGHT);
        [self refreshSubView];
        [self.view bringSubviewToFront:livePlayBarView];
//        super.m_navigationBar.hidden = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

// 显示滚动轮指示器
- (void)showLoading:(ProgressIndType)type
{
    if (VIDEO_PROGRESS_IND == type) {
        [m_videoProgressInd startAnimating];
    }
    else if (TALK_PROGRESS_IND == type) {
        [m_talkProgressInd startAnimating];
    }
}

// 消除滚动轮指示器
- (void)hideLoading:(ProgressIndType)type
{
    if (VIDEO_PROGRESS_IND == type && [m_videoProgressInd isAnimating]) {
        [m_videoProgressInd stopAnimating];
    }
    else if (TALK_PROGRESS_IND == type && [m_talkProgressInd isAnimating]) {
        [m_talkProgressInd stopAnimating];
    }
}

- (void)onActive:(id)sender
{
    m_tipLab.text = @"ready play";
    NSLog(@"onActive motivated");
}
- (void)onResignActive:(id)sender
{
    if (m_play) {
        [m_play stopRtspReal];
        [m_play stopAudio];
    }
    if (m_talker) {
        [m_talker stopTalk];
    }

    [self hideLoading:VIDEO_PROGRESS_IND];
    [self hideLoading:TALK_PROGRESS_IND];
    [self enableAllBtn:NO];
    m_replayBtn.hidden = NO;

    NSLog(@"onResignActive motivated");
}

- (void)dealloc
{
    NSLog(@"dealloc LiveVideoController");
}

@end

