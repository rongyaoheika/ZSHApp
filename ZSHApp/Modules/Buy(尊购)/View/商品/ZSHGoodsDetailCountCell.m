//
//  ZSHGoodsDetailCountCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailCountCell.h"
#import "JSNummberCount.h"

@implementation ZSHGoodsDetailCountCell

#pragma mark - UI
- (void)setup
{
    NSDictionary *titleLabelDic = @{@"text":@"数量",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(kRealValue(65));
    }];
   
    JSNummberCount *countBtn = [[JSNummberCount alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:countBtn];
    countBtn.NumberChangeBlock = ^(NSInteger count) {
        _NumberChangeBlock(count);
    };
    [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(kRealValue(55));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(15));
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end
