//
//  LocalRecordViewController.m
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/11.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import "DownloadPicture.h"
#import "LCOpenSDK/LCOpenSDK_Download.h"
#import "LCOpenSDK_Utils.h"
#import "RecordPlayViewController.h"
#import "RecordViewController.h"
#import "RestApiService.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define RECORD_NUM_MAX 10

@interface RecordViewController () {
    LCOpenSDK_Utils* m_util;
    LCOpenSDK_Download* m_download;
    NSString* m_downloadPath;
    int64_t m_totalDataSize[RECORD_NUM_MAX];
    int64_t m_receiveDataSize[RECORD_NUM_MAX];
    BOOL m_isCloudDownload[RECORD_NUM_MAX];
    NSInteger m_index; //正在下载的index，用于限制下载数目为1

    CGFloat m_cellWidth;
    CGFloat m_cellHeight;
    CGFloat m_separatorHeight;
    NSMutableArray* m_recInfo;
    DownloadPicture* m_downloadPicture[RECORD_NUM_MAX];
    NSString* m_dateSelected;
    NSLock* m_listViewLock;
//    UITableView* m_listView;
    BOOL m_isStarting;

    NSLock* m_recInfoLock;
    NSLock* m_downStatusLock;
    BOOL m_looping;
    NSInteger m_iPos;
    NSInteger m_downloadingPos;

    NSURL* m_httpUrl;
    NSMutableURLRequest* m_req;
    NSURLConnection* m_conn;

    NSInteger m_interval;
    NSTimer* m_timer;
    NSMutableSet* m_downloadSet;

    UIButton* m_right;
}

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWindow];
    [self initDatePicker];

    UINavigationItem* item;
    if (m_recordType == DeviceRecord) {
        item = [[UINavigationItem alloc] initWithTitle:@"本地录像"];
    }
    else if (m_recordType == CloudRecord) {
        item = [[UINavigationItem alloc] initWithTitle:@"云存储录像"];
    }
    
//    m_listView = [[UITableView alloc] initWithFrame:CGRectMake(0, super.m_yOffset, self.view.frame.size.width,
//                                                        self.view.frame.size.height - super.m_yOffset)];
    self.m_listView.delegate = (id<UITableViewDelegate>)self;
    self.m_listView.dataSource = (id<UITableViewDataSource>)self;
    self.m_listView.backgroundColor = [UIColor clearColor];
    self.m_listView.separatorColor = [UIColor clearColor];
    self.m_listView.allowsSelection = YES;
    self.m_listView.bounces = NO;
    
    //konnn
