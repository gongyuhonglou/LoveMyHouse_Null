//
//  WRPShowProjectViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPShowProjectViewController.h"
#import "WRPProjectDetailViewController.h"
#import "AFNetworking.h"
#import "GeneralModel.h"
#import "NetInterface.h"
#import "UIImageView+WebCache.h"
#import "WRPProjectDescriptionCell.h"
#import "WRPProjectTableViewCell.h"
#import "WRPProjectDetailViewController.h"
#import "UMSocial.h"
#import "Masonry.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define LIGHT_COLOR [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]

@interface WRPShowProjectViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WRPShowProjectViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"homeProjectId" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProjectId:) name:@"homeProjectId" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    [self customNavigationBar];
    [self initData];
}


#pragma mark -- 通知中心接收传值
- (void)getProjectId:(NSNotification *)notification {
    WRPProjectDetailViewController *projectDetail = [[WRPProjectDetailViewController alloc] init];
    projectDetail.project_id = notification.object;
    [self.navigationController pushViewController:projectDetail animated:YES];
}


#pragma mark -- 定制导航条
- (void)customNavigationBar {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREEN_SIZE.width - 44, 0, 20, 20);
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"Browsers_32px"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBar) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)rightBar {
    WRPProjectDetailViewController *projectDetail = [[WRPProjectDetailViewController alloc] init];
    GeneralModel *model = _dataSource[0];
    projectDetail.project_id = model.project_id;
    [self.navigationController pushViewController:projectDetail animated:YES];
}


#pragma mark -- 请求数据
- (void)initData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:HOME_URL_DETAIL,self.image_id,self.project_id];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
       NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = rootDic[@"data"];
            
        GeneralModel *model = [[GeneralModel alloc] init];
        [model setValuesForKeysWithDictionary:data];
        
        model.project_id = data[@"project"][@"project"][@"id"];
        model.user_id = data[@"images"][0][@"author_id"];
        
        model.http_prefix = data[@"http_prefix"];
        model.sub_path = data[@"images"][0][@"path"][@"sub_path"];
        model.thumb = data[@"images"][0][@"path"][@"thumb"];
        model.tagString = [NSString stringWithFormat:@"%@ %@",data[@"images"][0][@"tag"][0][@"names"][0][@"name"],data[@"images"][0][@"tag"][1][@"names"][0][@"name"]];
        model.project_name = data[@"images"][0][@"project_name"];
        model.comment = data[@"images"][0][@"comment"];
        
        model.company = data[@"images"][0][@"author"][@"company"];
        model.image = data[@"images"][0][@"author"][@"image"];
        
        
        
        NSArray *subjects = data[@"project"][@"subjects"];
        NSArray *similar = data[@"similar"];
        
        [_dataSource addObject:model];
        [_dataSource addObject:subjects];
        [_dataSource addObject:similar];

        
        [self createTableView];
        [self customHeaderView];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}


#pragma mark - 定制组头
- (void)customHeaderView {
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250)];
    baseView.backgroundColor = LIGHT_COLOR;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 200)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Discovery_Header"]];
    bgView.contentMode = UIViewContentModeScaleAspectFill;//图片自适应填充
    [baseView addSubview:bgView];
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 80, 80)];
    iconView.layer.cornerRadius = 40;
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    iconView.layer.borderWidth = 2.0;
    
    GeneralModel *model = _dataSource[0];
    [iconView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [baseView addSubview:iconView];
    
    iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [iconView addGestureRecognizer:tap];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, -10, 0);
        
        make.centerX.equalTo(baseView.mas_centerX);
        make.centerY.equalTo(bgView.mas_bottom).with.offset(padding.bottom);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, SCREEN_SIZE.width, 20)];
    
    companyLabel.textColor = [UIColor grayColor];
    companyLabel.font = [UIFont systemFontOfSize:12];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.text = model.company;
    [baseView addSubview:companyLabel];
    
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.centerX.equalTo(baseView.mas_centerX);
        make.top.equalTo(iconView.mas_bottom);
    }];
    
    _tableView.tableHeaderView = baseView;
    
}

- (void)taped:(UITapGestureRecognizer *)tap {
    
    NSLog(@"taped");
    
    //跳转到详情页面
    WRPProjectDetailViewController *detail = [[WRPProjectDetailViewController alloc] init];
    GeneralModel *model = _dataSource[0];
    detail.user_id = model.user_id;

    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - 创建tableview
- (void)createTableView {
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WRPProjectDescriptionCell *cell = [[WRPProjectDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        [cell configCellWith:_dataSource[indexPath.section]];
        return cell;
    }else if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        // 集成分享条
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:self.project_id];
        UMSocialBar *socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        
        socialBar.center = cell.contentView.center;
        cell.contentView.backgroundColor = socialBar.backgroundColor;
        [cell.contentView addSubview:socialBar];
        
        return cell;
    }else {
        WRPProjectTableViewCell *cell = [[WRPProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        [cell configcellWithdataSource:_dataSource[indexPath.section] inSection:indexPath.section];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95;
    }else if (indexPath.section == 3) {
        return 50;
    }else {
        return 130;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 3) {
        return 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -- 懒加载
//- (NSMutableArray *)dataSource {
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

@end
