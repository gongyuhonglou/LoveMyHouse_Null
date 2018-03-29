//
//  WRPDetailModel.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRPDetailModel : NSObject

@property (nonatomic,copy)NSString *real_name;
@property (nonatomic,copy)NSString *followed_number;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *cover_image;
@property (nonatomic,copy)NSArray *types;//业务类型
@property (nonatomic,copy)NSString *homepage;
@property (nonatomic,copy)NSString *detail_address;
@property (nonatomic,copy)NSString *mail_address;
@property (nonatomic,copy)NSString *city_name;
@property (nonatomic,copy)NSString *description;
@property (nonatomic,strong)NSArray *categories;//数组里为字典，有name，image字段
@property (nonatomic,strong)NSArray *collects;

@property (nonatomic,copy)NSString *user_id;

@end
