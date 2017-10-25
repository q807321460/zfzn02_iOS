//
//  JdFailTipView.h
//  JDMusic
//
//  Created by 沐阳 on 16/8/9.
//  Copyright © 2016年 henry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ensureBtnBlock)();

@interface JdFailTipView : UIView

@property (weak, nonatomic) IBOutlet UILabel *failL;

- (IBAction)ensureBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;



+ (JdFailTipView *)viewWithParentView:(UIView*)parentView tip:(NSString *)tip;

- (void)showWithparentView:(UIView*)parentView;


- (void)removeFromParentView;

@property (nonatomic,copy) ensureBtnBlock ensureBlock;

@end
