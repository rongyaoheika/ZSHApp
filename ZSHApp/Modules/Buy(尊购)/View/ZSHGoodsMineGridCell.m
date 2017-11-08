//
//  ZSHGoodsMineGridCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsMineGridCell.h"

@interface ZSHGoodsMineGridCell()

@property (nonatomic,strong)UIButton *centerBtn;

@end

@implementation ZSHGoodsMineGridCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"会员中心" forState:UIControlStateNormal];
    btn.titleLabel.font = kPingFangRegular(14);
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn setImage:[UIImage imageNamed:@"goods_mine_gift"] forState:UIControlStateNormal];
    [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    self.centerBtn = btn;
}

- (void)setModelDic:(NSDictionary *)modelDic{
    kWeakSelf(self);
    _modelDic = modelDic;
    self.centerBtn.tag = [_modelDic[@"tag"]integerValue];
    [self.centerBtn setImage:[UIImage imageNamed:_modelDic[@"image"]] forState:UIControlStateNormal];
    [self.centerBtn setTitle:_modelDic[@"desc"]forState:UIControlStateNormal];
    [self.centerBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(30)];
    [self.centerBtn addTapBlock:^(UIButton *btn) {
        weakself.btnClickBlock(btn);
    }];
    
}

@end
