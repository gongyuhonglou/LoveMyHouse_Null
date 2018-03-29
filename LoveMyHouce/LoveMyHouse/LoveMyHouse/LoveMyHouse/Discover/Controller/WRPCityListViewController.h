//
//  WRPCityListViewController.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "GeneralListViewController.h"

@interface WRPCityListViewController : GeneralListViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy)void(^cityBlock)(NSString *);

@end
