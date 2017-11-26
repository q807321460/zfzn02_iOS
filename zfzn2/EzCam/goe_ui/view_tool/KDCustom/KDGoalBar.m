
#import "KDGoalBar.h"

@implementation KDGoalBar
@synthesize    percentLabel;
@synthesize halo;
#pragma Init & Setup
- (id)init
{
	if ((self = [super init]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
    
	return self;
}


-(void)layoutSubviews {
    //NSLog(@"layoutSubvies.....");
    CGRect frame = self.frame;
  
    [percentLabel setText:[NSString stringWithFormat:@"%d", nTotalTimes-iTimes]];

    
    CGRect labelFrame = percentLabel.frame;
    labelFrame.origin.x = frame.size.width / 2 - percentLabel.frame.size.width / 2;
    labelFrame.origin.y = frame.size.height / 2 - percentLabel.frame.size.height / 2;
    percentLabel.frame = labelFrame;
    
    [super layoutSubviews];
}

-(void)setup {
    iTotalTimes=60;
    nTotalTimes=(int)iTotalTimes;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;

    
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [percentLabel setFont:[UIFont systemFontOfSize:50]];
    [percentLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    [percentLabel setTextAlignment:NSTextAlignmentCenter];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    percentLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:percentLabel];
    
    percentLayer = [KDGoalBarPercentLayer layer];
    
    CGRect ssbou=self.bounds;
    percentLayer.bounds=self.bounds;
    percentLayer.anchorPoint=CGPointMake(0.5, 0.5);
    percentLayer.position=CGPointMake(70, 70);
    
    
    percentLayer.contentsScale = [UIScreen mainScreen].scale;
    percentLayer.percent = 0;
    //percentLayer.frame = self.bounds;
    percentLayer.masksToBounds = NO;
    [percentLayer setNeedsDisplay];
    
    
    self.halo = [PulsingHaloLayer layer];
    //self.halo.anchorPoint=CGPointZero;
    //self.halo.position=CGPointMake(0, 0);
    self.halo.position = percentLayer.position;
    
    [self.layer addSublayer:self.halo];
    [self.layer addSublayer:percentLayer];

    
}
- (void)stop
{
    [self.halo stop];
}
-(void)setTotalTimes:(float)times_total
{
    iTotalTimes=times_total;
    nTotalTimes=(int)iTotalTimes;
}
#pragma mark - Touch Events

#pragma mark - Custom Getters/Setters
- (void)setPercent:(int)percent animated:(BOOL)animated {
    
    //NSLog(@"setPercent.....");
    if (percent==0) {
        [halo start];
    }
    CGFloat floatPercent = percent/iTotalTimes;
    floatPercent = MIN(1, MAX(0, floatPercent));
   // NSLog(@"floatPercent=%f",floatPercent);
    iTimes=percent;
    percentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
    
//    [self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    
}



@end
