//
//  ZSHGoodsChartCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsChartCell.h"
#import "ZSHGoodModel.h"

@interface ZSHGoodsChartCell ()

@property (nonatomic, strong) UIView  *topLine;
@property (nonatomic, strong) UILabel *leftTypeLabel;
@property (nonatomic, strong) UILabel *rightDescLabel;
@property (nonatomic, strong) UIView  *verticalLineView;

@end
@implementation ZSHGoodsChartCell

- (void)setup{
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = KZSHColor1D1D1D;
    _topLine.hidden = YES;
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(0.5)));
    }];
    
   NSDictionary *leftTypeLabelDic = @{@"text":@"材质",@"font":kPingFangMedium(12)};
   _leftTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:leftTypeLabelDic];
    [self.contentView addSubview:_leftTypeLabel];
    
    _verticalLineView = [[UIView alloc]init];
    _verticalLineView.backgroundColor = KZSHColor1D1D1D;
    [self.contentView addSubview:_verticalLineView];
    
    NSDictionary *rightDescLabelDic = @{@"text":@"牛皮",@"font":kPingFangRegular(12)};
    _rightDescLabel = [ZSHBaseUIControl createLabelWithParamDic:rightDescLabelDic];
    [self.contentView addSubview:_rightDescLabel];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KZSHColor1D1D1D;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(0.5)));
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_leftTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(25));
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(KScreenWidth*0.3);
    }];
    
    [_verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftTypeLabel.mas_right);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self);
    }];
    
    [_rightDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_verticalLineView.mas_right).offset(kRealValue(25));
//        make.top.and.height.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
    }];
}

- (void)setRow:(NSInteger)row{
    if (_row == 0) {
        _topLine.hidden = NO;
    }
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    _leftTypeLabel.text = dic[@"leftTitle"];
    _rightDescLabel.text = dic[@"rightTitle"];
}

- (void)updateCellWithKey:(NSString *)key value:(NSString *)value {
    _leftTypeLabel.text = key;
    _rightDescLabel.text = value;
}

- (void)updateCellWithModel:(ZSHGoodModel *)model {
//    _rightDescLabel.text
}

@end
