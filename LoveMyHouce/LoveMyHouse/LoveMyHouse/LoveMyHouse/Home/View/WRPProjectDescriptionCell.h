//
//  WRPProjectDescriptionCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralModel.h"

@interface WRPProjectDescriptionCell : UITableViewCell

@property (nonatomic,strong) UILabel  *tagLabel;

@property (nonatomic,strong) UILabel  *project_nameLabel;

@property (nonatomic,strong) UILabel  *commentLabel;

- (void)configCellWith:(GeneralModel *)model;

@end
