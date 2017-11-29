//
//  ZSHCardCustomizedSecond.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardCustomizedSecond.h"

@interface ZSHCardCustomizedSecond ()

@property (nonatomic, strong) UIImageView      *cardImageView;
@property (nonatomic, strong) UILabel          *promptLabel;
@property (nonatomic, strong) NSMutableArray   *btnArr;
@end

@implementation ZSHCardCustomizedSecond

- (void)setup{
    self.userInteractionEnabled = YES;
    _btnArr = [[NSMutableArray alloc]init];
    
    _cardImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_customized"]];
    [self addSubview:_cardImageView];
    
     NSDictionary *promptDic = @{@"text":@"全球能力磁石GPS定位战术项链",@"font":kPingFangLight(11),@"textAlignment":@(NSTextAlignmentCenter)};
    _promptLabel = [ZSHBaseUIControl createLabelWithParamDic:promptDic];
    [self addSubview:_promptLabel];
    
    NSArray *titleArr = @[@"男",@"女"];
    for (int i = 0; i<titleArr.count; i++) {
//        NSDictionary *genderBtnDic = @{@"title":titleArr[i],@"font":kPingFangLight(14)};
        UIButton *genderBtn = [[UIButton alloc]init];
        [genderBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        genderBtn.titleLabel.font = kPingFangLight(14);
        
        //[ZSHBaseUIControl createBtnWithParamDic:genderBtnDic];
        [genderBtn setImage:[UIImage imageNamed:@"gender_normal"] forState:UIControlStateNormal];
        [genderBtn setImage:[UIImage imageNamed:@"gender_press"] forState:UIControlStateSelected];
        genderBtn.tag = i+1;
        [genderBtn addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:genderBtn];
        [_btnArr addObject:genderBtn];
    }
   
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.size.mas_equalTo(CGSizeMake(kRealValue(268), kRealValue(140)));
        make.centerX.mas_equalTo(self);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cardImageView.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(17));
    }];
    
    int i = 0;
    CGFloat leftSpace = (kScreenWidth - 2*kRealValue(50))/2;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(leftSpace+i*(kRealValue(50)+kRealValue(20)));
            make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(25)));
            make.top.mas_equalTo(_promptLabel.mas_bottom).offset(kRealValue(3.5));
        }];
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(8)];
        i++;
    }
}

#pragma action
- (void)genderBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
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
