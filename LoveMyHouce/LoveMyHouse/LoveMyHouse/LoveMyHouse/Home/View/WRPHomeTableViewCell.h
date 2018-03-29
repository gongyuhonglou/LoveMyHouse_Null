//
//  WRPHomeTableViewCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralModel.h"

@interface WRPHomeTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel  *tagLabel;

@property (nonatomic,strong) UIImageView *thumblView;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) UIButton *collectButton;

@property (nonatomic,strong) UIButton *shareButton;

@property (nonatomic,strong) NSString  *image_id;

- (void)configCellWithModel:(GeneralModel *)model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
