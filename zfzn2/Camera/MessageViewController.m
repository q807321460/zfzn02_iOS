//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "MessageViewController.h"
#import <Foundation/Foundation.h>
@interface MessageViewController () {
    NSInteger m_msgCellNumber;
    UIAlertView* m_alertDelView;
    UIAlertView* m_alertDelFailView;
    UIButton* m_btnDetelte;
    UIButton* m_right;
}
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];

    m_toastLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    m_toastLab.center = self.view.center;
    m_toastLab.backgroundColor = [UIColor whiteColor];
    m_toastLab.textAlignment = NSTextAlignmentCenter;
    m_toastLab.hidden = YES;
    [self.view addSubview:m_toastLab];

    NSLog(@"%f",self.view.frame.size.height - 49);
//    self.m_messageList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 44 - 20)];
    self.m_messageList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.m_messageList];
    self.m_messageList.delegate = self;
    self.m_messageList.dataSource = self;

    self.m_messageList.backgroundColor = [UIColor clearColor];
    self.m_messageList.separatorColor = [UIColor colorWithRed:217.0 / 255.0 green:217.0 / 255.0 blue:217.0 / 255.0 alpha:1.0];
    self.m_messageList.allowsSelection = YES;
    self.m_messageList.bounces = NO;

    m_wholePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 9 / 16)];
    m_wholePic.center = self.view.center;
    [self.view addSubview:m_wholePic];
    m_wholePic.hidden = YES;
    [m_wholePic setUserInteractionEnabled:YES];
    [m_wholePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)]];

    [self.view bringSubviewToFront:self.m_queryView];
    [self.view bringSubviewToFront:m_progressInd];
    self.m_queryView.hidden = YES;
    self.m_MessageNull.hidden = YES;
    m_seleceDate = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    m_strSelectDate = [fmt stringFromDate:m_seleceDate];

    m_msgInfoArray = [[NSMutableArray alloc] init];
    m_util = [[LCOpenSDK_Utils alloc] init];

    for (int i = 0; i < MESSAGE_NUM_MAX; i++) {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }

    m_downStatusLock = [[NSLock alloc] init];
    m_messageListLock = [[NSLock alloc] init];
    m_looping = YES;
    m_conn = nil;

    dispatch_queue_t downQueue = dispatch_queue_create("alarmPicDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });

    m_msgCellNumber = -1;
    [self refreshList];
}

- (IBAction)onBack:(id)sender
{
    [self destroyThread];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (IBAction)onSearch:(id)sender
//{
//    self.m_queryView.hidden = NO;
//}
- (void)onClick:(id)sender
{
    m_wholePic.hidden = YES;
    [m_wholePic setImage:nil];
    self.m_messageList.hidden = NO;
    super.m_navigationBar.hidden = NO;
}
- (void)onDelete:(id)sender
{
    m_btnDetelte = (UIButton*)sender;

    m_alertDelView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"confirm to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [m_alertDelView show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == m_alertDelView) {
        if (0 == buttonIndex) {
            NSLog(@"cancel delete the %ld alarmMessage!", (long)m_btnDetelte.tag);
            return;
        }
        else if (1 == buttonIndex) {
            [self showLoading];
            dispatch_queue_t delete_alarm_msg = dispatch_queue_create("delete_alarm_msg", nil);
            dispatch_async(delete_alarm_msg, ^{
                RestApiService* restApiService = [RestApiService shareMyInstance];
                if ([restApiService deleteAlarmMsg:((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:m_btnDetelte.tag])->alarmId]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideLoading];
                        [self refreshList];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"delete msg failed");
                        m_alertDelFailView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"delete failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [m_alertDelFailView show];
                    });
                }
            });
        }
    }
}

- (void)setInfo:(NSString*)token dev:(NSString*)deviceId chn:(NSInteger)chn
{
//    m_hc = hc;
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    m_accessToken = [NSString stringWithString:token];
    m_strDevSelected = [NSString stringWithString:deviceId];
    m_devChnSelected = chn;
}

- (void)onCancel:(id)sender
{
    self.m_queryView.hidden = YES;
}
- (void)onQuery:(id)sender
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    m_strSelectDate = [fmt stringFromDate:self.m_datePicker.date];

    self.m_queryView.hidden = YES;

    [self refreshList];
}

- (void)onValueChange:(id)sender
{
}

