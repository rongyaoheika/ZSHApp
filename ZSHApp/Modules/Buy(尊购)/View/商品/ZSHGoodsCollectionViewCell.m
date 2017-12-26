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
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    
    _headLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(12)}];
    [self.contentView addSubview:_headLabel];
    
    _numLabe = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(11)}];
    [self.contentView addSubview:_numLabe];
    
    _detailView = [[UIView alloc] init];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.headImageView).offset(KLeftMargin);
        make.width.mas_equalTo(kRealValue(35));
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView);
        make.left.mas_equalTo(_headImageView).offset(kRealValue(10));
        make.right.mas_equalTo(self.contentView).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(13));
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(self.headImageView);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(82.5));
    }];
}

@end
