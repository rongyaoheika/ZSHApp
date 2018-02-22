//
//  ZSHCabinetCollectionCell.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHCabinetCollectionCell.h"

@interface ZSHCabinetCollectionCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@end

@implementation ZSHCabinetCollectionCell

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(14)}];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _imageView.image = [UIImage imageNamed:dic[@"image"]];
    _titleLabel.text = dic[@"title"];
}

@end
