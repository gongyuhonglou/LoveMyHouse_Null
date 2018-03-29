//
//  UITabBarController+WRPAddChildController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "UITabBarController+WRPAddChildController.h"
#import "WRPNavigationViewController.h"
#import "WRPMineNavigationController.h"
#import "NetInterface.h"

@implementation UITabBarController (WRPAddChildController)


- (void)addChildTabbarController:(NSString *)title controller:(NSString *)controllerName unSelectedImage:(NSString *)unSelectedImageName selectedImage:(NSString *)selectedName {
    UIImage *normalImage = [UIImage imageNamed:unSelectedImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedName];
    if (IOS(7)) {
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    // 从字符串生成类对象
    Class controllerClass = NSClassFromString(controllerName);
    UIViewController *controller = [[controllerClass alloc] init];
    controller.tabBarItem = item;
    controller.title = title;
    
    if ([controllerName isEqualToString:@"WRPMineViewController"]) {
        WRPMineNavigationController *nav1 = [[WRPMineNavigationController alloc] initWithRootViewController:controller];
        [self addChildViewController:nav1];
    }else {
    
    WRPNavigationViewController *nav = [[WRPNavigationViewController alloc] initWithRootViewController:controller];
        
//    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
//    nav.navigationController.navigationBar.translucent = NO;
    nav.navigationBar.backgroundColor = [UIColor yellowColor];
    
    [self addChildViewController:nav];
    
    }
}

@end
