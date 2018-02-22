//
//  ZSHCardBtnListView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardBtnListView.h"

#define midYSpace kRealValue(15)


@interface ZSHCardBtnListView ()

@property (nonatomic, strong) NSMutableArray   *btnArr;
@property (nonatomic, assign) NSInteger        column;
@property (nonatomic, assign) UIButton         *lastBtn;
@property (nonatomic, assign) NSInteger        selectIndex;
@end

@implementation ZSHCardBtnListView

- (void)setup{
    
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *titleListArr = self.paramDic[@"titleArr"];

    for (int i = 0; i<titleListArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":titleListArr[i],@"font":kPingFangLight(15), @"selectedTitleColor":KZSHColorF29E19};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.tag = i + 1;

        if (self.paramDic[@"selectedImage"]) {
            [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"normalImage"]] forState:UIControlStateNormal];
            [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"selectedImage"]] forState:UIControlStateSelected];
        } else {
            cardTypeBtn.layer.borderWidth = 1.0;
            cardTypeBtn.layer.borderColor = KZSHColor929292.CGColor;
            [cardTypeBtn setBackgroundImage:[UIImage imageWithColor:self.paramDic[@"selectedColor"]] forState:UIControlStateSelected];
        }
        
        [cardTypeBtn addTarget:self action:@selector(cardTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
        
        _selectIndex = (self.paramDic[@"btnTag"]?[self.paramDic[@"btnTag"]integerValue]:0);
        if (i == _selectIndex ) {
            cardTypeBtn.selected = YES;
            _lastBtn = cardTypeBtn;
        }
    }
}

-  (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftMargin = KLeftMargin;
    CGFloat xSpace;
    CGFloat btnWidth;
    CGFloat btnHeight;
    int i = 0;
    if ([self.paramDic[@"titleArr"] count] ==4) {//一排两个按钮
        _column = 2;
        btnWidth = kRealValue(165);
        btnHeight = kRealValue(30);
        xSpace = KScreenWidth - 2*KLeftMargin - _column*btnWidth;
    } else {
        _column = 3;
        btnWidth = kRealValue(100);
        btnHeight = kRealValue(30);
        xSpace = kRealValue(20);
    }
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(leftMargin + (i%_column)*(btnWidth+xSpace));
            make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
            make.top.mas_equalTo(self).offset(kRealValue(10) + (i/_column)*(btnHeight+midYSpace));
        }];
        i++;
    }
}

#pragma action
- (void)cardTypeBtnAction:(UIButton *)btn{
    RLog(@"点击按钮tag==%ld",btn.tag);
   
    if (_lastBtn != btn) {
        btn.selected = YES;
        _lastBtn.selected = NO;
        _lastBtn = btn;
        if (self.btnClickBlock) {
            self.btnClickBlock(btn);
        }
    } else if(btn.tag!=_selectIndex){
        UIButton *tempBtn = btn;
        tempBtn.selected = !tempBtn.selected;
        if(self.clickSameBtn){
            self.clickSameBtn(tempBtn.selected);
        }
    } else if(btn.tag == _selectIndex){
        btn.selected = YES;
        if (self.btnClickBlock) {
            self.btnClickBlock(btn);
        }
    }
}

@end
