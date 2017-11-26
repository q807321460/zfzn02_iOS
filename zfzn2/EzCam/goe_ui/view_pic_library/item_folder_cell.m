//
//  item_folder_cell.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "item_folder_cell.h"

@implementation item_folder_cell
@synthesize cell_title;
@synthesize cell_img;
@synthesize cell_img_ok;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"item_folder_cell" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        //self.cell_img.layer.cornerRadius = 4.0;
        //self.cell_img.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //self.cell_img.layer.borderWidth = 1.0;
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
