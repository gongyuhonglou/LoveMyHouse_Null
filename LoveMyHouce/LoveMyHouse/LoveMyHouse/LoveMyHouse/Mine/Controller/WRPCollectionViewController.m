//
//  WRPCollectionViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/3.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPCollectionViewController.h"
#import "FMDBManager.h"
#import "WRPCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DatabaseModel.h"
#import "WRPProjectDetailViewController.h"
#import "Masonry.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation WRPCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (_dataSource.count > 0) {
        [self createCollectionView];
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
    
    [self initDataSource];
}


- (void)initDataSource {
    if ([self.dataType isEqualToString:@"like"]) {
        _dataSource = [NSMutableArray arrayWithArray:[[FMDBManager shareInstance] selectLikeData]];
        self.navigationController.navigationBar.topItem.title = @"我的喜欢";
    }else if ([self.dataType isEqualToString:@"collect"]) {
        _dataSource = [NSMutableArray arrayWithArray:[[FMDBManager shareInstance] selectLikeData]];
        self.navigationController.navigationBar.topItem.title = @"我的收藏";
        
    }
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *fllowlayout = [[UICollectionViewFlowLayout alloc] init];
    fllowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    fllowlayout.minimumInteritemSpacing = 10;
    fllowlayout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 44) collectionViewLayout:fllowlayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:NSClassFromString(@"WRPProductCell") forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
}



#pragma mark -- UICollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;// 返回几组
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat productW = (SCREEN_SIZE.width - 30) / 2;// 每个作品的宽度
    return CGSizeMake(productW, productW + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DatabaseModel *model = _dataSource[indexPath.item];
    WRPProjectDetailViewController *projectDetail = [[WRPProjectDetailViewController alloc] init];
    projectDetail.project_id = model.project_id;
    
    [self.navigationController pushViewController:projectDetail animated:YES];
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
