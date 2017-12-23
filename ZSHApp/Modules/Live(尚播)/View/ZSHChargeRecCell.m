//
//  ZSHChargeRecCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHChargeRecCell.h"

@interface ZSHChargeRecCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nicknameLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UILabel     *valueLabel;

@end

@implementation ZSHChargeRecCell

- (void)setup {
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    
    NSDictionary *nicknameLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:nicknameLabelDic];
    [self addSubview:_nicknameLabel];
    
    
    NSDictionary *dateLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self addSubview:_dateLabel];
    
    NSDictionary *valueLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    _valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    [self addSubview:_valueLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(13.5));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.width.mas_equalTo(kRealValue(32));
        make.height.mas_equalTo(kRealValue(32));
    }];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14.5));
        make.left.mas_equalTo(self).offset(kRealValue(57));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(34));
        make.left.mas_equalTo(self).offset(kRealValue(57));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(18.5));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(22));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    self.headImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.nicknameLabel.text = dic[@"nickname"];
    self.dateLabel.text = dic[@"date"];
    self.valueLabel.text = dic[@"value"];
    self.paramDic = dic;
    [self layoutIfNeeded];
    
}

@end
