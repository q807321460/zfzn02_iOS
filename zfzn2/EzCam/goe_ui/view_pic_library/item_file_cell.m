//
//  item_file_cell.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "item_file_cell.h"

@implementation item_file_cell
@synthesize cell_img;
@synthesize cell_img_ok;
@synthesize cell_img_video_flag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"item_file_cell" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
