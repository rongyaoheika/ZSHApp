//
//  ZSHIntegralExchangeCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHIntegralExchangeCell.h"

@interface ZSHIntegralExchangeCell()

@property (nonatomic, strong) UILabel    *typeNameLabel;
@property (nonatomic, strong) UIButton   *exchangeBtn;

@end

@implementation ZSHIntegralExchangeCell

- (void)setup{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exchange coupon_bg"]];
    [self insertSubview:bgImageView atIndex:0];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(17.5);
        make.right.mas_equalTo(self).offset(-17.5);
        make.height.mas_equalTo(kRealValue(117));
        make.centerY.mas_equalTo(self);
    }];
    
    NSDictionary *typeNameLabelDic = @{@"text":@"20元代金券",@"font":kPingFangMedium(24),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *typeNameLabel = [ZSHBaseUIControl createLabelWithParamDic:typeNameLabelDic];
    [self addSubview:typeNameLabel];
    [typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgImageView);
        make.width.mas_equalTo(kRealValue(250));
        make.height.mas_equalTo(kRealValue(40));
        make.centerY.mas_equalTo(self);
    }];
    self.typeNameLabel = typeNameLabel;
    
    NSDictionary *exchangeLabelDic = @{@"title":@"兑换",@"titleColor":KZSHColor929292,@"font":kPingFangMedium(24),@"backgroundColor":KClearColor};
    UIButton *exchangeBtn = [ZSHBaseUIControl createBtnWithParamDic:exchangeLabelDic];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exchangeBtn];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgImageView);
        make.width.mas_equalTo(kRealValue(95));
        make.height.mas_equalTo(kRealValue(40));
        make.centerY.mas_equalTo(self);
    }];
    self.exchangeBtn = exchangeBtn;
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    if ([dic[@"fromClassType"]integerValue]== FromCouponVCToIntegralExchangeCell) {
        self.typeNameLabel.text = @"满999即可使用";
        [self.exchangeBtn setTitle:@"¥99" forState:UIControlStateNormal];
        self.exchangeBtn.titleLabel.font = kPingFangMedium(40);
    }
}

- (void)exchangeBtnAction:(UIButton *)exchangeBtn{
    if (self.exchangeBlock) {
        self.exchangeBlock();
    }
}

@end
