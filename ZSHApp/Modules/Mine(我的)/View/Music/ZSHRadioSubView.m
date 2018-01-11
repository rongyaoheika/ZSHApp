//
//  ZSHRadioSubView.m
//  ZSHApp
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHRadioSubView.h"

@interface ZSHRadioSubView()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;

@end

@implementation ZSHRadioSubView

- (void)setup{
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.backgroundColor = [UIColor greenColor];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    NSDictionary *songNameLabelDic = @{@"text":@"说谎"};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:songNameLabelDic];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.left.mas_equalTo(_headImageView.mas_right).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    
    NSDictionary *detailNameLabelDic = @{@"text":@"林宥嘉  感官世界",@"font":kPingFangRegular(11)};
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailNameLabelDic];
    [self addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.bottom.mas_equalTo(self).offset(-kRealValue(10));
    }];
}

@end
