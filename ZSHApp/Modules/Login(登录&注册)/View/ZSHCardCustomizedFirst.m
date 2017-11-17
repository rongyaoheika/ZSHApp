//
//  ZSHCardCustomizedFirst.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardCustomizedFirst.h"

@interface ZSHCardCustomizedFirst ()

@property (nonatomic, strong) UILabel          *promptLabel;
@property (nonatomic, strong) UITextField      *signTextField;
@property (nonatomic, strong) UIView           *bottomView;
@property (nonatomic, strong) UIImageView      *bottomImageView;
@property (nonatomic, strong) UILabel          *bottomPromptLabel;
@property (nonatomic, strong) UIScrollView     *bottomScrollView;

@end


@implementation ZSHCardCustomizedFirst

- (void)setup{
    NSDictionary *promptLabelDic = @{@"text":@"图示：请输入您要定制的姓名的拼音大写，如（成龙）",@"font":kPingFangLight(11)};
    _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    _promptLabel.numberOfLines = 0;
    [self addSubview:_promptLabel];
    
    _signTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    _signTextField.layer.cornerRadius = kRealValue(2.0);
    _signTextField.layer.borderColor = KZSHColor929292.CGColor;
    _signTextField.layer.borderWidth = 1.0;
    NSString *placeholder = @"请您输入自己的个性签名";
    _signTextField.placeholder = placeholder;
    [_signTextField setValue:KZSHColor929292 forKeyPath:@"_placeholderLabel.textColor"];
    [_signTextField setValue:kPingFangLight(15) forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:_signTextField];
    
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    _bottomView.backgroundColor = KZSHColor0B0B0B;
    [self addSubview:_bottomView];
    
    _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"glory_card_little"]];
    [_bottomView addSubview:_bottomImageView];
    
    NSDictionary *bottomPromptLabelDic = @{@"text":@"85%的用户选择为自己定制一张专属的环球黑卡",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentCenter)};
    _bottomPromptLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomPromptLabelDic];
    [_bottomView addSubview:_bottomPromptLabel];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(43));
        make.right.mas_equalTo(self).offset(-kRealValue(43));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(17));
    }];
    
    [_signTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_promptLabel.mas_bottom).offset(kRealValue(20));
        make.size.mas_equalTo(CGSizeMake(kRealValue(200), kRealValue(30)));
        make.centerX.mas_equalTo(self);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signTextField.mas_bottom).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(160));
        make.width.mas_equalTo(kRealValue(330));
        make.centerX.mas_equalTo(self);
    }];
    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomView).offset(kRealValue(13));
        make.size.mas_equalTo(CGSizeMake(kRealValue(167), kRealValue(106)));
        make.centerX.mas_equalTo(_bottomView);
    }];
    
    [_bottomPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomImageView.mas_bottom).offset(kRealValue(8));
        make.width.mas_equalTo(_bottomView);
        make.height.mas_equalTo(kRealValue(17));
        make.centerX.mas_equalTo(_bottomView);
    }];
}


@end
