//
//  ZSHPhoneNumListView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPhoneNumListView.h"

@interface ZSHPhoneNumListView ()

@property (nonatomic, strong) NSMutableArray   *btnArr;
@property (nonatomic, assign) NSInteger        row;
@property (nonatomic, assign) NSInteger        column;

@end

@implementation ZSHPhoneNumListView

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    
    NSArray *titleListArr = self.paramDic[@"titleArr"];
    _row = ceil(titleListArr.count/2.0);
    _column = 2;
    
    for (int i = 0; i<titleListArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":titleListArr[i],@"font":kPingFangRegular(12), @"selectedTitleColor":KZSHColorF29E19};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.tag = i + 1;
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"normalImage"]]    forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"selectedImage"]] forState:UIControlStateSelected];
        [cardTypeBtn addTarget:self action:@selector(phoneNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
    }
}

-  (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = kRealValue(130);
    CGFloat btnH = kRealValue(30);
    CGFloat midXSpace = (KScreenWidth - 2*kRealValue(22) - _column*btnW)/(self.column-1);
    CGFloat midYSpace = (CGRectGetHeight(self.frame) - _row*btnH)/(self.row-1);
    int i = 0;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kRealValue(22) + (i%2)*(btnW+midXSpace));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
            make.top.mas_equalTo(self).offset((i/2)*(btnH+midYSpace));
        }];
        i++;
    }
}

#pragma action
- (void)phoneNumBtnAction:(UIButton *)btn{
    [self selectedByIndex:btn.tag];
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

- (void)selectedByIndex:(NSUInteger)index {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:@"CARDNO"];
        } else {
            btn.selected = NO;
        }
    }];
}

@end

