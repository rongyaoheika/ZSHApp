//
//  ZSHCardPayCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardPayCell.h"

@interface ZSHCardPayCell ()

@property (nonatomic, strong) NSMutableArray   *btnArr;
@property (nonatomic, strong) UILabel          *promptLabel;


@end

@implementation ZSHCardPayCell

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *btnTitleArr = @[@"微信",@"支付宝"];
    NSArray *imageArr = @[@"pay_wechat",@"pay_alipay"];
    for (int i = 0; i<btnTitleArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":btnTitleArr[i],@"font":kPingFangLight(15), @"selectedTitleColor":KZSHColorF29E19,@"withImage":@(YES),@"normalImage":imageArr[i]};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.tag = i + 1;
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_normal"] forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_press"] forState:UIControlStateSelected];
        [cardTypeBtn addTarget:self action:@selector(cardNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
    }
    [self selectedByIndex:1];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat leftSpace = (kScreenWidth - 2*kRealValue(100))/2;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(leftSpace+i*kRealValue(100));
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
            make.top.mas_equalTo(self).offset(kRealValue(20));
        }];
        
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(20)];
        i++;
    }
}

#pragma action
- (void)cardNumBtnAction:(UIButton *)btn{
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
