//
//  WRPSortListViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "GeneralListViewController.h"

@interface WRPSortListViewController : GeneralListViewController

@property (nonatomic,copy)void(^orderBlock)(NSString *);

@end
