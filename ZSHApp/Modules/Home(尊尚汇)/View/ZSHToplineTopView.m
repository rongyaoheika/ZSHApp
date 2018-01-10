//
//  ZSHToplineTopView.m
//  ZSHApp
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHToplineTopView.h"

@implementation ZSHToplineTopView

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(50))];
    btnView.tag = 3;
    btnView.backgroundColor = KZSHColor0B0B0B;
    [self addSubview:btnView];
    NSArray *titleArr = @[@"文字",@"图片",@"视频"];
    NSArray *imageArr = @[@"topline_edit",@"topline_photo",@"topline_video",];
    for (int i = 0; i<3; i++) {
        UIButton *topLineTopBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth/3)*i, 0, kScreenWidth/3, kRealValue(50))];
        topLineTopBtn.tag = i;
        [topLineTopBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [topLineTopBtn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
        [topLineTopBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [topLineTopBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(5)];
        [topLineTopBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:topLineTopBtn];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != 3) {
        [UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
            [self removeFromSuperview];
        } completion:nil];
    }
}

- (void)btnAction:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

@end
