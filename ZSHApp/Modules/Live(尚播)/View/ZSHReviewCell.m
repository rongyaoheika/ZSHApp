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
@property (nonatomic, strong) UILabel             *reNameLabel;
@property (nonatomic, strong) UILabel             *dateLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIImageView         *detailImageView;
@property (nonatomic, strong) UIImageView         *replyImageView;

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
    
    UIImageView *replyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibo_reply"]];
    [self.contentView addSubview:replyImage];
    self.replyImageView = replyImage;
    
    _reNameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:_reNameLabel];
    
    NSDictionary *dateLabelDic = @{@"text":@"昨天16:36",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self.contentView addSubview:self.dateLabel];
    
    NSDictionary *detailLabelDic = @{@"text":@"#跑车世界# 一枚宽体战神GTR ",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.detailLabel];
    
    self.detailImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.detailImageView];
    
    UIButton *dislike = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"0",@"font":kPingFangRegular(14),@"withImage":@(YES),@"normalImage":@"weibo_dislike"}];
    [self.contentView addSubview:dislike];
    [dislike addTarget:self action:@selector(dislikeAction) forControlEvents:UIControlEventTouchUpInside];
    [dislike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kRealValue(11));
        make.trailing.mas_equalTo(self.contentView).offset(kRealValue(-15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(23)));
    }];
    
    UIButton *like = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"0",@"font":kPingFangRegular(14),@"withImage":@(YES),@"normalImage":@"weibo_like"}];
    [self.contentView addSubview:like];
    [like addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kRealValue(11));
        make.trailing.mas_equalTo(dislike).offset(kRealValue(-5-30));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(23)));
    }];
>>>>>>> 完成微博评论添加回复人的昵称
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(kRealValue(15));
        make.top.mas_equalTo(self.contentView).offset(kRealValue(10));
        make.width.and.height.mas_equalTo(kRealValue(40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kRealValue(15));
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    [replyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(kRealValue(8), kRealValue(8)));
    }];
    
    [_reNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(replyImage.mas_right).offset(kRealValue(5));
        make.height.mas_equalTo(kRealValue(14));
        make.right.mas_lessThanOrEqualTo(kRealValue(-75));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealValue(6));
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(kRealValue(11));
        make.right.mas_equalTo(self.contentView).offset(-kRealValue(10));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(self.avatarImageView);
//        make.height.mas_equalTo(kRealValue(50));
        make.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-kRealValue(15));
    }];
    
//    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.detailLabel.mas_bottom);
//        make.left.mas_equalTo(self.avatarImageView);
//        make.height.mas_equalTo(kRealValue(100));
//        make.width.mas_equalTo(kRealValue(110));
//    }];
}


- (void)updateCellWithModel:(ZSHCommentListModel *)model {
    if ([model.REPLYHONOURUSER_ID isEqualToString:@""]) {
        _replyImageView.hidden = true;
        _reNameLabel.text = @"";
    } else {
        _replyImageView.hidden = false;
        _reNameLabel.text = model.REPLYNICKNAME;
    }
    _nameLabel.text = model.COMMENTNICKNAME;
    _dateLabel.text = model.COMMENTTIME;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    _detailLabel.text = model.COMCONTENT;
}


+ (CGFloat)getCellHeightWithModel:(ZSHCommentListModel *)model {
    CGSize detailLabelSize = [model.COMCONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    model.height =62.5 + detailLabelSize.height+14;
    return model.height;
}


- (void)dislikeAction {
    
}

- (void)likeAction {
    
}


@end
