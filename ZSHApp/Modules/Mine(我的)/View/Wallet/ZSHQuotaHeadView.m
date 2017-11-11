//
//  ZSHQuotaHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHQuotaHeadView.h"


@implementation ZSHQuotaHeadView

- (void)setup{
    self.backgroundColor = KClearColor;
    
    NSDictionary *topDic = @{@"text":self.paramDic[@"headKeyTitle"],@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *topLabel = [ZSHBaseUIControl createLabelWithParamDic:topDic];
    [self addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(30));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(self);
    }];
    
    NSDictionary *bottomDic = @{@"text":self.paramDic[@"headValueTitle"],@"font":kPingFangRegular(32),@"textColor":[UIColor colorWithHexString:@"A0A0A0"],@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomDic];
    bottomLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(kRealValue(20));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(25));
        make.width.mas_equalTo(self);
    }];
}

@end
