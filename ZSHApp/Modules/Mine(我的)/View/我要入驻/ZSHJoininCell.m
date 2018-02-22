//
//  ZSHJoininCell.m
//  ZSHApp
//
//  Created by mac on 12/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHJoininCell.h"

@interface ZSHJoininCell ()

@property (nonatomic, strong) UIImageView  *headView;
@property (nonatomic, strong) UILabel      *headLabel;

@end

@implementation ZSHJoininCell

- (void)setup {
    _headView = [[UIImageView alloc] init];
    [self addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    _headLabel = [ZSHBaseUIControl createLabelWithParamDic:@{}];
    [self addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headView);
        make.left.mas_equalTo(_headView.mas_right).offset(KLeftMargin);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(16);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _headView.image = [UIImage imageNamed:dic[@"image"]];
    _headLabel.text = dic[@"title"];
}

@end
