//
//  ActionRightWrongView.h
//  Smart360
//
//  Created by michael on 15/12/29.
//  Copyright © 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionRightWrongViewDelegate <NSObject>

- (void)actionRightClick;
- (void)actionWrongClick;

@end


@interface ActionRightWrongView : UIView

@property (nonatomic, weak) id<ActionRightWrongViewDelegate>delegate;

- (instancetype)initWithAction:(NSString *)actionStr;

//-(void)updateActionStr:(NSString *)actionStr;

@end
