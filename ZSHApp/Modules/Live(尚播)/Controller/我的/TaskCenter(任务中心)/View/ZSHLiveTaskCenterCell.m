//
//  ZSHLiveTaskCenterCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveTaskCenterCell.h"

@interface ZSHLiveTaskCenterCell()



@end

@implementation ZSHLiveTaskCenterCell

- (void)setup {
    
    UIImageView *activityImage = [[UIImageView alloc]init];
    activityImage.layer.cornerRadius = 10.0;
    [self addSubview:activityImage];
    self.activityImage = activityImage;
    
    NSDictionary *titleLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangMedium(15)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    NSDictionary *contentLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(12)};
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    NSDictionary *finishBtnDic = @{@"title":@"去看看",@"font":kPingFangRegular(11)};
    UIButton *finishBtn = [ZSHBaseUIControl  createBtnWithParamDic:finishBtnDic target:self action:@selector(normalAction:)];
    finishBtn.layer.borderColor = [KZSHColor929292 CGColor];
    [finishBtn.layer setMasksToBounds:YES];
    [finishBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [finishBtn.layer setBorderWidth:0];
    [finishBtn setTitle:@"已完成" forState:UIControlStateSelected];
    [self addSubview:finishBtn];
    self.finishBtn = finishBtn;
}

- (void)normalAction:(UIButton *)sender {
    if (sender.selected) {
        sender.layer.borderWidth = 0;
    } else {
        sender.layer.borderWidth = 0.5;
    }
    sender.selected = !sender.selected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14.5));
        make.left.mas_equalTo(self).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(30));
        make.height.mas_equalTo(kRealValue(30));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14));
        make.left.mas_equalTo(self).offset(kRealValue(60));
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(34));
        make.left.mas_equalTo(self).offset(kRealValue(60));
        make.width.mas_equalTo(kRealValue(300));
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(22));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.width.mas_equalTo(kRealValue(45));
        make.height.mas_equalTo(kRealValue(15));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.activityImage.image = [UIImage imageNamed:dic[@"bgImageName"]];
    self.titleLabel.text = dic[@"TitleText"];
    self.contentLabel.text = dic[@"ContentText"];
    self.finishBtn.titleLabel.text = dic[@"FinishTitle"];
    self.paramDic = dic;
    if (_finishBtn.selected) {
        _finishBtn.layer.borderWidth = 0.5;
    } else {
        _finishBtn.layer.borderWidth = 0;
    }
    [self layoutIfNeeded];
    
}


@end
