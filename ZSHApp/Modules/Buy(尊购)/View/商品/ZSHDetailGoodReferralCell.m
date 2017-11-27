//
//  ZSHDetailGoodReferralCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHDetailGoodReferralCell.h"

@interface ZSHDetailGoodReferralCell ()

/* 新品 */
@property (nonatomic, strong)UIButton  *typeBtn;

@end

@implementation ZSHDetailGoodReferralCell

#pragma mark - UI
- (void)setup
{
    NSDictionary *goodTitleLabelDic = @{@"text":@"Gucci/古奇/古驰女士手拿包蓝色大LOGO",@"font":kPingFangMedium(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _goodTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:goodTitleLabelDic];
    _goodTitleLabel.numberOfLines = 0;
    [self addSubview:_goodTitleLabel];
    
    NSDictionary *goodPriceLabelDic = @{@"text":@"¥3999",@"font":kPingFangMedium(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    _goodPriceLabel = [ZSHBaseUIControl createLabelWithParamDic:goodPriceLabelDic];
    [self addSubview:_goodPriceLabel];
    
    NSDictionary *goodSubtitleLabelDic = @{@"text":@"Herschel Supply Co",@"font":kPingFangRegular(12),@"textColor":KZSHColorB2B2B2,@"textAlignment":@(NSTextAlignmentLeft)};
    _goodSubtitleLabel = [ZSHBaseUIControl createLabelWithParamDic:goodSubtitleLabelDic];
    _goodSubtitleLabel.numberOfLines = 0;
    [self addSubview:_goodSubtitleLabel];
    
    NSDictionary *btnDic = @{@"title":@"新品",@"titleColor":KWhiteColor,@"font":kPingFangRegular(10),@"backgroundColor":[UIColor colorWithHexString:@"68BF7B"]};
    _typeBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
    _typeBtn.layer.cornerRadius = kRealValue(5.0);
    [self addSubview:_typeBtn];
    
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(kScreenWidth*0.7);
    }];
    
    [_goodSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodTitleLabel);
        make.width.mas_equalTo(_goodTitleLabel);
        make.top.mas_equalTo(_goodTitleLabel.mas_bottom).offset(kRealValue((10)));
    }];
    
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(_goodTitleLabel);
        make.height.mas_equalTo(kRealValue(12));
        make.width.mas_equalTo(kRealValue(50));
    }];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_goodPriceLabel);
        make.top.mas_equalTo(_goodSubtitleLabel).offset(6);
        make.height.mas_equalTo(_goodPriceLabel);
        make.width.mas_equalTo(kRealValue(25));
    }];
}

@end
