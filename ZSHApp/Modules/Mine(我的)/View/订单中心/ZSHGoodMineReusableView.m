//
//  ZSHGoodMineReusableView.m
//  ZSHApp
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodMineReusableView.h"

@implementation ZSHGoodMineReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSDictionary *headLabellDic = @{@"text":@"text", @"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
        _headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabellDic];
        [self addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kRealValue(13));
            make.bottom.mas_equalTo(self).offset(-kRealValue(18));
            make.width.mas_equalTo(KScreenWidth -2*kRealValue(13));
            make.height.mas_equalTo(kRealValue(15));
        }];
    }
    return self;
}



- (void)updateWithTitle:(NSString *)title {
    _headLabel.text = title;
}

@end
