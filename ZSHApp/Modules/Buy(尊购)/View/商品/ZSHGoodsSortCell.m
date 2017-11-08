//
//  ZSHGoodsSortCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsSortCell.h"
#import "ZSHClassMainModel.h"
#import "ZSHClassSubModel.h"
#import <UIImageView+WebCache.h>

@interface ZSHGoodsSortCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* label */
@property (strong , nonatomic)UILabel *goodsTitleLabel;

@end


@implementation ZSHGoodsSortCell

#pragma mark - UI
- (void)setup
{
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodsImageView];
    
     NSDictionary *goodsTitleLabelDic = @{@"text":@"头盔",@"font":kPingFangLight(13),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    _goodsTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsTitleLabelDic];
    [self.contentView addSubview:_goodsTitleLabel];
    
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:5];
        make.size.mas_equalTo(CGSizeMake(self.zsh_width * 0.85, self.zsh_width * 0.85));
    }];
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_goodsImageView.mas_bottom)setOffset:5];
        make.width.mas_equalTo(_goodsImageView);
        make.centerX.mas_equalTo(self);
    }];
}


#pragma mark - Setter Getter Methods
- (void)setSubItem:(ZSHClassSubModel *)subItem
{
    _subItem = subItem;
    if ([subItem.image_url containsString:@"http"]) {
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:subItem.image_url]];
    } else {
        _goodsImageView.image = [UIImage imageNamed:subItem.image_url];
    }
    _goodsTitleLabel.text = subItem.goods_title;
}

@end
