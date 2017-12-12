//
//  ZSHReviewCell.m
//  ZSHApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHReviewCell.h"


@interface ZSHReviewCell()

@property (nonatomic, strong) UIImageView         *avatarImageView;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel             *dateLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIImageView         *detailImageView;

@end

@implementation ZSHReviewCell

- (void)setup {
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
    
//    self.detailImageView = [[UIImageView alloc]init];
//    [self.contentView addSubview:self.detailImageView ];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.top.mas_equalTo(self).offset(kRealValue(10));
        make.width.and.height.mas_equalTo(kRealValue(40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(15));
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
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(self.avatarImageView);
//        make.height.mas_equalTo(kRealValue(50));
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-kRealValue(15));
    }];
    
//    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.detailLabel.mas_bottom);
//        make.left.mas_equalTo(self.avatarImageView);
//        make.height.mas_equalTo(kRealValue(100));
//        make.width.mas_equalTo(kRealValue(110));
//    }];
}


- (void)updateCellWithModel:(ZSHCommentListModel *)model {
    _dateLabel.text = model.COMMENTTIME;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    _detailLabel.text = model.COMCONTENT;
}


- (CGFloat)getCellHeightWithModel:(ZSHCommentListModel *)model {
    CGSize detailLabelSize = [model.COMCONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    model.height =62.5 + detailLabelSize.height+14;
    return model.height;
}

@end
