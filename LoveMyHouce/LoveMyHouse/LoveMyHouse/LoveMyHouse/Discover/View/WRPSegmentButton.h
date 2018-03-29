//
//  WRPSegmentButton.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRPSegmentButton : UIButton

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *arrowView;

- (void)setButtonTitle:(NSString *)title Tag:(NSInteger)tag;

@end
