//
//  ZSHWeiBoCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiBoCell.h"
#import "ZSHWeiBoCellModel.h"
#import "ZSHWeiBoBottomView.h"

@interface ZSHWeiBoCell()
//控件声明
@property (nonatomic, strong) UIImageView         *avatarImageView;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel             *dateLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIImageView         *detailImageView;
@property (nonatomic, strong) ZSHWeiBoBottomView  *bottomView;

@property (nonatomic, strong) MASConstraint       *topConstraint;

@end

@implementation ZSHWeiBoCell

- (void)setup{
    //子控件的创建
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
    
    self.detailImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.detailImageView ];
    
    _bottomView = [[ZSHWeiBoBottomView alloc]initWithFrame:CGRectZero paramDic:nil];
    [self.contentView addSubview:self.bottomView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
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
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(17.5));
        make.left.mas_equalTo(self.avatarImageView);
        make.height.mas_equalTo(kRealValue(50));
        make.right.mas_equalTo(self).offset(-kRealValue(15));
    }];
    
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom);
        make.left.mas_equalTo(self.avatarImageView);
        make.height.mas_equalTo(kRealValue(100));
        make.width.mas_equalTo(kRealValue(110));
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.detailImageView.mas_bottom);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(43));
    }];
    
    if (kFromVCType == ZSHGoodsCommentSubVCToWeiBoCell) {
        self.bottomView.hidden = YES;
        self.bottomView.frame = CGRectZero;
    }
}

- (void)updateCellWithModel:(ZSHWeiBoCellModel *)model{
    //子控件数据的更新
    [self.avatarImageView setImage:[UIImage imageNamed:model.avatarPicture]];
    [self.nameLabel setText:model.name];
    [self.detailLabel setText:model.detailText];
    
    CGSize detailLabelSize = [model.detailText boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailLabel.font,NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
    
    if (!model.detailText.length) {
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(17.5));
            make.left.mas_equalTo(self.avatarImageView);
            make.height.mas_equalTo(0);
            make.right.mas_equalTo(self).offset(-kRealValue(15));
        }];
    } else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        NSString *detailStr = model.detailText;
        NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString: model.detailText];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
        [self.detailLabel setAttributedText:setString];

        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(17.5));
            make.left.mas_equalTo(self.avatarImageView);
            make.height.mas_equalTo(detailLabelSize.height + kRealValue(10));
            make.right.mas_equalTo(self).offset(-kRealValue(15));
        }];
    }
    [self.detailImageView setImage:[UIImage imageNamed:model.detailPicture]];
    if (!model.detailPicture) {
        [self.detailImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailLabel.mas_bottom);
            make.left.mas_equalTo(self.avatarImageView);
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(0);
        }];
    }

    [self layoutIfNeeded];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.paramDic  = dic;
}

+ (CGFloat)getCellHeightWithModel:(ZSHWeiBoCellModel *)model{
    ZSHWeiBoCell *cell = [[ZSHWeiBoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
    [cell updateCellWithModel:model];
    
    RLog(@"控件的高度==%f ==%f  ==%f  ==%f",CGRectGetMaxY(cell.detailImageView.frame),CGRectGetMaxY(cell.detailLabel.frame),CGRectGetMaxY(cell.bottomView.frame),CGRectGetHeight(cell.bottomView.frame));
    return (CGRectGetMaxY(cell.bottomView.frame));
}


@end
