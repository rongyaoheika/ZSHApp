//
//  ZSHTrainTicketDetailCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainTicketDetailCell.h"

@interface ZSHTrainTicketDetailCell ()

@property (nonatomic, strong) UILabel                   *trainTypeLabel;
@property (nonatomic, strong) UILabel                   *trainTicketTypeLabel;
@property (nonatomic, strong) UIButton                  *bookeBtn;
@property (nonatomic, strong) UILabel                   *discountLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHTrainTicketDetailCell

- (void)setup{
    
    //火车类型
    NSDictionary *_trainTypeLabelDic = @{@"text":@"经济舱",@"font": kPingFangMedium(15)};
    _trainTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:_trainTypeLabelDic];
    _trainTypeLabel.numberOfLines = 0;
    [_trainTypeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_trainTypeLabel];
    
    //火车票出票方式
    NSDictionary *trainTicketTypeLabelDic = @{@"text":@"仅剩10张",@"font": kPingFangRegular(11)};
    _trainTicketTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:trainTicketTypeLabelDic];
    [self.contentView addSubview:_trainTicketTypeLabel];
    
    //火车票优惠
    NSDictionary *discountLabelDic = @{@"text":@"会员减99",@"font": kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentRight)};
    _discountLabel = [ZSHBaseUIControl createLabelWithParamDic:discountLabelDic];
    [self.contentView addSubview:_discountLabel];
    
    //火车票价格
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
    
    [_trainTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(KScreenWidth * 0.4);
        make.top.mas_equalTo(self).offset(kRealValue(17));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [_trainTicketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_trainTypeLabel.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(_trainTypeLabel);
        make.right.mas_equalTo(_trainTypeLabel);
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_trainTypeLabel);
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

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _trainTypeLabel.text = dic[@"type"];
}

@end
