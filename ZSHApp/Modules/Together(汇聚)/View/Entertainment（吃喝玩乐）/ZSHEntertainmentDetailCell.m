//
//  ZSHEntertainmentDetailCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentDetailCell.h"
#import "ZSHEnterDisModel.h"

@implementation ZSHEntertainmentDetailCell

- (void)setup{
    
    NSDictionary *titleLabelDic = @{@"text":@"详情要求",@"font":kPingFangRegular(14)};
    UILabel *topLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(13));
        make.height.mas_equalTo(kRealValue(14));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
    }];
    
    NSDictionary *detailLabelDic = @{@"text":@"天气那么冷，不如找家咖啡馆来一杯咖啡，一起玩玩狼人杀，交一些新朋友，多个朋友多条路嘛！生活不止低头看手机，还有面对面邂逅的缘分",@"font":kPingFangRegular(12)};
    UILabel *detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    detailLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    NSString *detailStr = @"天气那么冷，不如找家咖啡馆来一杯咖啡，一起玩玩狼人杀，交一些新朋友，多个朋友多条路嘛！生活不止低头看手机，还有面对面邂逅的缘分";
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:detailStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
    [detailLabel setAttributedText:setString];

    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(topLabel.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(54));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
    }];
    
}

- (void)updateCellWithModel:(ZSHEnterDisModel *)model {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    NSString *detailStr = model.CONVERGEDET;
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:detailStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
    [_detailLabel setAttributedText:setString];
}

@end
