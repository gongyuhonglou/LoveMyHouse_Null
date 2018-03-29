//
//  WRPMallDetailController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/2.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPMallDetailController.h"
#import "WRPActivityIndicatorView.h"

@interface WRPMallDetailController ()

@end

@implementation WRPMallDetailController {
    
    UIWebView *_webView;
    WRPActivityIndicatorView *_activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWebView];
}

- (void)loadWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]];
    [_webView loadRequest:request];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToBack:)];
    [_webView addGestureRecognizer:swipeRight];
    
    [self.view addSubview:_webView];
    
    // 旋转状态
    _activityIndicator = [[WRPActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.color = [UIColor yellowColor];
    [self.view addSubview:_activityIndicator];
}

- (void)swipeToBack:(UISwipeGestureRecognizer *)swipe {
    [_webView goBack];
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicator removeFromSuperview];
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

@end
