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
    _leftIV.contentMode =  UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_leftIV];
    [_leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(12.5));
        make.centerY.mas_equalTo(self);
    }];
    
    NSDictionary *titleLabelDic = @{@"text":@"",@"font":kPingFangMedium(15)};
    _textLB = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_textLB];
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(45));
        make.height.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    UIImage *leftImage = [UIImage imageNamed:dic[@"imageName"]];
    _leftIV.size = leftImage.size;
    _leftIV.image = leftImage;
    [_textLB setText:dic[@"titleText"]];
}

@end
