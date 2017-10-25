//
//  ZCZBarViewController.m
//  ZbarDemo
//
//  Created by ZhangCheng on 14-4-18.
//  Copyright (c) 2014年 ZhangCheng. All rights reserved.
//

#import "ZCZBarViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#import "AppDelegate.h"
#import "DevicesManagerNetworkMgr.h"
#import "SBApplianceEngineMgr.h"


@interface ZCZBarViewController ()

@end

@implementation ZCZBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithBlock:(void(^)(NSString*,BOOL))a{
    if (self=[super init]) {
        self.ScanResult=a;
        
    }
    
    return self;
}
-(void)createView{
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    bgImageView.contentMode=UIViewContentModeTop;
//    bgImageView.clipsToBounds=YES;
    bgImageView.userInteractionEnabled=YES;
    
    if (self.view.frame.size.height<500) {
        //4s
        bgImageView.image = [UIImage imageNamed:@"qrcode_scan_bg_Green"];
        
    }else{
        //5及以上
        bgImageView.image = [[UIImage imageNamed:@"qrcode_scan_bg_Green_iphone5"] stretchableImageWithLeftCapWidth:(SCREEN_WIDTH/2) topCapHeight:420];
        
    }
    
    [self.view addSubview:bgImageView];
    
    self.guideLabel = [[UILabel alloc] init];
    
    if (self.view.frame.size.height<600) {
        //5S及以下
        self.guideLabel.frame = CGRectMake(0, 344, SCREEN_WIDTH, 40);
        
    }else{
        
        if (667 == self.view.frame.size.height) {
            //6
            self.guideLabel.frame = CGRectMake(0, 379, SCREEN_WIDTH, 40);
        }else{
            //6s
            self.guideLabel.frame = CGRectMake(0, 379, SCREEN_WIDTH, 40);
        }

    }
    
    self.guideLabel.text = @"对准红卫星二维码，即可自动扫描";

    
    
    self.guideLabel.textColor = kBindCode_Describ_Color;
    self.guideLabel.textAlignment = NSTextAlignmentCenter;
//    self.guideLabel.lineBreakMode = NSLineBreakByWordWrapping; //省略模式
    self.guideLabel.numberOfLines = 2;
    self.guideLabel.font=[UIFont systemFontOfSize:12];
    self.guideLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.guideLabel];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 70, SCREEN_WIDTH-100, 4)];
    _line.image = [UIImage imageNamed:@"qrcode_scan_light_green.png"];
    [bgImageView addSubview:_line];
   
    
//    //假导航
//    UIImageView*navImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//    navImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
//    navImageView.userInteractionEnabled=YES;
//    [self.view addSubview:navImageView];
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2)-32, 20, 64, 44)];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.text=@"二维码扫描";
//    [navImageView addSubview:titleLabel];
//    
//    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed.png"] forState:UIControlStateHighlighted];
//    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor.png"] forState:UIControlStateNormal];
//    
//    
//    [button setFrame:CGRectMake(10,10, 48, 48)];
//    [button addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

    
    [UIView animateWithDuration:1.9 animations:^{
        
        _line.frame = CGRectMake(50, 50+200, SCREEN_WIDTH-100, 4);
    }completion:^(BOOL finished) {
        
    }];
    
    
    
   timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{

    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
        
        [UIView animateWithDuration:2 animations:^{
            
            _line.frame = CGRectMake(50, 50+200, SCREEN_WIDTH-100, 4);
        }completion:^(BOOL finished) {
            //        [UIView animateWithDuration:2 animations:^{
            //          _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
            //        }];
            
        }];
        
    });
    
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    [self setTitle:@"二维码扫描" withFont:kTitleLabel_Font withTitleColor:kTitleLabel_Color];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    
    
    
    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断是否有摄像头
    
    if (Custom) {
        [self initCapture];//启动摄像头
    }
    [self createView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma  mark -  返回
- (void)leftItemClicked:(id)sender {
    
    self.isScanning = NO;
    [self.captureSession stopRunning];
    
//    self.ScanResult(nil,NO);
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
    _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
    num = 0;
    upOrdown = NO;
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark 点击取消
//- (void)pressCancelButton:(UIButton *)button
//{
//    self.isScanning = NO;
//    [self.captureSession stopRunning];
//    
//    self.ScanResult(nil,NO);
//    if (timer) {
//        [timer invalidate];
//        timer=nil;
//    }
//    _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
//    num = 0;
//    upOrdown = NO;
////    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark 开启相机
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    
    if (IOS7) {
        AVCaptureMetadataOutput*_output=[[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        self.isScanning = YES;
        [self.captureSession startRunning];
        
        
    }else{
        [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:captureOutput];
        
        NSString* preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
            [UIScreen mainScreen].scale > 1 &&
            [inputDevice
             supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
                // NSLog(@"960");
                preset = AVCaptureSessionPresetiFrame960x540;
            }
        if (!preset) {
            // NSLog(@"MED");
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;
        
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        self.isScanning = YES;
        [self.captureSession startRunning];
        
        
    }
    
    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    return image;
}

#pragma mark 对图像进行解码
- (void)decodeImage:(UIImage *)image
{
    
    self.isScanning = NO;
    ZBarSymbol *symbol = nil;
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate = self;
    
    CGImageRef cgImageRef = image.CGImage;
    
    for(symbol in [read scanImage:cgImageRef])break;
    
    if (symbol!=nil) {
        
        if (timer) {
            [timer invalidate];
            timer=nil;
        }
        
        _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
        num = 0;
        upOrdown = NO;
//        self.ScanResult(symbol.data,YES);
        self.isScanning = NO;
        [self.captureSession stopRunning];
        
        [self handleWithResult:symbol.data isSucc:YES];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        num = 0;
        upOrdown = NO;
        self.isScanning = YES;
        [self.captureSession startRunning];

    }
    
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self decodeImage:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//IOS7下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
//        self.ScanResult(metadataObject.stringValue,YES);
        
        self.isScanning = NO;
        [self.captureSession stopRunning];
        
        num = 0;
        upOrdown = NO;
        if (timer) {
            [timer invalidate];
            timer=nil;
        }
        _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
        
        [self handleWithResult:metadataObject.stringValue isSucc:YES];
    }
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - DecoderDelegate

+(NSString*)zhengze:(NSString*)str
{
    
    NSError *error;
    //http+:[^\\s]* 这是检测网址的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];//筛选
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从urlString中截取数据
            NSString *result1 = [str substringWithRange:resultRange];
            NSLog(@"正则表达后的结果%@",result1);
            return result1;
            
        }
    }
    return nil;
}





#pragma mark - 扫到结果后

-(void)handleWithResult:(NSString *)result isSucc:(BOOL)isSucc{
    
    self.strScanResult = result;
    
    
    
        JSInfo(@"Scan QR Code RedStar",@"scan success, redStarID: %@",result);
        
        [self showHud];
        
    unsigned long devIdLong = strtoul([result UTF8String], 0, 16);
    NSString *redSatelliteID = [NSString stringWithFormat:@"%lu",devIdLong];

        //配置红卫星
        NSDictionary *addRedStatelliteContigDic = @{@"commandType": @"configRedStar",@"applianceId":redSatelliteID};
        [SBApplianceEngineMgr redSatelliteConfigWithDic:addRedStatelliteContigDic withSuccessBlock:^(NSString *result) {
            [self hideHud];
            self.ScanResult(self.strScanResult,YES);
            
            [self.navigationController popViewControllerAnimated:YES];
        } withFailBlock:^(NSString *msg) {
            [self hideHud];
            //            dict[kSBEngine_ErrMsg]
            //            @"配置红卫星失败，请再次扫描二维码配置"
            NSString *toastStr = @"配置红卫星失败，请重试";
                toastStr = msg;
            [self.view makeToast:toastStr duration:1.0 position:CSToastPositionCenter];
            
            [self startScanQRCodeAfterFail];

        }];
    return;
    
        //添加前先config
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiRedSatelliteConfig:) name:kNotifi_SBApplianceEngineCallBack_Event_RedSatelliteConfig object:nil];
        [SBApplianceEngineMgr redSatelliteConfig:result];
}


