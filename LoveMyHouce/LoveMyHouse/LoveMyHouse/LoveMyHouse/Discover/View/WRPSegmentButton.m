//
//  WRPSegmentButton.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPSegmentButton.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation WRPSegmentButton

@synthesize titleLabel = _titleLabel;
@synthesize arrowView = _arrowView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = SCREEN_SIZE.width/4;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 40)/2, 10, 40, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
        
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 40)/2 + 40, 10, 20, 20)];
        self.arrowView.image = [[UIImage imageNamed:@"三角向下箭头_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:self.arrowView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width - 0.5, 10, 0.5, 20)];//分割线
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    
    return self;
}

- (void)setButtonTitle:(NSString *)title Tag:(NSInteger)tag
{
    self.titleLabel.text = title;
    self.tag = tag;
}

@end
