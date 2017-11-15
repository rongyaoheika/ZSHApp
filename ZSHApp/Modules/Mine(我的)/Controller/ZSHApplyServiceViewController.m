//
//  ZSHApplyServiceViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHApplyServiceViewController.h"
#import "UILabel+Spacing.h"
#import "XXTextView.h"

@interface ZSHApplyServiceViewController ()

@end

@implementation ZSHApplyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"申请售后";
    
    CGFloat topSpacing = 0;
    switch ([self.paramDic[KFromClassType]integerValue]) {
        case ZSHFromGoodsMineVCToApplyServiceVC:{
            topSpacing = 82;
        }
            break;
        default:{
            topSpacing = 18;
        }
            break;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_watch"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(topSpacing));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(37), kRealValue(64)));
    }];
    
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    nameLabel.numberOfLines = 0;
    [nameLabel setRowSpace:5.0];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(topSpacing));
        make.left.mas_equalTo(self.view).offset(kRealValue(72));
        make.size.mas_equalTo(CGSizeMake(kRealValue(214), kRealValue(36)));
    }];
    
    UILabel *priceLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"¥49200",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    priceLabel.numberOfLines = 0;
    [self.view addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel).offset(kRealValue(46));
        make.left.mas_equalTo(self.view).offset(kRealValue(72));
        make.size.mas_equalTo(CGSizeMake(kRealValue(214), kRealValue(12)));
    }];
    
    UILabel *serviceTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"服务类型",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:serviceTypeLabel];
    [serviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(kRealValue(28));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(57.5), kRealValue(15)));
    }];
    
    UIButton *repairBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"维修",@"font":kPingFangRegular(12)}];
    repairBtn.layer.borderWidth = 0.5;
    repairBtn.layer.borderColor = KZSHColor929292.CGColor;
    [self.view addSubview:repairBtn];
    [repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceTypeLabel).offset(kRealValue(18));
        make.left.mas_equalTo(serviceTypeLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(80), kRealValue(30)));
    }];

    UIButton *replaceBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"维修",@"font":kPingFangRegular(12)}];
    replaceBtn.layer.borderWidth = 0.5;
    replaceBtn.layer.borderColor = KZSHColor929292.CGColor;
    [self.view addSubview:replaceBtn];
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repairBtn);
        make.left.mas_equalTo(repairBtn).offset(kRealValue(90));
        make.size.mas_equalTo(CGSizeMake(kRealValue(80), kRealValue(30)));
    }];
    
    
    UILabel *problemDESCLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"问题描述",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:problemDESCLabel];
    [problemDESCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repairBtn).offset(kRealValue(58));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(57.5), kRealValue(15)));
    }];

    XXTextView *contentTextView = [[XXTextView alloc] init];
    contentTextView.backgroundColor = KClearColor;
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:12];
    contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    contentTextView.xx_placeholder = @"请您在此描述问题";
    contentTextView.xx_placeholderFont = [UIFont systemFontOfSize:12];
    contentTextView.xx_placeholderColor = KZSHColor454545;
    [self.view addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(problemDESCLabel).offset(kRealValue(20));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-30, kRealValue(50)));
    }];
    
    UILabel *logisticsLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"物流单号",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:logisticsLabel];
    [logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(problemDESCLabel).offset(kRealValue(90));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(57.5), kRealValue(15)));
    }];
    
    UILabel *logisticsNumLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"621699049821",@"font":kPingFangRegular(12),@"textColor":KZSHColor454545,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:logisticsNumLabel];
    [logisticsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logisticsLabel).offset(kRealValue(30));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(86.5), kRealValue(12)));
    }];
    
    UILabel *logisticsCompanyLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"物流公司",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:logisticsCompanyLabel];
    [logisticsCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logisticsLabel).offset(kRealValue(60));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(57.5), kRealValue(15)));
    }];
    
    UILabel *logisticsCompanyNameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@" 申通快递",@"font":kPingFangRegular(12),@"textColor":KZSHColor454545,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:logisticsCompanyNameLabel];
    [logisticsCompanyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logisticsCompanyLabel).offset(kRealValue(30));
        make.left.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(86.5), kRealValue(12)));
    }];
    

    UIButton *netxBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"mine_next"}];
    [self.view addSubview:netxBtn];
    [netxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logisticsCompanyLabel).offset(kRealValue(28));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(9), kRealValue(14)));
    }];
    
    ;
    UIButton *stewardBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"申请售后",@"titleColor":KZSHColor929292,@"font":kPingFangMedium(17),@"backgroundColor":KBlackColor}];
    [self.view addSubview:stewardBtn];
    [stewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(KScreenWidth));
        make.height.mas_equalTo(KBottomNavH);
    }];

    self.view.backgroundColor = [UIColor redColor];
}

- (void)initViewModel {
    
}

@end
