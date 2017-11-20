//
//  ZSHFindArticleCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFindArticleCell.h"

@interface ZSHFindArticleCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *pageviewLabel;


@end

@implementation ZSHFindArticleCell

- (void)setup {
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"乘客姓名",@"font":kPingFangMedium(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    _titleLabel.numberOfLines = 0;
    _titleLabel.contentMode = UIViewContentModeTop;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(220), kRealValue(44)));
    }];
    
    _picView = [[UIImageView alloc] init];
    _picView.image = [UIImage imageNamed:@"play_find_2"];
    [self addSubview:_picView];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(7.5));
        make.trailing.mas_equalTo(self).offset(kRealValue(-KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(115), kRealValue(90)));
    }];
    
    _pageviewLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"2.2万人浏览",@"font":kPingFangMedium(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:_pageviewLabel];
    [_pageviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_picView);
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-kRealValue(70), kRealValue(16)));
    }];
    
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _titleLabel.text = dic[@"title"];
    _picView.image = [UIImage imageNamed:dic[@"image"]];
    [self layoutIfNeeded];
}


@end
