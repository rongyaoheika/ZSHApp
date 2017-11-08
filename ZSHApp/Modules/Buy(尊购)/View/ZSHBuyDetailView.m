//
//  ZSHBuyDetailView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBuyDetailView.h"

@interface ZSHBuyDetailView()

@property (nonatomic,strong) UIButton       *selectBtn;
@property (nonatomic,strong) UIImageView    *goodsImageView;

@end

@implementation ZSHBuyDetailView

- (void)setup{
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn setImage:[UIImage imageNamed:@"sign_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"sign_press"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(12));
        make.height.mas_equalTo(kRealValue(12));
        make.left.mas_equalTo(self).offset(kRealValue(20));
    }];
    self.selectBtn = selectBtn;
    
    UIImage *image = [UIImage imageNamed:self.paramDic[@"goodsImageName"]];
    UIImageView *goodsImageView = [[UIImageView alloc]initWithImage:image];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectBtn.mas_right).offset(kRealValue(18));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    NSDictionary *titleLabelDic = @{@"text":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *goodsDetailLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    goodsDetailLabel.numberOfLines = 0;
    [self addSubview:goodsDetailLabel];
    [goodsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImageView.mas_right).offset(kRealValue(10));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.right.mas_equalTo(self).offset(-kRealValue(90));
        make.height.mas_equalTo(kRealValue(36));
    }];
    
    NSDictionary *priceLabelDic = @{@"text":@"¥ 49200",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsDetailLabel);
        make.top.mas_equalTo(goodsDetailLabel.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(goodsDetailLabel);
        make.height.mas_equalTo(kRealValue(12));
    }];
    
}

- (void)selectBtnAction:(UIButton *)selectBtn{
    
    
}

@end
