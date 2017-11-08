//
//  ZSHMemberCenterHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMemberCenterHeadView.h"
@interface ZSHMemberCenterHeadView ()

@property (nonatomic, strong) UIImageView   *headImageView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UIImageView   *bgImageView;


@end
@implementation ZSHMemberCenterHeadView

- (void)setup{
    
    _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weibo_head_image"]];
    [self addSubview:_headImageView];

     NSDictionary *nameLabelDic = @{@"text":@"普通会员",@"font":kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentCenter)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self addSubview:_nameLabel];
    
    _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_image_1"]];
    [self insertSubview:_bgImageView atIndex:0];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
        make.top.mas_equalTo(self).offset(kRealValue(40));
        make.centerX.mas_equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView.mas_bottom).offset(kRealValue(15));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(17));
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_headImageView).offset(kRealValue(20));
        make.size.mas_equalTo(CGSizeMake(kRealValue(310), kRealValue(140)));
    }];
}

@end
