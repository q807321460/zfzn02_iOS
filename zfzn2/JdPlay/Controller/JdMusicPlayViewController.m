//
//  MusicPlayViewController1.m
//  智能音响
//
//  Created by henry on 15/7/17.
//  Copyright (c) 2015年 york. All rights reserved.
//

#import "JdMusicPlayViewController.h"
#import "UIView+Frame.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "JdPlayCtrlBottomView.h"


#define HeaderViewH 64
#define playViewH 160
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface JdMusicPlayViewController ()<JUITableViewSheetDelegate,PlayCtrlView>
{
    int mDuration, mPosition,isPlaying;
    JdShareClass * shareObj;
    JdPlayControlPresenter * mPresenter;
    JdPlayCtrlBottomView * bview;
}
@end


@implementation JdMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    shareObj = [JdShareClass sharedInstance];
    mPresenter = [JdPlayControlPresenter sharedManager];
    [self createUI];
    [self createDataSource];
    
    bview = [JdPlayCtrlBottomView sharedInstance];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mPresenter.delegate = self;
    bview.hidden = YES;
}


- (void)createUI
{
    //待拖动松开手的时候调用valueChange方法
    self.volumeSlider.continuous  = NO;
    self.volumeSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"seekbar_thumb.png"] forState:UIControlStateNormal];
    
    self.playProgressSlider.continuous = NO;
    self.playProgressSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.playProgressSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    [self.playProgressSlider setThumbImage:[UIImage imageNamed:@"seekbar_thumb.png"] forState:UIControlStateNormal];
    
    int width = SCREEN_WIDTH - 120;
    CGFloat roundViewCenterX = SCREEN_WIDTH / 2;
    CGFloat roundViewCenterY = (SCREEN_HEIGHT - HeaderViewH - playViewH)/2;
    
    roundView = [[JingRoundView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    roundView.centerX = roundViewCenterX;
    roundView.centerY = roundViewCenterY;
    
    [roundView addBorder];
    
    roundView.translatesAutoresizingMaskIntoConstraints = NO;
    [_firstPage addSubview:roundView];
    
}



-(void)createDataSource
{
    if (shareObj.songInfo) {
        self.songNameLabel.text = shareObj.songInfo.title;
        self.singerLabel.text = shareObj.songInfo.creator;
        [roundView setRoundImage:shareObj.songInfo.albumurl];
    }else{
        self.songNameLabel.text = @"未知歌曲";
        self.singerLabel.text = @"未知来源";
        [roundView setRoundImage:nil];
    }
    
    mPosition = shareObj.position;
    mDuration = shareObj.totalTime;
    self.currentPlayTimeLabel.text = [self FormatTime:mPosition];
    self.totalTimeLabel.text = [self FormatTime:mDuration];
    if (mDuration > 0 && mDuration > mPosition) {
        self.playProgressSlider.value = (mPosition*1.0/mDuration);
    }
    
    self.volumeSlider.value = shareObj.volume/100.0;
    [self setPlayMode:shareObj.playOrder];
    [self setPlayOrPause:shareObj.playState];
}


#pragma mark - JUITableViewSheet的代理方法
-(void)actionSheet:(JUITableViewSheet *)actionSheet tableSelectRowAtIndexPath:(NSInteger)row
{
    [mPresenter playPlaylistWithPos:(int)row];
}


#pragma mark - PlayCtrlView
-(void)setVolume:(int)percent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.volumeSlider.value = percent/100.0;
    });
}

-(void)setPosition:(int)position
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPlayTimeLabel.text = [self FormatTime:position];
    });
}


-(void)setSeekProgress:(float)percent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playProgressSlider.value = percent;
    });
}


-(void)setDuration:(int)duration
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalTimeLabel.text = [self FormatTime:duration];
    });
}


-(void)setPlayOrPause:(BOOL)isPlay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPlay) { //播放
            [self.playStatusBtn setImage:[UIImage imageNamed:@"play_activity_play_nol"] forState:UIControlStateNormal];
            
        }else{    //暂停
            [self.playStatusBtn setImage:[UIImage imageNamed:@"play_activity_pause_nol"] forState:UIControlStateNormal];
        }
    });
}


-(void)setPlayMode:(int)order
{
    NSString * imageName;
    switch (order) {
        case 0:
            imageName = @"play_mode_sort";
            break;
        case 1:
            imageName = @"play_mode_single";
            break;
        case 2:
            imageName = @"play_mode_shuffle";
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playModeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    });
}


-(void)setSongName:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.songNameLabel.text = name;
    });

}


-(void)setSingerName:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.singerLabel.text = name;
    });
}


-(void)setAlbumPic:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [roundView setRoundImage:url];
    });
}


-(void)setPlaylist:(NSArray *)songs
{
    NSString* sheetTitle = [NSString stringWithFormat:@"播放队列共%lu首",(unsigned long)songs.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        JUITableViewSheet* actionSheet = [JUITableViewSheet sheetWithTitle:sheetTitle withDelegate:self cancelButtonTitle:@"关闭" withData:songs];
        [actionSheet showOnViewController:self];
    });
}





#pragma mark -格式化时间
- (NSString *)FormatTime:(int)timeMS
{
    int tmp = (int) timeMS / 1000;
    int m = tmp / 60;
    int s = tmp % 60;
    return [NSString stringWithFormat:@"%02d : %02d",m,s];
}



#pragma mark - 按钮点击事件
- (IBAction)back:(id)sender
{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    bview.hidden = NO;
}


#pragma mark -处理播放上一曲事件
- (IBAction)lastSongBtnClick:(UIButton *)sender {
    [mPresenter prev];
}


#pragma mark -处理播放事件
- (IBAction)playBtnClick:(UIButton *)sender {
    [mPresenter togglePlay];
}


#pragma mark -处理播放下一曲事件
- (IBAction)nextSongBtnClick:(UIButton *)sender {
    [mPresenter next];
}

#pragma mark -处理音量改变事件
- (IBAction)volumeChanged:(UISlider *)sender {
    
    [mPresenter changeVolume:(sender.value*100)];
}


#pragma mark -处理播放进度改变事件
- (IBAction)playProgressChanged:(UISlider *)sender {
    
    [mPresenter seekTo:(sender.value)];
}


#pragma mark -处理播放模式改变事件
- (IBAction)PlayModeBtnClick:(UIButton *)sender {
    
    //0：顺序播放 1：单曲循环 2：随机播放
    if (shareObj.playOrder == 1) {
        [self.playModeBtn setImage:[UIImage imageNamed:@"play_mode_shuffle"] forState:UIControlStateNormal];
    }else if (shareObj.playOrder == 2){
        [self.playModeBtn setImage:[UIImage imageNamed:@"play_mode_sort"] forState:UIControlStateNormal];
    }else{
        [self.playModeBtn setImage:[UIImage imageNamed:@"play_mode_single"] forState:UIControlStateNormal];
    }
    [mPresenter changePlayMode];
}


#pragma mark -显示播放列表
- (IBAction)playListBtnClick:(UIButton *)sender {
    
    [mPresenter getPlayList];
}

@end

