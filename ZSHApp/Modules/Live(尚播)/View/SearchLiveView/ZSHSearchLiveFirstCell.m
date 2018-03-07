//
//  ZSHSearchLiveFirstCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSearchLiveFirstCell.h"

@interface ZSHSearchLiveFirstCell()

@property (nonatomic, strong)NSMutableArray *btnArr;

@end

@implementation ZSHSearchLiveFirstCell

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    
    NSArray *titleArr = @[@"黑微博",@"开播呗",@"小视频"];
    for (int i = 0; i<titleArr.count; i++) {
        NSDictionary *btnDic = @{@"title":titleArr[i],@"titleColor":KZSHColor333333,@"selectedTitleColor":KZSHColorF29E19,@"font":kPingFangLight(14)};
        UIButton *btn = [ZSHBaseUIControl  createBtnWithParamDic:btnDic target:self action:@selector(btnAction:)];
        btn.tag = i+1;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kRealValue(45));
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
            if (i == 0) {
                make.left.mas_equalTo(self).offset(kRealValue(30));
            } else if (i == 2) {
                make.right.mas_equalTo(self).offset(-kRealValue(30));
            } else {
                make.centerX.mas_equalTo(self);
            }
        }];
        [_btnArr addObject:btn];
    }
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
