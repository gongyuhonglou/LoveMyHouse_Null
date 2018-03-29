//
//  WRPDesignerListViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPDesignerListViewController.h"
#import "AFNetworking.h"
#import "NetInterface.h"

@interface WRPDesignerListViewController ()

@end

@implementation WRPDesignerListViewController{
    
    
    NSArray *_dataSource;
    UITableView *_tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTypeButton];
    [self customDataSourceWithTag:100];
}

- (void)createTypeButton
{
    CGFloat buttonW = SCREEN_SIZE.width/3;
    //    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonW, 380)];
    //    bgView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //    [self.view addSubview:bgView];
    
    NSArray *titleArray = @[@"设计师",@"厂商",@"其他专业人士"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 60 * i, buttonW, 60);
        button.tag = 100 + i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:button];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    [self customDataSourceWithTag:button.tag];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_tableView reloadData];
}

#pragma mark - 数据源
//之前写死了button和数据源，很low的方法加载数据

- (void)customDataSourceWithTag:(NSInteger)tag
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CITY_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *data = rootDic[@"data"];
        NSArray *array = data[@"types"];
        
        if (tag == 100) {
            
            _dataSource = array[0][@"values"];
        }else if (tag == 101){
            _dataSource = array[1][@"values"];
        }else if (tag == 102){
            _dataSource = array[2][@"values"];
        }
        
        [self createTableView];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:
                  CGRectMake( SCREEN_SIZE.width/3, 0, 2 * SCREEN_SIZE.width/3, 380)
                                              style:
                  UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableviewDataSource相关方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text= _dataSource[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"type == %@",_dataSource[indexPath.row][@"name"]);
    self.typeBlock(_dataSource[indexPath.row][@"id"]);
    [self.view removeFromSuperview];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}

@end
