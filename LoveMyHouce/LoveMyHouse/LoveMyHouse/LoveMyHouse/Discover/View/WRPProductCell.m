//
//  WRPProductCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProductCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPProductCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat productW = (SCREEN_SIZE.width - 30)/2;//每个作品的宽度
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, productW, productW, 20)];
        _titleLabel = label;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_titleLabel];
        
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productW, productW)];
        _detailImageView = iv;
        _detailImageView.layer.cornerRadius = 5;
        _detailImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_detailImageView];
        
        
        self.collectionView = [[UIImageView alloc] initWithFrame:CGRectMake(productW - 25, 5, 20, 20)];
        
        //        self.collectionView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.collectionView];
        
        
    }
    return self;
    
}
//
- (void)configCellWithDataModel:(DatabaseModel *)model
{
    self.titleLabel.text = model.tag;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"heating_room_128.png"]];
}

@end
