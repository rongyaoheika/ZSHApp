//
//  ZSHSimpleCellView.m
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSimpleCellView.h"
#import "ZSHUserInfoModel.h"

@interface ZSHSimpleCellView()

@property (nonatomic,strong) UILabel      *leftLabel;
@property (nonatomic,strong) UILabel      *rightLabel;
@property (nonatomic,strong) UIImageView  *rightImageView;
@property (nonatomic,strong) UISwitch     *rightSwitchBtn;

@end

@implementation ZSHSimpleCellView

- (void)setup{
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth*0.5);
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    if (NSClassFromString(self.paramDic[@"rightTitle"]) == [UIImage class]) {
        [self addSubview:self.rightImageView];
        self.rightImageView.image = [UIImage imageNamed:@"weibo_head_image"];
        CGFloat imageWH = floor(kRealValue(44));
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-35);
            make.width.and.height.mas_equalTo(imageWH);
            make.centerY.mas_equalTo(self);
        }];
    } else if (NSClassFromString(self.paramDic[@"rightTitle"]) == [UISwitch class]) {
        [self addSubview:self.rightSwitchBtn];
        [self.rightSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(50));
            make.height.mas_equalTo(kRealValue(30));
        }];
        
    } else {
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-35);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(KScreenWidth*0.5);
            make.height.mas_equalTo(kRealValue(15));
        }];
    }
    
}

#pragma getter

- (UILabel *)leftLabel{
    if (!_leftLabel) {
         NSDictionary *leftLabelDic = @{@"text":self.paramDic[@"leftTitle"],@"font":kPingFangRegular(14)};
        _leftLabel = [ZSHBaseUIControl createLabelWithParamDic:leftLabelDic];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        NSDictionary *rightLabelDic = @{@"text":self.paramDic[@"rightTitle"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentRight)};
        _rightLabel = [ZSHBaseUIControl createLabelWithParamDic:rightLabelDic];
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        CGFloat imageWH = floor(kRealValue(44));
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:self.paramDic[@"rightTitle"]];
        _rightImageView.layer.cornerRadius = imageWH/2;
        _rightImageView.layer.masksToBounds = YES;
    }
    return _rightImageView;
}

- (UISwitch *)rightSwitchBtn{
    if (!_rightSwitchBtn) {
        _rightSwitchBtn = [[UISwitch alloc]initWithFrame:CGRectZero];
        _rightSwitchBtn.onTintColor = [UIColor colorWithHexString:@"44DB5E"];
        [_rightSwitchBtn setOn:YES];
    }
    return _rightSwitchBtn;
}

- (void)updateViewWithModel:(ZSHUserInfoModel *)model index:(NSInteger)index {
    if (index == 0) {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    } else if (index == 1) {
        _rightLabel.text = model.NICKNAME;
    } else if (index == 2) {
        _rightLabel.text = model.REALNAME;
    } else if (index == 3) {
        _rightLabel.text = model.SEX;
    } else if (index == 4) {
        _rightLabel.text = model.BIRTHDAY;
    } else if (index == 5) {
        _rightLabel.text = model.CARDNO;
    } else if (index == 6) {
        _rightLabel.text = model.ADDRESS;
    } else if (index == 7) {
        _rightLabel.text = model.SIGNNAME;
    }
}

- (void)updateView2WithModel:(ZSHUserInfoModel *)model index:(NSInteger)index {
    if (index == 0) {
        _rightLabel.text  = model.USERIDCARD;
    } else if (index == 1) {
        _rightLabel.text  = model.PHONE;
    }
}

- (void)updateHeadImage:(UIImage *)image {
    _rightImageView.image = image;
}

- (void)updateRightText:(NSString *)text {
    _rightLabel.text = text;
}

@end
