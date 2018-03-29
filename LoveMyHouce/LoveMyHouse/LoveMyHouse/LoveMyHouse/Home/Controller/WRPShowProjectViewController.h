//
//  WRPShowProjectViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPBaseViewController.h"


@interface WRPShowProjectViewController : WRPBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSString *image_id;

@property (nonatomic,strong) NSString *project_id;

@end
