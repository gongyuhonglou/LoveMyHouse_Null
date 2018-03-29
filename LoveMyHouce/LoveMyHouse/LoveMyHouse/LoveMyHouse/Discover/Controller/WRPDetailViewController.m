//
//  WRPDetailViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPDetailViewController.h"
#import "AFNetworking.h"
#import "WRPDetailModel.h"
#import "NetInterface.h"
#import "UIImageView+WebCache.h"
#import "CExpandHeader.h"
#import "WRPDetailDescriptionCell.h"
#import "WRPCatagoryCell.h"
#import "WRPProjectDetailViewController.h"
#import "FMDBManager.h"

#define PINK_COLOR [UIColor colorWithRed:254/255.0 green:179/255.0 blue:155/255.0 alpha:1]
#define LIGHT_COLOR [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

static CGFloat imageOriginH = 200.f;

@interface WRPDetailViewController ()

@end

@implementation WRPDetailViewController{
    
    WRPDetailModel *_dataModel;//文字数据源
    
    WRPDetailModel *_productModel;//作品数据源
    
    NSString *_projectId;//选中每个作品对应的id
    
    UIImageView *_coverView;
    UITableView *_tableView;
    
    CExpandHeader *_header;
    
    WRPDetailDescriptionCell *descriptionCell;
    WRPCatagoryCell *catagoryCell;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotificationObserver];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProjectId:) name:@"project_id" object:nil];
}

- (void)getProjectId:(NSNotification *)notification
{
    WRPProjectDetailViewController *projectDetail = [[WRPProjectDetailViewController alloc] init];
    projectDetail.project_id = notification.object;
    
    [self.navigationController pushViewController:projectDetail animated:YES];
}

- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"project_id"];//为什么注销反而崩溃？？
}

- (void)getData
{
    _dataModel = [[WRPDetailModel alloc] init];
    _productModel = [[WRPDetailModel alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:DISCOVERY_URL_DETAIL,self.user_id] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        NSLog(@"~~~~~%@",[NSString stringWithFormat:URL_DISCOVERY_DETAIL,self.user_id]);
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = rootDic[@"data"];
        
        [_productModel setValuesForKeysWithDictionary:data];
        
        NSDictionary *user = data[@"user"];
        
        [_dataModel setValuesForKeysWithDictionary:user];
        
        [self createUI];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self customHeaderView];
}

#pragma mark - 图片拖动放大
- (void)customHeaderView
{
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, imageOriginH)];
    [_coverView sd_setImageWithURL:[NSURL URLWithString:_dataModel.cover_image]];
    
    UIImageView *agentView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 60, 60)];
    agentView.layer.cornerRadius = 30;
    agentView.layer.masksToBounds = YES;
    [agentView sd_setImageWithURL:[NSURL URLWithString:_dataModel.image]];
    [_coverView addSubview:agentView];
    
    UILabel *realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, SCREEN_SIZE.width - 140, 20)];
    realNameLabel.font = [UIFont boldSystemFontOfSize:12];
    realNameLabel.textColor = [UIColor whiteColor];
    realNameLabel.text = _dataModel.real_name;
    [_coverView addSubview:realNameLabel];
    
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 60, 20)];
    fansLabel.font = [UIFont boldSystemFontOfSize:10];
    fansLabel.textColor = [UIColor whiteColor];
    fansLabel.text = [NSString stringWithFormat:@"粉丝：%@",_dataModel.followed_number];
    [_coverView addSubview:fansLabel];
    
    
    _header = [CExpandHeader expandWithScrollView:_tableView expandView:_coverView];//图片拖动放大
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        descriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"WRPDetailDescriptionCell" owner:self options:nil] lastObject];
        [descriptionCell configCellWith:_dataModel];
        
        if ([[FMDBManager shareInstance] verifyConcernsInfoWithProjectID:self.user_id] == YES) {
            [descriptionCell.concernButton setBackgroundColor:LIGHT_COLOR];
            [descriptionCell.concernButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [descriptionCell.concernButton setTitle:@"√ 已关注" forState:UIControlStateNormal];
        }else{
            [descriptionCell.concernButton setBackgroundColor:PINK_COLOR];
            [descriptionCell.concernButton setTitle:@"关 注" forState:UIControlStateNormal];
            [descriptionCell.concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        if (_isExtend) {
            
            descriptionCell.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
        [descriptionCell.concernButton addTarget:self action:@selector(concernButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedLabel:)];
        [descriptionCell.descriptionLabel addGestureRecognizer:tap];
        
        
        
        return descriptionCell;
        
    }else if (indexPath.section == 1){
        
        
        catagoryCell = [[WRPCatagoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"catagoryCell"];
        [catagoryCell configcellWithModel:_productModel];
        
        return catagoryCell;
    }
    return nil;
}


- (void)concernButtonClicked:(UIButton *)button
{
    if ([[FMDBManager shareInstance] verifyConcernsInfoWithProjectID:self.user_id] == YES) {
        //收藏过
        [button setBackgroundColor:PINK_COLOR];
        [button setTitle:@"关 注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[FMDBManager shareInstance] deleteConcernsInfo:self.user_id];
        
    }else{
        [button setBackgroundColor:LIGHT_COLOR];
        [button setTitle:@"√ 已关注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[FMDBManager shareInstance] saveConcernsInfoWiththumb:_dataModel.image tag:_dataModel.real_name projectId:self.user_id];
    }
}


- (void)tapedLabel:(UITapGestureRecognizer *)tap
{
    
    _isExtend = !_isExtend;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (_isExtend) {
            CGRect rect = [descriptionCell.descriptionLabel.text boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            
            return 100 + rect.size.height;
            
        }else{
            descriptionCell.descriptionLabel.frame = CGRectMake(10, 60, SCREEN_SIZE.width - 20, 60);
            descriptionCell.arrowView.frame = CGRectMake(180, 125, 15, 15);
            
            return 150;
        }
    }else if (indexPath.section == 1){
        
        
        
        NSInteger max_number = MAX(_productModel.categories.count, _productModel.collects.count);
        CGFloat collectionViewH = (max_number/2 + max_number%2) * 210.0f;//collectionview的高度
        
        
        
        return collectionViewH + 100;
        
        
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
