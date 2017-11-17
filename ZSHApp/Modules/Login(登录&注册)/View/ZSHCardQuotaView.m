//
//  ZSHCardQuotaView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardQuotaView.h"

@interface ZSHCardQuotaView()

@property (nonatomic, strong) UILabel *valueLabel;

@end


@implementation ZSHCardQuotaView

- (void)setup{
    NSDictionary *promptLabelDic = @{@"text":@"本周剩余名额",@"font":kPingFangRegular(15)};
    UILabel *promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    [self addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(27));
        make.height.mas_equalTo(kRealValue(45));
        make.width.mas_equalTo(kRealValue(95));
        make.top.mas_equalTo(self);
    }];
    
     NSDictionary *valueLabelDic = @{@"text":@"2%（共50张）",@"textColor":KZSHColorF29E19,@"font":kPingFangRegular(12)};
    _valueLabel = [ZSHBaseUIControl createLabelWithParamDic:valueLabelDic];
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(promptLabel.mas_right).mas_equalTo(kRealValue(10));
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(promptLabel);
        make.top.mas_equalTo(self);
    }];
    
    // 经验条
    UIProgressView *expProgressView = [[UIProgressView alloc] init];
    [expProgressView setTrackImage:[UIImage imageNamed:@"grade_image_2"]];
    expProgressView.progressTintColor = KZSHColorF29E19;
    for (UIImageView * imageview in expProgressView.subviews) {
        imageview.layer.cornerRadius = 4.0;
        imageview.clipsToBounds = YES;
    }
    [self addSubview:expProgressView];
    [expProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(promptLabel);
        make.top.mas_equalTo(promptLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kRealValue(275), kRealValue(8)));
    }];
    expProgressView.progress = 0.9;
}

@end
