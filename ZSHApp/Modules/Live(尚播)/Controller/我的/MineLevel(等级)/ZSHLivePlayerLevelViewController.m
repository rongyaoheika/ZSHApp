//
//  ZSHLivePlayerLevelViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLivePlayerLevelViewController.h"

@interface ZSHLivePlayerLevelViewController ()

@end

@implementation ZSHLivePlayerLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{

    // 等级背景
    UIImageView *gradeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grade_image_1"]];
    [self.view addSubview:gradeImageView];
    [gradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(130));
        make.height.mas_equalTo(kRealValue(89.5));
    }];
    
    // 头像
    UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weibo_head_image"]];
    headImageView.layer.cornerRadius = kRealValue(50)/2;
    headImageView.clipsToBounds = YES;
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(30));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(60), kRealValue(60)));
    }];
    
    // 当前等级
    NSDictionary *levelLabelDic = @{@"text":@"LV.1",@"font": kPingFangSemibold(15),@"textAlignment":@(NSTextAlignmentCenter),@"textColor":KWhiteColor};
    UILabel *levelLabel = [ZSHBaseUIControl createLabelWithParamDic:levelLabelDic];
    [self.view addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(gradeImageView).offset(kRealValue(72.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(31), kRealValue(16)));
    }];
    
    // 下一个等级提示
    NSDictionary *nextLevelLabelDic = @{@"text":@"距离LV.2还差30经验",@"font": kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter),@"textColor":KZSHColor929292};
    UILabel *nextLevelLabel = [ZSHBaseUIControl createLabelWithParamDic:nextLevelLabelDic];
    [self.view addSubview:nextLevelLabel];
    [nextLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(gradeImageView).offset(kRealValue(109.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(143), kRealValue(16)));
    }];
    
    // 经验条
    UIProgressView *expProgressView = [[UIProgressView alloc] init];
    [expProgressView setTrackImage:[UIImage imageNamed:@"grade_image_2"]];
    expProgressView.progressTintColor = KZSHColorF29E19;
    for (UIImageView * imageview in expProgressView.subviews) {
        imageview.layer.cornerRadius = 4.0;
        imageview.clipsToBounds = YES;
    }
    [self.view addSubview:expProgressView];
    [expProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kRealValue(169.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(275), kRealValue(8)));
    }];
    expProgressView.progress = 0.9;
    
    // 快速升级提示
    NSDictionary *quickUpgradeLabelDic = @{@"text":@"如何快速升级",@"font": kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentLeft),@"textColor":KZSHColor929292};
    UILabel *quickUpgradeLabel = [ZSHBaseUIControl createLabelWithParamDic:quickUpgradeLabelDic];
    [self.view addSubview:quickUpgradeLabel];
    [quickUpgradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(expProgressView).offset(kRealValue(29));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(16));
    }];
    
    // 升级规则
    UIImageView *upgradeRuleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grade_image_4"]];
    [self.view addSubview:upgradeRuleImageView];
    [upgradeRuleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(quickUpgradeLabel).offset(kRealValue(33));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(270)));
    }];
}

- (void)initViewModel {
    
}

@end
