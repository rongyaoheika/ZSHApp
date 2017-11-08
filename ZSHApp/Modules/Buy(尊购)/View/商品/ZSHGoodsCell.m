//
//  ZSHGoodsCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsCell.h"
#import "ZSHGoodModel.h"

@interface ZSHGoodsCell()

/* 图片 */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 标题 */
@property (strong , nonatomic)UILabel *goodsLabel;
/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;

@end

@implementation ZSHGoodsCell

#pragma mark - Intial

- (void)setup
{
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_goodsImageView];
    
    NSDictionary *goodsLabelDic = @{@"text":@"杰克琼斯男鞋低帮系带休闲简约百搭舒适板鞋TURBO",@"font":kPingFangLight(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _goodsLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsLabelDic];
    _goodsLabel.numberOfLines = 2;
    [self addSubview:_goodsLabel];
    
     NSDictionary *priceLabelDic = @{@"text":@"¥599",@"font":kPingFangLight(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self addSubview:_priceLabel];
    
    NSDictionary *sameButtonDic = @{@"title":@"特价",@"titleColor":KWhiteColor,@"font":kPingFangRegular(10),@"backgroundColor":[UIColor colorWithHexString:@"FF3F2B"]};
    _sameButton = [ZSHBaseUIControl createBtnWithParamDic:sameButtonDic];
    _sameButton.layer.cornerRadius = kRealValue(2.5);
    [_sameButton addTarget:self action:@selector(lookSameGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sameButton];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (self.cellType == ZSHCollectionViewCellType) {
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kRealValue(185) , kRealValue(180)));
        }];
        
        [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_goodsImageView);
            make.width.mas_equalTo(kRealValue(150));
            make.height.mas_equalTo(kRealValue(36));
            make.top.mas_equalTo(_goodsImageView.mas_bottom).offset(kRealValue(16));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_goodsLabel);
            make.width.mas_equalTo(kRealValue(50));
            make.top.mas_equalTo(_goodsLabel.mas_bottom).offset(kRealValue(10));
            make.height.mas_equalTo(kRealValue(12));
        }];
        
        [_sameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsLabel);
            make.top.mas_equalTo(_priceLabel);
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(12)));
        }];
    } else {
        [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.top.mas_equalTo(self).offset(10);
            make.width.mas_equalTo(kRealValue(100.5));
            make.bottom.mas_equalTo(self).offset(-10);
        }];
        
        [_goodsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsImageView.mas_right).offset(15);
            make.right.mas_equalTo(self).offset(-kRealValue(40));
            make.height.mas_equalTo(kRealValue(36));
            make.top.mas_equalTo(_goodsImageView);
        }];
        
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsLabel);
            make.width.mas_equalTo(kRealValue(50));
            make.top.mas_equalTo(_goodsLabel.mas_bottom).offset(kRealValue(20));
            make.height.mas_equalTo(kRealValue(12));
        }];
        
        [_sameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            make.top.mas_equalTo(_priceLabel);
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(12)));
        }];
    }
    
}

#pragma mark - Setter Getter Methods

- (void)setGoodModel:(ZSHGoodModel *)goodModel{
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image_url]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.1f",[goodModel.price floatValue]];
    _goodsLabel.text = goodModel.main_title;
}

#pragma mark - 点击事件
- (void)lookSameGoods{
    !_lookSameBlock ? : _lookSameBlock();
}

- (void)setCellType:(ZSHCellType)cellType{
    _cellType = cellType;
    [self layoutSubviews];
}

@end
