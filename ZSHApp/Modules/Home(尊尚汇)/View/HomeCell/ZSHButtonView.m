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
    _showLabel = YES;
    
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kFromClassTypeValue >= FromMusicMenuToNoticeView ) {
             make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, kRealValue(45), 0));
        } else {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, kRealValue(20), 0));
        }
        
    }];
    

    _label = [ZSHBaseUIControl createLabelWithParamDic:self.paramDic];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.numberOfLines = 0;
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.and.width.mas_equalTo(self);
        if (kFromClassTypeValue >= FromMusicMenuToNoticeView ) {
            make.height.mas_equalTo(kRealValue(36));
        } else {
            make.height.mas_equalTo(kRealValue(12));
        }
    }];
}


- (void)setShowLabel:(BOOL)showLabel{
    _showLabel = showLabel;
    if (!_showLabel) {
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
        }];
        
        [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_imageView);
            make.left.and.width.mas_equalTo(0);
            make.height.mas_equalTo(kRealValue(0));
        }];
    }
}

@end
