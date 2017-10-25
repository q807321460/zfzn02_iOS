#import <Foundation/Foundation.h>

@interface NSTimer (wrapper)

//
- (void)pauseTimer;

//重新开始
- (void)resumeTimer;

//超时后重新开始
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
