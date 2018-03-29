//
//  WRPCityListViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPCityListViewController.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "WRPCityResultViewController.h"

@interface WRPCityListViewController ()

@end

@implementation WRPCityListViewController{
    
    UITextField *_textField;
    UICollectionView *_collectionView;
    NSArray *_dataSource;
    NSArray *_cityList;//城市数据源
    
    WRPCityResultViewController *_tableViewVC;
    NSString *_searchString;
    
    NSString *_resultCity;//接收用户选择的城市（id）
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customDataSource];
    [self customCityTextField];
    [self createCollectionView];
}

#pragma mark - 数据请求
- (void)customDataSource
{
    _dataSource = @[@"广州",@"深圳",@"武汉",@"南京",@"杭州",@"苏州",@"西安",@"成都",@"北京",@"天津",@"重庆",@"上海"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CITY_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = rootDic[@"data"];
        
        _cityList = data[@"cities"];//城市对应的id库
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}




#pragma mark - 定制搜索框
- (void)customCityTextField
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _tableViewVC = [[WRPCityResultViewController alloc] init];//初始化城市搜索结果列表
    _tableViewVC.view.frame = CGRectMake(60, 50, SCREEN_SIZE.width - 120, 300);
    
    
    //写了一大堆又用不到，跨界面传值，用通知中心
    //    __weak CityResultViewController *weakSelf = _tableViewVC;
    //    weakSelf.cityBlock = ^(NSString *cityid){
    //
    //        _resultCity = cityid;//block反向传值，接收客户选择的搜索结果
    //        NSLog(@"~~~~~%@",_resultCity);//父类调用了_tableViewVC，_tableViewVC里面的block又调用了父类的_resultCity，有可能retain cycle
    //
    //
    //
    //    };
    
    
    
    _tableViewVC.dataSource = [[NSMutableArray alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, SCREEN_SIZE.width - 120, 50)];
    imageView.image = [[UIImage imageNamed:@"橘色线"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [bgView addSubview:imageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 20, SCREEN_SIZE.width - 120, 30)];
    _textField.placeholder = @"搜索城市";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    
    
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];//监听搜索框
    
    [self.view addSubview:_textField];
    
    
    
    
}

//监听搜索文字
- (void)textChanged:(UITextField *)textField
{
    
    BOOL isCreated = NO;
    for (id subView in self.view.subviews) {
        if (subView == _tableViewVC.view) {
            isCreated = YES;
            break;
        }
    }
    
    if (isCreated == NO) {
        [self addChildViewController:_tableViewVC];
        [self.view addSubview:_tableViewVC.view];
    }
    
    
    if (textField.text.length > 0) {
        
        //清空上一次搜索结果
        if (_tableViewVC.dataSource != nil) {
            [_tableViewVC.dataSource removeAllObjects];
        }
        _searchString = textField.text;
        //        NSLog(@"searchString : %@",_searchString);
        
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"self contains[c] %@",_searchString];
        
        for (NSDictionary *dict in _cityList) {
            
            NSString *cityName = dict[@"name"];
            
            if ([predicate evaluateWithObject:cityName]) {
                
                //                NSLog(@"%@",dict[@"name"]);
                [_tableViewVC.dataSource addObject:dict];
            }
            
        }
        
        [_tableViewVC.tableView reloadData];
        
    }else{
        [_tableViewVC.view removeFromSuperview];
        [_tableViewVC removeFromParentViewController];
    }
}


#pragma mark - 创建collectionview
- (void)createCollectionView
{
    
    CGFloat xSpace = SCREEN_SIZE.width/11;//每个cell和间隙等宽，cell加间隙共11个
    
    //collectionview组头标题
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace, 100, SCREEN_SIZE.width, 20)];
    headerLabel.font = [UIFont systemFontOfSize:12.0];
    headerLabel.text = @"热门城市";
    [self.view addSubview:headerLabel];
    
    //collectionview
    
    
    
    UICollectionViewFlowLayout *fllowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    fllowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    fllowLayout.minimumInteritemSpacing = xSpace;
    fllowLayout.minimumLineSpacing = xSpace;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(xSpace, 120, SCREEN_SIZE.width - 2 * xSpace, 260) collectionViewLayout:fllowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self.view addSubview:_collectionView];
    
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
}



#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;//返回组数
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    //给cell添加一个label
    CGFloat xSpace = SCREEN_SIZE.width/11;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, xSpace, 20)];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = _dataSource[indexPath.item];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat xSpace = SCREEN_SIZE.width/11;
    return CGSizeMake(xSpace, 20);
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//当选中某一项
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = _dataSource[indexPath.item];
    
    for (NSDictionary *dict in _cityList) {
        
        if ([city isEqualToString:[dict objectForKey:@"name"]]) {
            
            self.cityBlock(dict[@"id"]);
            break;
        }
    }
    
    [self.view removeFromSuperview];
    //    [self removeFromParentViewController];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}



@end
