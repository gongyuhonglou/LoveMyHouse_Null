//
//  WRPCatagoryCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPCatagoryCell.h"
#import "WRPProductCell.h"
#import "UIImageView+WebCache.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPCatagoryCell{
    
    
    NSArray *_dataSource;
}





- (void)configcellWithModel:(WRPDetailModel *)model
{
    
    self.dataModel = model;
    _dataSource = self.dataModel.categories;//初始化collectionview的数据源，默认显示作品组
    
    NSInteger max_number = MAX(model.categories.count, model.collects.count);
    CGFloat collectionViewH = (max_number/2 + max_number%2) * 210.0f;//collectionview的高度
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50 + collectionViewH)];
    
    self.categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width/2, 40)];
    [self.categoryButton setTitle:[NSString stringWithFormat:@"%ld个作品",model.categories.count] forState:UIControlStateNormal];
    [self.categoryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.categoryButton.tag = 11;
    [self.categoryButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchDown];
    
    self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2, 0, SCREEN_SIZE.width/2, 40)];
    [self.collectButton setTitle:[NSString stringWithFormat:@"%ld个集库",model.collects.count] forState:UIControlStateNormal];
    [self.collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.collectButton.tag = 12;
    [self.collectButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchDown];
    
    UIView *buttonLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2, 5, 0.5f, 30)];
    [buttonLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.categoryButton addSubview:buttonLine];
    
    
    [self.baseView addSubview:self.categoryButton];
    [self.baseView addSubview:self.collectButton];
    [self.contentView addSubview:self.baseView];
    
    UICollectionViewFlowLayout * fllowLayout = [[UICollectionViewFlowLayout alloc] init];
    fllowLayout.minimumInteritemSpacing = 0;
    fllowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_SIZE.width, collectionViewH) collectionViewLayout:fllowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [_collectionView registerClass:NSClassFromString(@"WRPProductCell") forCellWithReuseIdentifier:@"Cell"];
    [self.baseView addSubview:self.collectionView];
    
}


- (void)clicked:(UIButton *)button
{
    NSLog(@"%ld",button.tag);
    if (button.tag == 11) {
        _dataSource = self.dataModel.categories;
    }else{
        _dataSource = self.dataModel.collects;
    }
    [_collectionView reloadData];
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
    
    WRPProductCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = _dataSource[indexPath.row][@"name"];
    [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"heating_room_128.png"]];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat productW = (SCREEN_SIZE.width - 30)/2;//每个作品的宽度
    return CGSizeMake(productW, productW + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

//当选中某一项
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"作品 ： %@",_dataSource[indexPath.item]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"project_id" object:_dataSource[indexPath.item][@"id"]];
    
}

@end
