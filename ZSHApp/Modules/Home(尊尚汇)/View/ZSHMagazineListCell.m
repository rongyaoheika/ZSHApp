//
//  ZSHMagazineListCell.m
//  ZSHApp
//
//  Created by mac on 10/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHMagazineListCell.h"

@interface ZSHMagazineListCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@end

@implementation ZSHMagazineListCell

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(230);
    }];
    
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"瑞丽", @"font":kPingFangRegular(14)}];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"SHOWIMG"]]];
//    _titleLabel.text = dic[@"title"];
}

@end
