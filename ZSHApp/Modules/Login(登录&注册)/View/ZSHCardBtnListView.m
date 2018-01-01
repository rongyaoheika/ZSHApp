//
//  ZSHCardBtnListView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardBtnListView.h"

#define btnW kRealValue(100)
#define btnH kRealValue(30)
#define midXSpace kRealValue(20)
#define midYSpace kRealValue(15)


@interface ZSHCardBtnListView ()

@property (nonatomic, strong) NSMutableArray   *btnArr;
@property (nonatomic, assign) NSInteger        row;
@property (nonatomic, assign) NSInteger        column;
@property (nonatomic, assign) UIButton         *lastBtn;
@property (nonatomic, assign) NSInteger        selectIndex;
@end

@implementation ZSHCardBtnListView

- (void)setup{
    
    _btnArr = [[NSMutableArray alloc]init];
    
    NSArray *titleListArr = self.paramDic[@"titleArr"];
    _row = ceil(titleListArr.count/3.0);
    _column = 3;
   
    for (int i = 0; i<titleListArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":titleListArr[i],@"font":kPingFangLight(15), @"selectedTitleColor":KZSHColorF29E19};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.tag = i + 1;
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"normalImage"]] forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"selectedImage"]] forState:UIControlStateSelected];
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

    int i = 0;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin + (i%3)*(btnW+midXSpace));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
            make.top.mas_equalTo(self).offset(kRealValue(10) + (i/3)*(btnH+midYSpace));
        }];
        i++;
    }
}

#pragma action
- (void)cardTypeBtnAction:(UIButton *)btn{
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
