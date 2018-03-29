//
//  lfetViewController.h
//  WRPLeftSlide
//
//  Created by qianfeng on 16/5/20.
//  Copyright © 2016年 WengRenPu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lfetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView  *tableView;

@end
