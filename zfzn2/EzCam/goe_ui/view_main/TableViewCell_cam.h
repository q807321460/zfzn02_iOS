//
//  TableViewCell_cam.h
//  easycam
//
//  Created by zxy on 2017/8/8.
//  Copyright © 2017年 vveye. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableViewCell_cam_interface <NSObject>
@optional
-(void)on_button_play_click:(NSString*)cam_id pos:(int)pos;
-(void)on_button_set_click:(NSString*)cam_id pos:(int)pos;
-(void)on_button_playback_click:(NSString*)cam_id pos:(int)pos;
-(void)on_button_delete_click:(NSString*)cam_id pos:(int)pos;
-(void)on_button_events_click:(NSString*)cam_id pos:(int)pos;
@end

@interface TableViewCell_cam : UITableViewCell
{
    NSString* m_tag_id;
    int m_pos;
}
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (assign) id<TableViewCell_cam_interface> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button_cam;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UIButton *button_playback;
@property (weak, nonatomic) IBOutlet UIButton *button_events;
@property (weak, nonatomic) IBOutlet UIButton *button_set;
@property (weak, nonatomic) IBOutlet UIButton *button_delete;



-(void)config_cell:(NSString*)name devid:(NSString*)devid on_line:(int)on_line with_pos:(int)pos with_tag:(NSString*)tag hidden:(BOOL)hidden;
- (IBAction)button_play_click:(id)sender;
- (IBAction)button_set_click:(id)sender;
- (IBAction)button_playback_click:(id)sender;
- (IBAction)button_delete_click:(id)sender;
- (IBAction)button_events_click:(id)sender;

@end
