//
//  ZSHGoodsDetailCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailCell.h"
#import "ZSHGoodModel.h"

@interface ZSHGoodsDetailCell()

/* 图片 */
@property (nonatomic, strong) UIImageView   *goodsImageView;
/* 标题 */
@property (nonatomic, strong) UILabel       *goodsLabel;
/* 副标题 */
@property (nonatomic, strong) UILabel       *goodsSubLabel;
/* 价格 */
@property (nonatomic, strong) UILabel       *priceLabel;
/* 数量 */
@property (nonatomic, strong) UILabel       *countLabel;

@end


@implementation ZSHGoodsDetailCell

- (void)setup
{
    _goodsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_watch_little"]];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_goodsImageView];
    
    NSDictionary *goodsLabelDic = @{@"text":@"卡地亚Cartier伦敦SOLO手表 石英男表",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _goodsLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsLabelDic];
    _goodsLabel.numberOfLines = 0;
    [self addSubview:_goodsLabel];
    
    NSDictionary *goodsSubLabelDic = @{@"text":@"W6701005",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _goodsSubLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsSubLabelDic];
    [self addSubview:_goodsSubLabel];
    
    NSDictionary *priceLabelDic = @{@"text":@"¥49200",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self addSubview:_priceLabel];
    
    NSDictionary *countLabelDic = @{@"text":@"X1",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    _countLabel = [ZSHBaseUIControl createLabelWithParamDic:countLabelDic];
    [self addSubview:_countLabel];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(18));
        make.size.mas_equalTo(CGSizeMake(kRealValue(37) , kRealValue(64)));
    }];
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodsImageView.mas_right).offset(kRealValue(20));
        make.right.mas_equalTo(self).offset(-kRealValue(30));
        make.height.mas_equalTo(kRealValue(14));
        make.top.mas_equalTo(self).offset(kRealValue(20));
    }];
    
    [_goodsSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodsLabel);
        make.right.mas_equalTo(_goodsLabel);
        make.height.mas_equalTo(_goodsLabel);
        make.top.mas_equalTo(_goodsLabel.mas_bottom).offset(kRealValue(10));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodsLabel);
        make.right.mas_equalTo(_goodsLabel);
        make.top.mas_equalTo(_goodsSubLabel.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRealValue(20));
        make.right.mas_equalTo(-KLeftMargin);
        make.top.mas_equalTo(_priceLabel);
        make.height.mas_equalTo(kRealValue(12));
    }];
}

#pragma mark - Setter Getter Methods

- (void)updateCellWithModel:(ZSHGoodModel *)goodModel{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image_url]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.1f",[goodModel.price floatValue]];
    _goodsLabel.text = goodModel.main_title;
    if (self.fromClassType == ZSHFromOrderDetailVCToGoodsDetailCell) {
        _countLabel.hidden = YES;
    }
}

- (void)setFromClassType:(NSInteger)fromClassType{
    _fromClassType = fromClassType;
    if (fromClassType == ZSHFromOrderDetailVCToGoodsDetailCell) {
        _countLabel.hidden = YES;
    }
}

@end
