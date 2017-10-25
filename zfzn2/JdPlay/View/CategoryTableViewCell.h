//
//  CategoryTableViewCell.h
//  JdPlayOpenSDKWithUI
//
//  Created by 沐阳 on 16/11/12.
//  Copyright © 2016年 沐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JdPlaySdk/JdPlaySdk.h>


@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

- (void)refreshDataWithModel:(JdCategoryModel *)model;
- (void)refrehDataWithSong:(EglSong *)song;


@end
