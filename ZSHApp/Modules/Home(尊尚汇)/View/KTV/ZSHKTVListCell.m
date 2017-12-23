//
//  ZSHKTVListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHKTVListCell.h"

@interface ZSHKTVListCell()

@property (nonatomic, strong) UILabel                   *promptLabel;
@property (nonatomic, strong) UIButton                  *bookeBtn;
@property (nonatomic, strong) UILabel                   *discountLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHKTVListCell

- (void)setup{
    
    //KTV提示时间
    NSDictionary *promptLabelDic = @{@"text":@"09:00-18:00内任选3小时",@"font": kPingFangRegular(12)};
    _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    _promptLabel.numberOfLines = 0;
    [_promptLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_promptLabel];
    
    //KTV优惠
    NSDictionary *discountLabelDic = @{@"text":@"会员减99",@"font": kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentRight)};
    _discountLabel = [ZSHBaseUIControl createLabelWithParamDic:discountLabelDic];
    [self.contentView addSubview:_discountLabel];
    
    //酒店价格
    NSDictionary *priceLabelDic = @{@"text":@"¥399",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentLeft)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
    //订按扭
    _bookeBtn = [[UIButton alloc]init];
    [_bookeBtn setBackgroundImage:[UIImage imageNamed:@"hotel_book"] forState:UIControlStateNormal];
    [self.contentView addSubview:_bookeBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-kRealValue(100));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(17));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_promptLabel.mas_bottom).offset(kRealValue(7.5));
        make.left.mas_equalTo(_promptLabel);
        make.height.mas_equalTo(kRealValue(17));
        make.width.mas_equalTo(kRealValue(50));
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(55));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    [_bookeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_discountLabel);
        make.right.mas_equalTo(_discountLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(kRealValue(10), kRealValue(10)));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    _promptLabel.text = dic[@"KTVDETTITLE"];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[dic[@"KTVDETTITLE"]floatValue]];
}

@end
