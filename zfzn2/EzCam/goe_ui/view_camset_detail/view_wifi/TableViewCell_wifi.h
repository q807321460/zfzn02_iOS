//
//  TableViewCell_wifi.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 15-4-11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableViewCell_wifi_interface <NSObject>
@optional
-(BOOL)on_item_wifi_click:(NSString*)cell_id pos:(int)pos;
@end
@interface TableViewCell_wifi : UITableViewCell
{
    NSString* m_tag_id;
    int m_pos;
}
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property (weak, nonatomic) IBOutlet UIButton *button_bg;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_pass;
@property (weak, nonatomic) IBOutlet UIImageView *img_signal;
@property (assign) id<TableViewCell_wifi_interface> delegate;

-(void)config_cell:(NSString*)tag pos:(int)pos name:(NSString*)name ispass:(int)ispass signal:(int)signal;
- (IBAction)on_item_click:(id)sender;
@end
