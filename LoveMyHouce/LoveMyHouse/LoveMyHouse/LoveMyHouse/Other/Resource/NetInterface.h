//
//  NetInterface.h
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#ifndef NetInterface_h
#define NetInterface_h

// 判断iOS操作系统的版本
#define IOS(r) ([UIDevice currentDevice].systemVersion.floatValue >= r)


/** 接口信息 */

// 主页
#define Home_URL @"http://api.zhulogic.com/json/routes/index.php?m=index&order=score&over=%ld"

// 主页筛选
#define FILTER_URL @"http://api.zhulogic.com/json/routes/index.php?m=index&image_tags=%@&order=score&over=%ld"
// 主页详情
#define HOME_URL_DETAIL @"http://api.zhulogic.com/json/routes/index.php?m=show&image_id=%@&project_id=%@"
// 主页详情描述
#define PROJECT_URL_DETAIL @"http://api.zhulogic.com/json/routes/index.php?m=detail&project_id=%@"


// 商城
#define Mall_URL @"http://appweb.hongniujia.com/gallery/index/0/%@/"


// 发现
#define Discover_URL @"http://api.zhulogic.com/json/routes/professor.php?m=index&skip=%ld"
//发现详情
#define DISCOVERY_URL_DETAIL @"http://api.zhulogic.com/json/routes/professor.php?m=show&professor_id=%@"

// 我
#define Mine_URL @""






//获取城市id
#define CITY_URL @"http://api.zhulogic.com/json/routes/professor.php?m=index"

//类型
//&type_id=%@

//地区
//&&city_id=%@

//排序
////&order=%@
//最新排序order=registration_date
//热门order=hot



//收藏和喜欢

//喜欢
#define FAVORITE_URL @"http://api.zhulogic.com/json/routes/rate_favorite.php"
//POST请求
//参数：c=rates,image_id=%@,m=store
//获取 喜欢 数据(无法使用，需要登陆接口才有效)
#define FAVORITE_URL_LOCAL @"http://api.zhulogic.com/json/routes/rate_favorite.php?c=rates&m=index"

#endif /* NetInterface_h */

#ifdef DEBUG
#define WRPLog(...) NSLog(__VA_ARGS__)
#else
#define WRPLog(...)
#endif
