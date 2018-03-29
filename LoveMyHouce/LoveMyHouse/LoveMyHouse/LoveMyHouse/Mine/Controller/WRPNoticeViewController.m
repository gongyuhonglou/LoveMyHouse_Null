//
//  WRPNoticeViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/6.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPNoticeViewController.h"
#import "Masonry.h"


#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface WRPNoticeViewController ()

@end

@implementation WRPNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.noticeType;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBgView];
}

- (void)addBgView {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_SIZE.width, 300)];
    bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"消息为空" ofType:@"png"]];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.625);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
