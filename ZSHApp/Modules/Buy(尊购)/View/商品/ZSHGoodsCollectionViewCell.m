//
//  ZSHGoodsCollectionViewCell.m
//  ZSHApp
//
//  Created by mac on 26/12/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZSHGoodsCollectionViewCell.h"

@interface ZSHGoodsCollectionViewCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *headLabel;
@property (nonatomic, strong) UILabel     *numLabe;
@property (nonatomic, strong) UIView      *detailView;
@end

@implementation ZSHGoodsCollectionViewCell

- (void)setup {
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_image_2"]];
    [self.contentView addSubview:_headImageView];
    
    _headLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"天珠传奇-藏传美学圣饰品牌", @"font":kPingFangRegular(12)}];
    [self.contentView addSubview:_headLabel];
    
    _numLabe = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"共10件宝贝",@"font":kPingFangRegular(11)}];
    [self.contentView addSubview:_numLabe];
    
    _detailView = [[UIView alloc] init];
    [self.contentView addSubview:_detailView];
    
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(KLeftMargin);
        make.width.mas_equalTo(kRealValue(35));
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView);
        make.left.mas_equalTo(_headImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self.contentView).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(13));
    }];
    
    
    [_numLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImageView);
        make.left.mas_equalTo(_headLabel);
        make.height.mas_equalTo(kRealValue(13));
        make.right.mas_equalTo(_headLabel);
    }];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(self.headImageView);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(55));
    }];
    
    
    for (int i = 0; i<4; i++) {
        UIImageView *detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(82.5), kRealValue(82.5))];
        [detailImageView setImage:[UIImage imageNamed:@"video_image_2"]];
        [_detailView addSubview:detailImageView];
        [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailView);
            make.left.mas_equalTo(self.headImageView).offset((kRealValue(55)+kRealValue(10)) *i);
            make.width.and.height.mas_equalTo(kRealValue(55));
        }];
    }
    
}




@end
