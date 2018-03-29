//
//  WRPProductCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseModel.h"

@interface WRPProductCell : UICollectionViewCell

@property (nonatomic,weak)UILabel * titleLabel;
@property (nonatomic,weak)UIImageView * detailImageView;
@property (nonatomic, strong)UIImageView *collectionView;

- (void)configCellWithDataModel:(DatabaseModel *)model;

@end
