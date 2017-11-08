//
//  ZSHTextFieldCellView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTextFieldCellView.h"

@interface ZSHTextFieldCellView()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel      *leftLabel;
@property (nonatomic,strong) UITextField  *textField;
@property (nonatomic,strong) YYLabel      *getCaptchaBtn;
@property (nonatomic,strong) UIView       *verticalLine;

@end

@implementation ZSHTextFieldCellView

- (void)setup{
    if (kFromVCType == FromMultiInfoNickNameVCToTextFieldCellView) {//修改昵称
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(0));
            make.height.mas_equalTo(kRealValue(0));
        }];
    } else {
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(80));
            make.height.mas_equalTo(kRealValue(15));
        }];
    }
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    if ([self.paramDic[@"textFieldType"] integerValue] == ZSHTextFieldViewCaptcha) {
        [self addSubview:self.getCaptchaBtn];
        [self.getCaptchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(kRealValue(15));
            make.width.mas_equalTo(kRealValue(77));
            make.right.mas_equalTo(self).offset(-10);
        }];
        
        [self addSubview:self.verticalLine];
        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kRealValue(12));
            make.bottom.mas_equalTo(self).offset(-kRealValue(12));
            make.width.mas_equalTo(0.5);
            make.right.mas_equalTo(self.getCaptchaBtn.mas_left).offset(-10);
        }];
    }
}

#pragma getter

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        NSDictionary *leftLabelDic = @{@"text":self.paramDic[@"leftTitle"],@"font":kPingFangRegular(14)};
        _leftLabel = [ZSHBaseUIControl createLabelWithParamDic:leftLabelDic];
    }
    return _leftLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = KZSHColor929292;
        _textField.tintColor = KZSHColor929292;
        _textField.backgroundColor = KClearColor;
        _textField.font = kPingFangLight(14);
        _textField.delegate = self;
        _textField.placeholder = self.paramDic[@"placeholder"];
        _textField.secureTextEntry = ([self.paramDic[@"textFieldType"]integerValue] == ZSHTextFieldViewPwd);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: self.paramDic[@"placeholder"] attributes:@{NSForegroundColorAttributeName:KZSHColor929292}];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    }
    return _verticalLine;
}

- (YYLabel *)getCaptchaBtn{
    if (!_getCaptchaBtn) {
        _getCaptchaBtn = [[YYLabel alloc] init];
        _getCaptchaBtn.text = @"获取验证码";
        _getCaptchaBtn.font = kPingFangRegular(14);
        _getCaptchaBtn.textColor = KLightWhiteColor;
        _getCaptchaBtn.backgroundColor = KClearColor;
        _getCaptchaBtn.textAlignment = NSTextAlignmentRight;
        _getCaptchaBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        //    getCaptchaBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //        [weakself skipAction];
        //    };
    }
    return _getCaptchaBtn;
}

#pragma action
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.textFieldChanged) {
        self.textFieldChanged(textField.text);
    }
}

@end