//    self.automaticallyAdjustsScrollViewInsets = false;//保证顶部不留白
//    m_listView.tableFooterView = [UIView init];
    
    [self.view addSubview:self.m_listView];

    
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

    m_recInfo = [[NSMutableArray alloc] init];
    m_util = [[LCOpenSDK_Utils alloc] init];

    [self.view bringSubviewToFront:self.m_viewDateBar];
    [self.view bringSubviewToFront:m_toastLab];
    [self.view bringSubviewToFront:m_progressInd];

    for (int i = 0; i < RECORD_NUM_MAX; i++) {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }
    m_index = -1;
    m_iPos = 0;
    m_downloadingPos = -1;

    m_listViewLock = [[NSLock alloc] init];
    m_downStatusLock = [[NSLock alloc] init];
    m_recInfoLock = [[NSLock alloc] init];
    m_looping = YES;
    m_conn = nil;
    m_downloadSet = [[NSMutableSet alloc] init];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onSmsTimer:) userInfo:nil repeats:YES];

    m_download = [LCOpenSDK_Download shareMyInstance];
    [m_download setListener:(id<LCOpenSDK_DownloadListener>)self];

    [self getRecords];

    dispatch_queue_t downQueue = dispatch_queue_create("cloudThumbnailDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setInfo:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn Type:(RecordType)type
{
    m_accessToken = [NSString stringWithString:token];
    m_strDevSelected = [NSString stringWithString:deviceId];
    m_devChnSelected = chn;
    m_recordType = type;
    //konnn
//    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
//    m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
    
//    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
//    m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:@"openapi.lechange.cn" port:443 CA_PATH:cerPath];
//    m_strAccessToken = [NSString stringWithString:token];
//    RestApiService* restApiService = [RestApiService shareMyInstance];
//    if (nil != m_hc) {
//        [restApiService initComponent:m_hc Token:m_strAccessToken];
//    }
}

- (NSString*)timeTransformFormatter:(NSString*)time
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"; //正常字符范围
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理
    //不符合格式的返回nil
    if (![pred evaluateWithObject:time]) {
        NSLog(@"Time format error:%@", time);
        return nil;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* retTime = [formatter stringFromDate:date];
    return [retTime substringFromIndex:2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    //    NSLog(@"section is 1====\n");
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSLog(@"device or cloud record [%lu],section[%ld]\n", (unsigned long)m_recInfo.count, (long)section);
    self.m_ImgRecordNull.hidden = (0 == m_recInfo.count && m_isStarting) ? NO : YES;

    NSInteger iCount = 0;
    [m_recInfoLock lock];
    iCount = m_recInfo.count;
    [m_recInfoLock unlock];
    return iCount;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return m_cellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"Cell";

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [m_recInfoLock lock];
    if ([indexPath row] >= m_recInfo.count) {
        NSLog(@"RecordViewController cellForRowAtIndexPath not valid,row[%ld],count[%lu]", (long)[indexPath row], (unsigned long)m_recInfo.count);
        [m_recInfoLock unlock];
        return cell;
    }
    NSString* beginTime = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->beginTime;
    NSString* endTime = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->endTime;
    [m_recInfoLock unlock];

    UIImage* imgPic = nil;

    if (nil != m_downloadPicture[[indexPath row]].picData) {
        NSLog(@"test cell image thumbnail");
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
    }
    else {
        NSLog(@"test cell image default");

        imgPic = [UIImage imageNamed:@"common_defaultcover.png"];
    }
    UIImageView* imgPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (m_cellHeight)*16.0 / 9, m_cellHeight)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];

    UIImageView* mImgBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_toast_bg"]];
    mImgBar.frame = CGRectMake(-50, m_cellHeight - m_separatorHeight - 30, m_cellWidth + 100, 30);
    [mImgBar setContentMode:UIViewContentModeScaleAspectFill];
    mImgBar.clipsToBounds = YES;
    [cell addSubview:mImgBar];
    UILabel* dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, m_cellHeight - m_separatorHeight - 30, m_cellWidth - 10 - 2 * 30, 30)];
    dateLab.text = [NSString stringWithFormat:@"%@—%@", [self timeTransformFormatter:beginTime], [self timeTransformFormatter:endTime]];
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.textColor = [UIColor whiteColor];
    [dateLab setFont:[UIFont systemFontOfSize:13.0f]];
    [cell addSubview:dateLab];

    UIView* additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, m_cellHeight - m_separatorHeight, m_cellWidth, m_separatorHeight)];
    additionalSeparator.backgroundColor = [UIColor whiteColor];
    [cell addSubview:additionalSeparator];

    if (m_totalDataSize[[indexPath row]] != 0) {
        double rate = 1.0 * m_receiveDataSize[[indexPath row]] / m_totalDataSize[[indexPath row]];
        rate = rate > 1.0 ? 1.0 : rate;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(m_cellWidth - 60, m_cellHeight - m_separatorHeight - 30 + 2.5, rate * 2 * (30 - 5), 30 - 5)];
        label.backgroundColor = [UIColor greenColor];
        [cell addSubview:label];

        UIButton* downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(m_cellWidth - 60, m_cellHeight - m_separatorHeight - 30 + 2.5, 2 * (30 - 5), 30 - 5)];
        if (m_isCloudDownload[[indexPath row]]) {
            [downloadBtn setBackgroundImage:[UIImage imageNamed:@"video_download_cancel"] forState:UIControlStateNormal];
        }
        else {
            [downloadBtn setBackgroundImage:[UIImage imageNamed:@"video_download"] forState:UIControlStateNormal];
        }
        downloadBtn.tag = [indexPath row];
        [downloadBtn addTarget:self action:@selector(onDownload:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:downloadBtn];
        [cell bringSubviewToFront:downloadBtn];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [m_recInfoLock lock];
    if ([indexPath row] >= m_recInfo.count) {
        NSLog(@"tableView indexPath[%ld],m_recInfo[%lu]", (long)[indexPath row], (unsigned long)m_recInfo.count);
        [m_recInfoLock unlock];
        return;
    }
    if (m_recordType == DeviceRecord)

    {
        m_strRecSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->name;
    }
    else if (m_recordType == CloudRecord) {
        //处于下载状态，不允许播放云录像
        if (-1 != m_index) {
            [m_recInfoLock unlock];
            [self showDownloadToast:DOWNLOADING];
            return;
        }
        m_strRecSelected = [NSString stringWithFormat:@"%lld", (int64_t)((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->recId];
    }
    m_beginTimeSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->beginTime;
    m_endTimeSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->endTime;
    m_imgPicSelected = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];

    [m_recInfoLock unlock];
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordPlayViewController* recordPlayView = [currentBoard instantiateViewControllerWithIdentifier:@"RecordPlay"];
    [recordPlayView setInfo:m_accessToken Dev:m_strDevSelected Chn:m_devChnSelected Type:m_recordType];
    [recordPlayView setRecInfo:m_strRecSelected Begin:m_beginTimeSelected End:m_endTimeSelected Img:m_imgPicSelected];
    [self.navigationController pushViewController:recordPlayView animated:NO];
}

- (void)initWindow
{
    m_separatorHeight = 5;
    m_cellWidth = [UIScreen mainScreen].bounds.size.width;
    m_cellHeight = m_cellWidth * 9 / 16 + m_separatorHeight;
    self.m_viewDateBar.hidden = YES;
    m_isStarting = NO;
}

- (void)initDatePicker
{
    self.m_datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //设置日期显示的格式
    self.m_datePicker.datePickerMode = UIDatePickerModeDate;
    [self.m_datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChange:(UIDatePicker*)datePicker
{
    //创建一个日期格式
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    //设置日期的显示格式
    fmt.dateFormat = @"yyyy-MM-dd";
    //将日期转为指定格式显示
    NSString* dateStr = [fmt stringFromDate:datePicker.date];
    m_dateSelected = dateStr;
}

- (void)onCancel:(id)sender
{
    self.m_viewDateBar.hidden = YES;
}

- (void)onQuery:(id)sender
{
    for (NSString* obj in m_downloadSet) {
        NSInteger index = [obj intValue];
        [m_download stopDownload:index];
        m_isCloudDownload[index] = NO;
        m_receiveDataSize[index] = 0;
        [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
        m_index = -1;
    }
    [m_downStatusLock lock];
    for (int i = 0; i < RECORD_NUM_MAX; i++) {
        [m_downloadPicture[i] clearData];
    }
    m_iPos = 0;
    m_downloadingPos = -1;
    m_conn = nil;
    [m_downStatusLock unlock];

    self.m_viewDateBar.hidden = YES;
    [m_listViewLock lock];
    self.m_listView.hidden = YES;
    self.m_ImgRecordNull.hidden = YES;
    [m_listViewLock unlock];

    [self getRecords];
}

- (void)onSearch:(id)sender
{
    self.m_viewDateBar.hidden = NO;
}

- (void)onDownload:(UIButton*)sender
{
    NSLog(@"RecordPlayViewController onDownload");
    /**
     *  管理标志符， 
     *  m_index == -1, 下载任务未开始
     *  m_index != -1, 下载任务已开启，不再开启下载任务
     */
    if (m_index != -1 && m_index != sender.tag) {
        [self showDownloadToast:DOWNLOADING];
        return;
    }
    m_index = sender.tag;
    if (m_index < 0) {
        NSLog(@"RecordPlayViewController onDownload[%ld] Wrong!", (long)m_index);
        m_index = -1;
        return;
    }
    // 取消下载任务
    if (m_isCloudDownload[m_index]) {
        [m_download stopDownload:m_index];
        m_isCloudDownload[m_index] = NO;
        m_receiveDataSize[m_index] = 0;
        [m_listViewLock lock];
        [self reloadCell:self.m_listView Section:0 Row:m_index];
        [m_listViewLock unlock];
        [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)m_index]];
        [self showDownloadToast:NONE];
        m_index = -1;
        return;
    }

    // 开始下载任务
    m_isCloudDownload[m_index] = YES;
    [m_downloadSet addObject:[NSString stringWithFormat:@"%ld", (long)m_index]];
    int64_t recId = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->recId;
    NSString* beginTime = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->beginTime;
    NSString* time;

    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"; //正常字符范围
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理

    if ([pred evaluateWithObject:beginTime]) {
        NSArray* array = [beginTime componentsSeparatedByString:@" "];
        NSArray* arrayDate = [array[0] componentsSeparatedByString:@"-"];
        NSArray* arrayTime = [array[1] componentsSeparatedByString:@":"];
        time = [arrayDate[0] stringByAppendingFormat:@"%@%@%@%@%@", arrayDate[1], arrayDate[2], arrayTime[0], arrayTime[1], arrayTime[2]];
    }

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* downloadDirectory = [myDirectory stringByAppendingPathComponent:@"download"];

    NSString* infoPath = [downloadDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_download_%lld", time, recId]];
    m_downloadPath = [infoPath stringByAppendingString:@".mp4"];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:downloadDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    NSLog(@"RecordPlayViewController[m_downloadPath] = %@", m_downloadPath);
    [m_listViewLock lock];
    [self reloadCell:self.m_listView Section:0 Row:m_index];
    [m_listViewLock unlock];
    [m_download startDownload:m_index filepath:m_downloadPath token:m_accessToken devID:m_strDevSelected recordID:recId Timeout:10];
}

- (void)onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index < 0 || index >= RECORD_NUM_MAX) {
            NSLog(@"RecordViewController, index Wrong!");
            return;
        }
        //        NSLog(@"retain count = %ld\n", CFGetRetainCount((__bridge CFTypeRef)(self)));
        m_receiveDataSize[index] = m_receiveDataSize[index] + datalen;
    });
}

