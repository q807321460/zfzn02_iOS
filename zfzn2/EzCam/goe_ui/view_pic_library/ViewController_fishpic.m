//
//  ViewController_fishpic.m
//  P2PONVIF_PRO_vv
//
//  Created by zxy on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController_fishpic.h"

@interface ViewController_fishpic ()

@end

@implementation ViewController_fishpic
@synthesize m_player;
@synthesize m_play_view;
@synthesize view_top;
@synthesize label_title;
@synthesize glview_bottom_space;
@synthesize glview_top_space;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_strings=[vv_strings getInstance];
    
    label_title.text=NSLocalizedString(@"m_fish_pic", @"");
    m_share_item=[share_item getInstance];
    
    m_player=[[CPlayer_fish_jpg alloc]init:0];
    [m_player set_surfaceview:m_play_view];
     
    m_play_file=m_share_item.cur_fish_jpgname;
    m_video_fishtype=-1;
    
    if (m_share_item.cur_playpic_src==0) {
        NSRange range0 = [m_play_file rangeOfString:@"type="];
        NSRange range1 = [m_play_file rangeOfString:@"left="];
        NSRange range2 = [m_play_file rangeOfString:@"right="];
        NSRange range3 = [m_play_file rangeOfString:@"top="];
        NSRange range4 = [m_play_file rangeOfString:@"bottom="];
        NSRange range5 = [m_play_file rangeOfString:@".jpg"];
        if (range0.length==0 || range1.length==0 || range2.length==0 || range3.length==0 || range4.length==0 || range5.length==0) {
            return;
        }
        int location0=(int)(range0.location+range0.length);
        int location1=(int)(range1.location+range1.length);
        int location2=(int)(range2.location+range2.length);
        int location3=(int)(range3.location+range3.length);
        int location4=(int)(range4.location+range4.length);
        
        m_video_fishtype = [[m_play_file substringWithRange:NSMakeRange(location0, range1.location-location0)]intValue];
        m_video_space_left = [[m_play_file substringWithRange:NSMakeRange(location1, range2.location-location1)]floatValue];
        m_video_space_right = [[m_play_file substringWithRange:NSMakeRange(location2, range3.location-location2)]floatValue];
        m_video_space_top = [[m_play_file substringWithRange:NSMakeRange(location3, range4.location-location3)]floatValue];
        m_video_space_bottom = [[m_play_file substringWithRange:NSMakeRange(location4, range5.location-location4)]floatValue];
    }
    else{
        m_video_fishtype = m_share_item.cur_alarm_item.m_video_fishtype;
        m_video_space_left = m_share_item.cur_alarm_item.m_video_space_left;
        m_video_space_right = m_share_item.cur_alarm_item.m_video_space_right;
        m_video_space_top = m_share_item.cur_alarm_item.m_video_space_top;
        m_video_space_bottom = m_share_item.cur_alarm_item.m_video_space_bottom;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"viewDidAppear");
    if (m_video_fishtype!=1 && m_video_fishtype !=2) {
        return;
    }
    [m_player start_play:m_play_file top:m_video_space_top bottom:m_video_space_bottom left:m_video_space_left right:m_video_space_right fisheyetype:m_video_fishtype];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    toOrientation = toInterfaceOrientation;
    if (toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight){
        view_top.hidden=true;
        
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ((fromInterfaceOrientation == UIDeviceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)&&(toOrientation == UIDeviceOrientationLandscapeLeft || toOrientation == UIDeviceOrientationLandscapeRight)) {
        //变横屏
        glview_bottom_space.constant=0;
        glview_top_space.constant=0;
    }
    else if((fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown)){
        view_top.hidden=false;
        //变竖屏
        glview_bottom_space.constant=100;
        glview_top_space.constant=100;
    }
    
}

- (IBAction)button_return_click:(id)sender {
    
    m_strings=nil;
    m_share_item=nil;
    [m_player stop_play];
    
    [self dismissViewControllerAnimated:NO completion:^(){
        
    }];
}
@end
