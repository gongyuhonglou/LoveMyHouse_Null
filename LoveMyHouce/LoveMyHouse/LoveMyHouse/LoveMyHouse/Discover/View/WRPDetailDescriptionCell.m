//
//  WRPDetailDescriptionCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPDetailDescriptionCell.h"

@implementation WRPDetailDescriptionCell

- (void)configCellWith:(WRPDetailModel *)model
{
    self.typeLabel.text = model.types[0][@"name"];
    
    self.homepageLabel.text = model.homepage;
    if ([model.homepage isEqualToString:@""]) {
        self.homepageLabel.text = model.mail_address;
    }
    
    self.detailAdressLabel.text = model.detail_address;
    if ([model.detail_address isEqualToString:@""]) {
        self.detailAdressLabel.text = model.city_name;
    }
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.description];
    if ([model.description isEqualToString:@""]) {
        self.descriptionLabel.text = model.real_name;
    }
    
    self.categoriesButton.titleLabel.text = [NSString stringWithFormat:@"%ld个作品",model.categories.count];
    self.collectButton.titleLabel.text = [NSString stringWithFormat:@"%ld个集库",model.collects.count];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
