//
//  ZSHTopicCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTopicCell.h"
#import "ZSHWeiboTopicModel.h"
#import "UIImage+String.h"

@interface ZSHTopicCell ()

@end

@implementation ZSHTopicCell

- (void)setup{
    
    _leftIV = [[UIImageView alloc]init];
    _leftIV.image = [UIImage imageNamed:@"live_room_head5"];
    _leftIV.contentMode = UIViewContentModeScaleAspectFit;
    _leftIV.clipsToBounds = YES;
    [self.contentView addSubview:_leftIV];
    [_leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    NSDictionary *topLabelDic = @{@"text":@"",@"font":kPingFangRegular(14)};
    _topLabel = [ZSHBaseUIControl createLabelWithParamDic:topLabelDic];
    [self.contentView addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftIV);
        make.left.mas_equalTo(_leftIV.mas_right).offset(KLeftMargin);
        make.right.mas_equalTo(self).offset(-kRealValue(100));
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    NSDictionary *bottomLabelDic = @{@"text":@"#感恩有你话题详情#",@"font":kPingFangRegular(12)};
    _bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomLabelDic];
    [self.contentView addSubview:_bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_leftIV);
        make.left.mas_equalTo(_topLabel);
        make.right.mas_equalTo(_topLabel);
        make.height.mas_equalTo(_topLabel);
    }];
    
    NSDictionary *rightLabelDic = @{@"text":@"#话题#",@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
    _rightLabel = [ZSHBaseUIControl createLabelWithParamDic:rightLabelDic];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(80));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(_topLabel);
    }];

}

- (void)updateCellWithModel:(ZSHWeiboTopicModel *)model  {
    
    if (model.TITLE){
        _topLabel.text = NSStringFormat(@"#%@#", model.TITLE);
        
        if (model.SHOWIMG) {
            if ([model.SHOWIMG isEqualToString:@"newTopic"]) {
                _leftIV.image = [UIImage getImage:[model.TITLE substringToIndex:1]];
            } else {
                [_leftIV sd_setImageWithURL:[NSURL URLWithString:model.SHOWIMG]];
            }
        }
    }
    
    if (model.DESCRIPTION) {
        _bottomLabel.text = model.DESCRIPTION;
    }
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    _leftIV.image = [[UIImage alloc] init];
    _topLabel.text = dic[@"topic"];
    _bottomLabel.text = @"新话题";
}

@end
