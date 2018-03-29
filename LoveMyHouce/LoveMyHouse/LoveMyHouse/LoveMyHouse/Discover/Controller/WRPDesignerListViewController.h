//
//  WRPDesignerListViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "GeneralListViewController.h"

@interface WRPDesignerListViewController : GeneralListViewController<UITableViewDataSource,UITableViewDelegate>

//“类型”按钮 下拉菜单视图控制器
@property (nonatomic,copy)void (^typeBlock)(NSString *);

@end
