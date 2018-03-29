//
//  WRPProjectTableViewCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRPProjectTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UILabel  *tagLabel;
@property (nonatomic,strong) UICollectionView  *collectionView;
@property (nonatomic,strong) NSArray  *dataSource;
@property (nonatomic,assign) NSInteger  section;

- (void)configcellWithdataSource:(NSArray *)dataSource inSection:(NSInteger)section;

@end
