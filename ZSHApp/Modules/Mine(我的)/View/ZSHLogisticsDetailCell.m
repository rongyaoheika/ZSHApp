//
//  ZSHLogisticsDetailCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLogisticsDetailCell.h"
#import "ZSHLogisticsDetailModel.h"

@interface ZSHLogisticsDetailCell ()

@property (nonatomic, strong) UILabel        *descLabel;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UIImageView    *pointView;
@property (nonatomic, strong) UIView         *verticalLine;

@end

@implementation ZSHLogisticsDetailCell

- (void)setup{
    
    _pointView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _pointView.image = [UIImage imageNamed:@"order_point"];
    _pointView.backgroundColor = KZSHColor262626;
    _pointView.layer.cornerRadius = kRealValue(15)/2;
    [self.contentView addSubview:_pointView];
    
    _verticalLine = [[UIView alloc]init];
    _verticalLine.backgroundColor = KZSHColor262626;
    [self.contentView addSubview:_verticalLine];
    
    NSDictionary *descLabelDic = @{@"text":@"",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _descLabel = [ZSHBaseUIControl createLabelWithParamDic:descLabelDic];
    [self.contentView addSubview:_descLabel];
    
    NSDictionary *timeLabelDic = @{@"text":@"",@"font":kPingFangRegular(10),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _timeLabel = [ZSHBaseUIControl createLabelWithParamDic:timeLabelDic];
    [self.contentView addSubview:_timeLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(30));
        make.size.mas_equalTo(CGSizeMake(kRealValue(15), kRealValue(15)));
        make.left.mas_equalTo(kRealValue(20));
    }];
    
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_pointView);
        make.width.mas_equalTo(1.0);
        if (self.row == 0) {
            make.top.mas_equalTo(_pointView.mas_bottom);
        } else {
            make.top.mas_equalTo(self);
        }
        if (self.row == 3) {
             make.bottom.mas_equalTo(_pointView.mas_top);
        } else {
             make.bottom.mas_equalTo(self);
        }
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(15));
        make.left.mas_equalTo(_verticalLine.mas_right).offset(kRealValue(15));
        make.top.mas_equalTo(_pointView);
        make.height.mas_equalTo(12);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(15));
        make.left.mas_equalTo(_descLabel);
        make.top.mas_equalTo(_descLabel.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(10);
    }];
}

- (void)setRow:(NSInteger)row{
    _row = row;
    if (!_row) {
        _pointView.image = [UIImage imageNamed:@"order_detail"];
    }
}

- (void)updateCellWithModel:(ZSHLogisticsDetailModel *)model{
    _descLabel.text = model.detailText;
    _timeLabel.text = model.timeText;
}

@end
