//
//  WRPDiscoverViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPDiscoverViewController.h"
#import "WRPSegmentButton.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "MJRefresh.h"
#import "GeneralModel.h"
#import "WRPDiscoveryCell.h"
#import "WRPDetailViewController.h"
#import "WRPDesignerListViewController.h"
#import "WRPCityListViewController.h"
#import "WRPSortListViewController.h"


#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPDiscoverViewController ()

@end

@implementation WRPDiscoverViewController{
    
    BOOL _isExtended;//判断顶部分栏按钮是否展开
    NSInteger _lastButton;
    
    NSMutableArray *_dataSource;
    UITableView *_tableView;
    
    BOOL _isPulling;
    NSInteger _skip;
    
    NSString *_dataUrl;//用于请求数据的URL
    NSString *_typeId;
    NSString *_cityId;//筛选的城市id
    NSString *_orderId;//筛选的排序关键字
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"掘匠";
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCityId:) name:@"cityid" object:nil];//通知中心接收筛选传值
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentTitle];
    
    _skip = 0;
    _dataSource = [[NSMutableArray alloc] init];
    _dataUrl = [NSString stringWithFormat:Discover_URL,_skip];
    [self getData];
    [self createTableView];
    [self createRefresh];
}

#pragma mark - 分栏标题
#pragma mark - 分栏标题
- (void)createSegmentTitle
{
    NSArray *titleArray = @[@"类型",@"地区",@"排序",@"清除"];
    CGFloat buttonW = SCREEN_SIZE.width/4;
    for (int i = 0; i < 4; i++) {
        
        WRPSegmentButton *button = [[WRPSegmentButton alloc] initWithFrame:CGRectMake(i *buttonW, 0, buttonW, 40)];
        [button setButtonTitle:titleArray[i] Tag:100 + i];
        [button addTarget:self action:@selector(indexChanged:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
    }
    _lastButton = 100;//初始化默认选中的button为第一个button
}

#pragma mark - 筛选按钮点击事件
- (void)indexChanged:(WRPSegmentButton *)button
{
    //    NSLog(@"%ld",button.tag);
    
    
    BOOL needOpen = NO;//判断点击按钮是否需要展开，如果needOpen或者按钮为灰色，满足任一条件即展开
    if (self.view.subviews.count == 5) {
        needOpen = YES;
    }
    
    if (button.tag != _lastButton) {
        WRPSegmentButton *button = (WRPSegmentButton *)[self.view viewWithTag:_lastButton];
        button.titleLabel.textColor = [UIColor grayColor];
        button.arrowView.image = [[UIImage imageNamed:@"三角向下箭头_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
    if (button.titleLabel.textColor == [UIColor grayColor]||needOpen) {
        button.titleLabel.textColor = [UIColor redColor];
        button.arrowView.image = [[UIImage imageNamed:@"键盘（箭头向上）_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //点击相应的按钮进行相应的操作
        _skip = 0;//初始化默认筛选结果显示第一页
        if (button.tag == 100) {
            
            //类型按钮
            WRPDesignerListViewController *typeList =
            [[WRPDesignerListViewController alloc] init];
            
            typeList.view.frame =
            CGRectMake(0, 40, SCREEN_SIZE.width, 400);
            
            __weak WRPDesignerListViewController *weakSelf = typeList;
            
            weakSelf.typeBlock = ^(NSString *typeid){
                
                _typeId = typeid;
                
                if (_dataSource != nil) {
                    [_dataSource removeAllObjects];//筛选后清空原来的数据
                }
                
                NSString *tmpUrl =
                [NSString stringWithFormat:Discover_URL,_skip];
                
                NSString * utf8String =
                [NSString stringWithFormat:@"%@&type_id=%@",tmpUrl,_typeId];
                
                _dataUrl = [utf8String stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//新的ASCII转码方法
                
                //                NSLog(@"%@",_dataUrl);
                
                [self getData];
                [_tableView reloadData];
                
                while ([self.view.subviews count] > 5) {
                    [[self.view.subviews lastObject] removeFromSuperview];
                }
                
            };
            
            
            [self addChildViewController:typeList];
            [self.view addSubview:typeList.view];
            
        }else if (button.tag == 101){
            
            //地区按钮
            WRPCityListViewController *cityList =
            [[WRPCityListViewController alloc] init];
            
            cityList.view.frame =
            CGRectMake(0, 40, SCREEN_SIZE.width, 400);
            
            __weak WRPCityListViewController *weakSelf = cityList;
            
            weakSelf.cityBlock = ^(NSString *cityid){
                
                _cityId = cityid;
                
                if (_dataSource != nil) {
                    [_dataSource removeAllObjects];//筛选后清空原来的数据
                }
                
                NSString *tmpUrl =
                [NSString stringWithFormat:Discover_URL,_skip];
                
                _dataUrl =
                [NSString stringWithFormat:@"%@&city_id=%@",tmpUrl,_cityId];
                
                [self getData];
                [_tableView reloadData];
                
                while ([self.view.subviews count] > 5) {
                    [[self.view.subviews lastObject] removeFromSuperview];
                }
            };
            
            
            
            [self addChildViewController:cityList];
            [self.view addSubview:cityList.view];
            
        }else if (button.tag == 102){
            
            //排序按钮
            WRPSortListViewController *sortList =
            [[WRPSortListViewController alloc] init];
            
            sortList.view.frame =
            CGRectMake(0, 40, SCREEN_SIZE.width, 400);
            
            __weak WRPSortListViewController *weakSelf = sortList;
            weakSelf.orderBlock = ^(NSString *orderString){
                
                _typeId = orderString;
                
                if (_dataSource != nil) {
                    [_dataSource removeAllObjects];//筛选后清空原来的数据
                }
                
                NSString *tmpUrl =
                [NSString stringWithFormat:Discover_URL,_skip];
                
                _dataUrl =
                [NSString stringWithFormat:@"%@&type=%@",tmpUrl,_typeId];
                
                [self getData];
                [_tableView reloadData];
                
                while ([self.view.subviews count] > 5) {
                    [[self.view.subviews lastObject] removeFromSuperview];
                }
                
            };
            
            [self addChildViewController:sortList];
            [self.view addSubview:sortList.view];
            
        }else if (button.tag == 103){
            
            //清除按钮
            for (int i = 0; i < 4; i++) {
                WRPSegmentButton *button = (WRPSegmentButton *)[self.view viewWithTag:100 + i];
                button.titleLabel.textColor = [UIColor grayColor];
                button.arrowView.image = [[UIImage imageNamed:@"三角向下箭头_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            
            if (_dataSource != nil) {
                [_dataSource removeAllObjects];
            }
            
            _skip = 0;
            _cityId = nil;
            _dataUrl = [NSString stringWithFormat:Discover_URL,_skip];
            [self getData];
            [_tableView reloadData];
            
            while ([self.view.subviews count] > 5) {
                [[self.view.subviews lastObject] removeFromSuperview];
            }
        }
        
        
        
    }else{
        button.titleLabel.textColor = [UIColor grayColor];
        button.arrowView.image = [[UIImage imageNamed:@"三角向下箭头_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        while (self.view.subviews.count >5) {
            [[self.view.subviews lastObject] removeFromSuperview];//移除添加上去的子视图
        }
        [self.childViewControllers[0] removeFromParentViewController];
    }
    
    _lastButton = button.tag;
}

#pragma mark - 筛选：通知中心传值
- (void)getCityId:(NSNotification *)notification
{
    _cityId = notification.object;
    
    //    NSLog(@"notification: %@",notification);
    if (_dataSource != nil) {
        [_dataSource removeAllObjects];//筛选后清空原来的数据
    }
    _skip = 0;
    NSString *mainUrl = [NSString stringWithFormat:Discover_URL,_skip];
    _dataUrl = [NSString stringWithFormat:@"%@&city_id=%@",mainUrl,_cityId];
    [self getData];
    [_tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"cityid"];
}


#pragma mark - 数据请求
- (void)getData
{
    if (_isPulling) {
        [_dataSource removeAllObjects];
        [_tableView reloadData];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_dataUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *data = rootDic[@"data"];
        NSArray *array = data[@"users"];
        for (NSDictionary *dict in array) {
            GeneralModel *model = [[GeneralModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            [_dataSource addObject:model];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 40 -44) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


#pragma mark - 刷新和加载更多
- (void)createRefresh
{
    
//    [_tableView addHeaderWithTarget:self action:@selector(pullRefresh)];
//    [_tableView addFooterWithTarget:self action:@selector(pushRefresh)];
    
}
- (void)pullRefresh
{
    //下拉刷新
    
    _isPulling = YES;
    _skip = 0;
    [self getData];
    
//    [_tableView headerEndRefreshing];
}

- (void)pushRefresh
{
    //上拉加载更多
    _isPulling = NO;
    _skip = _skip + 30;
    [self getData];
    
//    [_tableView footerEndRefreshing];
}


#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WRPDiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID1"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WRPDiscoveryCell" owner:self options:nil] lastObject];
    }
    
    [cell configCellWithModel:_dataSource[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到详情页面
    WRPDetailViewController *detail = [[WRPDetailViewController alloc] init];
    GeneralModel *model = _dataSource[indexPath.row];
    detail.user_id = model.user_id;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - cell动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.frame = CGRectMake(0, 310 * indexPath.row, SCREEN_SIZE.width, 310);
    [UIView commitAnimations];
}

@end
