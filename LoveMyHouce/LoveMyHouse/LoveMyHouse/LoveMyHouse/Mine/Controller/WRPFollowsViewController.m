//
//  WRPFollowsViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/6.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPFollowsViewController.h"
#import "UIImageView+WebCache.h"
#import "FMDBManager.h"
#import "DatabaseModel.h"

#import "Masonry.h"


#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPFollowsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation WRPFollowsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.title = @"我的关注";
    _dataSource = [[FMDBManager shareInstance] selectConcernsData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_dataSource.count > 0) {
        [self createTableView];
    }else {
        [self addBgView];
    }
}

- (void)addBgView {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_SIZE.width, 300)];
    bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"收藏为空" ofType:@"png"]];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.625);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
}

- (void)createDataSource {
    _dataSource = [NSMutableArray arrayWithArray:[[FMDBManager shareInstance] selectConcernsData]];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}


#pragma mark -- tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    DatabaseModel *model = _dataSource[indexPath.section];
    
    cell.imageView.layer.cornerRadius = 20.0;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"小头像_1.jpg"]];
    cell.textLabel.text = model.tag;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}


@end
