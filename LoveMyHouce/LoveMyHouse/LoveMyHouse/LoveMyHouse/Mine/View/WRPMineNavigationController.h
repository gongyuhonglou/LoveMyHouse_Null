//
//  WRPMineNavigationController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/30.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPNavigationViewController.h"

@interface WRPMineNavigationController : UINavigationController

// 插入导航条上的透明view
@property (nonatomic,strong) UIView  *transView;

@end

//方便外界调用透明的view
@interface UINavigationController (Transparent)

@property (nonatomic,strong,readonly) UIView *transView;

@end
