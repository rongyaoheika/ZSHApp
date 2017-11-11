//
//  ZSHBrandsSortHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBrandsSortHeadView.h"
#import "ZSHClassMainModel.h"

@interface ZSHBrandsSortHeadView ()

/* 头部标题Label */
@property (nonatomic, strong)UILabel *headLabel;

@end

@implementation ZSHBrandsSortHeadView

#pragma mark - UI
- (void)setUpUI
{
    NSDictionary *headLabelDic = @{@"text":@"热门品牌",@"font":kPingFangLight(13),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabelDic];
    [self addSubview:_headLabel];
    
    _headLabel.frame = CGRectMake(10, 0, self.width, self.height);
}

#pragma mark - Setter Getter Methods
- (void)setHeadTitle:(ZSHClassMainModel *)headTitle
{
    _headTitle = headTitle;
    _headLabel.text = headTitle.title;
}


@end
