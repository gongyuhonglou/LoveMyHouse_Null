//
//  WRPProjectItemCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRPProjectItemCell : UICollectionViewCell

@property (nonatomic,weak) UIImageView  *thumbView;

- (void)configCellWith:(NSDictionary *)dict;

@end
