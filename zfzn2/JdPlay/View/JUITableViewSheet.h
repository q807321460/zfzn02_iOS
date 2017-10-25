//
//  JUITableViewSheet.h
//  智能音响
//
//  Created by henry on 15/5/29.
//  Copyright (c) 2015年 york. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JUITableViewSheet;
@protocol JUITableViewSheetDelegate <NSObject>

@optional
- (void) actionSheet:(JUITableViewSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) actionSheet:(JUITableViewSheet*)actionSheet tableSelectRowAtIndexPath:(NSInteger)row;

@end

@interface JUITableViewSheet : UIView<UITableViewDataSource,UITableViewDelegate>
{
    @private
    NSString* _title;
    NSString* _cancelTitle;
    NSMutableArray* _dataList;
    id<JUITableViewSheetDelegate> _delegate;
    int cancelButtonIndex;
    UITableView *tableview;
    UITableViewCell* lastCell;
    UIButton * playOrder;
    UILabel* titleLabel;
}

@property (nonatomic, strong) UIPopoverController* popoverController;

- (void) showOnViewController:(UIViewController *)parentViewController;
-(void)flashUI:(NSArray*)data;

+ (id) sheetWithTitle:(NSString *)title withDelegate:(id<JUITableViewSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle withData:(NSArray *)data;
@end
