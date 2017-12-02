//
//  ZSHHotelCalendarCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelCalendarCell.h"

@interface ZSHHotelCalendarCell()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *leaveBtn;

@end

@implementation ZSHHotelCalendarCell

- (void)setup{
    
    NSDictionary *leftTopDic = @{@"text":@"入住",@"font":kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    NSDictionary *leftBottomDic = @{@"text":@"8-8",@"font":kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    UIButton *checkBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:leftTopDic bottomDic:leftBottomDic];
    checkBtn.tag = 1;
    [checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(80));
        make.top.mas_equalTo(self).offset(kRealValue(16));
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(kRealValue(35));
    }];
    _checkBtn = checkBtn;
    
    NSDictionary *dateBtnDic = @{@"title":@"共一天",@"font":kPingFangMedium(15)};
    UIButton *dateBtn = [ZSHBaseUIControl createBtnWithParamDic:dateBtnDic];
    [self.contentView addSubview:dateBtn];
    [dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(checkBtn);
        make.height.mas_equalTo(kRealValue(23));
        make.width.mas_equalTo(kRealValue(70));
    }];
     [ZSHSpeedy zsh_chageControlCircularWith:dateBtn AndSetCornerRadius:kRealValue(12) SetBorderWidth:1 SetBorderColor:KZSHColor979797 canMasksToBounds:YES];
    _dateBtn = dateBtn;
    
    NSDictionary *rightTopDic = @{@"text":@"离开",@"font":kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    NSDictionary *rightBottomDic = @{@"text":@"8-9",@"font":kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    UIButton *leaveBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:rightTopDic bottomDic:rightBottomDic];
    leaveBtn.tag = 2;
    [leaveBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leaveBtn];
    [leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(80));
        make.top.mas_equalTo(checkBtn);
        make.width.mas_equalTo(checkBtn);
        make.height.mas_equalTo(checkBtn);
    }];
    _leaveBtn = leaveBtn;
}

- (void)checkBtnAction:(UIButton *)btn{
    if (self.dateViewTapBlock) {
        self.dateViewTapBlock(btn.tag);
    }
}

@end
