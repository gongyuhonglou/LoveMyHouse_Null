//
//  WRPSortListViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPSortListViewController.h"

@interface WRPSortListViewController ()

@end

@implementation WRPSortListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createOrderButton];
}

- (void)createOrderButton
{
    NSArray *titleArray = @[@"最新排序",@"热门排序"];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 40 + (20 + 40) * i, SCREEN_SIZE.width, 20);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(ordered:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:button];
    }
    
}

- (void)ordered:(UIButton *)button
{
    if (button.tag == 100) {
        
        self.orderBlock(@"registration_date");
        [self.view removeFromSuperview];
        
    }else if (button.tag == 101){
        
        self.orderBlock(@"registration_date");
        [self.view removeFromSuperview];
    }
    
}

@end
