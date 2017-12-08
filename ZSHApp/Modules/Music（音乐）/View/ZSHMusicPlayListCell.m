//
//  ZSHMusicPlayListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicPlayListCell.h"

@interface ZSHMusicPlayListCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *songNameLabel;
@property (nonatomic, strong) UILabel     *singerNameLabel;

@end

@implementation ZSHMusicPlayListCell

- (void)setup{
    
    _headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    NSDictionary *songNameLabelDic = @{@"text":@"回忆杀，不一样的三国《憨逗军团》",@"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    _songNameLabel = [ZSHBaseUIControl createLabelWithParamDic:songNameLabelDic];
    [self.contentView addSubview:_songNameLabel];
    [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView);
//        make.left.mas_equalTo(_headImageView.mas_right).offset(KLeftMargin);
    }];
    
}

@end
