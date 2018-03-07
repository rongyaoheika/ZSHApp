//
//  ZSHQuotaViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHQuotaViewController.h"
#import "ZSHQuotaHeadView.h"

@interface ZSHQuotaViewController ()

@property (nonatomic, strong) ZSHQuotaHeadView              *headerView;

@end

@implementation ZSHQuotaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    self.title = @"黑卡额度";
    NSDictionary *nextParamDic = @{@"headKeyTitle":@"最高额度（元）",@"headValueTitle":@"100,000.00"};
    self.headerView = [[ZSHQuotaHeadView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(kRealValue(90));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    NSDictionary *activeBtnDic = @{@"title":@"激活额度",@"font":kPingFangRegular(17)};
    UIButton *activeBtn = [ZSHBaseUIControl  createBtnWithParamDic:activeBtnDic target:self action:nil];
    [self.view addSubview:activeBtn];
    [activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(kRealValue(40));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(140));
        make.height.mas_equalTo(kRealValue(35));
    }];
    [ZSHSpeedy zsh_chageControlCircularWith:activeBtn AndSetCornerRadius:kRealValue(35)/2 SetBorderWidth:1.0 SetBorderColor:KZSHColor929292 canMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
