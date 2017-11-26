//
//  TableViewCell_cam.m
//  easycam
//
//  Created by zxy on 2017/8/8.
//  Copyright © 2017年 vveye. All rights reserved.
//

#import "TableViewCell_cam.h"

@implementation TableViewCell_cam
@synthesize label_title;
@synthesize delegate;
@synthesize button_cam;
@synthesize button_playback;
@synthesize button_events;
@synthesize button_set;
@synthesize button_delete;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config_cell:(NSString*)name devid:(NSString*)devid on_line:(int)on_line with_pos:(int)pos with_tag:(NSString*)tag hidden:(BOOL)hidden
{
    m_tag_id=tag;
    m_pos=pos;
    label_title.text=name;
    if (on_line==1) {
        _label_state.text=@"在线";
        _label_state.textColor= [UIColor greenColor];
    }
    else{
        _label_state.text=@"离线";
        _label_state.textColor= [UIColor grayColor];
    }
    button_playback.hidden=hidden;
    button_events.hidden=hidden;
    button_set.hidden=hidden;
    button_delete.hidden=hidden;
    
}
- (IBAction)button_play_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_button_play_click:pos:)]) {
        [delegate on_button_play_click:m_tag_id pos:m_pos];
    }
}

- (IBAction)button_set_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_button_set_click:pos:)]) {
        [delegate on_button_set_click:m_tag_id pos:m_pos];
    }
}

- (IBAction)button_playback_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_button_playback_click:pos:)]) {
        [delegate on_button_playback_click:m_tag_id pos:m_pos];
    }
}

- (IBAction)button_delete_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_button_delete_click:pos:)]) {
        [delegate on_button_delete_click:m_tag_id pos:m_pos];
    }
}

- (IBAction)button_events_click:(id)sender {
    if ([delegate respondsToSelector:@selector(on_button_events_click:pos:)]) {
        [delegate on_button_events_click:m_tag_id pos:m_pos];
    }
}
@end
