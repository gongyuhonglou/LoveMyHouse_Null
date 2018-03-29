//
//  WRPHomeTableViewCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPHomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumblView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 370)];
        [self.contentView addSubview:self.thumblView];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 375, 200, 20)];
        self.tagLabel.font = [UIFont systemFontOfSize:12];
        self.tagLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.tagLabel];
        
        //喜欢 收藏 点赞
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 120, 375, 20, 20)];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"爱心点赞"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.likeButton];
        
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 80, 375, 20, 20)];
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.collectButton];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 40, 377, 16, 16)];
        self.shareButton.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.shareButton setBackgroundImage:[[UIImage imageNamed:@"Share_24px"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.contentView addSubview:self.shareButton];
    }
    return self;
}


- (void)configCellWithModel:(GeneralModel *)model {
    
    self.image_id = model.image_id;
    
    NSMutableString *tagString = [[NSMutableString alloc] initWithCapacity:100];
    for (NSDictionary *dict in model.tags[0][@"names"]) {
        NSString *tag = dict[@"name"];
        [tagString appendFormat:@" | %@",tag];
    }
    self.tagLabel.text = [NSString stringWithFormat:@"%@%@",model.tags[0][@"names"][0][@"names"],tagString];
    [self.thumblView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",model.http_prefix,model.sub_path,model.thumb]] placeholderImage:[UIImage imageNamed:@"Project_Main.png"]];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
