//
//  ZSHHomeSubListCell.m
//  ZSHApp
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHHomeSubListCell.h"

@interface ZSHHomeSubListCell ()

@property (nonatomic, strong) UIImageView   *leftIV;
@property (nonatomic, strong) UILabel       *textLB;


@end

@implementation ZSHHomeSubListCell

- (void)setup{
    
    _leftIV = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftIV];
    [_leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(7.5));
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];
    
    NSDictionary *titleLabelDic = @{@"text":@"",@"font":kPingFangMedium(15)};
    _textLB = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_textLB];
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftIV.mas_right).offset(kRealValue(7.0));
        make.height.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    [_leftIV setImage:[UIImage imageNamed:dic[@"imageName"]]];
    [_textLB setText:dic[@"titleText"]];
}

@end
