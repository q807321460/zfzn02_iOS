//
//  JingRoundView.h
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import <UIKit/UIKit.h>
//#import "UIImageView+AFNetworking.h"

////////////
//delegate//
////////////
@protocol JingRoundViewDelegate <NSObject>

-(void) playStatuUpdate:(BOOL)playState;

@end


//////////////
//@interface//
//////////////
@interface JingRoundView : UIView
{
    float angle;
    BOOL stop;
    NSTimer * timer;
}

@property (assign, nonatomic) id<JingRoundViewDelegate> delegate;

//@property (strong, nonatomic) UIImage *roundImage;
@property (assign, nonatomic) BOOL isPlay;
@property (assign, nonatomic) float rotationDuration;
@property (strong, nonatomic) UIImageView *roundImageView;
//@property (strong, nonatomic) UIImageView *playStateView;
@property (strong, nonatomic) CABasicAnimation* rotationAnimation;

-(void)setRoundImage:(NSString *)imgUrl;
-(void)setImage:(UIImage *)image;
-(void) play;
-(void) pause;
-(void)addBorder;
-(void)startAnimation;
-(void)stopAnimation;
@end
