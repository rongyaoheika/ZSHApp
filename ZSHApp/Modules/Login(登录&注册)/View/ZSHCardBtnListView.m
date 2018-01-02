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
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"normalImage"]]    forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:self.paramDic[@"selectedImage"]] forState:UIControlStateSelected];
        [cardTypeBtn addTarget:self action:@selector(cardTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
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
    [self selectedByIndex:btn.tag];
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

- (void)selectedByIndex:(NSUInteger)index {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
}

@end
