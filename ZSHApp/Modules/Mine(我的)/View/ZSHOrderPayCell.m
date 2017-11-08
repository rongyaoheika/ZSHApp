//
//  ZSHOrderPayCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderPayCell.h"

@interface ZSHOrderPayCell ()

@property (nonatomic, strong) UIImageView   *payImgeView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIButton      *selectBtn;

@end

@implementation ZSHOrderPayCell

- (void)setup{
    
    _payImgeView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_payImgeView];

    NSDictionary *titleLabelDic = @{@"text":@"微信支付",@"font":kPingFangLight(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_titleLabel];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_payImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(20), kRealValue(20)));
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(_payImgeView.mas_right).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(kRealValue(100));
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(17.5), kRealValue(17.5)));
        make.centerY.mas_equalTo(self);
    }];
}

- (void)selectBtnAction:(UIButton *)selectBtn{
    selectBtn.selected = !selectBtn.selected;
    RLog(@"点击btn的tag==%ld",(long)selectBtn.tag);
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    _titleLabel.text = dic[@"title"];
    _payImgeView.image = [UIImage imageNamed:dic[@"payImage"]];
    _selectBtn.tag = [dic[@"btnTag"]integerValue];
    [_selectBtn setImage:[UIImage imageNamed:dic[@"btnNormalImage"]]  forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:dic[@"btnPressImage"]] forState:UIControlStateSelected];
}

@end
