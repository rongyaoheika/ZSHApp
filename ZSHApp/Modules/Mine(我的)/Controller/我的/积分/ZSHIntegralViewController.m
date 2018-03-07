//
//  ZSHIntegralViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHIntegralViewController.h"
#import "ZSHIntegralLuckViewController.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHExchangeViewController.h"

@interface ZSHIntegralViewController ()

@end

@implementation ZSHIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    self.title = @"积分";
    
    UIImageView *ringImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"integral_circle"]];
    ringImage.clipsToBounds = YES;
    [self.view addSubview:ringImage];
    [ringImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+kRealValue(25));
        make.height.and.width.mas_equalTo(kRealValue(155));
    }];
    
    NSDictionary *valueLabelDic = @{@"text":@"256",@"font":kPingFangMedium(50),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    valueLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ringImage);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(50));
        make.width.mas_equalTo(kRealValue(150));
    }];
    
    NSArray *titleArr = @[@"积分账单",@"积分抽奖",@"积分兑换"];
    NSArray *imageArr = @[@"integral_bill",@"integral_luck",@"integral_exchange"];
    for (int i = 0; i<3; i++) {
        NSDictionary *btnDic = @{@"title":titleArr[i],@"font":kPingFangRegular(14),@"normalImage":imageArr[i]};
        UIButton *btn = [ZSHBaseUIControl  createBtnWithParamDic:btnDic target:self action:@selector(btnAction:)];        
        btn.tag = i;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*KScreenWidth/3);
            make.top.mas_equalTo(ringImage.mas_bottom).offset(kRealValue(30));
            make.width.mas_equalTo(kRealValue(KScreenWidth/3));
            make.height.mas_equalTo(kRealValue(55));
        }];
        
       [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:8];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getter
- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 0) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromIntegralVCToTitleContentVC),@"title":@"积分账单"};
        ZSHTitleContentViewController *integralBillVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
        [self.navigationController pushViewController:integralBillVC animated:YES];
    } else if (btn.tag == 1) {
        ZSHIntegralLuckViewController  *luckVC = [[ZSHIntegralLuckViewController alloc]init];
        [self.navigationController pushViewController:luckVC animated:YES];
    } else if (btn.tag == 2) {
        ZSHExchangeViewController  *exchangeVC = [[ZSHExchangeViewController alloc]init];
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }
}

@end
