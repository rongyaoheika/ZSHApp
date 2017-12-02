//
//  ZSHHotelPayHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelPayHeadCell.h"
#import "ZSHKTVModel.h"

@interface ZSHHotelPayHeadCell()

@property (nonatomic, strong) UIImageView               *hotelmageView;
@property (nonatomic, strong) UILabel                   *hotelNameLabel;
@property (nonatomic, strong) UILabel                   *hotelTypeLabel;
@property (nonatomic, strong) UILabel                   *sizeInfoLabel;
@property (nonatomic, strong) UILabel                   *hotelLiveInfoLabel;
@property (nonatomic, strong) UILabel                   *discountLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHHotelPayHeadCell

- (void)setup{
    
    //酒店图片
    UIImage *image = [UIImage imageNamed:@"hotel_image"];
    _hotelmageView = [[UIImageView alloc]initWithImage:image];
    [self.contentView addSubview:_hotelmageView];
    
    //酒店名字
    NSDictionary *hotelNameLabelDic = @{@"text":@"三亚大中华希尔顿酒店",@"font": kPingFangMedium(17)};
    _hotelNameLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelNameLabelDic];
    _hotelNameLabel.numberOfLines = 0;
    [_hotelNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelNameLabel];
    
    //酒店型号名字
    NSDictionary *hotelTypeLabelDic = @{@"text":@"豪华贵宾房",@"font": kPingFangRegular(11)};
    _hotelTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelTypeLabelDic];
    [self.contentView addSubview:_hotelTypeLabel];
    
    //酒店底部（距离，型号，大小）
    NSDictionary *liveInfoLabelDic = @{@"text":@"60㎡   大床  1.8m",@"font": kPingFangRegular(11)};
    _sizeInfoLabel = [ZSHBaseUIControl createLabelWithParamDic:liveInfoLabelDic];
    _sizeInfoLabel.numberOfLines = 0;
    [_sizeInfoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_sizeInfoLabel];
    
    //酒店底部（入住信息）
    NSDictionary *hotelLiveInfoLabelDic = @{@"text":@"6月8日入住，6月9日离开，1天",@"font": kPingFangRegular(11)};
    _hotelLiveInfoLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelLiveInfoLabelDic];
    _hotelLiveInfoLabel.numberOfLines = 0;
    [_hotelLiveInfoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelLiveInfoLabel];
    
    //酒店价格
    NSDictionary *priceLabelDic = @{@"text":@"¥999",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.fromClassType == ZSHFromHotelDetailVCToHotelPayVC || self.fromClassType == ZSHFromKTVDetailVCToHotelPayVC){//订单支付(酒店，KTV)
        [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.top.mas_equalTo(self).offset(kRealValue(20));
            make.size.mas_equalTo(CGSizeMake(kRealValue(90), kRealValue(110)));
        }];
        
        [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelmageView.mas_right).offset(KLeftMargin);
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.top.mas_equalTo(_hotelmageView).offset(kRealValue(15));
            make.height.mas_equalTo(kRealValue(18));
        }];
        
        [_hotelTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.top.mas_equalTo(_hotelNameLabel.mas_bottom).offset(kRealValue(18));
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_hotelLiveInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelTypeLabel.mas_bottom).offset(kRealValue(18));
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
    } else if (self.fromClassType == ZSHFromHotelDetailBottomVCToHotelPayVC) {//底部弹窗
        [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.top.mas_equalTo(self).offset(kRealValue(10));
            make.size.mas_equalTo(CGSizeMake(kRealValue(55), kRealValue(55)));
        }];
        
        _hotelNameLabel.text = @"豪华贵宾房";
        [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelmageView.mas_right).offset(kRealValue(10));
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.top.mas_equalTo(_hotelmageView);
            make.height.mas_equalTo(kRealValue(15));
        }];
        
        [_hotelLiveInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelNameLabel.mas_bottom).offset(kRealValue(7));
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_sizeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelLiveInfoLabel.mas_bottom).offset(kRealValue(7));
            make.left.and.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.height.mas_equalTo(kRealValue(17));
            make.width.mas_equalTo(kRealValue(50));
        }];
    }
}

- (void)setFromClassType:(ZSHFromVCToHotelPayVC)fromClassType{
    _fromClassType = fromClassType;
    [self layoutIfNeeded];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
     if (self.fromClassType == ZSHFromHotelDetailBottomVCToHotelPayVC) {//订单支付
         [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:dic[@"HOTELDETIMGS"]]];
         _hotelNameLabel.text = dic[@"HOTELDETNAME"];
         _hotelLiveInfoLabel.text = _liveInfo;
         _sizeInfoLabel.text = [NSString stringWithFormat:@"%@㎡   %@",dic[@"HOTELDETROOMSIZE"],dic[@"HOTELDETBEDTYPE"] ];
         _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[dic[@"HOTELDETPRICE"]floatValue] ];
     }
    
}


- (void)updateCellWithModel:(ZSHBaseModel *)model{
    if (self.fromClassType == ZSHFromKTVDetailVCToHotelPayVC) {
        ZSHKTVModel  *KTVModel = (ZSHKTVModel *)model;
        _hotelNameLabel.text = KTVModel.KTVName;
        _hotelTypeLabel.text = KTVModel.roomType;
        _hotelLiveInfoLabel.text = KTVModel.time;
    }
}
@end
