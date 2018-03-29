//
//  WRPBaseViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPBaseViewController.h"
#import "MBProgressHUD.h"

@interface WRPBaseViewController ()

// 声明加载一个菊花
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation WRPBaseViewController

#pragma mark -- 菊花相关
- (void)showLoadingView {
    // 先把hud提到最上层，保证不会被其他的视图覆盖
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
}

- (void)hideLoadingView {
    [self.hud hide:YES];
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        // 加载菊花显示的文字
        _hud.labelText = @"加载中...";
        [self.view addSubview:_hud];
    }
    return _hud;
}


@end
