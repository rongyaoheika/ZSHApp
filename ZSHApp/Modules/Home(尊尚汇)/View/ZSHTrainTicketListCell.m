//
//  ZSHTrainTicketListCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainTicketListCell.h"

@interface ZSHTrainTicketListCell ()

@property (nonatomic, strong) UIButton *beginPlaceBtn;
@property (nonatomic, strong) UIButton *endPlaceBtn;
@property (nonatomic, strong) UILabel  *secSeatLabel;
@property (nonatomic, strong) UILabel  *firstSeatLabel;
@property (nonatomic, strong) UILabel  *businessLabel;
@property (nonatomic, strong) UILabel  *priceLabel;
@property (nonatomic, strong) UIButton *ticketLineBtn;
@property (nonatomic, strong) UILabel  *trainNumLabel;
@property (nonatomic, strong) UILabel  *timeLabel;

@end

@implementation ZSHTrainTicketListCell

- (void)setup{
    
    //火车票始发站
    NSDictionary *beginPlaceBtnTopDic = @{@"text":@"北京南",@"font":kPingFangMedium(15),@"height":@(15)};
    NSDictionary *beginPlaceBtnBottomDic = @{@"text":@"06:40",@"font":kPingFangRegular(10),@"height":@(10)};
    _beginPlaceBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:beginPlaceBtnTopDic bottomDic:beginPlaceBtnBottomDic];
    [self.contentView addSubview:_beginPlaceBtn];
    
    //火车票终点站
    NSDictionary *endPlaceBtnTopDic = @{@"text":@"上海虹桥",@"font":kPingFangMedium(15),@"height":@(15)};
    NSDictionary *endPlaceBtnBottomDic = @{@"text":@"12:39",@"font":kPingFangRegular(10),@"height":@(10)};
    _endPlaceBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:endPlaceBtnTopDic bottomDic:endPlaceBtnBottomDic];
    [self.contentView addSubview:_endPlaceBtn];
    
    //火车票 二等座
    NSDictionary *ticketNumLabelDic = @{@"text":@"二等座：10张",@"font": kPingFangRegular(10)};
    _secSeatLabel = [ZSHBaseUIControl createLabelWithParamDic:ticketNumLabelDic];
    [self.contentView addSubview:_secSeatLabel];
    
    //火车票 一等座
    NSDictionary *firstSeatLabelDic = @{@"text":@"一等座：10张",@"font": kPingFangRegular(10)};
    _firstSeatLabel = [ZSHBaseUIControl createLabelWithParamDic:firstSeatLabelDic];
    [self.contentView addSubview:_firstSeatLabel];
    
    //火车票 商务座
    _businessLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"商务座：10张",@"font": kPingFangRegular(10)}];
    [self.contentView addSubview:_businessLabel];
    
    //火车票价格
    NSDictionary *priceLabelDic = @{@"text":@"¥999起",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
    //
    _ticketLineBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    UIImage *ticketLineImage = [UIImage imageNamed:@"ticket_line"];
    ticketLineImage = [ticketLineImage resizableImageWithCapInsets:UIEdgeInsetsMake(ticketLineImage.size.height*0.4, ticketLineImage.size.width*0.4, ticketLineImage.size.height*0.4, ticketLineImage.size.width*0.4)];
    [_ticketLineBtn setBackgroundImage:ticketLineImage forState:UIControlStateNormal];
    [self.contentView addSubview:_ticketLineBtn];
    
    
    // 车次
    _trainNumLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"G101",@"font": kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.contentView addSubview:_trainNumLabel];
    
    // 耗时
    _timeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"4小时39分钟",@"font": kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.contentView addSubview:_timeLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_beginPlaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(35));
        make.width.mas_equalTo(kRealValue(62));
    }];
    
    [_ticketLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_beginPlaceBtn.mas_right).offset(kRealValue(15.5));
        make.top.mas_equalTo(self).offset(kRealValue(22.5));
        make.width.mas_equalTo(kRealValue(70));
        make.height.mas_equalTo(kRealValue(5));
    }];
    
    [_endPlaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_beginPlaceBtn);
        make.left.mas_equalTo(_ticketLineBtn.mas_right).offset(kRealValue(15.5));
        make.width.mas_equalTo(_beginPlaceBtn);
        make.height.mas_equalTo(_beginPlaceBtn);
    }];
    
    [_secSeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_beginPlaceBtn);
        make.top.mas_equalTo(_beginPlaceBtn.mas_bottom).offset(kRealValue(10));
        make.width.mas_equalTo(kRealValue(70));
        make.height.mas_equalTo(kRealValue(10));
    }];
    
    [_firstSeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secSeatLabel);
        make.width.mas_equalTo(kRealValue(75));
        make.left.mas_equalTo(_secSeatLabel.mas_right);
        make.height.mas_equalTo(_secSeatLabel);
    }];
    
    [_businessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secSeatLabel);
        make.width.mas_equalTo(kRealValue(75));
        make.left.mas_equalTo(_firstSeatLabel.mas_right);
        make.height.mas_equalTo(_secSeatLabel);
    }];

    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_beginPlaceBtn);
        make.trailing.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(17));
        make.width.mas_equalTo(kRealValue(60));
    }];
    
    [_trainNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_ticketLineBtn).offset(kRealValue(-5));
        make.centerX.mas_equalTo(_ticketLineBtn);
        make.size.mas_equalTo(CGSizeMake(kRealValue(23), kRealValue(11)));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ticketLineBtn).offset(kRealValue(5));
        make.centerX.mas_equalTo(_ticketLineBtn);
        make.size.mas_equalTo(CGSizeMake(kRealValue(60), kRealValue(11)));
    }];

}


@end
