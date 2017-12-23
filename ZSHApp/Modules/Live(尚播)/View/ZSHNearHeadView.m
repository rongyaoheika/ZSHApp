//
//  ZSHNearHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHNearHeadView.h"

@implementation ZSHNearHeadView

- (void)setup{
    
    UIImage *screenImage = [UIImage imageNamed:@"live_screen"];
    UIImageView *screenImageView = [[UIImageView alloc]initWithImage:screenImage];
    [self addSubview:screenImageView];
    [screenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(screenImage.size);
    }];
    
    NSDictionary *textLabelDic = @{@"text":@"筛选播主",@"font":kPingFangLight(12)};
    UILabel *textLabel = [ZSHBaseUIControl createLabelWithParamDic:textLabelDic];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(screenImageView.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(60));
        make.centerY.mas_equalTo(self);
    }];
    
    UIButton *accessoryBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [accessoryBtn setImage:[UIImage imageNamed:@"mine_next"] forState:UIControlStateNormal];
    [accessoryBtn addTarget:self action:@selector(searchLiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessoryBtn];
    [accessoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(44));
        make.height.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)searchLiveAction:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

@end
