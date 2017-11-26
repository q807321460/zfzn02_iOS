//
//  item_file_cell.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UIGridViewCell.h"

@interface item_file_cell : UIGridViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cell_img;
@property (weak, nonatomic) IBOutlet UIImageView *cell_img_ok;
@property (weak, nonatomic) IBOutlet UIImageView *cell_img_video_flag;

@property (assign) BOOL b_selected;

@end
