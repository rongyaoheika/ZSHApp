//
//  ZSHHotelCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelCell.h"
#import "TggStarEvaluationView.h"
#import "ZSHHotelDetailModel.h"
@interface ZSHHotelCell()

@property (nonatomic, strong) UIImageView               *hotelmageView;
@property (nonatomic, strong) UILabel                   *hotelDescLabel;
@property (nonatomic, strong) UILabel                   *hotelAddressLabel;
@property (nonatomic, strong) UILabel                   *distanceLabel;
@property (nonatomic, strong) UILabel                   *commentLabel;
@property (nonatomic, strong) TggStarEvaluationView     *starView;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHHotelCell

- (void)setup{
    //酒店图片
    UIImage *image = [UIImage imageNamed:@"hotel_image"];
    _hotelmageView = [[UIImageView alloc]initWithImage:image];
    [self.contentView addSubview:_hotelmageView];
    
    //酒店名字详情
    NSDictionary *hotelDescLabelDic = @{@"text":@"如家-北京霍营地铁站店",@"font": kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _hotelDescLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelDescLabelDic];
    _hotelDescLabel.numberOfLines = 0;
    [_hotelDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelDescLabel];
    
    //酒店地址
    NSDictionary *hotelAddressLabelDic = @{@"text":@"昌平区回龙观镇科星西路47号",@"font": kPingFangRegular(11)};
    _hotelAddressLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelAddressLabelDic];
    [self.contentView addSubview:_hotelAddressLabel];
    
    //酒店距离
    NSDictionary *distanceLabelDic = @{@"text":@"23公里",@"font": kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentRight)};
    _distanceLabel = [ZSHBaseUIControl createLabelWithParamDic:distanceLabelDic];
    [self.contentView addSubview:_distanceLabel];
    
    _starView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:nil];
    [self.contentView addSubview:_starView];
    
    //酒店评价
    NSDictionary *commentLabelDic = @{@"text":@"（120条评价）",@"font": kPingFangRegular(11)};
    _commentLabel = [ZSHBaseUIControl createLabelWithParamDic:commentLabelDic];
    [self.contentView addSubview:_commentLabel];
    
    //酒店价格
    NSDictionary *priceLabelDic = @{@"text":@"¥499",@"font": kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(80), kRealValue(80)));
    }];
    
    [_hotelDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelmageView);
        make.left.mas_equalTo(_hotelmageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_hotelAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelDescLabel.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_hotelDescLabel);
        make.height.mas_equalTo(kRealValue(12));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelAddressLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(_hotelAddressLabel);
        make.width.mas_equalTo(kRealValue(50));
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelAddressLabel.mas_bottom).offset(kRealValue(30));
        make.left.mas_equalTo(_hotelDescLabel);
        make.height.mas_equalTo(kRealValue(12));
        make.width.mas_equalTo(kRealValue(80));
    }];
    _starView.starCount = 4.5;
    _starView.spacing = 0.25;
   
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_starView);
        make.left.mas_equalTo(_starView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(_starView);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_commentLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(_commentLabel);
        make.width.mas_equalTo(kRealValue(50));
    }];
}

- (void)updateCellWithModel:(ZSHHotelDetailModel *)model{
    
    _hotelmageView.image = [UIImage imageNamed:model.imageName];
    _hotelDescLabel.text = model.title;
    _hotelAddressLabel.text = model.address;
    _distanceLabel.text = [NSString stringWithFormat:@"%@公里",model.distance];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    _commentLabel.text = [NSString stringWithFormat:@"（%@条评价）",model.comment];
}

- (CGFloat)rowHeightWithCellModel:(ZSHHotelDetailModel *)model{
    [self updateCellWithModel:model];
    [self layoutIfNeeded];
    CGFloat detailLabelY = CGRectGetMaxY(self.starView.frame);
    return detailLabelY + kRealValue(15);
}


@end
