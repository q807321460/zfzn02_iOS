#import <UIKit/UIKit.h>

#import "JingRoundView.h"
#import "JUITableViewSheet.h"
#import <JdPlaySdk/JdPlaySdk.h>

@interface JdMusicPlayViewController : UIViewController
{
   @private
    
    JingRoundView *roundView;
}


@property (weak, nonatomic) IBOutlet UIView *firstPage;
@property (weak, nonatomic) IBOutlet UIView *headview;

/**
 *  播放进度滑条
 */
@property (weak, nonatomic) IBOutlet UISlider *playProgressSlider;

/**
 *  歌名
 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
/**
 *  歌手
 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/**
 *  播放状态
 */
@property (weak, nonatomic) IBOutlet UIButton *playStatusBtn;
/**
 *  播放模式
 */
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn;
/**
 *  音量滑条
 */
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
/**
 *  当前播放进度
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTimeLabel;
/**
 *  歌曲总时间
 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/**
 *  处理播放上一曲事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)lastSongBtnClick:(UIButton *)sender;




/**
 *  处理播放事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playBtnClick:(UIButton *)sender;


/**
 *  处理播放下一曲事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)nextSongBtnClick:(UIButton *)sender;

/**
 *  处理音量改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)volumeChanged:(UISlider *)sender;
/**
 *  处理播放进度改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playProgressChanged:(UISlider *)sender;

/**
 *  处理播放模式改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)PlayModeBtnClick:(UIButton *)sender;

/**
 *  显示歌单列表
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playListBtnClick:(UIButton *)sender;



@end
