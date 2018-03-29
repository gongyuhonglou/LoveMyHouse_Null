//
//  DatabaseNodel.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/27.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseModel : NSObject

@property (nonatomic,copy)NSString *phoneNumber;
@property (nonatomic,copy)NSString *password;


//收藏喜欢用
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,copy)NSString *project_id;

@end
