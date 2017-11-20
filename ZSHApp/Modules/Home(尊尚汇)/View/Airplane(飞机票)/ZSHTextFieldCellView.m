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
@property (nonatomic,strong) UIView       *bottomLine;

@end

@implementation ZSHTextFieldCellView

- (void)setup{
    [self addSubview:self.leftLabel];
    [self addSubview:self.textField];
    [self addSubview:self.getCaptchaBtn];
    [self addSubview:self.verticalLine];
    [self addSubview:self.bottomLine];
    [self layoutIfNeeded];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.paramDic[@"leftTitle"]) {
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(80));
            make.height.mas_equalTo(kRealValue(15));
        }];
    }

    if ([self.paramDic[@"textFieldType"] integerValue] != ZSHTextFieldViewNone) {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_right);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    if ([self.paramDic[@"textFieldType"]integerValue] == ZSHTextFieldViewCaptcha) {
        [self.getCaptchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(kRealValue(15));
            make.width.mas_equalTo(kRealValue(77));
            make.right.mas_equalTo(self).offset(-10);
        }];

        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kRealValue(12));
            make.bottom.mas_equalTo(self).offset(-kRealValue(12));
            make.width.mas_equalTo(0.5);
            make.right.mas_equalTo(self.getCaptchaBtn.mas_left).offset(-10);
        }];
    }
    
    if (kFromClassTypeValue == FromLoginVCToTextFieldCellView||kFromClassTypeValue == FromCardVCToTextFieldCellView) {
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
    
}

#pragma getter
- (UILabel *)leftLabel{
    if (!_leftLabel) {
        NSString *leftTitle = self.paramDic[@"leftTitle"]?self.paramDic[@"leftTitle"]:@"";
        NSDictionary *leftLabelDic = @{@"text":leftTitle,@"font":kPingFangRegular(14)};
        _leftLabel = [ZSHBaseUIControl createLabelWithParamDic:leftLabelDic];
        _leftLabel.frame = CGRectZero;
    }
    return _leftLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.textColor = KZSHColor929292;
        _textField.tintColor = KZSHColor929292;
        _textField.backgroundColor = KClearColor;
        _textField.font = kPingFangLight(14);
        _textField.delegate = self;
        NSString *placeholder = self.paramDic[@"placeholder"]?self.paramDic[@"placeholder"]:@"";
        _textField.placeholder = placeholder;
        _textField.secureTextEntry = ([self.paramDic[@"textFieldType"]integerValue] == ZSHTextFieldViewPwd);
        UIColor *placeholderTextColor = self.paramDic[@"placeholderTextColor"]?self.paramDic[@"placeholderTextColor"]:KZSHColor929292;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:placeholderTextColor}];
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

- (UIView *)bottomLine{
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = KZSHColor2A2A2A;
    }
    return _bottomLine;
}

#pragma action

- (void)updateViewWithParamDic:(NSDictionary *)paramDic{
    _leftLabel.text = paramDic[@"leftTitle"];
    _textField.placeholder = self.paramDic[@"placeholder"];
    _textField.secureTextEntry = ([self.paramDic[@"textFieldType"]integerValue] == ZSHTextFieldViewPwd);
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (self.textFieldChanged) {
        self.textFieldChanged(textField.text);
    }
}

@end
