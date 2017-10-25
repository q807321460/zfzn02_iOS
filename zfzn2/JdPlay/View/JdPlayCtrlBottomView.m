//
//  JdPlayCtrlBottomView.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/16.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "JdPlayCtrlBottomView.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "JdMusicPlayViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface JdPlayCtrlBottomView()<PlayCtrlDelegate>

{
    JdPlayControlPresenter * presenter;
}

@end

@implementation JdPlayCtrlBottomView

+(JdPlayCtrlBottomView *)sharedInstance
{
    static JdPlayCtrlBottomView * shareObj = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[self alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    });
    return shareObj;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        presenter = [JdPlayControlPresenter sharedManager];
        presenter.ctrlDelgate = self;
        
        [self createSubviews];

        UIWindow * window =  [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];

    }
    return self;
}


- (void)createSubviews {
    
    UIButton * songBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-60, 49)];
    [songBtn setTitle:@"未知" forState:UIControlStateNormal];
    [songBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    songBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    songBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    songBtn.tag = 1;
    [songBtn addTarget:self action:@selector(songBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * playBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, 0, 50, 49)];
    [playBtn setImage:[UIImage imageNamed:@"play_activity_pause_nol"] forState:UIControlStateNormal];
    playBtn.tag = 2;
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    [self addSubview:songBtn];
    self.backgroundColor = [UIColor lightGrayColor];
    //[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}


#pragma mark - PlayCtrlDelegate
- (void)onCurrentPlaySongChange:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton * songB = [self viewWithTag:1];
        
        if (title.length == 0) {
            [songB setTitle:@"未知歌曲" forState:UIControlStateNormal];
        }else{
            [songB setTitle:title forState:UIControlStateNormal];
        }

    });
}

- (void)onCurrentPlayStatusChange:(BOOL)state {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIButton * playB = [self viewWithTag:2];
        
        if (state) { //播放
            [playB setImage:[UIImage imageNamed:@"play_activity_play_nol"] forState:UIControlStateNormal];
        }else{    //暂停
            [playB setImage:[UIImage imageNamed:@"play_activity_pause_nol"] forState:UIControlStateNormal];
        }
    });
}


#pragma mark - 点击事件
- (void)playBtnClick {
    
    [presenter togglePlay];
}


- (void)songBtnClick {
    
    JdMusicPlayViewController * vc = [[JdMusicPlayViewController alloc] init];
    self.hidden = YES;
    UIViewController * rvc =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rvc presentViewController:vc animated:YES completion:nil];
}



@end
