//
//  ZSHCollectCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCollectCell.h"

@interface ZSHCollectCell ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIImageView *activityImage;
@property (nonatomic, strong) UIButton    *similarBtn;

@end

@implementation ZSHCollectCell

- (void)setup {
    
    UIImageView *activityImage = [[UIImageView alloc]init];
    
    activityImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:activityImage];
    self.activityImage = activityImage;
    
    NSDictionary *titleLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    NSDictionary *contentLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    NSDictionary *similarBtnDic = @{@"title":@"找相似",@"font":kPingFangRegular(10)};
    UIButton *similarBtn = [ZSHBaseUIControl createBtnWithParamDic:similarBtnDic];
    similarBtn.layer.cornerRadius = 10.0;
    similarBtn.layer.masksToBounds = true;
    similarBtn.layer.borderWidth = 0.5;
    similarBtn.layer.borderColor = [KZSHColor929292 CGColor];
    [self addSubview:similarBtn];
    self.similarBtn = similarBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(kRealValue(20));
        make.size.mas_equalTo(CGSizeMake(kRealValue(60), kRealValue(60)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.left.mas_equalTo(self).offset(kRealValue(93));
        make.width.mas_equalTo(kRealValue(268));
        make.height.mas_equalTo(kRealValue(37));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(70.5));
        make.left.mas_equalTo(self).offset(kRealValue(93));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(13));
    }];
    
    [self.similarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(68.5));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.width.mas_equalTo(kRealValue(53.5));
        make.height.mas_equalTo(kRealValue(17.5));
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.activityImage.image = [UIImage imageNamed:dic[@"bgImageName"]];
    self.titleLabel.text = dic[@"TitleText"];
    self.contentLabel.text = dic[@"ContentText"];
    self.paramDic = dic;
    [self layoutIfNeeded];
    
}

@end