- (void)onDownloadState:(NSInteger)index code:(NSString*)code type:(NSInteger)type
{
    NSLog(@"RecordPlayViewController onDownloadState[code, type] = [%@, %ld]", code, (long)type);
    if (99 == type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"openapi 网络交互超时");
            m_isCloudDownload[index] = NO;
            [m_listViewLock lock];
            [self reloadCell:self.m_listView Section:0 Row:index];
            [m_listViewLock unlock];
            [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
            [self showDownloadToast:DOWNLOADFAILED];
            m_index = -1;
        });
        return;
    }
    if (1 == type) {
        if ([HLS_Result_String(HLS_DOWNLOAD_FAILD) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAD_FAILD");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:self.m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOADFAILED];
                m_index = -1;
            });
            return;
        }
        if ([HLS_Result_String(HLS_DOWNLOAD_BEGIN) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAD_BEGIN");
            });
            return;
        }
        if ([HLS_Result_String(HLS_DOWNLOAD_END) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAD_END");
            });
            return;
        }
        if ([HLS_Result_String(HLS_SEEK_SUCCESS) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_SEEK_SUCCESS");
            });
            return;
        }
        if ([HLS_Result_String(HLS_SEEK_FAILD) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_SEEK_FAILD");
            });
            return;
        }
        if ([HLS_Result_String(HLS_ABORT_DONE) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_ABORT_DONE");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:self.m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOADFAILED];
                m_index = -1;
            });
            return;
        }
        if ([HLS_Result_String(HLS_DOWNLOAS_TIMEOUT) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAS_TIMEOUT");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:self.m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOADFAILED];
                m_index = -1;
            });
            return;
        }
    }
}

