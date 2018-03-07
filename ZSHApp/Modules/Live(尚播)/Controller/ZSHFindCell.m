//
//  ZSHFindCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFindCell.h"
#import "ZSHFindModel.h"

@interface ZSHFindCell ()

@end

@implementation ZSHFindCell



- (void)setup {
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"乘客姓名",@"font":kPingFangMedium(14)}];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-kRealValue(30), kRealValue(15)));
    }];
    
    _picView = [[UIImageView alloc] init];
    [self addSubview:_picView];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(34));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(130)));
    }];
    

    _playBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"text":@"",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentLeft),@"normalImage":@"play_find_1"} target:self action:nil];
    [self addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(_picView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    _pageviewLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"2.2万人浏览",@"font":kPingFangMedium(11)}];
    [self addSubview:_pageviewLabel];
    [_pageviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(174));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-kRealValue(30), kRealValue(12)));
    }];

}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _titleLabel.text = dic[@"title"];
    _picView.image = [UIImage imageNamed:dic[@"image"]];
}

- (void)updateCellWithModel:(ZSHFindModel *)model {
    _titleLabel.text = model.TITLE;
    [_picView sd_setImageWithURL:[NSURL URLWithString:model.VIDEOBACKIMAGE.firstObject]];
    _pageviewLabel.text = NSStringFormat(@"%@人浏览", model.PAGEVIEWS);
    
}

@end
