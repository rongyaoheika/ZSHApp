//
//  ZSHDiscussCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHDiscussCell.h"

@interface ZSHDiscussCell()

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *contentImage;

@end

@implementation ZSHDiscussCell

- (void)setup {
    
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    self.headImage = headImage;
    
    
    UILabel *nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"132456", @"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    nicknameLabel.numberOfLines = 0;
    nicknameLabel.contentMode = UIViewContentModeLeft;
    [self addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;
    
    
    UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"10天前",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    
    UIImageView *contentImage = [[UIImageView alloc] init];
    [self addSubview:contentImage];
    self.contentImage = contentImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(9.5));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-kRealValue(10));
        make.left.mas_equalTo(self).offset(kRealValue(65));
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(12)));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage);
        make.left.mas_equalTo(self).offset(kRealValue(65));
        make.width.mas_equalTo(kRealValue(265));
        make.bottom.mas_equalTo(self.dateLabel.mas_top).offset(-kRealValue(10));
    }];
    
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14.5));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];


}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.headImage.image = [UIImage imageNamed:dic[@"headImage"]];
    self.nicknameLabel.text = dic[@"nickname"];
    
    NSMutableParagraphStyle *nickLBStyle = [[NSMutableParagraphStyle alloc]init];
    [nickLBStyle setLineSpacing:2.0];
    NSMutableAttributedString *setStr = [[NSMutableAttributedString alloc]initWithString:self.nicknameLabel.text];
    [setStr addAttribute:NSParagraphStyleAttributeName value:nickLBStyle range:NSMakeRange(0, [self.nicknameLabel.text length])];
    [self.nicknameLabel setAttributedText:setStr];
    
    self.dateLabel.text = dic[@"date"];
    self.contentImage.image = [UIImage imageNamed:dic[@"content"]];

    [self layoutIfNeeded];
    
}
@end
