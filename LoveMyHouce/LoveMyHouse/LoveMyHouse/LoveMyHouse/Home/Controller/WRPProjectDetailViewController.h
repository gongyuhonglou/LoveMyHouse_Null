//
//  WRPProjectDetailViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPBaseViewController.h"

@interface WRPProjectDetailViewController : WRPBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString  *project_id;

@property (nonatomic,copy) NSString  *user_id;

@end
