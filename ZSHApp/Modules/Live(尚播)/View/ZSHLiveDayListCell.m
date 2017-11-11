//
//  ZSHLiveDayListCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveDayListCell.h"

@interface ZSHLiveDayListCell ()

@property (nonatomic, strong) UILabel     *rankLable;
@property (nonatomic, strong) UIImageView *championImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nicknameLabel;
@property (nonatomic, strong) UILabel     *valueLabel;


@end

@implementation ZSHLiveDayListCell

- (void)setup {
    
    NSDictionary *rankLableDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(15),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentLeft)};
    _rankLable = [ZSHBaseUIControl createLabelWithParamDic:rankLableDic];
    [self addSubview:_rankLable];
    
    _championImageView = [[UIImageView alloc] init];
    [self addSubview:_championImageView];
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];

    NSDictionary *nicknameLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:nicknameLabelDic];
    [self addSubview:_nicknameLabel];
    
    NSDictionary *valueLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    [self addSubview:_valueLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_rankLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(31.5));
        make.left.mas_equalTo(self).offset(kRealValue(20.5));
        make.width.mas_equalTo(kRealValue(9));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    
    [_championImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(26));
        make.left.mas_equalTo(self).offset(kRealValue(16));
        make.width.mas_equalTo(kRealValue(18));
        make.height.mas_equalTo(kRealValue(23.5));
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(19.5));
        make.left.mas_equalTo(self).offset(kRealValue(49));
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(kRealValue(40));
    }];

    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(24));
        make.left.mas_equalTo(self).offset(kRealValue(99));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(15));
    }];

    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(44));
        make.left.mas_equalTo(self).offset(kRealValue(99));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(12));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    if ([dic[@"index"] isEqual:@(0)]) {
        self.championImageView.image = [UIImage imageNamed:@"list_image_1"];
    } else if ([dic[@"index"] isEqual:@(1)]) {
        self.championImageView.image = [UIImage imageNamed:@"list_image_2"];
    } else if ([dic[@"index"] isEqual:@(2)]) {
        self.championImageView.image = [UIImage imageNamed:@"list_image_3"];
    } else {
        self.championImageView.image = [[UIImage alloc] init];
    }
    self.rankLable.text = [NSString stringWithFormat:@"%ld", [dic[@"index"] integerValue] + 1];
    self.headImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.nicknameLabel.text = dic[@"nickname"];
    self.valueLabel.text = [NSString stringWithFormat:@"贡献值：%@", dic[@"value"]];
    self.paramDic = dic;
    [self layoutIfNeeded];
    
}

@end
