
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "ScanViewController.h"
#import "OMGToast.h"

@interface ScanViewController ()

@end

@implementation ScanViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_width=self.view.frame.size.width;
    m_height=self.view.frame.size.height;
    self.view.backgroundColor = [UIColor grayColor];
    /*
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=NSLocalizedString(@"m_barcode_hint", @"");
    [self.view addSubview:labIntroudction];
    */
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((m_width-220)/2, (m_height-220)/2, 220, 220)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    //imageView.center=self.view.center;
    
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_width, (m_height-220)/2)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(20, 40, m_width-40, 50);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=NSLocalizedString(@"m_barcode_hint", @"");
    [upView addSubview:labIntroudction];
    
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, (m_height-220)/2, (m_width-220)/2, 220)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(m_width-(m_width-220)/2, (m_height-220)/2, (m_width-220)/2, 220)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, m_height-(m_height-220)/2, m_width, (m_height-220)/2)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:NSLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
    scanButton.frame = CGRectMake((m_width-120)/2, m_height-(m_height-220)/2+30, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((m_width-180)/2, (m_height-2)/2, 180, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:.04 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    if (upOrdown == NO) {//下
        num ++;
        _line.frame = CGRectMake((m_width-180)/2, (m_height-2)/2+2*num, 180, 2);
        if (2*num == 90) {
            upOrdown = YES;
        }
    }
    else {//shang
        num --;
        _line.frame = CGRectMake((m_width-180)/2, (m_height-2)/2+2*num, 180, 2);
        if (2*num == -90) {
            upOrdown = NO;
        }
    }
   // NSLog(@"num===%d",2*num);

}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //[_output setRectOfInterest:CGRectMake(((m_height-210)/2)/m_height,((m_width-210)/2)/m_width,210/m_height,210/m_width)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    if ([_output.availableMetadataObjectTypes containsObject:
         AVMetadataObjectTypeQRCode]){
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    }
    else{
        //NSLog(@"................");
        [OMGToast showWithText:NSLocalizedString(@"m_camera_nopermission", @"")];
        return;
    }
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //_preview.frame =CGRectMake((m_width-210)/2, (m_height-210)/2, 210, 210);
    _preview.frame =CGRectMake(0, 0, m_width, m_height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //_preview.layer.center=self.view.center;

    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *stringValue;    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
   [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];
        NSLog(@"%@",stringValue);
        if ([delegate respondsToSelector:@selector(on_scan_string:)]) {
            [delegate on_scan_string:stringValue];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
@end