- (void)onDownloadEnd:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        m_isCloudDownload[index] = NO;
        m_receiveDataSize[index] = 0;
        [m_listViewLock lock];
        [self reloadCell:self.m_listView Section:0 Row:index];
        [m_listViewLock unlock];
        [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
        [self showDownloadToast:DOWNLOADFINISHED];
        m_index = -1;

        [self saveVideoToPhone:m_downloadPath];

    });
}

- (void)onSmsTimer:(NSInteger)index
{
    for (NSString* obj in m_downloadSet) {
        [m_listViewLock lock];
        [self reloadCell:self.m_listView Section:0 Row:[obj intValue]];
        [m_listViewLock unlock];
    }
}

- (void)saveVideoToPhone:(NSString*)path
{
    if (!UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        NSLog(@"无录像，保存失败");
        return;
    }
    // 保存图片, 并且保存的图片不能再次被保存直到被删除
    NSString* key = [NSString stringWithFormat:@"assetUrl %@", path];
    NSString* savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSURL* url = [NSURL URLWithString:savedValue];

    if (url != nil) {
        PHFetchResult* result = [PHAsset fetchAssetsWithALAssetURLs:[NSArray arrayWithObject:url] options:nil];
        if (result.count) {
            NSLog(@"录像已存在");
            NSMutableArray* toDeleteAssets = [NSMutableArray new];

            for (PHAsset* asset in result) {
                [toDeleteAssets addObject:asset];
            }

            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest deleteAssets:toDeleteAssets];
            }
                completionHandler:^(BOOL success, NSError* error) {
                    if ((!success) && (error != nil)) {
                        NSLog(@"Error deleting asset: %@", [error description]);
                    }
                }];
        }
    }

    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path]
                                completionBlock:^(NSURL* assetURL, NSError* error) {
                                    [library assetForURL:assetURL
                                        resultBlock:^(ALAsset* asset) {
                                            NSString* ass = [assetURL absoluteString];
                                            [[NSUserDefaults standardUserDefaults] setObject:ass forKey:key];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            NSLog(@"保存成功");
                                        }
                                        failureBlock:^(NSError* error) {
                                            NSLog(@"保存失败");
                                        }];
                                }];
}

