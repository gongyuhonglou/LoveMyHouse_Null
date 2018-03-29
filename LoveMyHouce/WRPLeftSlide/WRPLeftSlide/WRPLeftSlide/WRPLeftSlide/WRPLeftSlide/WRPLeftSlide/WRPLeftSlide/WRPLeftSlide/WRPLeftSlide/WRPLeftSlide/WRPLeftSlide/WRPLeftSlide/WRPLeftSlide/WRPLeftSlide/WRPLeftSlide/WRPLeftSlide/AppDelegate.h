//
//  AppDelegate.h
//  WRPLeftSlide
//
//  Created by qianfeng on 16/5/20.
//  Copyright © 2016年 WengRenPu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;

@property (nonatomic,strong) UINavigationController  *vcNavigation;

@end

