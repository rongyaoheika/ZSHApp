//
//  ZSHHotelDetailHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelDetailHeadCell.h"
#import "ZSHFoodModel.h"
#import "ZSHHotelModel.h"
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
        make.edges.mas_equalTo(self);
    }];

    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(KScreenWidth*0.6);
        make.bottom.mas_equalTo(self).offset(-kRealValue(13.5));
        make.height.mas_equalTo(kRealValue(18));
    }];

}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    if (self.fromClassType == ZSHFromFoodVCToHotelDetailVC) {//美食
        ZSHFoodDetailModel *foodDetailModel = (ZSHFoodDetailModel *)model;
        [_headView updateViewWithParamDic:@{@"dataArr":foodDetailModel.SHOPDETAILSIMGS}];
        _detailLabel.text = foodDetailModel.SHOPNAMES;
    } else if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {//酒店
        ZSHHotelDetailModel *hotelDetailModel = (ZSHHotelDetailModel *)model;
        [_headView updateViewWithParamDic:@{@"dataArr":hotelDetailModel.HOTELDETAILSIMGS}];
        _detailLabel.text = hotelDetailModel.HOTELNAMES;
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {//KTV
        ZSHKTVDetailModel *KTVDetailModel = (ZSHKTVDetailModel *)model;
        [_headView updateViewWithParamDic:@{@"dataArr":KTVDetailModel.KTVDETAILSIMGS}];
        _detailLabel.text = KTVDetailModel.KTVNAMES;
    }
    
}

@end
