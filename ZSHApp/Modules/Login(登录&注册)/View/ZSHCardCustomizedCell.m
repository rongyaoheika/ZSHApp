//
//  ZSHCardCustomizedCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardCustomizedCell.h"
#import "ZSHCardCustomizedFirst.h"
#import "ZSHCardCustomizedSecond.h"
@interface ZSHCardCustomizedCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray            *btnArr;
@property (nonatomic, strong) UIScrollView              *bottomScrollView;
@property (nonatomic, strong) ZSHCardCustomizedFirst    *customizedFirstView;
@property (nonatomic, strong) ZSHCardCustomizedSecond   *customizedSecondView;

@end

@implementation ZSHCardCustomizedCell

- (void)setup{
    
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *btnTitleArr = @[@"定制（200元）",@"定制（800元）",@"放弃定制"];
    for (int i = 0; i<btnTitleArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":btnTitleArr[i],@"font":kPingFangLight(15), @"selectedTitleColor":KZSHColorF29E19};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        cardTypeBtn.tag = i + 1;
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_normal"] forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_press"] forState:UIControlStateSelected];
        [cardTypeBtn addTarget:self action:@selector(cardNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
    }
    
    [self.contentView addSubview:self.bottomScrollView];
    
     _customizedFirstView = [[ZSHCardCustomizedFirst alloc]init];
    [self.bottomScrollView addSubview:_customizedFirstView];
    
    _customizedSecondView = [[ZSHCardCustomizedSecond alloc]init];
    [_customizedSecondView selectedByIndex:2];
    [self.bottomScrollView addSubview:_customizedSecondView];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat leftSpace = (kScreenWidth - 3*kRealValue(100))/2;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(leftSpace+i*kRealValue(100));
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
            make.top.mas_equalTo(self).offset(kRealValue(20));
        }];
        i++;
    }
    
    self.bottomScrollView.contentSize = CGSizeMake(3*kScreenWidth, self.frame.size.height-kRealValue(50));
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(50));
        make.bottom.mas_equalTo(self).offset(-KLeftMargin);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self);
    }];
    
    [_customizedFirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomScrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(_bottomScrollView);
        make.top.mas_equalTo(_bottomScrollView);
    }];
    
    [_customizedSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomScrollView).offset(KScreenWidth);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(_bottomScrollView);
        make.top.mas_equalTo(_bottomScrollView);
    }];
}

#pragma getter
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _bottomScrollView.scrollsToTop = NO;
        _bottomScrollView.scrollEnabled = YES;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate = self;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bottomScrollView;
}

#pragma action
- (void)cardNumBtnAction:(UIButton *)btn{
    [self selectedByIndex:btn.tag];
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
    
    [self.bottomScrollView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-1), 0) animated:YES];
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger tag = scrollView.contentOffset.x/kScreenWidth;
    [self selectedByIndex:tag+1];
}

@end
