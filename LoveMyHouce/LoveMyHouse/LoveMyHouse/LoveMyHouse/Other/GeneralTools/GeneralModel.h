//
//  GeneralModel.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/19.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralModel : NSObject

@property (nonatomic,copy)NSString *http_prefix;//图片地址前缀

@property (nonatomic,copy)NSString *sub_path;//图片地址前缀

@property (nonatomic,copy)NSString *thumb;//图片地址前缀

@property (nonatomic,strong)NSArray *tags;

@property (nonatomic,copy)NSString *image_id;

@property (nonatomic,copy)NSString *project_id;

@property (nonatomic,copy)NSString *comment;

@property (nonatomic,copy)NSString *tagString;

@property (nonatomic,copy)NSString *project_name;

@property (nonatomic,copy)NSString *company;

@property (nonatomic,copy)NSString *image;

@property (nonatomic,copy)NSString *cover_image;

@property (nonatomic,copy)NSString *real_name;

@property (nonatomic,copy)NSString *user_types;

@property (nonatomic,copy)NSString *number;

@property (nonatomic,copy)NSString *province_name;

@property (nonatomic,copy)NSString *city_name;

@property (nonatomic,copy)NSString *detail_address;

@property (nonatomic,copy)NSString *user_id;//每个图片对应的的id

@property (nonatomic,copy) NSString  *image_share_path;

@end
