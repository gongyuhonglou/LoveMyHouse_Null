//
//  WRPProjectDescriptionCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProjectDescriptionCell.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPProjectDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_SIZE.width - 20, 20)];
        self.tagLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.tagLabel];
        
        self.project_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_SIZE.width - 20, 20)];
        self.project_nameLabel.font = [UIFont systemFontOfSize:12];
        self.project_nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.project_nameLabel];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_SIZE.width - 20, 60)];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = [UIFont systemFontOfSize:14];
        self.commentLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (void)configCellWith:(GeneralModel *)model {
    self.tagLabel.text = model.tagString;
    self.project_nameLabel.text = model.project_name;
    self.commentLabel.text = model.comment;
    
    CGRect rect = [self.commentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    self.commentLabel.frame = CGRectMake(10, 40, SCREEN_SIZE.width - 20, rect.size.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
