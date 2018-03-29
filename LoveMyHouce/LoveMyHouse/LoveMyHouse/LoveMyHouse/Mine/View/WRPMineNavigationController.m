//
//  WRPMineNavigationController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/30.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPMineNavigationController.h"

@interface WRPMineNavigationController ()

@end

@implementation WRPMineNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取透明图片
    UIImage *image = [self getTransImageFromSize:CGSizeMake(1, 1)];
    // 设置为导航的背景图片
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 创建自定义的透明的view
    self.transView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.navigationBar.bounds.size.width, 64)];
    // 添加到导航栏
    [self.navigationBar insertSubview:self.transView atIndex:0];
    // 隐藏底部的线
    self.navigationBar.shadowImage = [UIImage new];
    // 添加一个tag值
    self.transView.tag = 2000;
}

/**
 用代码创建一个透明的图片
 */
- (UIImage *)getTransImageFromSize:(CGSize)size {
    //1.开始绘制图片
    /**
     参数1  大小
     参数2  和透明相关的，no，透明,yes就是不透明
     */
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘制图片
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UINavigationController (Transparent)

- (UIView *)transView {
    // 判断是不是自定义的导航
    if ([self isKindOfClass:[WRPMineNavigationController class]]) {
        return [self.navigationBar viewWithTag:2000];
    }
    return nil;
}

@end
