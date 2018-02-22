//
//  ZSHLiveGiftPopCell.m
//  ZSHApp
//
//  Created by mac on 2018/2/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLiveGiftPopCell.h"

@interface ZSHLiveGiftPopCell ()

@property (nonatomic, strong) UILabel   *leftLB;
@property (nonatomic, strong) UILabel   *rightLB;

@end

@implementation ZSHLiveGiftPopCell

- (void)setup{
    NSDictionary *leftLBDic = @{@"text":@"1314",@"font":kPingFangRegular(14),@"textColor":KZSHColorF29E19,@"textAlignment":@(NSTextAlignmentCenter)};
    _leftLB = [ZSHBaseUIControl createLabelWithParamDic:leftLBDic];
    [self.contentView addSubview:_leftLB];
    [_leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(60));
        make.height.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    
    NSDictionary *rightLBDic = @{@"text":@"1314",@"font":kPingFangRegular(14)};
    _rightLB = [ZSHBaseUIControl createLabelWithParamDic:rightLBDic];
    [self.contentView addSubview:_rightLB];
    [_rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLB.mas_right);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    if (dic[@"midTitle"]) {
        _leftLB.text = dic[@"midTitle"];
        [_leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    } else {
        _leftLB.text = dic[@"leftTitle"];
        _rightLB.text = dic[@"rightTitle"];
    }
    
}

@end
