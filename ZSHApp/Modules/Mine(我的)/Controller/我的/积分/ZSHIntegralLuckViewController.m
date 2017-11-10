//
//  ZSHIntegralLuckViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHIntegralLuckViewController.h"
#import "ZSHLuckCardView.h"

@interface ZSHIntegralLuckViewController ()

@property (nonatomic, strong)ZSHLuckCardView      *luckView;

@end

@implementation ZSHIntegralLuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{
    self.title = @"积分抽奖";
    [self.view addSubview:self.luckView];
}

-(ZSHLuckCardView *)luckView{
    if (!_luckView) {
        _luckView = [[ZSHLuckCardView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight + kRealValue(30), KScreenWidth, kRealValue(215)) paramDic:nil];
//        _luckView = [[ZSHLuckCardView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight + kRealValue(30), KScreenWidth, kRealValue(215))];
    }
    return _luckView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
