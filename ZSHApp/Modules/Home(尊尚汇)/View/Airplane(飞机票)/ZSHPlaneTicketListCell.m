//
//  ZSHPlaneTicketListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPlaneTicketListCell.h"

@interface ZSHPlaneTicketListCell()

@property (nonatomic, strong) UIButton                  *beginTimeBtn;
@property (nonatomic, strong) UIButton                  *endTimeBtn;
@property (nonatomic, strong) UILabel                   *ticketNumLabel;
@property (nonatomic, strong) UILabel                   *ticketTypeLabel;
@property (nonatomic, strong) UILabel                   *priceLabel;
@property (nonatomic, strong) UIButton                  *ticketLineBtn;

@end

@implementation ZSHPlaneTicketListCell

- (void)setup{
    
    //机票开始时间
    NSDictionary *beginTimeBtnTopDic = @{@"text":@"20:30",@"font":kPingFangMedium(15),@"height":@(15)};
    NSDictionary *beginTimeBtnBottomDic = @{@"text":@"首都T2",@"font":kPingFangRegular(10),@"height":@(10)};
    _beginTimeBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:beginTimeBtnTopDic bottomDic:beginTimeBtnBottomDic];
    [self.contentView addSubview:_beginTimeBtn];
    
    //机票结束时间
    NSDictionary *endTimeBtnTopDic = @{@"text":@"22:30",@"font":kPingFangMedium(15),@"height":@(15)};
    NSDictionary *endTimeBtnBottomDic = @{@"text":@"浦东T1",@"font":kPingFangRegular(10),@"height":@(10)};
    _endTimeBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:endTimeBtnTopDic bottomDic:endTimeBtnBottomDic];
    [self.contentView addSubview:_endTimeBtn];
    
    //机票编号
    NSDictionary *ticketNumLabelDic = @{@"text":@"海航HU7609",@"font": kPingFangRegular(10)};
    _ticketNumLabel = [ZSHBaseUIControl createLabelWithParamDic:ticketNumLabelDic];
    [self.contentView addSubview:_ticketNumLabel];
    
    //机票型号
    NSDictionary *ticketTypeLabelDic = @{@"text":@"中型机321",@"font": kPingFangRegular(10)};
    _ticketTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:ticketTypeLabelDic];
    [self.contentView addSubview:_ticketTypeLabel];
    
    //机票价格
    NSDictionary *priceLabelDic = @{@"text":@"¥999",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
    
    _ticketLineBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_ticketLineBtn setBackgroundImage:[UIImage imageNamed:@"ticket_line"] forState:UIControlStateNormal];
    [self.contentView addSubview:_ticketLineBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_beginTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(35));
        make.width.mas_equalTo(kRealValue(42));
    }];
    
    [_ticketLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_beginTimeBtn.mas_right).offset(kRealValue(17.5));
        make.top.mas_equalTo(self).offset(kRealValue(22.5));
        make.width.mas_equalTo(kRealValue(30));
        make.height.mas_equalTo(kRealValue(5));
    }];
    
    [_endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_beginTimeBtn);
        make.left.mas_equalTo(_ticketLineBtn.mas_right).offset(kRealValue(17.5));
        make.width.mas_equalTo(_beginTimeBtn);
        make.height.mas_equalTo(_beginTimeBtn);
    }];
    
    [_ticketNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_beginTimeBtn);
        make.top.mas_equalTo(_beginTimeBtn.mas_bottom).offset(kRealValue(10));
        make.width.mas_equalTo(kRealValue(70));
        make.height.mas_equalTo(kRealValue(10));
    }];
    
    [_ticketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ticketNumLabel);
        make.width.mas_equalTo(kRealValue(55));
        make.left.mas_equalTo(_ticketNumLabel.mas_right);
        make.height.mas_equalTo(_ticketNumLabel);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_beginTimeBtn);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(17));
        make.width.mas_equalTo(kRealValue(50));
    }];
    
}

@end
