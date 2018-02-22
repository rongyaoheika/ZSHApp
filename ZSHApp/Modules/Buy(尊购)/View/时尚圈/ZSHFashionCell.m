//
//  ZSHFashionCell.m
//  ZSHApp
//
//  Created by mac on 12/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHFashionCell.h"
@interface ZSHFashionCell()

@property (nonatomic, strong) UIImageView    *headImageView;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel        *detailLabel;
@property (nonatomic, strong) UIImageView    *backgroundImageView;
@property (nonatomic, strong) UILabel        *subTitleLabel;
@property (nonatomic, strong) UILabel        *contentLabel;

@end

@implementation ZSHFashionCell

- (void)setup {
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flagship4"]];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(35), kRealValue(35)));
    }];
    
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"劳力士旗舰店", @"font":kPingFangRegular(12)}];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(10);
        make.top.mas_equalTo(_headImageView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(13)));
    }];
    
    _detailLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"共10件宝贝", @"font":kPingFangRegular(11)}];
    [self addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImageView);
        make.left.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(13)));
    }];
    
    _backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(175);
    }];
    
    _subTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(15)}];
    [self addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundImageView.mas_bottom).offset(KLeftMargin);
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(16);
    }];
    
    
    _contentLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(12)}];
    _contentLabel.numberOfLines = 0;
    NSString *string = @"厌倦了一模一样和规矩刻板的孩童服装？那么你的想法正好跟这两名来自以色列的设计师不谋而合";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:string];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    CGSize detailLabelSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    [_contentLabel setAttributedText:setString];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(detailLabelSize.height);
    }];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _backgroundImageView.image = [UIImage imageNamed:dic[@"image"]];
    _subTitleLabel.text = dic[@"title"];
    
    NSString *string =  dic[@"content"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:string];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    CGSize detailLabelSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    [_contentLabel setAttributedText:setString];
    
}

@end
