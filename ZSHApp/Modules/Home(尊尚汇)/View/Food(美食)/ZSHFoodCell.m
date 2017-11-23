//
//  ZSHFoodCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodCell.h"
#import "TggStarEvaluationView.h"
#import "CWStarRateView.h"
#import "ZSHFoodModel.h"
@interface ZSHFoodCell()

@property (nonatomic, strong) UIImageView               *hotelmageView;
@property (nonatomic, strong) UILabel                   *hotelDescLabel;
@property (nonatomic, strong) UILabel                   *foodNameLabel;
@property (nonatomic, strong) UILabel                   *distanceLabel;
@property (nonatomic, strong) UILabel                   *commentLabel;
//@property (nonatomic, strong) TggStarEvaluationView     *starView;
@property (nonatomic, strong) CWStarRateView            *starView;
@property (nonatomic, strong) UILabel                   *priceLabel;

@end

@implementation ZSHFoodCell

- (void)setup{
    //餐厅图片
    UIImage *image = [UIImage imageNamed:@"hotel_image"];
    _hotelmageView = [[UIImageView alloc]initWithImage:image];
    [self.contentView addSubview:_hotelmageView];
    
    //餐厅价格
    NSDictionary *priceLabelDic = @{@"text":@"¥399／位",@"font": kPingFangMedium(17)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
    //餐厅地址
    NSDictionary *foodNameLabelDic = @{@"text":@"三亚市天涯区黄山路94号",@"font": kPingFangMedium(12)};
    _foodNameLabel = [ZSHBaseUIControl createLabelWithParamDic:foodNameLabelDic];
    [self.contentView addSubview:_foodNameLabel];
    
    //星星评价
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(kRealValue(230), kRealValue(217), kRealValue(80), kRealValue(12)) numberOfStars:5];
    _starView.scorePercent = 0.45;
    _starView.allowIncompleteStar = YES;
    _starView.hasAnimation = YES;
    _starView.allowUserTap = NO;
    [self.contentView addSubview:_starView];
    
    //餐厅评价
    NSDictionary *commentLabelDic = @{@"text":@"（120条评价）",@"font": kPingFangRegular(11)};
    _commentLabel = [ZSHBaseUIControl createLabelWithParamDic:commentLabelDic];
    [self.contentView addSubview:_commentLabel];
    _commentLabel.frame = CGRectMake(kRealValue(kRealValue(315)), kRealValue(217), kRealValue(74), kRealValue(12));
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(175));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hotelmageView.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_hotelmageView);
        make.height.mas_equalTo(kRealValue(17));
        make.right.mas_equalTo(_hotelmageView);
    }];
    
    [_foodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(_hotelmageView);
        make.height.mas_equalTo(kRealValue(12));
        make.width.mas_equalTo(KScreenWidth*0.5);
    }];
    
}

- (void)updateCellWithModel:(ZSHFoodModel *)model{
    
    [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMAGES]];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@／位",model.SHOPPRICE];
    _foodNameLabel.text = model.SHOPNAMES;
    _commentLabel.text = [NSString stringWithFormat:@"（%@条评价）",model.SHOPEVACOUNT];
    _starView.scorePercent = [model.SHOPEVALUATE floatValue]/5.0;

}

- (CGFloat)rowHeightWithCellModel:(ZSHFoodModel *)model{
    [self updateCellWithModel:model];
    [self layoutIfNeeded];
    CGFloat detailLabelY = CGRectGetMaxY(self.foodNameLabel.frame);
    return detailLabelY + kRealValue(20);
}

@end
