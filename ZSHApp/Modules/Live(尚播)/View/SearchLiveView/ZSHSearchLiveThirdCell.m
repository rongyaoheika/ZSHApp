//
//  ZSHSearchLiveThirdCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSearchLiveThirdCell.h"
#import "DCSliderView.h"

@interface ZSHSearchLiveThirdCell()

@property (nonatomic, strong) DCSliderView        *timeSlider;

@end

@implementation ZSHSearchLiveThirdCell

- (void)setup{
    NSDictionary *titleLabelDic = @{@"text":@"活跃时间",@"font":kPingFangLight(14),@"textColor":KZSHColor333333};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(30));
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(60));
    }];
    
    _timeSlider = [[DCSliderView alloc]initWithFrame:CGRectZero WithLayerColor:KZSHColor929292];
    [self addSubview:_timeSlider];
    [self.timeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(titleLabel.mas_right).offset(kRealValue(46));
        make.width.mas_equalTo(kRealValue(220));
        make.height.mas_equalTo(kRealValue(30));
    }];
}

@end
