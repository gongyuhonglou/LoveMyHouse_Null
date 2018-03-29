//
//  WRPProjectTableViewCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProjectTableViewCell.h"
#import "WRPProjectItemCell.h"
#import "WRPProjectDetailViewController.h"
#import "UIImageView+WebCache.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPProjectTableViewCell


- (void)configcellWithdataSource:(NSArray *)dataSource inSection:(NSInteger)section {
    self.dataSource = dataSource;
    self.section = section;
    
    self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20)];
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    self.tagLabel.font = [UIFont systemFontOfSize:14];
    self.tagLabel.text = (self.section == 1) ? @"作品场景" : @"相似场景";
    [self.contentView addSubview:self.tagLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, 110) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:NSClassFromString(@"WRPProjectItemCell") forCellWithReuseIdentifier:@"CollectionCell"];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDataSource/delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WRPProjectItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSString *imageUrl;
    if (self.section == 1) {
        imageUrl = [NSString stringWithFormat:@"http://st.zhulogic.com/img/%@%@",
                    self.dataSource[indexPath.row][@"index_address"][@"sub_path"],
                    self.dataSource[indexPath.row][@"index_address"][@"thumb"]];
        
    }else if (self.section == 2){
        
        imageUrl = [NSString stringWithFormat:@"http://st.zhulogic.com/img/%@%@",
                    self.dataSource[indexPath.row][@"index_address"][@"sub_path"],
                    self.dataSource[indexPath.row][@"index_address"][@"thumb"]];
    }
    [cell.thumbView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"heating_room_128.png"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeProjectId" object:self.dataSource[indexPath.row][@"project_id"]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
