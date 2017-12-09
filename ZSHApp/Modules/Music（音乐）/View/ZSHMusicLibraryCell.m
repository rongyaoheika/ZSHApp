//
//  ZSHMusicLibraryCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLibraryCell.h"
#import "ZSHRankModel.h"
@implementation ZSHMusicLibraryCell

- (void)setup{
    
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:@"home_magazine1"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(110));
    }];
    
     NSDictionary *paramDic = @{@"text":@"聆听一首打开你心情\n的乡村音乐",@"font":kPingFangRegular(12)};
    _label = [ZSHBaseUIControl createLabelWithParamDic:paramDic];
    _label.numberOfLines = 0;
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(kRealValue(7));
        make.left.mas_equalTo(_imageView).offset(2.5);
        make.right.mas_equalTo(_imageView).offset(-2.5);
        make.height.mas_equalTo(kRealValue(kRealValue(36)));
    }];
}

- (void)updateCellWithModel:(ZSHRankModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.pic_big]];
    _label.text = model.title;
     
}


@end
