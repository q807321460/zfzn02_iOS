//
//  JDMyDeviceViewController.h
//  JDMusic
//
//  Created by henry on 15/10/17.
//  Copyright © 2015年 henry. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JdMyDeviceViewController : UIViewController

@property (nonatomic,strong) NSMutableArray * deviceListArr;

@property (weak, nonatomic) IBOutlet UIView * noDevice;
@property (weak, nonatomic) IBOutlet UITableView * tableview;
- (IBAction)OnBack:(UIButton *)sender;

@end
