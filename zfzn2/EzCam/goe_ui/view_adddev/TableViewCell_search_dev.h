//
//  TableViewCell_search_dev.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vv_strings.h"

@protocol TableViewCell_search_dev_interface <NSObject>
@optional
-(void)on_add_dev_select_click:(int)pos tag:(NSString*)tag;
@end

@interface TableViewCell_search_dev : UITableViewCell
{
    int m_pos;
    NSString* m_tag;
}
@property (assign) id<TableViewCell_search_dev_interface>delgate;
@property (weak, nonatomic) IBOutlet UILabel *label_devid;
@property (weak, nonatomic) IBOutlet UILabel *label_devip;
@property (weak, nonatomic) IBOutlet UILabel *label_exist;
@property (weak, nonatomic) IBOutlet UIButton *button_bg;
- (IBAction)button_dev_select:(id)sender;

-(void)config_cell:(NSString*)devid devip:(NSString*)devip exist:(BOOL)exist pos:(int)pos tag:(NSString*)tag;
@end
