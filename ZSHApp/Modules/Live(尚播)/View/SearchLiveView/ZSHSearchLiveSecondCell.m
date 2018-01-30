//
//  ZSHSearchLiveSecondCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSearchLiveSecondCell.h"

@interface ZSHSearchLiveSecondCell()

@property (nonatomic, strong)NSMutableArray *btnArr;

@end

@implementation ZSHSearchLiveSecondCell

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    
    NSDictionary *titleLabelDic = @{@"text":@"性别",@"font":kPingFangLight(14),@"textColor":KZSHColor333333};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(30));
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(40));
    }];
    
    NSArray *titleArr = @[@"全部",@"男",@"女"];
    for (int i = 0; i<titleArr.count; i++) {
        NSDictionary *btnDic = @{@"title":titleArr[i],@"titleColor":KZSHColor333333,@"selectedTitleColor":KZSHColorF29E19,@"font":kPingFangLight(14)};
        UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kRealValue(75));
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(kRealValue(148)+i*kRealValue(75));
        }];
        [_btnArr addObject:btn];
        
        UIView *devideLine = [[UIView alloc]init];
        devideLine.backgroundColor = KZSHColorE9E9E9;
        [self.contentView addSubview:devideLine];
        [devideLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_left);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(self);
            make.width.mas_equalTo(0.5);
        }];
    }
 
    [self selectedByIndex:1];
}

- (void)btnAction:(UIButton *)btn{
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
