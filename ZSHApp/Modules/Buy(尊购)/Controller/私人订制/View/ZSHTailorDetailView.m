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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(25));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(60));
        make.left.mas_equalTo(self).offset(kRealValue(15));
        make.right.mas_equalTo(self).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(72));
    }];
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(142));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
}

- (void)updateCellWithModel:(ZSHPersonalDetailModel *)model {
    if (model.SHOWIMG) {
        [_activityImage sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMG]];
    }
    
    if (model.TITLE) {
        NSArray *titlesArr = [model.TITLE componentsSeparatedByString:@","];
        if (titlesArr.count == 1) {
            _titleLabel.text  = titlesArr[0];
        }
    }
    if (model.CONTENT) {
        _contentLabel.text = model.CONTENT;
    }
    
}




+ (CGFloat)updateCellHeightWithModel:(ZSHPersonalDetailModel *)model {
    
    CGFloat height = 0;
    if (model.SHOWIMG) {
        height += 225;
    }

    if (model.TITLE) {
        NSArray *titlesArr = [model.TITLE componentsSeparatedByString:@","];
        height+= ((25+15)*titlesArr.count);
    }
    
    if (model.CONTENT) {
        CGSize detailLabelSize = [model.CONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
        height += detailLabelSize.height;
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
