//
//  ZSHShopCommentCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShopCommentCell.h"

@interface ZSHShopCommentCell()

@property (nonatomic, strong) UIImageView         *avatarImageView;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel             *dateLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, assign) CGFloat             detailLabelH;

@end

@implementation ZSHShopCommentCell

- (void)setup{
    self.avatarImageView = [[UIImageView alloc]init];
    [self.avatarImageView setClipsToBounds:YES];
    self.avatarImageView.layer.cornerRadius = kRealValue(40)/2;
    [self.contentView addSubview:self.avatarImageView];
    
    NSDictionary *nameLabelDic = @{@"text":@"昨忘记时间的钟",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft )};
    self.nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:self.nameLabel];
    
    NSDictionary *dateLabelDic = @{@"text":@"昨天16:36",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self.contentView addSubview:self.dateLabel];
    
    NSDictionary *detailLabelDic = @{@"text":@"#跑车世界# 一枚宽体战神GTR ",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.detailLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.width.and.height.mas_equalTo(kRealValue(40));
    
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14));
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(14));
        make.right.mas_equalTo(self).offset(-kRealValue(10));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealValue(6));
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(kRealValue(11));
        make.right.mas_equalTo(self).offset(-kRealValue(10));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(17.5));
        make.left.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
    }];
}

- (CGFloat)rowHeightWithCellModel:(ZSHShopCommentModel *)model{
    [self updateCellWithModel:model];
    kWeakSelf(self);
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakself.detailLabelH);
    }];
    [self layoutIfNeeded];
    CGFloat detailLabelY = CGRectGetMaxY(self.detailLabel.frame);
    return detailLabelY;
}

- (void)updateCellWithModel:(ZSHShopCommentModel *)model{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    _nameLabel.text = model.NICKNAME;
    _dateLabel.text = model.EVALUATEDATE;
    _detailLabel.text = model.EVALUATECONTENT;
}

/*
 *  懒加载的方法返回detailLabelH的高度  (只会调用一次)
 */
-(CGFloat)detailLabelH
{
    if(!_detailLabelH){
        CGFloat h = [self.detailLabel.text boundingRectWithSize:CGSizeMake( kScreenWidth-2*KLeftMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailLabel.font} context:nil].size.height;
        
        _detailLabelH = h + kRealValue(10);  //内容距离底部下划线10的距离
    }
    return _detailLabelH;
}

@end
