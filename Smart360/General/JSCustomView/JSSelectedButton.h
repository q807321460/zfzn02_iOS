//
//  JSSelectedButton.h
//  Smart360
//
//  Created by sun on 15/8/17.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSSelectedButton;

@protocol JSSelectedButtonDelegate <NSObject>

- (void)didSelectedRadioButton:(JSSelectedButton *)radio groupId:(NSString *)groupId;

@end

@interface JSSelectedButton : UIButton
//{
//    NSString                        *_groupId;
//    BOOL                            _checked;
//    __weak id<JSSelectedButtonDelegate>       _delegate;
//}


@property(nonatomic, weak)id<JSSelectedButtonDelegate> delegate;
@property(nonatomic, copy, readonly)NSString* groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;


@end
