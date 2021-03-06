//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_MessageViewController_h
#define LCOpenSDKDemo_MessageViewController_h
#import "DeviceViewController.h"
#import "DownloadPicture.h"
#import "LCOpenSDK_Utils.h"
#import "MyViewController.h"
#import "RestApiService.h"
#import <UIKit/UIKit.h>

#define MESSAGE_NUM_MAX 10

#define Message_Cell_Width ([[UIScreen mainScreen] bounds].size.width)
#define Separate_Cell 9
#define Message_Cell_Height 64
@interface MessageViewController : MyViewController <UITableViewDataSource, UITableViewDelegate> {
    LCOpenSDK_Api* m_hc;
    LCOpenSDK_Utils* m_util;
    NSString* m_accessToken;
    NSString* m_strDevSelected;
    NSInteger m_devChnSelected;

    NSDate* m_seleceDate;
    NSString* m_strSelectDate;
//    UITableView* m_messageList;
    NSMutableArray* m_msgInfoArray;
    DownloadPicture* m_downloadPicture[MESSAGE_NUM_MAX];
    UIImageView* m_wholePic;
    UIActivityIndicatorView* m_progressInd;
    UILabel* m_toastLab;

    NSLock* m_messageListLock;
    NSLock* m_downStatusLock;
    BOOL m_looping;
    NSInteger m_iPos;
    NSInteger m_downloadingPos;

    NSURL* m_httpUrl;
    NSURLConnection* m_conn;
}
@property (weak, nonatomic) IBOutlet UIImageView* m_MessageNull;
@property IBOutlet UIView* m_queryView;
@property IBOutlet UIDatePicker* m_datePicker;
@property (weak, nonatomic) IBOutlet UITableView *m_messageList;

- (IBAction)onBack:(id)sender;
//- (void)onSearch:(id)sender;
- (void)onClick:(id)sender;
- (void)onDelete:(id)sender;
- (IBAction)onSearch:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onQuery:(id)sender;
- (IBAction)onValueChange:(id)sender;
- (void)setInfo:(NSString*)token dev:(NSString*)deviceId chn:(NSInteger)chn;
- (void)refreshList;

- (void)downloadThread;
- (void)destroyThread;

@end
#endif
