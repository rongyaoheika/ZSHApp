//
//  ZSHCardCommitBottomView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardCommitBottomView.h"


@interface ZSHCardCommitBottomView()



@end

@implementation ZSHCardCommitBottomView

- (void)setup{
    self.backgroundColor = KZSHColor0B0B0B;
    
    _leftView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreenWidth * 0.7);
        make.left.and.top.and.bottom.mas_equalTo(self);
    }];
    
    NSDictionary *topLabelDic = @{@"text":@"至尊会籍卡",@"font":kPingFangLight(12),@"textAlignment":@(NSTextAlignmentCenter)};
    _leftTopLabel = [ZSHBaseUIControl createLabelWithParamDic:topLabelDic];
    [_leftView addSubview:_leftTopLabel];
    [_leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_leftView);
        make.width.mas_equalTo(_leftView);
        make.height.mas_equalTo(_leftView).multipliedBy(0.3);
        make.top.mas_equalTo(_leftView);
    }];
    
    NSDictionary *bottomLabelDic = @{@"text":@"总计：¥199（终身免年费）",@"font":kPingFangLight(12),@"textAlignment":@(NSTextAlignmentCenter)};
    _leftBottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomLabelDic];
    [_leftView addSubview:_leftBottomLabel];
    [_leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_leftView);
        make.width.mas_equalTo(_leftView);
        make.height.mas_equalTo(_leftView).multipliedBy(0.7);
        make.bottom.mas_equalTo(_leftView);
    }];
    
    NSDictionary *rightBtnDic = @{@"title":@"提交信息",@"font":kPingFangLight(17),@"backgroundColor": [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:0.4/1.0]};
    _rightBtn = [ZSHBaseUIControl createBtnWithParamDic:rightBtnDic];
    [self addSubview:_rightBtn];
//    [_rightBtn addTarget:self action:@selector(commitInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftView.mas_right);
        make.right.and.top.and.height.mas_equalTo(self);
    }];
    
    [self setNeedsLayout];
    
}

- (void)commitInfoAction{//提交注册信息

}

@end
