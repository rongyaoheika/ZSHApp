//
//  ZSHPlayListHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPlayListHeadView.h"
#import "ZSHRankModel.h"
#import "ZSHRadioDetailModel.h"
@interface ZSHPlayListHeadView ()

@property (nonatomic, strong) UIImageView   *bgImageView;
@property (nonatomic, strong) UIImageView   *authorImageView;
@property (nonatomic, strong) UILabel       *songTypeLabel;
@property (nonatomic, strong) UIButton      *loveBtn;
@property (nonatomic, strong) UIButton      *commentBtn;
@property (nonatomic, strong) UIButton      *shareBtn;

@end

@implementation ZSHPlayListHeadView

- (void)setup{
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.image = [UIImage imageNamed:@"music_image_19"];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _authorImageView = [[UIImageView alloc]init];
    _authorImageView.image = [UIImage imageNamed:@"music_image_1"];
    [self addSubview:_authorImageView];
    [_authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(7.5));
        make.bottom.mas_equalTo(self).offset(-KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(120), kRealValue(110)));
    }];
    
     NSDictionary *titleLabelDic = @{@"text":@"聆听一首打开你心情的乡村音乐",@"font":kPingFangRegular(15)};
    _songTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    _songTypeLabel.numberOfLines = 0;
    [self addSubview:_songTypeLabel];
    [_songTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_authorImageView.mas_top).offset(kRealValue(12.5));
        make.left.mas_equalTo(_authorImageView.mas_right).offset(kRealValue(17.5));
        make.width.mas_equalTo(kRealValue(180));
    }];
    
    NSDictionary *loveBtnDic = @{@"title":@"9.8万",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"music_like"};
    _loveBtn = [ZSHBaseUIControl createBtnWithParamDic:loveBtnDic];
    [self addSubview:_loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_songTypeLabel);
        make.bottom.mas_equalTo(_authorImageView);
        make.width.mas_equalTo(kRealValue(60));
        make.height.mas_equalTo(kRealValue(25));
    }];
    
    NSDictionary *commentBtnDic = @{@"title":@"9.8万",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"music_discuss"};
    _commentBtn = [ZSHBaseUIControl createBtnWithParamDic:commentBtnDic];
    [self addSubview:_commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_loveBtn.mas_right).offset(kRealValue(18));
        make.bottom.mas_equalTo(_authorImageView);
        make.width.mas_equalTo(_loveBtn);
        make.height.mas_equalTo(_loveBtn);
    }];
    
    NSDictionary *shareBtnDic = @{@"title":@"9.8万",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"music_share"};
    _shareBtn = [ZSHBaseUIControl createBtnWithParamDic:shareBtnDic];
    [self addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentBtn.mas_right).offset(kRealValue(18));
        make.bottom.mas_equalTo(_authorImageView);
        make.width.mas_equalTo(_loveBtn);
        make.height.mas_equalTo(_loveBtn);
    }];
}

- (void)updateViewWithParamDic:(NSDictionary *)paramDic{
     _bgImageView.image = [UIImage imageNamed:@"music_image_19"];
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:paramDic[@"headImage"]] placeholderImage:[UIImage imageNamed:@"music_image_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _bgImageView.image = [image applyDarkEffect];
        }
    }];
}

@end
