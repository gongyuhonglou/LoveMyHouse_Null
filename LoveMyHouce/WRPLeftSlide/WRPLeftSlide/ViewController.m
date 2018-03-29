//
//  ViewController.m
//  WRPLeftSlide
//
//  Created by qianfeng on 16/5/20.
//  Copyright © 2016年 WengRenPu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LeftSlideViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"bg_cloudy"];
    [self.view addSubview:imageView];
    self.title = @"Main";
    
    [self createButton];
}

- (void)createButton {
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.frame = CGRectMake(0, 0, 20, 20);
    [mainBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mainBtn];
    
}

- (void)leftClick {
    AppDelegate *tempAppdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppdelegate.LeftSlideVC.closed) {
        [tempAppdelegate.LeftSlideVC openLeftView];
    }
    else {
        [tempAppdelegate.LeftSlideVC closeLeftView];
    }
}


@end
