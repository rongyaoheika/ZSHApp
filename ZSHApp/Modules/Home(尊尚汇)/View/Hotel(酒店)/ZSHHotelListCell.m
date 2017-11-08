//
//  ZSHHotelListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelListCell.h"

@interface ZSHHotelListCell()

@property (nonatomic, strong) UIImageView               *hotelmageView;
@property (nonatomic, strong) UILabel                   *hotelNameLabel;
@property (nonatomic, strong) UILabel                   *hotelBottomLabel;
@property (nonatomic, strong) UILabel                   *hotelAddressLabel;
@property (nonatomic, strong) UIButton                  *bookeBtn;
@property (nonatomic, strong) UILabel                   *discountLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHHotelListCell

- (void)setup{
    
    //酒店图片
    UIImage *image = [UIImage imageNamed:@"hotel_image"];
    _hotelmageView = [[UIImageView alloc]initWithImage:image];
    [self.contentView addSubview:_hotelmageView];
    
    //酒店名字
    NSDictionary *hotelNameLabelDic = @{@"text":@"豪华贵宾房",@"font": kPingFangMedium(15)};
    _hotelNameLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelNameLabelDic];
    _hotelNameLabel.numberOfLines = 0;
    [_hotelNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelNameLabel];
    
    //酒店底部（距离，型号，大小）
    NSDictionary *hotelBottomLabelDic = @{@"text":@"60㎡   大床  1.8m",@"font": kPingFangRegular(11)};
    _hotelBottomLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelBottomLabelDic];
    _hotelBottomLabel.numberOfLines = 0;
    [_hotelBottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelBottomLabel];
    
    //酒店优惠
    NSDictionary *discountLabelDic = @{@"text":@"会员减99",@"font": kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentRight)};
    _discountLabel = [ZSHBaseUIControl createLabelWithParamDic:discountLabelDic];
    [self.contentView addSubview:_discountLabel];
    
    //酒店价格
    NSDictionary *priceLabelDic = @{@"text":@"¥999",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
    //订按扭
    _bookeBtn = [[UIButton alloc]init];
    [_bookeBtn setBackgroundImage:[UIImage imageNamed:@"hotel_book"] forState:UIControlStateNormal];
    [self.contentView addSubview:_bookeBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.size.mas_equalTo(CGSizeMake(kRealValue(55), kRealValue(55)));
    }];
    
    [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hotelmageView.mas_right).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-kRealValue(100));
        make.top.mas_equalTo(_hotelmageView).offset(kRealValue(5));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_hotelBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelNameLabel.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_hotelNameLabel);
        make.right.mas_equalTo(_hotelNameLabel);
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelNameLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(17));
        make.width.mas_equalTo(kRealValue(50));
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(kRealValue(10));
        make.width.mas_equalTo(kRealValue(55));
        make.right.mas_equalTo(_priceLabel);
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    [_bookeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_discountLabel);
        make.right.mas_equalTo(_discountLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(kRealValue(10), kRealValue(10)));
    }];
}

@end
