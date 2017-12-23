//
//  ZSHTailorDetailTableViewCell.m
//  ZSHApp
//
//  Created by Apple on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTailorDetailView.h"


@interface ZSHTailorDetailView()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *secTitleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIImageView *activityImage;

@end

@implementation ZSHTailorDetailView

- (void)setup {
    NSDictionary *titleLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    NSDictionary *contentLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;

    UIImageView *activityImage = [[UIImageView alloc]init];
    activityImage.layer.cornerRadius = 10.0;
    [self addSubview:activityImage];
    self.activityImage = activityImage;
    
//    NSDictionary *titleLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *secTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self addSubview:secTitleLabel];
    self.secTitleLabel = secTitleLabel;
    
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(225));
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_activityImage.mas_bottom).offset(kRealValue(25));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(20));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(72));
    }];
    
    [_secTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(kRealValue(-20));
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}


- (void)updateCellWithModel:(ZSHPersonalDetailModel *)model {
    if (![model.SHOWIMG isEqualToString:@""]) {
        [_activityImage sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMG]];
        [_activityImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealValue(225));
        }];
    } else {
        _activityImage.image = [[UIImage alloc] init];
        [_activityImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    
    if (![model.TITLE isEqualToString:@""]) {
        NSArray *titlesArr = [model.TITLE componentsSeparatedByString:@"@"];
        if (titlesArr.count > 1) {
            _secTitleLabel.text = titlesArr[1];
            [_secTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealValue(15));
            }];
        } else {
            _secTitleLabel.text = @"";
            [_secTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
        }
        _titleLabel.text  = titlesArr[0];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealValue(15));
            make.top.mas_equalTo(_activityImage.mas_bottom).offset(kRealValue(25));
        }];
    } else {
        _secTitleLabel.text = @"";
        _titleLabel.text = @"";
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_activityImage.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [_secTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    if (![model.CONTENT isEqualToString:@""]) {
        NSArray *contentArr = [model.CONTENT componentsSeparatedByString:@"@"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        if (contentArr.count == 1) {
            NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:model.CONTENT];
            [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.CONTENT length])];
            [_contentLabel setAttributedText:setString];
            CGSize detailLabelSize = [model.CONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(detailLabelSize.height);
                make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(20));
            }];
        } else {
            
            NSString *newContent = [model.CONTENT stringByReplacingOccurrencesOfString:@"@" withString:@"\n"];
            NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:newContent];
            [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [newContent length])];
            [_contentLabel setAttributedText:setString];
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(10));
                make.height.mas_equalTo(22*contentArr.count);
            }];
        }
    } else {
        _contentLabel.text = @"";
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    
}


+ (CGFloat)updateCellHeightWithModel:(ZSHPersonalDetailModel *)model {
    
    CGFloat height = 0;
    if (![model.SHOWIMG isEqualToString:@""]) {
        height += 225;
    }

    if (![model.TITLE isEqualToString:@""]) {
        NSArray *titlesArr = [model.TITLE componentsSeparatedByString:@"@"];
        height+= ((25+15)*titlesArr.count);
    }
    
    if (![model.CONTENT isEqualToString:@""]) {
        NSArray *contentArr = [model.CONTENT componentsSeparatedByString:@"@"];
        if (contentArr.count == 1) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10];
            CGSize detailLabelSize = [model.CONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
            height += detailLabelSize.height+40;
        } else {
            height += (22*contentArr.count+10);
        }
        
    }
    return height;
}


//- (void)updateCellWithParamDic:(NSDictionary *)dic{
//    self.activityImage.image = [UIImage imageNamed:dic[@"bgImageName"]];
//    self.titleLabel.text = dic[@"TitleText"];
//    self.contentLabel.text = dic[@"ContentText"];
//    self.paramDic = dic;
//    [self layoutIfNeeded];
//    
//}

//- (void)updateCellWithModel:(ZSHPersonalDetailModel *)model index:(NSInteger)index {
//    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.PERSONALDETIMGS[index]]];
//    if (index == 1) {
//        self.titleLabel.text = model.UPINTROTITLE;
//        self.contentLabel.text = model.UPINTROCONTENT;
//    } else if (index == 2) {
//        self.titleLabel.text = model.DOWNINTROTITLE;
//        self.contentLabel.text = model.DOWNINTROCONTENT;
//    }
//    [self layoutIfNeeded];
//}

@end
