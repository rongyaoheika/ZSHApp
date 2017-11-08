//
//  ZSHAirTicketDetailCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAirTicketDetailCell.h"

@interface ZSHAirTicketDetailCell()

@property (nonatomic, strong) UILabel                   *airPlaneTypeLabel;
@property (nonatomic, strong) UILabel                   *airTicketTypeLabel;
@property (nonatomic, strong) UIButton                  *bookeBtn;
@property (nonatomic, strong) UILabel                   *discountLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHAirTicketDetailCell

- (void)setup{
    
    //飞机类型
    NSDictionary *_airPlaneTypeLabelDic = @{@"text":@"经济舱",@"font": kPingFangMedium(15)};
    _airPlaneTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:_airPlaneTypeLabelDic];
    _airPlaneTypeLabel.numberOfLines = 0;
    [_airPlaneTypeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_airPlaneTypeLabel];
    
    //机票出票方式
    NSDictionary *airTicketTypeLabelDic = @{@"text":@"实时出票",@"font": kPingFangRegular(11)};
    _airTicketTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:airTicketTypeLabelDic];
    [self.contentView addSubview:_airTicketTypeLabel];
    
    //机票优惠
    NSDictionary *discountLabelDic = @{@"text":@"会员减99",@"font": kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentRight)};
    _discountLabel = [ZSHBaseUIControl createLabelWithParamDic:discountLabelDic];
    [self.contentView addSubview:_discountLabel];
    
    //机票价格
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
    
    [_airPlaneTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(KScreenWidth * 0.4);
        make.top.mas_equalTo(self).offset(kRealValue(17));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_airTicketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_airPlaneTypeLabel.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(_airPlaneTypeLabel);
        make.right.mas_equalTo(_airPlaneTypeLabel);
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_airPlaneTypeLabel);
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
