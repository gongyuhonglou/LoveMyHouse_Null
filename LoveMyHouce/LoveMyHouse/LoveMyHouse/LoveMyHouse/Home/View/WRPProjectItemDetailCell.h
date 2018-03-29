//
//  WRPProjectItemDetailCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRPProjectItemModel.h"

@interface WRPProjectItemDetailCell : UITableViewCell

@property (nonatomic,strong) UIImageView  *iconView;

@property (nonatomic,strong) UILabel  *numLabel;

@property (nonatomic,strong) UILabel  *descriptionLabel;

- (void)configCellWith:(WRPProjectItemModel *)model;

@end