- (void)onBack:(id)sender
{
    for (NSString* obj in m_downloadSet) {
        [m_download stopDownload:[obj intValue]];
    }
    [m_timer invalidate];
    [self destroyThread];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getRecords
{
    m_right.enabled = NO;
    switch (m_recordType) {
    case DeviceRecord:
        [self getLocalRecords];
        break;
    case CloudRecord:
        [self getCloudRecords];
    default:
        break;
    }
}

- (void)getLocalRecords
{
    [self showLoading];
    m_toastLab.hidden = YES;
    dispatch_queue_t get_local_records = dispatch_queue_create("get_local_records", nil);
    dispatch_async(get_local_records, ^{
        NSInteger year, month, day;
        NSInteger hour, minute, second;
        NSString* sBeginTime;
        NSString* sEndTime;
        year = month = day = hour = minute = second = 0;

        if (m_dateSelected == nil) {
            [self getCurrentDate:&year month:&month day:&day hour:&hour minute:&minute second:&second];
        }
        else {
            NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2}"; //正常字符范围
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理
            if ([pred evaluateWithObject:m_dateSelected]) {
                year = [[m_dateSelected substringWithRange:(NSRange){ 0, 4 }] intValue];
                month = [[m_dateSelected substringWithRange:(NSRange){ 5, 2 }] intValue];
                day = [[m_dateSelected substringWithRange:(NSRange){ 8, 2 }] intValue];
            }
        }
        sBeginTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", (long)year, (long)month, (long)day];
        sEndTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", (long)year, (long)month, (long)day];

        if (YES == m_isStarting) {
            [m_recInfoLock lock];
        }
        [self freeRecInfo];
        //end.
        NSString* errMsg;
        RestApiService* restApiService = [RestApiService shareMyInstance];
        NSInteger iNum = [restApiService getRecordNum:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime Desc:&errMsg];
        if (!errMsg) {
            NSLog(@"网络超时，请重试");
            if (YES == m_isStarting) {
                [m_recInfoLock unlock];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = @"网络超时，请重试";
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        if (iNum > 0) {
            NSInteger beginIndex = iNum > 10 ? (iNum - 9) : 1;
            if (![restApiService getRecords:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime IndexBegin:beginIndex IndexEnd:iNum InfoOut:m_recInfo]) {
                NSLog(@"网络超时，请重试");
                if (YES == m_isStarting) {
                    [m_recInfoLock unlock];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    m_toastLab.text = @"网络超时，请重试";
                    m_toastLab.hidden = NO;
                    m_right.enabled = YES;
                });
                return;
            }
            NSInteger count = m_recInfo.count;
            for (NSInteger i = 0; i <= count / 2 - 1; i++) {
                RecordInfo* t_record = [m_recInfo objectAtIndex:i];
                m_recInfo[i] = m_recInfo[count - 1 - i];
                m_recInfo[count - 1 - i] = t_record;
            }
        }
        if (YES == m_isStarting) {
            [m_recInfoLock unlock];
        }

        m_isStarting = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_listViewLock lock];
            self.m_listView.hidden = NO;
            [self.m_listView reloadData];
            [m_listViewLock unlock];
            [self hideLoading];
            m_right.enabled = YES;
        });
    });
}

