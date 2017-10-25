//
//  JSWebViewController.m
//  Smart360
//
//  Created by sun on 15/9/28.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSWebViewController.h"

@interface JSWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, copy)  NSString *mark;
@property (nonatomic, weak) UIButton *ctrlFootButton;
@property (nonatomic, weak) UIView *ctrlContentBgv;

@end

@implementation JSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemRightButtonWithTitle:@"  "];
    [self setNavigationItemWithTitle:self.titleStr];
    [self setNavigationItemLeftButtonWithTitle:@"返回"];
    
    //内容背景
    UIView *contentBgv = [[UIView alloc] init];
    self.ctrlContentBgv = contentBgv;
    [self.view addSubview:contentBgv];
    [contentBgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    NSString *url = [self.urlStr trimString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [contentBgv addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.ctrlContentBgv);
        make.center.equalTo(self.ctrlContentBgv);
    }];
    
    [self.webView loadRequest:request];
    
    
}


    

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHudWithText:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
    
    if (_isHandleURL) {
        NSString *url = [webView.request.URL absoluteString];
        NSArray *arr = [url componentsSeparatedByString:@"_063"];
        if (arr.count > 1) {
            [_ctrlContentBgv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-44);
            }];
            
            self.ctrlFootButton.hidden = NO;
            
            NSArray *tmpArr = [arr[1] componentsSeparatedByString:@"."];
            if (tmpArr.count > 1) {
                self.mark = tmpArr[0];
            }
        } else {
            self.ctrlFootButton.hidden = YES;
            
            [_ctrlContentBgv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(0);
            }];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
}

#pragma mark - leftItemClicked:
- (void)leftItemClicked:(id)sender {
    if ([self.enterType isEqualToString:@"present"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
