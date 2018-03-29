//
//  WRPCatagoryCell.h
//  LoveMyHouse
//
//  Created by WRP. on 16/6/7.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRPDetailModel.h"

@interface WRPCatagoryCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UIView *seperatorLine;
@property (nonatomic,strong)UIButton *categoryButton;
@property (nonatomic,strong)UIButton *collectButton;
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)WRPDetailModel *dataModel;

//@property (nonatomic,copy)void(^idBlock)(NSString *);

- (void)configcellWithModel:(WRPDetailModel *)model;

@end
