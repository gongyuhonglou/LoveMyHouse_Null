//
//  FMDBManager.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/27.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseModel.h"

@interface FMDBManager : NSObject{
    
    FMDatabase *_dataBase;
}


+ (instancetype)shareInstance;
- (instancetype)init;

//用户登录注册接口
- (void)saveUserInfoWithphoneNum:(NSString *)phoneNumber password:(NSString *)password;
- (BOOL)verifyUserInfoWithphoneNum:(NSString *)phoneNumber;
- (BOOL)verifyUserInfoWithphoneNum:(NSString *)phoneNumber password:(NSString *)password;
- (void)deleteUserInfo:(NSString *)account;
- (NSMutableArray *)selectAll;

//收藏喜欢接口
- (void)saveCollectionInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id;
- (void)saveLikeInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id;
- (void)saveConcernsInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id;

//读取数据
- (NSMutableArray *)selectCollectionData;
- (NSMutableArray *)selectLikeData;
- (NSMutableArray *)selectConcernsData;

//通过图片project_id查找是否收藏过
- (BOOL)verifyCollectionInfoWithProjectID:(NSString *)project_id;
- (BOOL)verifyLikeInfoWithProjectID:(NSString *)project_id;
- (BOOL)verifyConcernsInfoWithProjectID:(NSString *)project_id;


//通过图片project_id删除该条数据
- (void)deleteCollectionInfo:(NSString *)project_id;
- (void)deleteLikeInfo:(NSString *)project_id;
- (void)deleteConcernsInfo:(NSString *)project_id;

@end
