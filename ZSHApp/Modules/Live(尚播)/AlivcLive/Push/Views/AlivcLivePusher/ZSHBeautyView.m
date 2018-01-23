//
//  ZSHBeautyView.m
//  ZSHApp
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHBeautyView.h"

@interface ZSHBeautyView ()

@property (nonatomic, strong) UIView            *beautyView;
@property (nonatomic, strong) UIView            *setView;
@property (nonatomic, strong) UIButton          *defaultBtn;
@property (nonatomic, strong) NSMutableArray    *btnArr;
@end

@implementation ZSHBeautyView

- (void)setup{
    
    _btnArr = [[NSMutableArray alloc]init];
    _beautyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(150))];
    _beautyView.backgroundColor = [UIColor redColor];
//    _beautyView.hidden = YES;
    [self addSubview:_beautyView];
    
    _setView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(150), KScreenWidth, kRealValue(140))];
    _setView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.90];
    [self addSubview:_setView];
    
    NSDictionary *titleLabelDic = @{@"text":@"美颜",@"font":kPingFangRegular(15)};
    UILabel *titleLB = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [_setView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_setView).offset(kRealValue(25));
        make.height.mas_equalTo(kRealValue(44));
        make.width.mas_equalTo(kRealValue(100));
        make.top.mas_equalTo(_setView);
    }];
    
    NSDictionary *btnDic = @{@"title":@"恢复默认",@"font":kPingFangRegular(12),@"backgroundColor":KZSHColor454545};
    _defaultBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
    _defaultBtn.layer.cornerRadius = kRealValue(12.5);
    [_setView addSubview:_defaultBtn];
    [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(25)));
        make.right.mas_equalTo(_setView).offset(-KLeftMargin);
        make.centerY.mas_equalTo(titleLB);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(44), KScreenWidth, kRealValue(1))];
    lineView.backgroundColor = KLightWhiteColor;;
    [_setView addSubview:lineView];
    
    CGFloat space = (KScreenWidth - kRealValue(200))/6;
    for (int i = 0; i <5; i++) {
        NSDictionary *setBtnDic = @{@"title":[NSString stringWithFormat:@"%d",i],@"titleColor":KWhiteColor,@"font":kPingFangRegular(30)};
        UIButton *setBtn = [ZSHBaseUIControl createBtnWithParamDic:setBtnDic];
        [setBtn setBackgroundImage:[UIImage imageWithColor:KClearColor size:CGSizeMake(kRealValue(40), kRealValue(40))] forState:UIControlStateSelected];
        [setBtn setBackgroundImage:[UIImage imageWithColor:KWhiteColor size:CGSizeMake(kRealValue(40), kRealValue(40))] forState:UIControlStateSelected];
        [_setView addSubview:setBtn];
        [setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
            make.left.mas_equalTo(_setView).offset((i+1)*space + i*kRealValue(40));
            make.top.mas_equalTo(lineView.mas_bottom).offset(kRealValue(28));
        }];
        [_btnArr addObject:setBtn];
    }
    
    
}

- (void)setBtnAction:(UIButton *)sender{
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn == sender) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
    
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
    
}

@end
