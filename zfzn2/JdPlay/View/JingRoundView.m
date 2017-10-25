//
//  JingRoundView.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import "JingRoundView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define kRotationDuration 8.0

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]

@implementation JingRoundView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    if (self) {
        [self initJingRound];
    }
    return self;
}

-(void) initJingRound
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    //set JingRoundView
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.layer.cornerRadius = center.x;
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    self.roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.roundImageView setCenter:center];
    self.roundImageView.image = [UIImage imageNamed:@"music_default_img"];
    [self addSubview:self.roundImageView];
}


-(void)addBorder
{
    //border
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,self.frame.size.width,self.frame.size.height,8,0, colorSpace,kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor]);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, center.x , 0, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 13.0);
    CGContextStrokePath(context);
    
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage* image2 = [UIImage imageWithCGImage:image];
    UIImageView *imgv =[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width , self.frame.size.height)];
    imgv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    imgv.image = image2;
    [self addSubview:imgv];
}

//setter
-(void)setIsPlay:(BOOL)aIsPlay
{
    if (aIsPlay)
    {
        NSLog(@"_isPlay: %d",_isPlay);
        if (!_isPlay)
        {   angle = 0.0;
            [self startAnimation];
        }
    }
    else
    {
        [self stopAnimation];
    }
    _isPlay = aIsPlay;
}

-(void)setRoundImage:(NSString *)imgUrl
{
    __weak JingRoundView * weakSelf = self;
    
    if (imgUrl.length == 0) {
        weakSelf.roundImageView.image = [UIImage imageNamed:@"music_default_img"];
        return;
    }
    NSString * url;
    if([imgUrl containsString:@"@!"]){
        NSRange r1 = [imgUrl rangeOfString:@"@!"];//查找字符串（返回一个结构体（起始位置及长度））
        url = [imgUrl substringToIndex:r1.location];//截取子字符串方式
    }else if([imgUrl containsString:@"!"]){
        NSRange r1 = [imgUrl rangeOfString:@"!"];
        url = [imgUrl substringToIndex:r1.location];
    }else{
        url = imgUrl;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image != nil) {
                    weakSelf.roundImageView.image = image;
                }else{
                    weakSelf.roundImageView.image = [UIImage imageNamed:@"music_default_img"];
                }
            });
    });
}
                   

-(void)setImage:(UIImage *)image
{
    self.roundImageView.image = image;
}


- (void)startAnimation
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(addAngle) userInfo:nil repeats:YES];
    
}

-(void)addAngle
{
    angle += 1;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI /180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         dispatch_async(dispatch_get_main_queue(), ^{
                              _roundImageView.transform = endAngle;
                         });
                        
                     }
                     completion:^(BOOL finished){
                  
                     }];
}



-(void)stopAnimation
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


-(void)play
{
    self.isPlay = YES;
}
-(void)pause
{
    self.isPlay = NO;
}

@end
