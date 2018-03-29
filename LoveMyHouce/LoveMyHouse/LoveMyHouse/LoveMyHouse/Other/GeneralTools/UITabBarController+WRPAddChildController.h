//
//  UITabBarController+WRPAddChildController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (WRPAddChildController)

/**
 *  添加子控件
 *
 *  @param title               标题名称
 *  @param controllerName      控制器名称
 *  @param unSelectedImageName 未选中图片名称
 *  @param selectedName        选中图片名称
 */
- (void)addChildTabbarController:(NSString *)title controller:(NSString *)controllerName unSelectedImage:(NSString *)unSelectedImageName selectedImage:(NSString *)selectedName;

@end
