//
//  ZSHWeiBoBottomView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiBoBottomView.h"

@implementation ZSHWeiBoBottomView

- (void)setup{
    
    self.backgroundColor = KClearColor;
    NSArray *imageArr = @[@"weibo_love",@"weibo_comment",@"weibo_present"];
    NSArray *titleArr = @[@"18",@"56",@"56"];
    for (int i = 0; i<3; i++) {
        NSDictionary *btnDic = @{@"title":titleArr[i],@"titleColor":KZSHColor929292,@"font":kPingFangRegular(18),@"backgroundColor":KClearColor};
        UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        btn.tag = i+1;
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*KScreenWidth/3);
            make.width.mas_equalTo(KScreenWidth/3);
            make.height.mas_equalTo(kRealValue(22));
            make.centerY.mas_equalTo(self);
        }];
        
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(10)];
    }

}

- (void)btnAction:(UIButton*)btn{
    
}

@end
