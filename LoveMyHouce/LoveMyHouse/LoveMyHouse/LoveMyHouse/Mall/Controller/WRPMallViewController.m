//
//  WRPMallViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPMallViewController.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "WRPMallDetailController.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPMallViewController ()

@end

@implementation WRPMallViewController {
    
    UITableView *_tableView;
    NSMutableArray *_sectionState;
    NSArray *_sectionImageArray;
    NSArray *_sectionTitleArray;
    NSMutableArray *_dataArray;
    NSMutableArray *_indexArray;
    UIView *_headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self initData];
    
    self.navigationItem.title = @"商城";
}

#pragma mark -- 构造数据
- (void)initData {
    _sectionImageArray = @[@"家具.png",@"灯具.png",@"配饰.png",@"材料.png"];
    _sectionTitleArray = @[@"Furniture | 家具",@"Lighting | 灯具",@"Decorating | 配饰",@"Material | 辅装"];
    _sectionState = [NSMutableArray arrayWithArray:@[@NO,@NO,@NO,@NO]];
    
    _dataArray = [NSMutableArray array];
    _indexArray = [NSMutableArray array];
    
    NSArray *arr1 = @[@"沙发",@"凳椅",@"餐桌",@"茶几",@"床",@"衣柜",@"电视柜",@"储物柜"];
    NSArray *indexArr1 = @[@"11",@"12",@"15",@"14",@"16",@"17",@"13",@"19"];
    
    NSArray *arr2 = @[@"客厅吊灯",@"餐厅吊灯",@"吸顶灯",@"儿童灯",@"落地灯",@"水晶灯",@"台灯",@"壁灯"];
    NSArray *indexArr2 = @[@"156",@"265",@"157",@"158",@"159",@"166",@"103",@"160"];
    
    NSArray *arr3 = @[@"装饰画",@"相片框",@"仿真花",@"壁饰",@"摆件",@"果盘",@"钟表",@"花瓶"];
    NSArray *indexArr3 = @[@"27",@"28",@"34",@"31",@"32",@"33",@"35",@"332"];
    
    NSArray *arr4 = @[@"背景墙",@"瓷砖",@"地板",@"墙贴",@"壁纸",@"地垫"];
    NSArray *indexArr4 = @[@"24",@"163",@"164",@"25",@"26",@"36"];
    
    [_dataArray addObject:arr1];
    [_dataArray addObject:arr2];
    [_dataArray addObject:arr3];
    [_dataArray addObject:arr4];
    
    [_indexArray addObject:indexArr1];
    [_indexArray addObject:indexArr2];
    [_indexArray addObject:indexArr3];
    [_indexArray addObject:indexArr4];
}

#pragma mark -- 创建界面
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
//    [self customHeaderView];
}

// 定制头部view
//- (void)customHeaderView {
//    
//}

#pragma mark -- 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_sectionState[section] boolValue] == NO) {
        return 0;
    }else {
        return [_dataArray[section] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 170)];
    _headerView.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 170)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_sectionImageArray[section] ofType:@""]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width-20, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = _sectionTitleArray[section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [imageView addSubview:titleLabel];
    [_headerView addSubview:imageView];
    _headerView.userInteractionEnabled = YES;
    _headerView.tag = section;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [_headerView addGestureRecognizer:tap];
    
    return _headerView;
}

#pragma mark -- 点击组头
- (void)taped:(UITapGestureRecognizer *)tap {
    if ([_sectionState[tap.view.tag] boolValue] == NO) {
        [_sectionState removeObjectAtIndex:tap.view.tag];
        [_sectionState insertObject:@YES atIndex:tap.view.tag];
    }else {
        // 删掉@YES替换为@NO
        [_sectionState removeObjectAtIndex:tap.view.tag];
        [_sectionState insertObject:@NO atIndex:tap.view.tag];
    }
    [_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 170;
}

// 让headerView跟随cell一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 170;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark -- 选中某行cell进行跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRPMallDetailController *detailVc = [[WRPMallDetailController alloc] init];
    detailVc.detailUrl = [NSString stringWithFormat:Mall_URL,_indexArray[indexPath.section][indexPath.row]];
    
    //push的同时隐藏tabBar
    detailVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
