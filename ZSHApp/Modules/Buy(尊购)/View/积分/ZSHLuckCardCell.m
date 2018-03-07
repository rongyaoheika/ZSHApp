//
//  ZSHLuckCardCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLuckCardCell.h"

@implementation ZSHLuckCardCell

- (void)setup {
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"luck_card"]];
    bgImageView.userInteractionEnabled = YES;
//    bgImageView.frame = CGRectMake(0, 0, kRealValue(160), kRealValue(215));
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(160), kRealValue(215)));
    }];
    
    NSDictionary *descLabelDic = @{@"text":@"每次翻牌需消耗100积分",@"font":kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *descLabel = [ZSHBaseUIControl createLabelWithParamDic:descLabelDic];
    [bgImageView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.width.mas_equalTo(kRealValue(110));
        make.height.mas_equalTo(kRealValue(10));
        make.bottom.mas_equalTo(bgImageView).offset(-kRealValue(10));
    }];
    
    NSDictionary *transferBtnDic = @{@"title":@"点击翻牌",@"font":kPingFangMedium(15),@"backgroundColor":[UIColor colorWithHexString:@"272727"]};
    UIButton *transferBtn = [ZSHBaseUIControl  createBtnWithParamDic:transferBtnDic target:self action:@selector(transformAction:)];
    transferBtn.layer.cornerRadius = kRealValue(15);
    [bgImageView addSubview:transferBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(descLabel.mas_bottom).offset(-kRealValue(12.5));
        make.height.mas_equalTo(kRealValue(27));
        make.width.mas_equalTo(kRealValue(95));
    }];
}

- (void)transformAction:(UIButton *)btn{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    UIImageView *bgImageView = (UIImageView *)btn.superview;
    [bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


@end
