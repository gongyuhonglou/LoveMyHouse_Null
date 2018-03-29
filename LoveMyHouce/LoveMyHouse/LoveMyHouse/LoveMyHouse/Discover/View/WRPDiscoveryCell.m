//
//  WRPDiscoveryCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPDiscoveryCell.h"
#import "UIImageView+WebCache.h"

@implementation WRPDiscoveryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.logoView.layer.cornerRadius = 25;
    self.logoView.layer.masksToBounds = YES;
}

- (void)configCellWithModel:(GeneralModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image]];
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.logoView addGestureRecognizer:tap];
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@ | %@",model.province_name,model.city_name];
    self.agentLabel.text = model.real_name;
    self.typeLabel.text = model.user_types;
}

- (void)taped:(UITapGestureRecognizer *)tap
{
    NSLog(@"taped");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
