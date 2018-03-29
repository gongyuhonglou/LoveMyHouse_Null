//
//  WRPHomeViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPHomeViewController.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "GeneralModel.h"
#import "WRPHomeTableViewCell.h"
#import "MJRefresh.h"
#import "WRPShowProjectViewController.h"
#import "UMSocial.h"
#import "FMDBManager.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPHomeViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSString *dataUrl;//数据请求url

@property (nonatomic,strong) NSString *image_tags;

@property (nonatomic,assign) BOOL filter;

@property (nonatomic,assign) BOOL clearMode;//清除按钮

@property (nonatomic,strong) NSString *project_id;// 判断是否收藏、喜欢

@end

@implementation WRPHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"首页";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getKeyWord:) name:@"keyword" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyword" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    // 创建tableView
    [self createTableView];
    
    // 刷新数据
    [self addRefresh];
    // 初始值为1
    self.page = 1;
    [self initData];
    
}

#pragma mark -- 刷新
- (void)addRefresh {
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 还原页码
        self.page = 1;
        // 刷新请求数据
        [self initData];
    }];
    // 添加刷新头部
    self.tableView.header = header;
    
    // 上拉加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        // 页码 +1
        self.page++;
        [self initData];
    }];
    self.tableView.footer = footer;
}

#pragma mark - 筛选：通知中心传值
- (void)getKeyWord:(NSNotification *)notification
{
    
    _image_tags = notification.object;
    if ([_image_tags isEqualToString:@"不限"]) {
        _image_tags = nil;
    }
    
    NSString *str = [NSString stringWithFormat:FILTER_URL,_image_tags,_page];
    _dataUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_dataSource removeAllObjects];
    [self initData];
    
}

#pragma mark -- 请求数据
- (void)initData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 开始加载数据前，显示菊花
    [self showLoadingView];
    
    // 把结果进行序列化，关闭了自动解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // url解码
//    NSString *dataUrl = [[NSString stringWithFormat:Home_URL,self.page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *dataUrl = [NSString stringWithFormat:Home_URL,self.page];
    
    // 请求数据
    [manager GET:dataUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"请求成功%@",responseObject);
        /**
         *  需要先判断是下拉刷新还是上拉加载
         *  如果是下拉刷新，需要清空原来的内容
         *  如果是上拉加载，不要清空原来的内容
         */
        if (self.tableView.header.isRefreshing) {
            
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
        }
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *data = rootDic[@"data"];
        
        NSArray *array = data[@"subjects"];
        for (NSDictionary *dict in array) {
            GeneralModel *model = [[GeneralModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.http_prefix = data[@"http_prefix"];
            model.sub_path = dict[@"index_address"][@"sub_path"];
            model.thumb = dict[@"index_address"][@"thumb"];
            [_dataSource addObject:model];
        }
        
        [_tableView reloadData];
        // 隐藏
        [self hideLoadingView];
        // 停止刷新
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        [self hideLoadingView];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark -- 创建tableView
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[WRPHomeTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WRPHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[WRPHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    [cell configCellWithModel:_dataSource[indexPath.row]];
    cell.likeButton.tag = 10000 + indexPath.row;
    cell.collectButton.tag = 20000 + indexPath.row;
    
    //喜欢、收藏 按钮点击事件
    [cell.likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [cell.collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    
    //设置标识
    GeneralModel *model = _dataSource[indexPath.row];
    
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:model.project_id];
    
    if (socialData.isLike == NO) {
        
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"爱心点赞"] forState:UIControlStateNormal];
    }else{
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"爱心实心"] forState:UIControlStateNormal];
    }
    
    //是否收藏
    if ([[FMDBManager shareInstance] verifyCollectionInfoWithProjectID:model.project_id]== YES) {
        
        [cell.collectButton setBackgroundImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
    }else{
        [cell.collectButton setBackgroundImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    }
    return cell;
}

- (void)likeButtonClicked:(UIButton *)button
{
    NSString *loginstate = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginstate"];
    if ([loginstate isEqualToString:@"loggedin"]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag - 10000 inSection:0];
        WRPHomeTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        GeneralModel *model = _dataSource[indexPath.row];
        
        //设置标识
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:model.project_id];
        UMSocialDataService *socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
        
        if (socialData.isLike) {
            //变为喜欢状态
            [button setBackgroundImage:[UIImage imageNamed:@"爱心点赞"] forState:UIControlStateNormal];
            
            //删除本地喜欢数据库
            [[FMDBManager shareInstance] deleteLikeInfo:model.project_id];
            
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"爱心实心"] forState:UIControlStateNormal];
            [[FMDBManager shareInstance] saveLikeInfoWiththumb:[NSString stringWithFormat:@"%@%@%@",model.http_prefix,model.sub_path,model.thumb] tag:cell.tagLabel.text projectId:model.project_id];
        }
        
        //发送喜欢或者取消喜欢请求
        [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
            //获取请求结果
            NSLog(@"resposne is %@  likeState is %d",response,socialData.isLike);
        }];
    }else{
        //尚未登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录更精彩" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
    
}


- (void)collectButtonClicked:(UIButton *)button
{
    
    NSString *loginstate = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginstate"];
    if ([loginstate isEqualToString:@"loggedin"]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag - 20000 inSection:0];
        
        GeneralModel *model = _dataSource[indexPath.row];
        
        _project_id = model.project_id;
        
        WRPHomeTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        if ([[FMDBManager shareInstance] verifyCollectionInfoWithProjectID:_project_id] == YES) {
            //收藏过
            [button setBackgroundImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            [[FMDBManager shareInstance] deleteCollectionInfo:_project_id];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
            [[FMDBManager shareInstance] saveCollectionInfoWiththumb:[NSString stringWithFormat:@"%@%@%@",model.http_prefix,model.sub_path,model.thumb] tag:cell.tagLabel.text projectId:_project_id];
            
        }
        
        
    }else{
        //尚未登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录更精彩" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRPShowProjectViewController *projectDetail = [[WRPShowProjectViewController alloc] init];
    GeneralModel *model = self.dataSource[indexPath.row];
    projectDetail.image_id = model.image_id;
    projectDetail.project_id = model.project_id;
    
    //push的同时隐藏tabBar
    projectDetail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:projectDetail animated:YES];
//    NSLog(@"%@-------",projectDetail);
}

#pragma mark - alertview协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    LoginMainViewController *loginMainVC = [[LoginMainViewController alloc] init];
    
//    [self presentViewController:loginMainVC animated:YES completion:nil];
}
@end
