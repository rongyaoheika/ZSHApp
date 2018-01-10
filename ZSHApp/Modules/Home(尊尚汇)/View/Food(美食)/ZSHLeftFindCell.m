//
//  ZSHfindCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLeftFindCell.h"
#import "CWStarRateView.h"
#import "ZSHFoodModel.h"

@interface ZSHLeftFindCell()

@property (nonatomic, strong) UIImageView               *findImageView;
@property (nonatomic, strong) UILabel                   *hotelDescLabel;
@property (nonatomic, strong) UILabel                   *findNameLabel;
@property (nonatomic, strong) UILabel                   *distanceLabel;
@property (nonatomic, strong) UILabel                   *commentLabel;
@property (nonatomic, strong) CWStarRateView            *starView;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHLeftFindCell

- (void)setup{
    //发现图片
    _findImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_findImageView];
    [_findImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.top.mas_equalTo(self).offset(KLeftMargin);
        make.height.mas_equalTo(kRealValue(140));
    }];
    
    //发现title
    NSDictionary *findNameLabelDic = @{@"text":@"中国年饮中国茶，清静雅和福禄康逸",@"font": kPingFangMedium(15)};
    _findNameLabel = [ZSHBaseUIControl createLabelWithParamDic:findNameLabelDic];
    [self.contentView addSubview:_findNameLabel];
    [_findNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_findImageView.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(_findImageView);
        make.height.mas_equalTo(kRealValue(15));
        make.right.mas_equalTo(_findImageView);
    }];
    
    
    //发现价格
    NSDictionary *priceLabelDic = @{@"text":@"¥299",@"font": kPingFangRegular(12)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_findNameLabel.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(_findImageView);
        make.height.mas_equalTo(kRealValue(12));
        make.right.mas_equalTo(_findImageView);
    }];
    
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    _findImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    _findNameLabel.text = dic[@"title"];
    _priceLabel.text = dic[@"price"];
    
}

@end
