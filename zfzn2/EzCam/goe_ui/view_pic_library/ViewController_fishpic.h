//
//  ViewController_fishpic.h
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoWnd_fish.h"
#import "share_item.h"
#import "vv_strings.h"
#import "CPlayer_fish_jpg.h"

@interface ViewController_fishpic : UIViewController
{
    UIInterfaceOrientation toOrientation;
    share_item* m_share_item;
    vv_strings* m_strings;
    NSString* m_play_file;
    
    int m_video_fishtype;
    float m_video_space_left;
    float m_video_space_right;
    float m_video_space_top;
    float m_video_space_bottom;
}
@property (retain) CPlayer_fish_jpg* m_player;
@property (weak, nonatomic) IBOutlet VideoWnd_fish *m_play_view;

@property (weak, nonatomic) IBOutlet UIView *view_top;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glview_bottom_space;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glview_top_space;

- (IBAction)button_return_click:(id)sender;
@end
