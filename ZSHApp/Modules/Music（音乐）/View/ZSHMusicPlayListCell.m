//
//  ZSHMusicPlayListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicPlayListCell.h"

@interface ZSHMusicPlayListCell()

@property (nonatomic, strong) UILabel     *detailLabel;

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
    
    NSDictionary *songNameLabelDic = @{@"text":@"说谎"};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:songNameLabelDic];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.left.mas_equalTo(_headImageView.mas_right).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    
    NSDictionary *detailNameLabelDic = @{@"text":@"林宥嘉  感官世界",@"font":kPingFangRegular(11)};
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailNameLabelDic];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.bottom.mas_equalTo(self).offset(-kRealValue(10));
    }];
}

- (void)updateCellWithModel:(ZSHRankModel *)model{
    if (model.thumb) {//电台
         [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
         _detailLabel.text = model.author;
    } else {
        NSArray *array = [model.pic_small componentsSeparatedByString:@"@"];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        _detailLabel.text = [NSString stringWithFormat:@"%@  %@",model.author,model.album_title];
    }
    
    _titleLabel.text = model.title;
    
}

- (void)updateCellWithRadioModel:(ZSHRadioModel *)radioModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:radioModel.thumb]];
    _titleLabel.text = radioModel.name;
    _detailLabel.text = [NSString stringWithFormat:@"当前热度为%@万",radioModel.value];
}


- (void)updateCellWithSingerModel:(ZSHSingerModel *)singerModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:singerModel.avatar_small]];
    _titleLabel.text = singerModel.name;
    _detailLabel.text = @"";
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
    }];
}

- (void)updateCellWithLibraryRankModel:(ZSHRankModel *)rankModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:rankModel.pic_big]];
    _titleLabel.text = rankModel.title;
    _detailLabel.text = [NSString stringWithFormat:@"%@  %@",rankModel.author,rankModel.album_title];
}

@end
