//
//  WRPDiscoveryCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralModel.h"

@interface WRPDiscoveryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)configCellWithModel:(GeneralModel *)model;

@end
