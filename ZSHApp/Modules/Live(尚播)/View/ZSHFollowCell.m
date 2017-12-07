//
//  ZSHFollowCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFollowCell.h"
#import "ZSHFriendListModel.h"

@interface ZSHFollowCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nicknameLabel;
@property (nonatomic, strong) UILabel     *valueLabel;


@end

@implementation ZSHFollowCell

- (void)setup {
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.layer.cornerRadius = 20.0;
    _headImageView.layer.masksToBounds = true;
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
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    self.headImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.nicknameLabel.text = dic[@"nickname"];
    self.valueLabel.text = [NSString stringWithFormat:@"粉丝数：%@", dic[@"value"]];
    self.paramDic = dic;
    [self layoutIfNeeded];
    
}


- (void)updateCellWithModel:(ZSHFriendListModel *)model {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    _nicknameLabel.text = model.NICKNAME;
    _valueLabel.text = [NSString stringWithFormat:@"粉丝数：%@", model.FANSCOUNT];
    [self layoutIfNeeded];
}

@end
