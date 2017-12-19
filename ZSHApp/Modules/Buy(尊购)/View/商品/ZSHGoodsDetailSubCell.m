//
//  ZSHGoodsDeatailCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailSubCell.h"
#import "ZSHGoodsDetailModel.h"

@interface ZSHGoodsDetailSubCell()

@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIImageView         *detailImageView;
@property (nonatomic, assign) CGFloat             contentLabelH;  //文本高度
@end

@implementation ZSHGoodsDetailSubCell

- (void)setup{
    
    self.detailImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.detailImageView ];
    
    NSDictionary *detailLabelDic = @{@"text":@"#之前就来过这里，环境很不错，作为我来讲对这种牛排其实是一点都不感冒[撇嘴]，朋友的盛情邀请实在是不好意思拒绝，索性就来瞧瞧，不来不知道，吃过之后给我留下不错的印象，这次来也是带几个朋友来，给他们各种吹嘘这里的好东西多好之类的！！还好吃过之后大家都没有失望的表情。。。总之以后回多多光临的，页希望大家来哦",@"font":kPingFangRegular(11)};
    self.detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.detailLabel];
    
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(225));
        make.width.mas_equalTo(KScreenWidth);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailImageView.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-kRealValue(15));
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];

}

- (void)updateCellWithModel:(ZSHGoodsDetailModel *)model{
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:model.detailPicture]];
    self.detailLabel.text = model.detailText;
}

- (CGFloat)rowHeightWithCellModel:(ZSHGoodsDetailModel *)model{
    kWeakSelf(self);
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakself.contentLabelH);
    }];
    [self updateCellWithModel:model];
    [self layoutIfNeeded];
    CGFloat detailLabelY = CGRectGetMaxY(self.detailLabel.frame);
    return detailLabelY + kRealValue(20);
}

/*
 *  懒加载的方法返回contentLabel的高度  (只会调用一次)
 */
-(CGFloat)contentLabelH
{
    if(!_contentLabelH){
        CGFloat detailLabelH = [self.goodsDetailModel.detailText boundingRectWithSize:CGSizeMake(KScreenWidth -2*KLeftMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kPingFangRegular(11)} context:nil].size.height;
        
        _contentLabelH = detailLabelH + kRealValue(20);  //内容距离底部下划线10的距离
    }
    return _contentLabelH;
}

@end
