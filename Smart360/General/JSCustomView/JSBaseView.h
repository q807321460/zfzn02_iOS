//
//  JSBaseView.h
//  Smart360
//
//  Created by sun on 16/5/18.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSBaseView : UIView

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UIButton *ensureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat contentViewHeight;

-(id)initWithViewTitle:(NSString *)title;
- (void)showView;
- (void)closeView;


@end
