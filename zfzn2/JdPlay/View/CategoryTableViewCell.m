//
//  CategoryTableViewCell.m
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)refreshDataWithModel:(JdCategoryModel *)model
{
    self.nameL.text = model.name;
    [self setImageWithUrl:model.imagePath];
}

- (void)refrehDataWithSong:(EglSong *)song
{
    self.nameL.text = song.name;
    [self setImageWithUrl:song.imgPath];
    
}


- (void)setImageWithUrl:(NSString *)url {
    
    if (url.length == 0) {
        self.imgView.image = [UIImage imageNamed:@"music_default_img"];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image != nil) {
                self.imgView.image = image;
            }else{
                self.imgView.image = [UIImage imageNamed:@"music_default_img"];
            }
        });
    });

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


@end
