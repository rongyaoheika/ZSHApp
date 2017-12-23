//
//  ZSHSearchLiveThirdCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSearchLiveThirdCell.h"
#import "StepSlider.h"

@interface ZSHSearchLiveThirdCell()

@property (nonatomic, strong) StepSlider        *timeSlider;

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
    
    NSArray *labelTitleArr = @[@"0", @"15分钟内", @"2小时内", @"1天内", @"7天内"];
    _timeSlider = [[StepSlider alloc] initWithFrame:CGRectZero];
    [_timeSlider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    _timeSlider.dotsInteractionEnabled = YES;
    _timeSlider.labelOffset = kRealValue(-5);
    _timeSlider.sliderCircleColor = KZSHColor929292;
    _timeSlider.labelFont = kPingFangLight(11);
    _timeSlider.labelColor = KZSHColor929292;
    _timeSlider.sliderCircleColor = KZSHColor929292;
    _timeSlider.sliderCircleImage = [UIImage imageNamed:@"age_icon"];
    _timeSlider.trackHeight = kRealValue(2);
    _timeSlider.trackColor = KZSHColor929292;
    _timeSlider.trackCircleRadius = kRealValue(5);
    _timeSlider.labels = labelTitleArr;
    [_timeSlider setMaxCount:labelTitleArr.count];
    [self addSubview:_timeSlider];
    [self.timeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(titleLabel.mas_right).offset(kRealValue(42));
        make.width.mas_equalTo(kRealValue(220));
        make.height.mas_equalTo(kRealValue(40));
    }];
}

- (void)changeValue:(StepSlider *)sender
{
    RLog(@"值变化");
}

@end
