//
//  ZSHVideoDetailCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHVideoDetailCell.h"


@interface ZSHVideoDetailCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nicknameLabel;
@property (nonatomic, strong) UILabel     *valueLabel;
@property (nonatomic, strong) UILabel     *dateLabel;

@end

@implementation ZSHVideoDetailCell

- (void)setup {
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    
    NSDictionary *nicknameLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:nicknameLabelDic];
    [self addSubview:_nicknameLabel];
    
    NSDictionary *valueLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    [self addSubview:_valueLabel];
    
    
    _dateLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)}];
    [self addSubview:_dateLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(9.5));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14));
        make.left.mas_equalTo(self).offset(kRealValue(65));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(34));
        make.left.mas_equalTo(self).offset(kRealValue(65));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(15.5));
        make.trailing.mas_equalTo(self).offset(kRealValue(-KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(12)));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
//NSDictionary *nextParamDic = @{@"imageName":self.dataArr[i][@"imageName"],@"nickname":self.dataArr[i][@"nickname"],@"content":self.dataArr[i][@"content"],@"date":self.dataArr[i][@"date"]};
    self.headImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.nicknameLabel.text = dic[@"nickname"];
    self.valueLabel.text = dic[@"content"];
    _dateLabel.text = dic[@"date"];
    self.paramDic = dic;
    [self layoutIfNeeded];
    
}


@end