- (void)getCloudRecords
{
    [self showLoading];
    m_toastLab.hidden = YES;
    dispatch_queue_t get_cloud_records = dispatch_queue_create("get_cloud_records", nil);
    dispatch_async(get_cloud_records, ^{
        NSInteger year, month, day;
        NSInteger hour, minute, second;
        NSString* sBeginTime;
        NSString* sEndTime;
        year = month = day = hour = minute = second = 0;
        // TODO
        if (m_dateSelected == nil) {
            [self getCurrentDate:&year month:&month day:&day hour:&hour minute:&minute second:&second];
        }
        else {
            NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2}"; //正常字符范围
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理
            if ([pred evaluateWithObject:m_dateSelected]) {
                year = [[m_dateSelected substringWithRange:(NSRange){ 0, 4 }] intValue];
                month = [[m_dateSelected substringWithRange:(NSRange){ 5, 2 }] intValue];
                day = [[m_dateSelected substringWithRange:(NSRange){ 8, 2 }] intValue];
            }
        }
        sBeginTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", (long)year, (long)month, (long)day];
        sEndTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", (long)year, (long)month, (long)day];

        if (YES == m_isStarting) {
            [m_recInfoLock lock];
        }
        [self freeRecInfo];

        NSString* errMsg;
        RestApiService* restApiService = [RestApiService shareMyInstance];
        NSInteger iNum = [restApiService getCloudRecordNum:m_strDevSelected Chnl:m_devChnSelected Bengin:sBeginTime End:sEndTime Desc:&errMsg];
        if (!errMsg) {
            NSLog(@"网络超时，请重试");
            if (YES == m_isStarting) {
                [m_recInfoLock unlock];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = @"网络超时，请重试";
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        if (iNum > 0) {
            m_toastLab.hidden = YES;
            NSInteger beginIndex = iNum > 10 ? (iNum - 9) : 1;
            if (![restApiService getCloudRecords:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime IndexBegin:beginIndex IndexEnd:iNum InfoOut:m_recInfo]) {
                NSLog(@"网络超时，请重试");
                if (YES == m_isStarting) {
                    [m_recInfoLock unlock];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    m_toastLab.text = @"网络超时，请重试";
                    m_toastLab.hidden = NO;
                    m_right.enabled = YES;
                });
                return;
            }

            NSInteger count = m_recInfo.count;
            for (NSInteger i = 0; i <= count / 2 - 1; i++) {
                RecordInfo* t_record = [m_recInfo objectAtIndex:i];
                m_recInfo[i] = m_recInfo[count - 1 - i];
                m_recInfo[count - 1 - i] = t_record;
            }
        }
        for (NSInteger i = 0; i < m_recInfo.count; i++) {
            m_totalDataSize[i] = [((RecordInfo*)[m_recInfo objectAtIndex:i])->size longLongValue];
            m_receiveDataSize[i] = 0;
            m_isCloudDownload[i] = NO;
        }
        if (YES == m_isStarting) {
            [m_recInfoLock unlock];
        }
        m_isStarting = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            [m_listViewLock lock];
            self.m_listView.hidden = NO;
            [self.m_listView reloadData];
            [m_listViewLock unlock];
            m_right.enabled = YES;
        });
    });
}

