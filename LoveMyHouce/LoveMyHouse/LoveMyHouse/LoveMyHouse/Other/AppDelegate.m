//
//  AppDelegate.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "AppDelegate.h"
#import "WRPTabbarViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [SMSSDK registerApp:@"c97f0a949dfa" withSecret:@"b58f2a1364230891c7e15f94290a32c1"];//Mob短信验证
    
    //iPhone udid 662481da9132c67f29a9f32a5985d711cdd7f0ff
    //友盟key 56540cc967e58e12ef0018d6
    //新浪微博appkey 815963296
    
    //友盟key：57483c5767e58e1bd7000039
    [UMSocialData setAppKey:@"57483c5767e58e1bd7000039"];
    
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];//设置分享横屏
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    //高德key 49bae06f612282c175437b93baf291a1
//    [AMapLocationServices sharedServices].apiKey = @"49bae06f612282c175437b93baf291a1";
    
    
    
    // 创建视图控制器
    [self createWindow];
    
    // 启动页面运行的时间
//    [NSThread sleepForTimeInterval:1.0];
    
    return YES;
}

/** 设置Window */
- (void)createWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[WRPTabbarViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
