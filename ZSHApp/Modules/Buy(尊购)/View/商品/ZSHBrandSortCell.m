//
//  ZSHBrandSortCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBrandSortCell.h"
#import "ZSHClassSubModel.h"

@interface ZSHBrandSortCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *brandImageView;

@end

@implementation ZSHBrandSortCell


#pragma mark - UI
- (void)setup
{
    _brandImageView = [[UIImageView alloc] init];
    _brandImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_brandImageView];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [_brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.zsh_width - kRealValue(20), self.zsh_height -kRealValue(25)));
    }];
}

#pragma mark - Setter Getter Methods
- (void)setSubItem:(ZSHClassSubModel *)subItem
{
    _subItem = subItem;
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:subItem.image_url]];
}

@end
