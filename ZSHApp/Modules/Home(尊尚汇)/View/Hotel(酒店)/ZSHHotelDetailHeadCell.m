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
#import "ZSHGuideView.h"

@interface ZSHHotelDetailHeadCell ()

@property (nonatomic, strong)  UIImageView           *hotelImageView;
@property (nonatomic, strong)  ZSHGuideView          *headView;
@property (nonatomic, strong)  UILabel               *detailLabel;
@property (nonatomic, strong)  UIView                *lineView;
@end
@implementation ZSHHotelDetailHeadCell

- (void)setup{
    NSDictionary *nextParamDic = @{KFromClassType:@(FromHotelDetailVCToGuideView), @"pageViewHeight":@(kRealValue(225)), @"min_scale":@(1.0),@"withRatio":@(1.0),@"pageImage":@"page_press",@"currentPageImage":@"page_normal",@"infinite":@(false)};
    _headView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.contentView addSubview:_headView];
    
     NSDictionary *detailLabelDic = @{@"text":@"三亚大中华希尔顿酒店",@"font":kPingFangMedium(18)};
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    [self.contentView addSubview:_detailLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];

    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(KScreenWidth*0.6);
        make.bottom.mas_equalTo(self).offset(-kRealValue(13.5));
        make.height.mas_equalTo(kRealValue(18));
    }];

}

- (void)setFromClassType:(ZSHFromVCToHotelDetailVC)fromClassType{
    _fromClassType = fromClassType;
}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    
    if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {
        ZSHHotelDetailModel *hotelModel = (ZSHHotelDetailModel *)model;
        _hotelImageView.image = [UIImage imageNamed:hotelModel.detailImageName];
        _detailLabel.text = hotelModel.hotelName;
    } else if (self.fromClassType == ZSHFromFoodVCToHotelDetailVC) {
        ZSHFoodDetailModel *foodDetailModel = (ZSHFoodDetailModel *)model;
        [_headView updateViewWithParamDic:@{@"dataArr":foodDetailModel.SHOPDETAILSIMGS}];
        
        _detailLabel.text = foodDetailModel.SHOPNAMES;
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
        ZSHKTVModel *KTVModel = (ZSHKTVModel *)model;
        _hotelImageView.image = [UIImage imageNamed:KTVModel.detailImageName];
        _detailLabel.text = KTVModel.KTVName;
    }
    
}

@end
