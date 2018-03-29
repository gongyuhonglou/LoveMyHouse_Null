//
//  WRPProjectItemCell.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPProjectItemCell.h"

@implementation WRPProjectItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.thumbView = view;
        self.thumbView.layer.cornerRadius = 8;
        self.thumbView.layer.masksToBounds = YES;
        self.thumbView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.thumbView];
    }
    return self;
}

- (void)configCellWith:(NSDictionary *)dict {
    
}

@end
