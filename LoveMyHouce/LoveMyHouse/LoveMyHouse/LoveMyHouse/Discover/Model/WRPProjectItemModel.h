//
//  WRPProjectItemModel.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRPProjectItemModel : NSObject

@property (nonatomic,copy)NSString *http_prefix;//图片地址前缀
@property (nonatomic,copy)NSString *sub_path;//图片地址前缀
@property (nonatomic,copy)NSString *thumb;//图片地址前缀
@property (nonatomic,copy)NSString *image;//作者图片

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *project_id;
@property (nonatomic,copy)NSString *image_id;
@property (nonatomic,copy)NSString *comment;

@end
