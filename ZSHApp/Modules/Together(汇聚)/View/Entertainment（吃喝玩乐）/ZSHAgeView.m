//
//  ZSHAgeView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAgeView.h"
#import "YHSlider.h"
@interface ZSHAgeView()

@property (nonatomic, strong) YHSlider        *ageSlider;
@property (nonatomic, strong) UILabel         *firstValueLabel;
@property (nonatomic, strong) UILabel         *secondValueLabel;

@end

@implementation ZSHAgeView

- (void)setup{
    self.ageRangeStr = @"18-30岁";

    [self addSubview:self.ageSlider];
    [self.ageSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(220));
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    
    // 最小值label
    NSDictionary *firstValueLabelDic = @{@"text":@"18岁",@"font":kPingFangLight(11)};
    _firstValueLabel = [ZSHBaseUIControl createLabelWithParamDic:firstValueLabelDic];
    _firstValueLabel.text = [NSString stringWithFormat:@"%.0f岁", self.ageSlider.firstValue];
    [self addSubview:_firstValueLabel];
    [_firstValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageSlider).offset(-kRealValue(5));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
        make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
    }];
    
    // 最大值label
    NSDictionary *secondValueLabelDic = @{@"text":@"50岁",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentRight)};
    _secondValueLabel = [ZSHBaseUIControl createLabelWithParamDic:secondValueLabelDic];
    _secondValueLabel.text = [NSString stringWithFormat:@"%.0f岁", self.ageSlider.secondValue];
    [self addSubview:_secondValueLabel];
    [_secondValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ageSlider).offset(kRealValue(5));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
        make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
    }];
    
    kWeakSelf(self);
    self.ageSlider.valueChanged = ^(CGFloat firstValue, CGFloat secondValue) {
        weakself.firstValueLabel.text = [NSString stringWithFormat:@"%.0f岁", floor(firstValue)];
        weakself.secondValueLabel.text = [NSString stringWithFormat:@"%.0f岁", floor(secondValue)];
        weakself.ageRangeStr = [NSString stringWithFormat:@"%.0f-%.0f岁",floor(firstValue), floor(secondValue)];
    };
}

#pragma getter

- (YHSlider *)ageSlider{
    if (!_ageSlider) {
        _ageSlider = [[YHSlider alloc]initWithFrame:CGRectZero];
        _ageSlider.secondSliderImg = [UIImage imageNamed:@"age_icon"];
        _ageSlider.minmumValue = 18;
        _ageSlider.maxmumValue = 50;
        
        _ageSlider.firstValue = 18;
        _ageSlider.secondValue = 50;
    }
    return _ageSlider;
}

@end
