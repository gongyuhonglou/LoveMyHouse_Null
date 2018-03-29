//
//  WRPProjectDetailViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProjectDetailViewController.h"
#import "AFNetworking.h"
#import "WRPProjectItemModel.h"
#import "NetInterface.h"
#import "UIImageView+WebCache.h"
#import "WRPProjectItemDetailCell.h"
#import "Masonry.h"
#import "UMSocial.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPProjectDetailViewController ()

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) WRPProjectItemModel *infoModel;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation WRPProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark -- 数据请求
- (void)initData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:PROJECT_URL_DETAIL,self.project_id] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = rootDic[@"data"];
        self.infoModel = [[WRPProjectItemModel alloc] init];
        self.infoModel.http_prefix = data[@"http_prefix"];
        self.infoModel.id = data[@"project"][@"id"];
        self.infoModel.name = data[@"project"][@"name"];
        self.infoModel.image = data[@"project"][@"author"][0][@"image"];
        
        NSArray *array = data[@"subjects"];
        for (NSDictionary *dict in array) {
            WRPProjectItemModel *model = [[WRPProjectItemModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.sub_path = dict[@"index_address"][@"sub_path"];
            model.thumb = dict[@"index_address"][@"thumb"];
            [self.dataSource addObject:model];
        }
        
        [self createTableView];
        [self customHeaderView];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark -- 创建tableView
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -- 协议代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.dataSource.count;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        WRPProjectItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[WRPProjectItemDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell configCellWith:_dataSource[indexPath.row]];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        // 集成分享条
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:self.project_id];
        UMSocialBar *socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        socialBar.center = cell.contentView.center;
        cell.contentView.backgroundColor = socialBar.backgroundColor;
        [cell.contentView addSubview:socialBar];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 360;
    }else if (indexPath.section == 1){
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - 定制组头
- (void)customHeaderView {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250)];
    baseView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 200)];
    
    bgView.image = [UIImage imageNamed:@"遮罩条.png"];
    [baseView addSubview:bgView];
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 80, 80)];
    iconView.layer.cornerRadius = 40;
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderColor = [UIColor orangeColor].CGColor;
    iconView.layer.borderWidth = 2.0;
    iconView.backgroundColor = [UIColor whiteColor];
    [iconView sd_setImageWithURL:[NSURL URLWithString:_infoModel.image]];
    [baseView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_bottom);
    }];
    
    
    _tableView.tableHeaderView = baseView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
