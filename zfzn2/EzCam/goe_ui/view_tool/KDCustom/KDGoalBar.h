
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KDGoalBarPercentLayer.h"
#import "PulsingHaloLayer.h"

@interface KDGoalBar : UIView {
    UIImage * thumb;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
    int iTimes;
    float iTotalTimes;
    int nTotalTimes;
}

@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) PulsingHaloLayer *halo;

-(void)setTotalTimes:(float)times_total;
- (void)setPercent:(int)percent animated:(BOOL)animated;
- (void)stop;

@end