#pragma mark - 重新开始扫描

//失败后 重新开始扫描
-(void)startScanQRCodeAfterFail{
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        num = 0;
        upOrdown = NO;
        self.isScanning = YES;
        [self.captureSession startRunning];
        
        _line.frame = CGRectMake(50, 70, SCREEN_WIDTH-100, 4);
        
        [UIView animateWithDuration:1.9 animations:^{
            _line.frame = CGRectMake(50, 50+200, SCREEN_WIDTH-100, 4);
        }completion:^(BOOL finished) {
            
        }];
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
    });
    
}



#pragma mark - 添加Robot

#pragma mark - 二维码扫描 绑定设备  监听
- (void)notifiBindBox:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBEngineCallBack_Event_BoxInfo_Bind object:nil];
    
    JSDebug(@"二维码扫描绑定设备", @"ZbarVC中，notifiBindBox");
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]){
        
        JSDebug(@"Scan QR Code",  @"bind success");
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
            [self.view makeToast:@"绑定成功" duration:1.0 position:CSToastPositionCenter];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
        
    }else{
        JSDebug(@"Scan QR Code",  @"bind failed");
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hideHud];
//            dict[kSBEngine_ErrMsg]
            
            NSString *toastStr = @"绑定机器人失败，请重试";
            if (((NSString *)dict[kSBEngine_ErrMsg]).length>0) {
                toastStr = dict[kSBEngine_ErrMsg];
            }
            
            [self.view makeToast:toastStr duration:1.0 position:CSToastPositionCenter];
            
            [self startScanQRCodeAfterFail];
            
        });
    }
    
}





#pragma mark - 添加红卫星

#pragma Config配置
-(void)notifiRedSatelliteConfig:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.userInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifi_SBApplianceEngineCallBack_Event_RedSatelliteConfig object:nil];
    
    if (0 == [dict[kSBEngine_ErrCode] intValue]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
            
            self.ScanResult(self.strScanResult,YES); //此处执行的是UI的刷新
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }else{
        
        JSError(@"RedSatelliteConfig", @"Red Satellite config fail errorCode: %@",dict[kSBEngine_ErrCode]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hideHud];
//            dict[kSBEngine_ErrMsg]
//            @"配置红卫星失败，请再次扫描二维码配置"
            NSString *toastStr = @"配置红卫星失败，请重试";
            if (((NSString *)dict[kSBEngine_ErrMsg]).length>0) {
                toastStr = dict[kSBEngine_ErrMsg];
            }
            
            [self.view makeToast:toastStr duration:1.0 position:CSToastPositionCenter];
            
            [self startScanQRCodeAfterFail];
            
            
        });
        
    }
    
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
