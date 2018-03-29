//
//  WRPDetailViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRPDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSString *user_id;

@property (nonatomic,assign)BOOL isExtend;

@end
