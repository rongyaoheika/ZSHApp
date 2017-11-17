//
//  ZSHSelectCardNumCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSelectCardNumCell.h"
#import "ZSHSelectCardNumFirstView.h"
#import "ZSHSelectCardNumSecondView.h"
@interface ZSHSelectCardNumCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray                *btnArr;
@property (nonatomic, strong) UIScrollView                  *bottomScrollView;
@property (nonatomic, strong) ZSHSelectCardNumFirstView     *firstView;
@property (nonatomic, strong) ZSHSelectCardNumSecondView    *secondView;
@property (nonatomic, assign) NSInteger                     selectIndex;

@end
@implementation ZSHSelectCardNumCell

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *btnTitleArr = @[@"随机",@"选号"];
    for (int i = 0; i<btnTitleArr.count; i++) {
        NSDictionary *cardTypeBtnDic = @{@"title":btnTitleArr[i],@"font":kPingFangLight(15), @"selectedTitleColor":KZSHColorF29E19};
        UIButton *cardTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:cardTypeBtnDic];
        cardTypeBtn.tag = i + 1;
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_normal"] forState:UIControlStateNormal];
        [cardTypeBtn setBackgroundImage:[UIImage imageNamed:@"card_press"] forState:UIControlStateSelected];
        [cardTypeBtn addTarget:self action:@selector(cardNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cardTypeBtn];
        [_btnArr addObject:cardTypeBtn];
    }
    
    [self.contentView addSubview:self.bottomScrollView];
    
    _firstView = [[ZSHSelectCardNumFirstView alloc]initWithFrame:CGRectZero];
    [self.bottomScrollView addSubview:_firstView];
    
    _secondView = [[ZSHSelectCardNumSecondView alloc]initWithFrame:CGRectZero];
    [self.bottomScrollView addSubview:_secondView];
    
    [self layoutIfNeeded];
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
        i++;
    }
    
    self.bottomScrollView.contentSize = CGSizeMake(2*kScreenWidth, 0);
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(50));
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kRealValue(2380));
//        if (_selectIndex == 1) {
//            make.height.mas_equalTo(kRealValue(63));
//        } else if(_selectIndex == 2) {
//            make.height.mas_equalTo(kRealValue(2380));
//        }
    }];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomScrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(_bottomScrollView);
        make.top.mas_equalTo(_bottomScrollView);
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomScrollView).offset(KScreenWidth);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(_bottomScrollView);
        make.top.mas_equalTo(_bottomScrollView);
    }];
    
//    _cellHeight = CGRectGetMaxY(_bottomScrollView.frame);
//    
//    RLog(@"cellHight == %f\n  bottomScrollView.frame = %@\n  _firstView.frame = %@\n ,_secondView.frame = %@" ,_cellHeight,NSStringFromCGRect(_bottomScrollView.frame),NSStringFromCGRect(_firstView.frame),NSStringFromCGRect(_secondView.frame));
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
    _selectIndex = index;
    [self layoutSubviews];
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

- (CGFloat)rowHeightWithCellModel:(ZSHBaseModel *)model{
    return CGRectGetMaxY(_bottomScrollView.frame);
}

@end
