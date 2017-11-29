//
//  ZSHButtonView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHButtonView.h"

@implementation ZSHButtonView

- (void)setup{
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, kRealValue(20), 0));
    }];
    

    _label = [ZSHBaseUIControl createLabelWithParamDic:self.paramDic];
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.and.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(12));
    }];
}

@end
