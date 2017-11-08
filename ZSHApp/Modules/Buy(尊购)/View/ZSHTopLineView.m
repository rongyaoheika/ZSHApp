//
//  ZSHTopLineView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTopLineView.h"

@interface ZSHTopLineView ()

@property (nonatomic, strong) UIView              *lineView;
@property (nonatomic, strong) UILabel             *typeLabel;

@end

@implementation ZSHTopLineView

- (void)setup{
    
    //分割线
    _lineView = [[UIView alloc]initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(kRealValue(50.5));
        make.height.mas_equalTo(kRealValue(0.5));
    }];
    
    //取消按钮
    NSArray *btnTitleArr = @[@"取消",@"确定"];
    for (int i = 0; i<btnTitleArr.count; i++) {
        NSDictionary *btnDic = @{@"title":btnTitleArr[i],@"titleColor":KZSHColor333333,@"font":kPingFangRegular(15),@"backgroundColor":KClearColor};
        UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kRealValue(40));
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(kRealValue(50));
            if (i == 0) {
                make.left.mas_equalTo(self).offset(kRealValue(30));
            } else {
                make.right.mas_equalTo(self).offset(-kRealValue(30));
            }
        }];
    }
    
    //中间label
    NSDictionary *typeLabelDic = @{@"text":self.paramDic[@"typeText"],@"font":kPingFangMedium(15),@"textColor":KZSHColor333333,@"textAlignment":@(NSTextAlignmentCenter)};
    _typeLabel = [ZSHBaseUIControl createLabelWithParamDic:typeLabelDic];
    [self addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(50));
    }];
    
}

#pragma action
- (void)btnAction:(UIButton *)btn{
    if (self.btnActionBlock) {
        self.btnActionBlock(btn.tag - 1);
    }
}

@end
