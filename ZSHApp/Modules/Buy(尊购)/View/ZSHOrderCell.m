//
//  ZSHOrderCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderCell.h"


@interface ZSHOrderCell()

@property (nonatomic, strong)UIImageView *goodsImageView;
@property (nonatomic, strong)UILabel     *goodsDescLabel;
@property (nonatomic, strong)UILabel     *resultLabel;
@property (nonatomic, strong)UIView      *bottmView;
@property (nonatomic, strong)UILabel     *bottomLabel;

@end

@implementation ZSHOrderCell

- (void)setup{
    //商品图片
    UIImage *image = [UIImage imageNamed:@"buy_watch"];
    UIImageView *goodsImageView = [[UIImageView alloc]initWithImage:image];

    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(10));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(37));
        make.height.mas_equalTo(kRealValue(64));
    }];
    self.goodsImageView = goodsImageView;
    
    //商品详情
    NSDictionary *goodsDescLabelDic = @{@"text":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"font": kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *goodsDescLabel = [ZSHBaseUIControl createLabelWithParamDic:goodsDescLabelDic];
    goodsDescLabel.numberOfLines = 0;
    [goodsDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:goodsDescLabel];
    [goodsDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsImageView);
        make.left.mas_equalTo(goodsImageView.mas_right).offset(kRealValue(10));
        make.width.mas_equalTo(kRealValue(157));
        make.height.mas_equalTo(kRealValue(14));
    }];
    self.goodsDescLabel = goodsDescLabel;
    
    //底部控件容器
    UIView *bottmView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:bottmView];
    [bottmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsDescLabel);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(40));
        make.top.mas_equalTo(goodsDescLabel.mas_bottom).offset(kRealValue(10));
    }];
    self.bottmView = bottmView;
    
    //底部文字或按钮
    NSDictionary *bottomLabelDic = @{@"text":@"共1件商品 实付款¥49200",@"font": kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomLabelDic];
    [bottmView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottmView);
        make.left.mas_equalTo(bottmView);
        make.height.mas_equalTo(kRealValue(12));
        make.right.mas_equalTo(bottmView);
    }];
    self.bottomLabel = bottomLabel;
    
    NSDictionary *cancelBtnDic = @{@"title":@"取消订单",@"titleColor":KZSHColor929292,@"font":kPingFangLight(6),@"backgroundColor":KClearColor};
    UIButton *cancelBtn = [ZSHBaseUIControl createBtnWithParamDic:cancelBtnDic];
    cancelBtn.frame = CGRectZero;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 10.0;
    cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"979797"].CGColor;
    [bottmView addSubview:cancelBtn];
    
    //右侧结果
    NSDictionary *resultLabelDic = @{@"text":@"已发货",@"font": kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    _resultLabel = [ZSHBaseUIControl createLabelWithParamDic:resultLabelDic];
    [self addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsDescLabel);
        make.right.mas_equalTo(self).offset(-kRealValue(20));
        make.height.mas_equalTo(kRealValue(17));
        make.width.mas_equalTo(kRealValue(50));
    }];
}

// 酒吧
- (void)updateCellWithBarorder:(ZSHBarorderOrderModel *)model {
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMAGES]];
    [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(10));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(80));
        make.height.mas_equalTo(kRealValue(64));
    }];
    CGSize detailLabelSize = [model.BARDETTITLE boundingRectWithSize:CGSizeMake(kRealValue(157), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.goodsDescLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    [self.goodsDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(detailLabelSize.height);
    }];
    
    self.goodsDescLabel.text = model.BARDETTITLE;
    self.bottomLabel.text = NSStringFormat(@"实付款￥%@", model.ORDERMONEY);
    
    if ([model.ORDERSTATUS isEqualToString:@"0040001"]) {
        _resultLabel.text = @"待付款";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040002"]) {
        _resultLabel.text = @"待收货";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040003"]) {
        _resultLabel.text = @"待评价";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040004"]) {
        _resultLabel.text = @"已完成";
    }
    

}

// KTV
- (void)updateCellWithKtv:(ZSHKtvOrderModel *)model {
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMAGES]];
    [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(10));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(80));
        make.height.mas_equalTo(kRealValue(64));
    }];
    CGSize detailLabelSize = [model.KTVDETTITLE boundingRectWithSize:CGSizeMake(kRealValue(157), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.goodsDescLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    [self.goodsDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(detailLabelSize.height);
    }];
    
    self.goodsDescLabel.text = model.KTVDETTITLE;
    self.bottomLabel.text = NSStringFormat(@"实付款￥%@", model.ORDERMONEY);
    
    if ([model.ORDERSTATUS isEqualToString:@"0040001"]) {
        _resultLabel.text = @"待付款";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040002"]) {
        _resultLabel.text = @"待收货";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040003"]) {
        _resultLabel.text = @"待评价";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040004"]) {
        _resultLabel.text = @"已完成";
    }
}
// 酒店
- (void)updateCellWithHotel:(ZSHHotelOrderModel *)model {
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMAGES]];
    [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(10));
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(80));
        make.height.mas_equalTo(kRealValue(64));
    }];
    CGSize detailLabelSize = [model.HOTELDETNAME boundingRectWithSize:CGSizeMake(kRealValue(157), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.goodsDescLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    [self.goodsDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(detailLabelSize.height);
    }];
    
    self.goodsDescLabel.text = model.HOTELDETNAME;
    self.bottomLabel.text = NSStringFormat(@"实付款￥%@", model.ORDERMONEY);
    
    if ([model.ORDERSTATUS isEqualToString:@"0040001"]) {
        _resultLabel.text = @"待付款";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040002"]) {
        _resultLabel.text = @"待收货";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040003"]) {
        _resultLabel.text = @"待评价";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040004"]) {
        _resultLabel.text = @"已完成";
    }

}

- (void)updateCellWithModel:(ZSHGoodOrderModel *)model{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.PROSHOWIMG]];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    CGSize detailLabelSize = [model.PROTITLE boundingRectWithSize:CGSizeMake(kRealValue(157), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.goodsDescLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    [self.goodsDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.height.mas_equalTo(detailLabelSize.height);
    }];
    
    
    self.goodsDescLabel.text = model.PROTITLE;
    self.bottomLabel.text = NSStringFormat(@"共%@件商品 实付款￥%@", model.PRODUCTCOUNT, model.ORDERMONEY);
    
    if ([model.ORDERSTATUS isEqualToString:@"0040001"]) {
        _resultLabel.text = @"待付款";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040002"]) {
        _resultLabel.text = @"待收货";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040003"]) {
        _resultLabel.text = @"待评价";
    } else if ([model.ORDERSTATUS isEqualToString:@"0040004"]) {
        _resultLabel.text = @"已完成";
    }
}

+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model{
    ZSHOrderCell *cell = [[ZSHOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell updateCellWithModel:model];
    [cell layoutIfNeeded];
    return (CGRectGetMaxY(cell.bottmView.frame) + kRealValue(10));
}

@end
