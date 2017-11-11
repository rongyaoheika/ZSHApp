//
//  ZSHAgeView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAgeView.h"

@interface ZSHAgeView()

@property (nonatomic, strong) UISlider        *ageSlider;
@property (nonatomic, strong) UILabel         *valueLabel;

@end

@implementation ZSHAgeView

- (void)setup{
    
    [self addSubview:self.ageSlider];
    [self.ageSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(220));
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    // 当前值label
     NSDictionary *valueLabelDic = @{@"text":@"30岁",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentCenter)};
    self.valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f岁", self.ageSlider.value];
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ageSlider);
        make.bottom.mas_equalTo(self.ageSlider.mas_top).offset(-kRealValue(5));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    // 最小值label
    NSDictionary *minLabelDic = @{@"text":@"18岁",@"font":kPingFangLight(11)};
    UILabel *minLabel = [ZSHBaseUIControl createLabelWithParamDic:minLabelDic];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.text = [NSString stringWithFormat:@"%.0f岁", self.ageSlider.minimumValue];
    [self addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageSlider).offset(-kRealValue(5));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
        make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
    }];
    
    // 最大值label
    NSDictionary *maxLabelDic = @{@"text":@"50岁",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentRight)};
    UILabel *maxLabel = [ZSHBaseUIControl createLabelWithParamDic:maxLabelDic];
    maxLabel.text = [NSString stringWithFormat:@"%.0f岁", self.ageSlider.maximumValue];
    [self addSubview:maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ageSlider).offset(kRealValue(5));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
        make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
    }];
    
}

#pragma getter
- (UISlider *)ageSlider{
    if (!_ageSlider) {
        _ageSlider = [[UISlider alloc]initWithFrame:CGRectZero];
        _ageSlider.minimumValue = 18;
        _ageSlider.maximumValue = 50;
        _ageSlider.minimumValueImage = [UIImage imageNamed:@"order_point"];
        _ageSlider.maximumValueImage = [UIImage imageNamed:@"age_icon"];
        [_ageSlider setThumbImage:[UIImage imageNamed:@"order_point"] forState:UIControlStateNormal];
        _ageSlider.continuous = YES;
        [_ageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _ageSlider;
}

//年龄滑动块
-(void)sliderValueChanged:(id)sender{
    UISlider *ageSlider = (UISlider *)sender;
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f岁", ageSlider.value];
}

@end
