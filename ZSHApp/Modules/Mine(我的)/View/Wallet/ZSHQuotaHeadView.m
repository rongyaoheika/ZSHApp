//
//  ZSHQuotaHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHQuotaHeadView.h"

@interface ZSHQuotaHeadView ()

@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;

@end

@implementation ZSHQuotaHeadView

- (void)setup{
    self.backgroundColor = KClearColor;
    
    NSDictionary *topDic = @{@"text":self.paramDic[@"headKeyTitle"],@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
    _topLB = [ZSHBaseUIControl createLabelWithParamDic:topDic];
    [self addSubview:_topLB];
    [_topLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(30));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(self);
    }];
    
    NSDictionary *bottomDic = @{@"text":self.paramDic[@"headValueTitle"],@"font":kPingFangRegular(32),@"textColor":[UIColor colorWithHexString:@"A0A0A0"],@"textAlignment":@(NSTextAlignmentCenter)};
    _bottomLB = [ZSHBaseUIControl createLabelWithParamDic:bottomDic];
    _bottomLB.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_bottomLB];
    [_bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topLB.mas_bottom).offset(kRealValue(20));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(25));
        make.width.mas_equalTo(self);
    }];
}

@end
