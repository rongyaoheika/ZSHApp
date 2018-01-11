//
//  ZSHCabinetReusableView.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHCabinetReusableView.h"


@implementation ZSHCabinetReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _headLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"GUCCI 旗舰店", @"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)}];
        [self addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}


@end