- (void)getCurrentDate:(NSInteger*)year month:(NSInteger*)month day:(NSInteger*)day hour:(NSInteger*)hour minute:(NSInteger*)minute second:(NSInteger*)second
{
    NSDate* now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents* dateComponent = [calendar components:unitFlags fromDate:now];
    *year = [dateComponent year];
    *month = [dateComponent month];
    *day = [dateComponent day];
    *hour = [dateComponent hour];
    *minute = [dateComponent minute];
    *second = [dateComponent second];
}

- (void)freeRecInfo
{
    [m_recInfo removeAllObjects];
}

- (void)reloadCell:(UITableView*)tableView Section:(NSInteger)section Row:(NSInteger)row
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];

    if ([tableView numberOfRowsInSection:section] > row) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
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

        [m_recInfoLock lock];
        [m_downStatusLock lock];
        do {
            picUrl = nil;

            if (m_iPos < 0 || m_iPos >= m_recInfo.count) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);
                break;
            }

            for (j = 0; j < RECORD_NUM_MAX; j++) {
                if (DOWNLOADING == m_downloadPicture[j].downStatus) {
                    break;
                }
            }
            if (j < RECORD_NUM_MAX) {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);
                break;
            }
            picUrl = [NSString stringWithString:((RecordInfo*)[m_recInfo objectAtIndex:m_iPos])->thumbUrl];
        } while (0);

        [m_recInfoLock unlock];

        if (NO == bNeedDown) {
            [m_downStatusLock unlock];
            continue;
        }
        //download
        m_httpUrl = [NSURL URLWithString:picUrl];
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);

        NSURLRequest* request = [NSMutableURLRequest requestWithURL:m_httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
        NSHTTPURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
        if (m_downloadingPos < 0) {
            NSLog(@"connectionDidFinishLoading m_downloadingPos[%ld]", (long)m_downloadingPos);
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
                    [m_listViewLock lock];
                    [self.m_listView reloadData];
                    [m_listViewLock unlock];
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
}

- (void)showDownloadToast:(DownStatus)status
{
    switch (status) {
    case DOWNLOADFINISHED:
        m_toastLab.text = @"下载成功";
        m_toastLab.hidden = NO;
        [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
        break;
    case DOWNLOADFAILED:
        m_toastLab.text = @"下载失败";
        m_toastLab.hidden = NO;
        [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
        break;
    case DOWNLOADING:
        m_toastLab.text = @"下载中，请稍等";
        m_toastLab.hidden = NO;
        [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
        break;
    case NONE:
        m_toastLab.text = @"取消下载";
        m_toastLab.hidden = NO;
        [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
        break;
    default:
        break;
    }
}

- (void)downloadToastDelay
{
    m_toastLab.hidden = YES;
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
    NSLog(@"RecordViewController, dealloc");
}
@end
