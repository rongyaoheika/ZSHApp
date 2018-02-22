//
//  ZSHSelectCardNumFirstView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSelectCardNumFirstView.h"

@interface ZSHSelectCardNumFirstView ()

@property (nonatomic, strong) UILabel          *promptLabel;

@end

@implementation ZSHSelectCardNumFirstView

- (void)setup{
    
    NSDictionary *promptLabelDic = @{@"text":@"提示：若您选择随机分配，我们将在当前已开放号段内帮您分配卡号，并按照付款先后顺序发放",@"font":kPingFangLight(11)};
    _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    _promptLabel.numberOfLines = 0;
    [self addSubview:_promptLabel];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(43));
        make.right.mas_equalTo(self).offset(-kRealValue(43));
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(35));
    }];
}

@end