- (void)refreshList
{
    [self showLoading];
    m_toastLab.hidden = YES;
    m_right.enabled = NO;
    [m_messageListLock lock];
    self.m_messageList.hidden = YES;
    [m_messageListLock unlock];

    [m_downStatusLock lock];
    for (int i = 0; i < MESSAGE_NUM_MAX; i++) {
        [m_downloadPicture[i] clearData];
    }
    [m_downStatusLock unlock];
    m_conn = nil;
    m_iPos = 0;
    m_downloadingPos = -1;

    dispatch_queue_t getAlarmMsg = dispatch_queue_create("getAlarmMsg", nil);
    dispatch_async(getAlarmMsg, ^{
        [m_msgInfoArray removeAllObjects];
        NSString* strBeginDate = [m_strSelectDate stringByAppendingString:@" 00:00:00"];
        NSString* strEndDate = [m_strSelectDate stringByAppendingString:@" 23:59:59"];

        RestApiService* restApiService = [RestApiService shareMyInstance];

        if (![restApiService getAlarmMsg:m_strDevSelected Chnl:m_devChnSelected Begin:strBeginDate End:strEndDate Msg:m_msgInfoArray Count:MESSAGE_NUM_MAX]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = @"网络超时，请重试";
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        m_msgCellNumber = m_msgInfoArray.count;

        dispatch_async(dispatch_get_main_queue(), ^{
            [m_messageListLock lock];
            [self.m_messageList reloadData];
            self.m_messageList.hidden = NO;
            [m_messageListLock unlock];
            [self hideLoading];
            m_right.enabled = YES;

        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    self.m_MessageNull.hidden = m_msgCellNumber == 0 ? NO : YES;
    NSLog(@"message num[%ld]", (long)m_msgCellNumber);
    return m_msgCellNumber <= MESSAGE_NUM_MAX ? m_msgCellNumber : MESSAGE_NUM_MAX;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell;

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    NSLog(@"the row is %ld\n", (long)[indexPath row]);

    UIImage* imgPic = nil;

    if (nil != m_downloadPicture[[indexPath row]].picData) {
        NSLog(@"test cell image thumbnail");
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
    }
    else {
        NSLog(@"test cell image default");
        imgPic = [UIImage imageNamed:@"common_defaultcover.png"];
    }

    [m_messageListLock lock];
    if ([indexPath row] >= [m_msgInfoArray count]) {
        NSLog(@"cellForRowAtIndexPath index error ,count[%lu],index[%ld]", (unsigned long)[m_msgInfoArray count], (long)[indexPath row]);
        [m_messageListLock unlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_messageList reloadData];
        });
        return cell;
    }

    UIImageView* imgPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, Separate_Cell, (Message_Cell_Height - Separate_Cell) * 16.0 / 9, Message_Cell_Height - Separate_Cell)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];

    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake((Message_Cell_Height - Separate_Cell) * 16.0 / 9 + 20, Separate_Cell, 100, (Message_Cell_Height - Separate_Cell) / 2)];
    lbl.text = @"报警时间";
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:15];
    [cell addSubview:lbl];

    UILabel* lblLocal = [[UILabel alloc] initWithFrame:CGRectMake((Message_Cell_Height - Separate_Cell) * 16.0 / 9 + 20, Separate_Cell + (Message_Cell_Height - Separate_Cell) / 2, 200, (Message_Cell_Height - Separate_Cell) / 2)];
    lblLocal.text = ((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:[indexPath row]])->localDate;
    [lblLocal setTextColor:[UIColor colorWithRed:147 / 255.0 green:147 / 255.0 blue:153 / 255.0 alpha:1.0]];
    lblLocal.font = [UIFont boldSystemFontOfSize:13.0];
    lblLocal.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [cell addSubview:lblLocal];

    UIButton* btnDelDev = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelDev.frame = CGRectMake(Message_Cell_Width - 40 - 5, Separate_Cell, 40, 40);
    UIImage* imgDelDev = [UIImage imageNamed:@"message_icon_trash-0.png"];
    [btnDelDev setImage:imgDelDev forState:UIControlStateNormal];
    [cell addSubview:btnDelDev];
    btnDelDev.tag = [indexPath row];
    [btnDelDev addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = NO;
    [m_messageListLock unlock];

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.m_messageList == tableView) {
        if (nil != m_downloadPicture[[indexPath row]].picData) {
            [m_wholePic setImage:[UIImage imageWithData:m_downloadPicture[[indexPath row]].picData]];
        }
        else {
            [m_wholePic setImage:[UIImage imageNamed:@"common_defaultcover.png"]];
        }

        m_wholePic.hidden = NO;
        self.m_messageList.hidden = YES;
        self.m_queryView.hidden = YES;
        super.m_navigationBar.hidden = YES;
        [self showLoading];
        dispatch_queue_t whole_pic_download = dispatch_queue_create("whole_pic_download", nil);
        dispatch_async(whole_pic_download, ^{
            NSString* picUrl = [NSString stringWithString:((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:[indexPath row]])->picArray[0]];
            NSURL* httpUrl = [NSURL URLWithString:picUrl];

            NSURLRequest* request = [NSMutableURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse* response = nil;
                NSData* picData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];

                if (response == nil) {
                    NSLog(@"download failed");
                }
                else {
                    m_downloadPicture[m_downloadingPos].picData = picData;
                    NSData* dataOut = [[NSData alloc] init];

                    NSInteger iret = [m_util decryptPic:picData key:m_strDevSelected bufOut:&dataOut];
                    NSLog(@"decrypt iret[%ld]", (long)iret);
                    if (0 == iret) {
                        UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]]];
                        [m_wholePic setImage:img];
                    }
                }
                [self hideLoading];
            });

        });
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return Message_Cell_Height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadThread
{
    m_iPos = 0;
    m_downloadingPos = -1;
    int j;
    while (m_looping) {
        usleep(20 * 1000);
        BOOL bNeedDown = YES;
        NSString* picUrl;

        [m_messageListLock lock];
        [m_downStatusLock lock];
        do {
            picUrl = nil;

            if (m_iPos < 0 || m_iPos >= [m_msgInfoArray count]) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);
                break;
            }

            for (j = 0; j < MESSAGE_NUM_MAX; j++) {
                if (DOWNLOADING == m_downloadPicture[j].downStatus) {
                    break;
                }
            }
            if (j < MESSAGE_NUM_MAX) {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);
                break;
            }
            // 缩略图Url：thumbnail
            picUrl = [NSString stringWithString:((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:m_iPos])->thumbnail];
        } while (0);

        [m_messageListLock unlock];

        if (NO == bNeedDown) {
            [m_downStatusLock unlock];
            usleep(10 * 1000);
            continue;
        }

        //download
        m_httpUrl = [NSURL URLWithString:picUrl];
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);

        NSURLRequest* request = [NSMutableURLRequest requestWithURL:m_httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSHTTPURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];

        if (m_downloadingPos < 0) {
            NSLog(@"m_downloadingPos[%ld]", (long)m_downloadingPos);
            return;
        }

        if (response == nil) {
            NSLog(@"download failed");
            m_downloadPicture[m_downloadingPos].downStatus = DOWNLOADFAILED;
        }
        else {
            NSLog(@"connectionDidFinishLoading m_downloadingPos[%ld]", (long)m_downloadingPos);
            m_downloadPicture[m_downloadingPos].picData = data;
            NSData* dataOut = [[NSData alloc] init];

            NSInteger iret = [m_util decryptPic:m_downloadPicture[m_downloadingPos].picData key:m_strDevSelected bufOut:&dataOut];
            NSLog(@"decrypt iret[%ld]", (long)iret);
            if (0 == iret) {
                [m_downloadPicture[m_downloadingPos] setData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]] status:DOWNLOADFINISHED];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.self.m_messageList reloadData];
                });
            }
            else {
                [m_downloadPicture[m_downloadingPos] setData:nil status:DOWNLOADFAILED];
            }
        }
        [m_downStatusLock unlock];
    }
}
- (void)destroyThread
{
    m_looping = NO;
    m_conn = nil;
}

// 显示滚动轮指示器
- (void)showLoading
{
    [m_progressInd startAnimating];
}
// 消除滚动轮指示器
- (void)hideLoading
{
    if ([m_progressInd isAnimating]) {
        [m_progressInd stopAnimating];
    }
}

- (void)dealloc
{
    //    NSLog(@"retain count = %ld\n", CFGetRetainCount((__bridge CFTypeRef)(self)));
    //    NSLog(@"MessageViewController dealloc");
}
@end
