//
//  AddDeviceViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_AddDeviceViewController_h
#define LCOpenSDKDemo_AddDeviceViewController_h

#import "MyViewController.h"
#import "RestApiService.h"
#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UIViewController {
    LCOpenSDK_Api* m_hc;
    NSString* m_strAccessToken;
    NSInteger m_nAreaListFoot;
}
@property IBOutlet UITextField* m_textSerial;
@property (weak, nonatomic) IBOutlet UITextField *m_textName;
@property IBOutlet UITextField* m_textPasswd;
@property IBOutlet UILabel* m_lblSsid;
@property IBOutlet UILabel* m_lblHint;
@property IBOutlet UIButton* m_btnWifi;
- (IBAction)TouchDown:(UIControl *)sender;

- (IBAction)onBack:(id)sender;
- (void)setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token areaFoot:(NSInteger)areaFoot;

- (IBAction)onWifi:(id)sender;
- (void)notify:(NSInteger)event;

@end
#endif
