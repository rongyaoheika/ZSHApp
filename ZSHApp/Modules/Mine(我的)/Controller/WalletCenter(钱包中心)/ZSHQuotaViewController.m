//
//  ZSHQuotaViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHQuotaViewController.h"

@interface ZSHQuotaViewController ()

@property (nonatomic, strong) UIView              *headerView;

@end

@implementation ZSHQuotaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    self.title = @"黑卡额度";
    [self.view addSubview:[self createHeadView]];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(kRealValue(90));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    NSDictionary *activeBtnDic = @{@"title":@"激活额度",@"font":kPingFangRegular(17)};
    UIButton *activeBtn = [ZSHBaseUIControl createBtnWithParamDic:activeBtnDic];
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

#pragma getter
- (UIView *)createHeadView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectZero];
    self.headerView.backgroundColor = KClearColor;
    
    NSDictionary *topDic = @{@"text":@"最高额度（元）",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *topLabel = [ZSHBaseUIControl createLabelWithParamDic:topDic];
    [_headerView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView).offset(kRealValue(30));
        make.centerX.mas_equalTo(_headerView);
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(_headerView);
    }];
    
    NSDictionary *bottomDic = @{@"text":@"100,000.00",@"font":kPingFangRegular(32),@"textColor":[UIColor colorWithHexString:@"A0A0A0"],@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomDic];
    bottomLabel.adjustsFontSizeToFitWidth = YES;
    [_headerView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(kRealValue(20));
        make.centerX.mas_equalTo(_headerView);
        make.height.mas_equalTo(kRealValue(25));
        make.width.mas_equalTo(_headerView);
    }];
    return _headerView;
}


@end
