//
//  WRPDetailDescriptionCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRPDetailModel.h"

@interface WRPDetailDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homepageLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIButton *concernButton;
@property (weak, nonatomic) IBOutlet UIButton *categoriesButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

- (void)configCellWith:(WRPDetailModel *)model;

@end
