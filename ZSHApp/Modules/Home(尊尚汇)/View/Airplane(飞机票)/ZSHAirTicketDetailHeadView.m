//
//  ZSHAirTicketDetailHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAirTicketDetailHeadView.h"

@interface ZSHAirTicketDetailHeadView()

@property (nonatomic, strong) UIButton                  *beginTimeBtn;
@property (nonatomic, strong) UIButton                  *endTimeBtn;
@property (nonatomic, strong) UIButton                  *ticketLineBtn;
@property (nonatomic, strong) UILabel                   *timeLabel;
@property (nonatomic, strong) UILabel                   *detailLabel;
@end

@implementation ZSHAirTicketDetailHeadView

- (void)setup{
    
    //机票开始时间
    NSDictionary *beginTimeBtnTopDic = @{@"text":@"北京",@"font":kPingFangMedium(17),@"height":@(17)};
    NSDictionary *beginTimeBtnBottomDic = @{@"text":@"20:30",@"font":kPingFangMedium(15),@"height":@(15)};
    _beginTimeBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:beginTimeBtnTopDic bottomDic:beginTimeBtnBottomDic];
    [self addSubview:_beginTimeBtn];
    
    //机票结束时间
    NSDictionary *endTimeBtnTopDic = @{@"text":@"上海",@"font":kPingFangMedium(17),@"height":@(17)};
    NSDictionary *endTimeBtnBottomDic = @{@"text":@"22:30",@"font":kPingFangMedium(15),@"height":@(15)};
    _endTimeBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:endTimeBtnTopDic bottomDic:endTimeBtnBottomDic];
    [self addSubview:_endTimeBtn];
    
    //机票时长
    NSDictionary *timeLabelDic = @{@"text":@"2小时0分钟",@"font": kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)};
    _timeLabel = [ZSHBaseUIControl createLabelWithParamDic:timeLabelDic];
    [self addSubview:_timeLabel];
    
    _ticketLineBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_ticketLineBtn setBackgroundImage:[UIImage imageNamed:@"ticket_line_long"] forState:UIControlStateNormal];
    [self addSubview:_ticketLineBtn];
    
    //机票详细
    NSDictionary *detailLabelDic = @{@"text":@"海航HU7609  中型机321  准点率80%",@"font": kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)};
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    [self addSubview:_detailLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_ticketLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(kRealValue(52));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(5));
    }];
    
    [_beginTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_ticketLineBtn.mas_left).offset(-kRealValue(50));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(40));
        make.width.mas_equalTo(kRealValue(45));
    }];
    
    [_endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_beginTimeBtn);
        make.left.mas_equalTo(_ticketLineBtn.mas_right).offset(kRealValue(50));
        make.width.mas_equalTo(_beginTimeBtn);
        make.height.mas_equalTo(_beginTimeBtn);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_ticketLineBtn.mas_top).offset(-kRealValue(10));
        make.width.mas_equalTo(KScreenWidth * 0.5);
        make.height.mas_equalTo(kRealValue(10));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ticketLineBtn.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(KScreenWidth);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(_timeLabel);
    }];
    
}


@end
