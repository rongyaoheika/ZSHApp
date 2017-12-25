//
//  ZSHCardCustomizedFirst.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardCustomizedFirst.h"
#import "LXScollTitleView.h"
#import "ZSHTextFieldCellView.h"
@interface ZSHCardCustomizedFirst ()

@property (nonatomic, strong) UIView                    *labelView;
@property (nonatomic, strong) UIImageView               *textFieldView;

@property (nonatomic, strong) UILabel          *promptLabel;
@property (nonatomic, strong) UITextField      *signTextField;
@property (nonatomic, strong) UIView           *bottomView;
@property (nonatomic, strong) UIImageView      *bottomImageView;
@property (nonatomic, strong) UILabel          *bottomPromptLabel;
@property (nonatomic, strong) UIScrollView     *bottomScrollView;

@end


@implementation ZSHCardCustomizedFirst

- (void)setup{
    
    //姓名
    _labelView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seg_two_bg"]];
    [_labelView addSubview:bgIV];
    
    [self addSubview:_labelView];
    
    NSArray *labelTitleArr = @[@"姓",@"名"];
    for (int i = 0; i<labelTitleArr.count; i++) {
        NSDictionary *titleLabelDic = @{@"text":labelTitleArr[i],@"font":kPingFangLight(15),@"textAlignment":@(NSTextAlignmentCenter)};
        UILabel *label = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
        [_labelView addSubview:label];
    }
    
    //提示文字
    NSDictionary *promptLabelDic = @{@"text":@"图示：请输入您要定制的姓名的拼音大写，如（成龙）",@"font":kPingFangLight(11)};
    _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptLabelDic];
    _promptLabel.numberOfLines = 0;
    [self addSubview:_promptLabel];
    
    //输入姓名textField
    _textFieldView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _textFieldView.userInteractionEnabled = YES;
    [_textFieldView setImage:[UIImage imageNamed:@"seg_two_bg"]];
    [self addSubview:_textFieldView];
    
    NSArray *placeHolderArr = @[@"CHENG",@"LONG"];
    NSArray *textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser)];
    for (int i = 0; i<placeHolderArr.count; i++) {
        NSDictionary *textFieldDic = @{@"placeholder":placeHolderArr[i],@"textFieldType":textFieldTypeArr[i]};
         ZSHTextFieldCellView *textField = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectZero paramDic:textFieldDic];
        textField.userInteractionEnabled = YES;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:placeHolderArr[i] attributes:@{NSForegroundColorAttributeName:KZSHColor929292,NSFontAttributeName:kPingFangLight(15), NSParagraphStyleAttributeName:style}];
        textField.textField.attributedPlaceholder = attri;
        textField.tag = 112311+i;
        textField.textFieldChanged = ^(NSString *text, NSInteger tag) {
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:NSStringFormat(@"CardCustom%zd",tag)];
        };
        [_textFieldView addSubview:textField];
    }
    
    //图文
    _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    _bottomView.backgroundColor = KZSHColor0B0B0B;
    [self addSubview:_bottomView];
    
    _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"glory_card_little"]];
    [_bottomView addSubview:_bottomImageView];
    
    NSDictionary *bottomPromptLabelDic = @{@"text":@"85%的用户选择为自己定制一张专属的荣耀黑卡",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentCenter)};
    _bottomPromptLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomPromptLabelDic];
    [_bottomView addSubview:_bottomPromptLabel];
    
    [self layoutIfNeeded];
    
    //姓名
    [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(199.5), kRealValue(30)));
    }];
    
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_labelView);
    }];
    
    int i = 0;
    for (UILabel * label in _labelView.subviews) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_labelView).offset(kRealValue(99.5)*i);
            make.top.mas_equalTo(_labelView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
        }];
        i++;
    }
    
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(43));
        make.right.mas_equalTo(self).offset(-kRealValue(43));
        make.top.mas_equalTo(_labelView.mas_bottom).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(17));
    }];
    
    
    [_textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_promptLabel.mas_bottom).offset(kRealValue(20));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(199.5), kRealValue(30)));
    }];
    
    int j = 0;
    for (ZSHTextFieldCellView * textField in _textFieldView.subviews) {
        textField.userInteractionEnabled = YES;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_textFieldView).offset(kRealValue(99.5)*j);
            make.top.mas_equalTo(_textFieldView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
        }];
        j++;
    }
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textFieldView.mas_bottom).offset(kRealValue(20));
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

- (void)layoutSubviews{
    [super layoutSubviews];
   
    
}

@end
