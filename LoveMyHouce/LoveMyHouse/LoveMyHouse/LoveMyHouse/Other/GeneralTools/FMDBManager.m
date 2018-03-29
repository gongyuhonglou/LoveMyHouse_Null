//
//  FMDBManager.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/27.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "FMDBManager.h"
#import "NetInterface.h"


@implementation FMDBManager


+ (instancetype)shareInstance
{
    static FMDBManager *manager;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        manager = [[FMDBManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tinyhome.db"];
        NSLog(@"%@",path);
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        if ([_dataBase open]) {
            WRPLog(@"数据库创建成功");
        }
        
        NSString * createUserInfoTable = @"create table if not exists UserInfo(id integer primary key autoincrement,phonenumber varchar (256),password varchar (256))";
        if ([_dataBase executeUpdate:createUserInfoTable]) {
            WRPLog(@"userinfo表创建成功");
        }
        
        NSString * createLikeTable = @"create table if not exists likeInfo(id integer primary key autoincrement,thumburl varchar (256),tagtitle varchar (256),projectid varchar (256))";
        if ([_dataBase executeUpdate:createLikeTable]) {
            WRPLog(@"like表创建成功");
        }
        
        NSString * createCollectionTable = @"create table if not exists CollectionInfo(id integer primary key autoincrement,thumburl varchar (256),tagtitle varchar (256),projectid varchar (256))";
        if ([_dataBase executeUpdate:createCollectionTable]) {
            WRPLog(@"colleciton表创建成功");
        }
        
        
        NSString * createConcernsTable = @"create table if not exists ConcernsInfo(id integer primary key autoincrement,thumburl varchar (256),tagtitle varchar (256),projectid varchar (256))";
        if ([_dataBase executeUpdate:createConcernsTable]) {
            WRPLog(@"Concerns表创建成功");
        }
        
    }
    return self;
    
}

//插入数据的方法
- (void)saveUserInfoWithphoneNum:(NSString *)phoneNumber password:(NSString *)password
{
    
    NSString *insertSql = @"insert into UserInfo(phonenumber,password)values(?,?)";
    if ([_dataBase executeUpdate:insertSql,phoneNumber,password]) {
        WRPLog(@"保存注册信息成功");
    }
    
}

- (void)saveLikeInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id
{
    NSString *insertSqlite = @"insert into likeInfo(thumburl,tagtitle,projectid)values(?,?,?)";
    if ([_dataBase executeUpdate:insertSqlite,thumb,tag,project_id]) {
        WRPLog(@"喜欢 成功");
    }
}


- (void)saveCollectionInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id
{
    NSString *insertSqlite = @"insert into CollectionInfo(thumburl,tagtitle,projectid)values(?,?,?)";
    if ([_dataBase executeUpdate:insertSqlite,thumb,tag,project_id]) {
        WRPLog(@"收藏 成功");
    }
}

- (void)saveConcernsInfoWiththumb:(NSString *)thumb tag:(NSString *)tag projectId:(NSString *)project_id
{
    NSString *insertSqlite = @"insert into ConcernsInfo(thumburl,tagtitle,projectid)values(?,?,?)";
    if ([_dataBase executeUpdate:insertSqlite,thumb,tag,project_id]) {
        WRPLog(@"关注 成功");
    }
}


//通过用户名查找数据
- (BOOL)verifyUserInfoWithphoneNum:(NSString *)phoneNumber;
{
    NSString *selectSql = @"select *from UserInfo where phonenumber = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,phoneNumber];
    while ([set next]) {
        return YES;
    }
    return NO;
}

//核对密码
- (BOOL)verifyUserInfoWithphoneNum:(NSString *)phoneNumber password:(NSString *)passWord;
{
    NSString *selectSql = @"select *from UserInfo where phonenumber = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,phoneNumber];
    while ([set next]) {
        NSString *truePassword = [set stringForColumn:@"password"];
        //        NSLog(@"~~~%@",truePassword);
        if ([truePassword isEqualToString:passWord]) {
            return YES;
        }
    }
    return NO;
}


//通过图片project_id查找是否收藏过或喜欢过
- (BOOL)verifyCollectionInfoWithProjectID:(NSString *)project_id
{
    NSString *selectSql = @"select *from CollectionInfo where projectid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,project_id];
    while ([set next]) {
        return YES;
    }
    return NO;
}

- (BOOL)verifyLikeInfoWithProjectID:(NSString *)project_id
{
    NSString *selectSql = @"select *from likeInfo where projectid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,project_id];
    while ([set next]) {
        return YES;
    }
    return NO;
    
    
}

- (BOOL)verifyConcernsInfoWithProjectID:(NSString *)project_id
{
    NSString *selectSql = @"select *from ConcernsInfo where projectid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,project_id];
    while ([set next]) {
        return YES;
    }
    return NO;
    
    
}


//重设用户登陆信息，删除原有数据
- (void)deleteUserInfo:(NSString *)account
{
    NSString *deleteSql = @"delete from UserInfo where phonenumber = ?";
    if([_dataBase executeUpdate:deleteSql,account]){
        
        WRPLog(@"重设密码 成功");
    }
}

//通过图片project_id删除该条数据
- (void)deleteCollectionInfo:(NSString *)project_id
{
    NSString *deleteSql = @"delete from CollectionInfo where projectid = ?";
    if([_dataBase executeUpdate:deleteSql,project_id]){
        
        WRPLog(@"取消收藏 成功");
    }
}

- (void)deleteLikeInfo:(NSString *)project_id
{
    NSString *deleteSql = @"delete from likeInfo where projectid = ?";
    if([_dataBase executeUpdate:deleteSql,project_id]){
        
        WRPLog(@"取消喜欢 成功");
    }
}

- (void)deleteConcernsInfo:(NSString *)project_id
{
    NSString *deleteSql = @"delete from ConcernsInfo where projectid = ?";
    if([_dataBase executeUpdate:deleteSql,project_id]){
        
        WRPLog(@"取消关注 成功");
    }
}


- (NSMutableArray *)selectAll
{
    NSMutableArray *array = [NSMutableArray new];
    NSString *selectSql = @"select *from UserInfo";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        DatabaseModel *model = [[DatabaseModel alloc] init];
        
        //...此处把保存的一些字段赋给model，再将modal存入数组，封装起来
        NSString *username = [set stringForColumn:@"phonenumber"];
        NSString *password = [set stringForColumn:@"password"];
        model.phoneNumber = username;
        model.password = password;
        
        [array addObject:model];
    }
    return array;
}

- (NSMutableArray *)selectCollectionData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *selectSql = @"select *from CollectionInfo";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        
        DatabaseModel *model = [[DatabaseModel alloc] init];
        model.thumb = [set stringForColumn:@"thumburl"];
        model.tag = [set stringForColumn:@"tagtitle"];
        model.project_id = [set stringForColumn:@"projectid"];
        
        [array addObject:model];
    }
    
    return array;
}

- (NSMutableArray *)selectLikeData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *selectSql = @"select *from likeInfo";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        
        DatabaseModel *model = [[DatabaseModel alloc] init];
        model.thumb = [set stringForColumn:@"thumburl"];
        model.tag = [set stringForColumn:@"tagtitle"];
        model.project_id = [set stringForColumn:@"projectid"];
        
        [array addObject:model];
    }
    
    return array;
}

- (NSMutableArray *)selectConcernsData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *selectSql = @"select *from ConcernsInfo";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        
        DatabaseModel *model = [[DatabaseModel alloc] init];
        model.thumb = [set stringForColumn:@"thumburl"];
        model.tag = [set stringForColumn:@"tagtitle"];
        model.project_id = [set stringForColumn:@"projectid"];
        
        [array addObject:model];
    }
    
    return array;
}

@end
