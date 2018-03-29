//
//  WRPProjectItemDetailCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProjectItemDetailCell.h"
#import "UIImageView+WebCache.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPProjectItemDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 300)];
        [self.contentView addSubview:self.iconView];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 320, 20, 20)];
        self.numLabel.font = [UIFont fontWithName:@"Menlo-Italic" size:13];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.cornerRadius = 8;
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.backgroundColor = [UIColor lightGrayColor];
        self.numLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.numLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 300, SCREEN_SIZE.width-40, 60)];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)configCellWith:(WRPProjectItemModel *)model {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://st.zhulogic.com/img/%@%@",model.sub_path,model.thumb]]];
    self.descriptionLabel.text = model.comment;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
