//
//  GeneralListViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "GeneralListViewController.h"

@interface GeneralListViewController ()

@end

@implementation GeneralListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackgroundView];
    [self customFooterView];//下拉条背景
}

- (void)customBackgroundView
{
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 40 - 44);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 44 - 40 - 44)];//如果导航条透明，这里的高度需要重新设定
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    
    [self.view addSubview:bgView];
    
    
    self.listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 400)];
    self.listView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.listView.alpha = 1.0;
    
    [self.view addSubview:self.listView];
}


- (void)customFooterView
{
    UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, SCREEN_SIZE.width, 20)];
    footer.image = [[UIImage imageNamed:@"下拉条（底部）"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.listView addSubview:footer];
}


@end
