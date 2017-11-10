//
//  ZSHEnergyScoreCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnergyScoreCell.h"

@interface ZSHEnergyScoreCell ()

@property (nonatomic, strong) UIView    *leftCircleView;
@property (nonatomic, strong) UIButton  *inCircleBtn;
@property (nonatomic, strong) UIView  *inCircleBottomLabel;
@property (nonatomic, strong) UIView  *rightValueView;

@end

@implementation ZSHEnergyScoreCell

- (void)setup{
    
    [self.contentView addSubview:[self createLeftCircleView]];
    _rightValueView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_rightValueView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(68), kRealValue(68)));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(KLeftMargin);
    }];
    
    [_inCircleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftCircleView);
        make.height.mas_equalTo(kRealValue(40));
        make.top.mas_equalTo(self.leftCircleView).offset(kRealValue(18));
        make.width.mas_equalTo(kRealValue(60));
    }];
    
    [self.rightValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftCircleView.mas_right).offset(kRealValue(12.5));
        make.right.mas_equalTo(self).offset(-kRealValue(11));
        make.top.mas_equalTo(self.leftCircleView).offset(kRealValue(15));
        make.bottom.mas_equalTo(self.leftCircleView).offset(-kRealValue(15));
    }];
    
    int i = 0;
    NSInteger btnCount = _rightValueView.subviews.count;
    NSInteger totalRow = (btnCount == 1||btnCount == 3)?1:2;
    for (UIButton *btn in _rightValueView.subviews) {
        NSInteger row = btnCount > 2?i/3:i/1;
        NSInteger colum = btnCount > 2?i%3:i%1;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kRealValue(100));
            make.height.mas_equalTo(kRealValue(10));
            make.left.mas_equalTo(kRealValue(100)*colum);
            if (totalRow == 1) {
                make.centerY.mas_equalTo(self.rightValueView);
            } else {
                 make.top.mas_equalTo(self.rightValueView).offset(row *(kRealValue(10)+kRealValue(15)));
            }
        }];
        i++;
    }
}

#pragma getter
- (UIView *)createLeftCircleView{
    self.leftCircleView = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftCircleView.layer.cornerRadius = kRealValue(68)/2;
    self.leftCircleView.layer.masksToBounds = YES;
    self.leftCircleView.layer.borderWidth = 3.0;
    self.leftCircleView.layer.borderColor = [UIColor colorWithHexString:@"D48B32"].CGColor;
    self.leftCircleView.backgroundColor = KClearColor;

    NSDictionary *topDic = @{@"text":@"99",@"font":kPingFangLight(20),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(22)};
    NSDictionary *bottomDic = @{@"text":@"购物分",@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    _inCircleBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topDic bottomDic:bottomDic];
    
    [_leftCircleView addSubview:_inCircleBtn];
    return _leftCircleView;
}

- (void)updateCellWithParamDic:(NSDictionary *)paramDic{
    [self.rightValueView removeAllSubviews];
    self.leftCircleView.layer.borderColor = ((UIColor *)paramDic[@"leftColor"]).CGColor;
    
    UILabel *topLabel = [self.inCircleBtn viewWithTag:1];
    topLabel.text = paramDic[@"inCircleTopTitle"];
    topLabel.textColor = paramDic[@"leftColor"];
    
    UILabel *bottomLabel = [self.inCircleBtn viewWithTag:2];
    bottomLabel.text = paramDic[@"inCircleBottomTitle"];
    bottomLabel.textColor = paramDic[@"leftColor"];
    
    NSArray *rightArr = paramDic[@"rightArr"];
    int i = 0;
    for (NSDictionary *rightBtnParamDic in rightArr) {
        UIButton *rightValueBtn = [self createBtnWithParamDic:rightBtnParamDic];
        [_rightValueView addSubview:rightValueBtn];
        i++;
    }
}

- (UIButton *)createBtnWithParamDic:(NSDictionary *)paramDic{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    
    UIImageView *btnImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:paramDic[@"rightColor"]]];
    btnImageView.frame = CGRectMake(0, btn.centerY, kRealValue(10), kRealValue(10));
    [btn addSubview:btnImageView];
    [btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(10), kRealValue(10)));
        make.centerY.mas_equalTo(btn);
        make.left.mas_equalTo(btn);
    }];
    
    NSDictionary *titleLabelDic = @{@"text":paramDic[@"rightTitle"],@"font":kPingFangRegular(10),@"textColor":paramDic[@"rightColor"]};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [btn addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnImageView.mas_right).offset(kRealValue(9));
        make.right.mas_equalTo(btn);
        make.height.mas_equalTo(btnImageView);
        make.centerY.mas_equalTo(btn);
    }];
    return btn;
}

@end
