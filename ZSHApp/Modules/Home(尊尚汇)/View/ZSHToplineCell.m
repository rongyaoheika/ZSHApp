//
//  ZSHToplineCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHToplineCell.h"


@interface ZSHToplineCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation ZSHToplineCell

- (void)setup {
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"21cake蛋糕预订",@"font": kPingFangMedium(15)}];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(300), kRealValue(16)));
    }];

    _subtitleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"使用马达加斯加香草荚制作戚风香草坯",@"font": kPingFangMedium(15)}];
    [self addSubview:_subtitleLabel];
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(40));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(21)));
    }];
    
    
    _contentImageView = [[UIImageView alloc] init];
    [self addSubview:_contentImageView];
    [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(70));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(200)));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    
    _titleLabel.text = dic[@"title"];
    _subtitleLabel.text = dic[@"subtitle"];
    _contentImageView.image = [UIImage imageNamed:dic[@"image"]];
    
    [self setNeedsLayout];
}

@end
