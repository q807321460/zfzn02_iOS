//
//  RootViewController.h
//  NewProject
//
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "vv_strings.h"
@protocol ScanViewController_interface <NSObject>
@optional
-(void)on_scan_string:(NSString*)str_data;
@end


@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    float m_width;
    float m_height;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (assign) id<ScanViewController_interface> delegate;
@end
