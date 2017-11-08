//
//  ZSHIntegralBillCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHIntegralBillCell.h"

@interface ZSHIntegralBillCell()

@property (nonatomic, strong)UIImageView *goodsImageView;
@property (nonatomic, strong)UILabel     *goodsDescLabel;
@property (nonatomic, strong)UILabel     *dateLabel;
@property (nonatomic, strong)UILabel     *integralNumLabel;
@property (nonatomic, strong)UILabel     *bottomLabel;

@end

@implementation ZSHIntegralBillCell

- (void)setup{
    //左侧商品图片
    UIImageView *goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"good_watch"]];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(30));
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.width.mas_equalTo(kRealValue(37));
        make.height.mas_equalTo(kRealValue(64));
    }];
    self.goodsImageView = goodsImageView;
    
    //商品详情
    NSDictionary *goodsDetailLabelDic = @{@"text":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *goodsDetailLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsDetailLabelDic];
    goodsDetailLabel.numberOfLines = 0;
    [self addSubview:goodsDetailLabel];
    [goodsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImageView.mas_right).offset(kRealValue(26));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.right.mas_equalTo(self).offset(-kRealValue(120));
        make.height.mas_equalTo(kRealValue(36));
    }];
    self.goodsDescLabel = goodsDetailLabel;
    
    //日期
    NSDictionary *dateLabelDic = @{@"text":@"10-03",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(15));
        make.top.mas_equalTo(goodsDetailLabel);
        make.width.mas_equalTo(kRealValue(35));
        make.height.mas_equalTo(kRealValue(12));
    }];
    self.dateLabel = dateLabel;
    
    //购物送积分
    NSDictionary *bottomLabelDic = @{@"text":@"购物送积分",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomLabelDic];
    [self addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsDetailLabel);
        make.top.mas_equalTo(goodsDetailLabel.mas_bottom).offset(kRealValue(8));
        make.width.mas_equalTo(goodsDetailLabel);
        make.height.mas_equalTo(kRealValue(12));
    }];
    self.bottomLabel = bottomLabel;
    
    //积分数量
    NSDictionary *integralNumLabelDic = @{@"text":@"+17",@"font":kPingFangMedium(10),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    UILabel *integralNumLabel = [ZSHBaseUIControl createLabelWithParamDic:integralNumLabelDic];
    [self addSubview:integralNumLabel];
    [integralNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(dateLabel);
        make.top.mas_equalTo(bottomLabel);
        make.width.mas_equalTo(kRealValue(30));
        make.height.mas_equalTo(kRealValue(12));
    }];
    self.integralNumLabel = integralNumLabel;
    
}

- (void)updateCellWithModel:(ZSHIntegalModel *)model{
    UIImage *image = [UIImage imageNamed:model.imageName];
    self.goodsImageView.image = image;
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(30));
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.width.mas_equalTo(kRealValue(37));
        make.height.mas_equalTo(kRealValue(64));
    }];
    
    self.goodsDescLabel.text = model.descText;
    self.bottomLabel.text = model.bottomText;
    self.dateLabel.text = model.dateText;
    self.integralNumLabel.text = model.integralCount;
    
    CGSize detailLabelSize = [model.descText boundingRectWithSize:CGSizeMake(kRealValue(157), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.goodsDescLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    [self.goodsDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(kRealValue(26));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(detailLabelSize.height);
    }];
}

+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model{
    ZSHIntegralBillCell *cell = [[ZSHIntegralBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell updateCellWithModel:model];
    [cell layoutIfNeeded];
    return (CGRectGetMaxY(cell.bottomLabel.frame) + kRealValue(24));
}


@end
