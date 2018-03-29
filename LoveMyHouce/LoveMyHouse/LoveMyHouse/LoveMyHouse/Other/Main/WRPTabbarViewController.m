//
//  WRPTabbarViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPTabbarViewController.h"
#import "UITabBarController+WRPAddChildController.h"

@interface WRPTabbarViewController ()

@end

@implementation WRPTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabbarController];
}

// 创建tabbarController
- (void)createTabbarController {
    // 创建tabBar元素数组
    NSArray *array = @[@[@"家居",@"商城",@"发现",@"我的"],@[@"WRPHomeViewController",@"WRPMallViewController",@"WRPDiscoverViewController",@"WRPMineViewController"],@[@"unselected_home",@"unselected_mall",@"unselected_discover",@"unselected_mine"],@[@"selected_home",@"selected_mall",@"selected_discover",@"selected_mine"]];
    for (int i = 0; i < array.count; i++) {
        [self addChildTabbarController:array[0][i] controller:array[1][i] unSelectedImage:array[2][i] selectedImage:array[3][i]];
    }
    
}

@end
