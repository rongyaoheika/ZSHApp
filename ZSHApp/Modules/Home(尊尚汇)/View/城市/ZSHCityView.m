//
//  RLJKCityView.m
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCityView.h"
#define btnWith       kRealValue(90)
#define btnHeight     kRealValue(30)
#define xSpacing      kRealValue(15)
#define ySpacing      kRealValue(10)

@interface ZSHCityView()

@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation ZSHCityView

- (void)setup{
    self.titleArr = self.paramDic[@"titleArr"];
    
    NSDictionary *btnDic = @{@"title":@"三亚",@"font":kPingFangLight(14)};
    
    for (int i = 0; i<self.titleArr.count; i++) {
        UIButton *cityBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        [cityBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        cityBtn.tag = i+1;
        [ZSHSpeedy zsh_chageControlCircularWith:cityBtn AndSetCornerRadius:kRealValue(6.0) SetBorderWidth:1.0 SetBorderColor:KZSHColor929292 canMasksToBounds:YES];
        cityBtn.frame = CGRectMake(KLeftMargin + (i%3)*(btnWith + xSpacing), (i/3)*(btnHeight + ySpacing), btnWith, btnHeight);
        [self addSubview:cityBtn];
    }
}


- (void)btnClick:(UIButton*)btn{
    RLog(@"点击了城市");
}

@end
