#import "NSTimer+wrapper.h"

@implementation NSTimer (wrapper)

//
-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    NSLog(@"暂停");
    //暂停
    [self setFireDate:[NSDate distantFuture]];
}

//重新开始
-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    NSLog(@"继续");
    //继续。
    [self setFireDate:[NSDate date]];
}

//超时后重新开始
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
