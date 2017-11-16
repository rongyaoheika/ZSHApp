//
//  ZSHTrainPassengerCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainPassengerCell.h"

@interface ZSHTrainPassengerCell()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *typeLabel;
@property (nonatomic, strong) UILabel  *IDValueLabel;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation ZSHTrainPassengerCell

- (void)setup {
    
    UIButton *selectBtn = [ZSHBaseUIControl createBtnWithParamDic:@{}];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_press"] forState:UIControlStateSelected];
    [selectBtn addTapBlock:^(UIButton *btn) {
        btn.selected = !btn.selected;
    }];
    [self addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"132456", @"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *typeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"132456", @"font":kPingFangRegular(14),@"textColor":KBlackColor,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    
    UILabel *IDValueLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"132456", @"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:IDValueLabel];
    self.IDValueLabel = IDValueLabel;
    
    UIButton *editBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":@"passenger_image_1",@"selectedImage":@"pay_btn_press"}];
    
    [editBtn addTapBlock:^(UIButton *btn) {
        RLog(@"tap edit button");
    }];
    [self addSubview:editBtn];
    self.editBtn = editBtn;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(24));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(12.5), kRealValue(12.5)));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(13.5));
        make.left.mas_equalTo(self).offset(kRealValue(40));
        make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(15)));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(13.5));;
        make.left.mas_equalTo(self).offset(kRealValue(90));
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(15)));
    }];
    
    
    [self.IDValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(36));;
        make.left.mas_equalTo(self).offset(kRealValue(40));
        make.size.mas_equalTo(CGSizeMake(kRealValue(120), kRealValue(12)));

    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(22.5));
        make.trailing.mas_equalTo(self).offset(kRealValue(-15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(13.5), kRealValue(15.5)));
    }];
    
    
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    self.nameLabel.text = dic[@"name"];
    self.typeLabel.text = dic[@"type"];
    self.IDValueLabel.text = dic[@"IDValue"];
    [self layoutIfNeeded];
}

@end
