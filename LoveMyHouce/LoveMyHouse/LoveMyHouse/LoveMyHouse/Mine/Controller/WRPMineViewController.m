//
//  WRPMineViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/5/17.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPMineViewController.h"
#import "WRPMineNavigationController.h"
#import "FMDBManager.h"
#import "WRPCollectionViewController.h"
#import "WRPFollowsViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "WRPNoticeViewController.h"
#import "WRPAdviseViewController.h"
#import "SDImageCache.h"

#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kImageHeight 200

@interface WRPMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *headerView;// 头像

@property (nonatomic,strong) UILabel *nameLabel;// 用户名

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UINavigationController *navController;

// 用于缩放的图片
@property (nonatomic,strong) UIImageView *scaleImage;

@end

@implementation WRPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}
#pragma mark -- 构造数据
- (void)loadData {
    
    _dataSource = [[NSMutableArray alloc] init];
    NSArray *array1 = @[@"通知",@"私信",@"评论"];
    NSArray *array2 = @[@"我的喜欢",@"我的收藏",@"我的关注"];
    NSArray *array3 = @[@"清空缓存"];
    NSArray *array4 = @[@"意见反馈"];
    
    [self.dataSource addObject:array1];
    [self.dataSource addObject:array2];
    [self.dataSource addObject:array3];
    [self.dataSource addObject:array4];
    
    [self createTableView];
    
    // 把图片添加到tableview上
    [self.tableView insertSubview:_scaleImage atIndex:0];
    // 修改tableView的内间距，让图片显示出来
    self.tableView.contentInset = UIEdgeInsetsMake(kImageHeight, 0, 0, 0);
    // 关闭vc的自动调节内间距
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置透明的view的背景色
    self.navigationController.transView.backgroundColor = [UIColor yellowColor];
    
}

#pragma mark -- 创建tableView
- (void)createTableView {
    _scaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageHeight,kWidth, kImageHeight)];
    _scaleImage.image = [UIImage imageNamed:@"bgDefaultIcon"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self customHeaderView];
}

- (void)customHeaderView {
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-80)/2, (kImageHeight-80)/2, 80, 80)];
    _headerView.image = [UIImage imageNamed:@"小头像_1.jpg"];
    _headerView.layer.cornerRadius = 40;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.borderWidth = 2.0;
    _headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedHeaderView)];
    [_headerView addGestureRecognizer:tap];
    
    [_scaleImage addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 80)/2, 120, 80, 20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.userInteractionEnabled = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginstate"] isEqualToString:@"loggedin"]) {
        _nameLabel.text = @"注销";
    }else {
        _nameLabel.text = @"请登录";
    }
    [self.headerView addSubview:_nameLabel];
    
    UITapGestureRecognizer *tapedLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedLabel:)];
    [_nameLabel addGestureRecognizer:tapedLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.width.equalTo(@20);
        make.centerX.equalTo(_headerView.mas_centerX);
    }];
}

- (void)tapedLabel:(UIGestureRecognizer *)taped {
    if ([_nameLabel.text isEqualToString:@"注销"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"loggedout" forKey:@"loginstate"];
        _nameLabel.text = @"请登录";
    }else {
        // 跳转到注册页面
        
    }
}

- (void)tapedHeaderView {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginstate"] isEqualToString:@"loggedin"]) {
        // 点这里更换头像
        UIImagePickerController *piker = [[UIImagePickerController alloc] init];
        piker.delegate = self;
        [self presentViewController:piker animated:YES completion:nil];
    }else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _headerView.image = selectedImage;
    NSData *headerImageData = UIImagePNGRepresentation(selectedImage);
    [[NSUserDefaults standardUserDefaults] setObject:headerImageData forKey:@"headerImage"];// 头像储存到本地
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- tableView代理方法
// tableView有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
// 每个cell有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义一个标识
    static NSString *cellId = @"cell";
    // 去缓存池中取出可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%.1fM)",_dataSource[indexPath.section][indexPath.row],[[SDImageCache sharedImageCache] getSize] / 1000000.0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSString *loginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginstate"];
        if (![loginState isEqualToString:@"loggedin"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆更精彩" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self presentViewController:_navController animated:YES completion:nil];
//            }];
        }else {
            if (indexPath.section == 0) {
                // 通知评论页
                WRPNoticeViewController *noticeVc = [[WRPNoticeViewController alloc] init];
                noticeVc.noticeType = _dataSource[indexPath.section][indexPath.row];
                [self.navigationController pushViewController:noticeVc animated:YES];
            }else if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    // 我的喜欢
                    WRPCollectionViewController *likeVc = [[WRPCollectionViewController alloc] init];
                    likeVc.dataType = @"like";
                    [self.navigationController pushViewController:likeVc animated:YES];
                }else if (indexPath.row == 1) {
                    // 我的收藏
                    WRPCollectionViewController *collectionVc = [[WRPCollectionViewController alloc] init];
                    collectionVc.dataType = @"collect";
                    [self.navigationController pushViewController:collectionVc animated:YES];
                }else if (indexPath.row == 2) {
                    // 我的关注
                    WRPFollowsViewController *followsVc = [[WRPFollowsViewController alloc] init];
                    [self.navigationController pushViewController:followsVc animated:YES];
                }
            }
        }
    }else if (indexPath.section == 2) {
        [[SDImageCache sharedImageCache] clearDisk];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }else if (indexPath.section == 3) {
        WRPAdviseViewController *mailVc = [[WRPAdviseViewController alloc] initWithNibName:@"WRPAdviseViewController" bundle:nil];
        [self.navigationController pushViewController:mailVc animated:YES];
    }
}


#pragma mark -- ScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 修改导航栏的透明度
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.navigationController.transView.alpha = (offsetY + kImageHeight) / (kImageHeight - 64);
    // 缩放图片
    if (offsetY < -kImageHeight) {
        // 设置一个缩放系数
        CGFloat s = 0.01;
        // 缩放量
        CGFloat scale = (-offsetY - kImageHeight) * s;
        // 设置图片缩放
        _scaleImage.transform = CGAffineTransformMakeScale(1 + scale, 1 + scale);
    }
}

@end
