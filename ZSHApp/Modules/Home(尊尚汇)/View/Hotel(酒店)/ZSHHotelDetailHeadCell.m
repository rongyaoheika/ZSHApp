//
//  ZSHHotelDetailHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelDetailHeadCell.h"
#import "ZSHFoodModel.h"
#import "ZSHHotelDetailModel.h"
#import "ZSHKTVModel.h"

@interface ZSHHotelDetailHeadCell ()

@property (nonatomic, strong)  UIImageView           *hotelImageView;
@property (nonatomic, strong)  UILabel               *detailLabel;
@property (nonatomic, strong)  UIView                *lineView;
@end
@implementation ZSHHotelDetailHeadCell

- (void)setup{
    
    _hotelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_detail_big"]];
    [self.contentView insertSubview:_hotelImageView atIndex:0];
    
     NSDictionary *detailLabelDic = @{@"text":@"三亚大中华希尔顿酒店",@"font":kPingFangMedium(18),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    [self.contentView addSubview:_detailLabel];
    
    _lineView = [[UIView alloc]init];
    [self.contentView addSubview:_lineView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(KScreenWidth*0.6);
        make.bottom.mas_equalTo(self).offset(-kRealValue(13.5));
        make.height.mas_equalTo(kRealValue(18));
    }];
    
    _lineView.frame = CGRectMake(KScreenWidth - kRealValue(7) - kRealValue(71), CGRectGetHeight(self.frame) - kRealValue(14), kRealValue(71), 1);
     [ZSHBaseUIControl drawLineOfDashByCAShapeLayer:_lineView lineLength:kRealValue(10.5) lineSpacing:kRealValue(9.5) lineColor:KZSHColor979797 lineDirection:YES];
}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {
        ZSHHotelDetailModel *hotelModel = (ZSHHotelDetailModel *)model;
        _hotelImageView.image = [UIImage imageNamed:hotelModel.detailImageName];
        _detailLabel.text = hotelModel.hotelName;
    } else if (self.fromClassType == ZSHFromFoodVCToHotelDetailVC) {
        ZSHFoodModel *foodModel = (ZSHFoodModel *)model;
        _hotelImageView.image = [UIImage imageNamed:foodModel.detailImageName];
        _detailLabel.text = foodModel.foodName;
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
        ZSHKTVModel *KTVModel = (ZSHKTVModel *)model;
        _hotelImageView.image = [UIImage imageNamed:KTVModel.detailImageName];
        _detailLabel.text = KTVModel.KTVName;
    }
    
}

@end
