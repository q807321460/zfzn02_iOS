//
//  ProListView.h
//  Smart360
//
//  Created by michael on 16/1/27.
//  Copyright © 2016年 Jushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProRoomModel;

@protocol ProListViewDelegate <NSObject>

-(void)selecteOneProListViewCurrentRoomID:(NSString *)currentRoomID ProRoomModel:(ProRoomModel *)proRoomModel;

@end

@interface ProListView : UIView


@property (nonatomic, weak) id<ProListViewDelegate>delegate;


-(instancetype)initCustomWithProListAray:(NSArray *)proArray roomID:(NSString *)roomID;

//展示视图
-(void)showProListView;
//关闭视图
- (void)closeProListView;

@end
