//
//  ZSHAboutUsViewController.m
//  ZSHApp
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHAboutUsViewController.h"

@interface ZSHAboutUsViewController ()

@property (nonatomic,strong) UIImageView *midImageView;
@property (nonatomic,strong) UILabel     *promptLabel;
@property (nonatomic,strong) UILabel     *companyLB;
@property (nonatomic,strong) UILabel     *timeLB;

@end

@implementation ZSHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    self.title = @"关于我们";
    [self.view addSubview:self.midImageView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.companyLB];
    [self.view addSubview:self.timeLB];
    [self updateViewConstraints];
}


#pragma getter
- (UIImageView *)midImageView{
    if (!_midImageView) {
        _midImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon"]];
    }
    return _midImageView;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        NSDictionary *promptLabelDic = @{@"text":@"荣耀黑卡 v1.0.0",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
        _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    }
    return _promptLabel;
}

- (UILabel *)companyLB{
    if (!_companyLB) {
        NSDictionary *companyLBDic = @{@"text":@"海南尊尚汇网络科技有限公司",@"font":kPingFangMedium(12),@"textAlignment":@(NSTextAlignmentCenter)};
        _companyLB = [ZSHBaseUIControl createLabelWithParamDic:companyLBDic];
    }
    return _companyLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        NSDictionary *companyLBDic = @{@"text":@"Copyright ©2017-2018",@"font":kPingFangMedium(12),@"textAlignment":@(NSTextAlignmentCenter)};
        _timeLB = [ZSHBaseUIControl createLabelWithParamDic:companyLBDic];
    }
    return _timeLB;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    kWeakSelf(self);
    [self.midImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.view).offset(KNavigationBarHeight + kRealValue(80));
        make.width.mas_equalTo(kRealValue(90));
        make.height.mas_equalTo(kRealValue(90));
        make.centerX.mas_equalTo(weakself.view);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.midImageView.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(weakself.view);
        make.centerX.mas_equalTo(weakself.view);
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [self.companyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakself.view).offset(-KBottomNavH);
        make.width.mas_equalTo(weakself.view);
        make.centerX.mas_equalTo(weakself.view);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakself.companyLB.mas_top);
        make.width.mas_equalTo(weakself.view);
        make.centerX.mas_equalTo(weakself.view);
        make.height.mas_equalTo(kRealValue(15));
    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
