//
//  ZSHFlagshipCell.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHFlagshipCell.h"

@interface ZSHFlagshipCell()

@property (nonatomic, strong) UIImageView    *backgroundImageView;
@property (nonatomic, strong) UIImageView    *headImageView;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel        *detailLabel;

@end

@implementation ZSHFlagshipCell

- (void)setup {
    _backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(175);
    }];
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flagship4"]];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(35), kRealValue(35)));
    }];
    
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"劳力士旗舰店", @"font":kPingFangRegular(12)}];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(10);
        make.top.mas_equalTo(_headImageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(13)));
    }];
    
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"共10件宝贝", @"font":kPingFangRegular(11)}];
    [self addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImageView);
        make.left.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(13)));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _backgroundImageView.image = [UIImage imageNamed:dic];
}

@end
