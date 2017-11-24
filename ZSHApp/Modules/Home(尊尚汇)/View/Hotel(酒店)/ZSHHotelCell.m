//
//  ZSHHotelCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelCell.h"
#import "ZSHHotelModel.h"
#import "CWStarRateView.h"

@interface ZSHHotelCell()

@property (nonatomic, strong) UIImageView               *hotelmageView;
@property (nonatomic, strong) UILabel                   *hotelDescLabel;
@property (nonatomic, strong) UILabel                   *hotelAddressLabel;
@property (nonatomic, strong) UILabel                   *distanceLabel;
@property (nonatomic, strong) UILabel                   *commentLabel;
@property (nonatomic, strong) CWStarRateView            *starView;
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
    _hotelAddressLabel.numberOfLines = 0;
    
   
    [self.contentView addSubview:_hotelAddressLabel];
    
    //酒店距离
    NSDictionary *distanceLabelDic = @{@"text":@"23公里",@"font": kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentRight)};
    _distanceLabel = [ZSHBaseUIControl createLabelWithParamDic:distanceLabelDic];
    [self.contentView addSubview:_distanceLabel];
    
    
    //星星评价
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0,0,kRealValue(80), kRealValue(12)) numberOfStars:5];
    _starView.scorePercent = 0.45;
    _starView.allowIncompleteStar = YES;
    _starView.hasAnimation = YES;
    _starView.allowUserTap = NO;
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
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [_hotelAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelDescLabel.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_hotelDescLabel);
        make.right.mas_equalTo(self).offset(-kRealValue(80));
    }];
    
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelAddressLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(_hotelAddressLabel);
        make.width.mas_equalTo(kRealValue(50));
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_hotelmageView);
        make.left.mas_equalTo(_hotelDescLabel);
        make.height.mas_equalTo(kRealValue(12));
        make.width.mas_equalTo(kRealValue(80));
    }];

    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_starView);
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

- (void)updateCellWithModel:(ZSHHotelModel *)model{
    
    
    [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMAGES]];
    _hotelDescLabel.text = model.HOTELNAMES;
    
    _hotelAddressLabel.text = model.HOTELADDRESS;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    NSString *detailStr = model.HOTELADDRESS;
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:detailStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
    [_hotelAddressLabel setAttributedText:setString];
    
//    _distanceLabel.text = [NSString stringWithFormat:@"%@公里",model.distance];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.HOTELPRICE];
    _commentLabel.text = [NSString stringWithFormat:@"（%@条评价）",model.HOTELEVACOUNT];
    
}

- (CGFloat)rowHeightWithCellModel:(ZSHHotelModel *)model{
    [self updateCellWithModel:model];
    [self layoutIfNeeded];
    CGFloat detailLabelY = CGRectGetMaxY(self.starView.frame);
    return detailLabelY + kRealValue(15);
}


@end
