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
#import "LXScollTitleView.h"

@interface ZSHSelectCardNumCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView                   *bgIV;
@property (nonatomic, strong) LXScollTitleView              *titleView;
@property (nonatomic, strong) ZSHSelectCardNumFirstView     *firstView;
@property (nonatomic, strong) ZSHSelectCardNumSecondView    *secondView;
@property (nonatomic, strong) UIScrollView                  *bottomScrollView;

@end

@implementation ZSHSelectCardNumCell

- (void)setup{
    NSArray *btnTitleArr = @[@"随机",@"选号"];
    [self.contentView addSubview:self.titleView];
    self.titleView.selectedIndex = 0;
    
    _bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seg_two_bg"]];
    [self.titleView addSubview:_bgIV];
    [self.titleView reloadViewWithTitles:btnTitleArr];
    
    [self.contentView addSubview:self.bottomScrollView];
    
    _firstView = [[ZSHSelectCardNumFirstView alloc]initWithFrame:CGRectZero];
    [self.bottomScrollView addSubview:_firstView];
    
    _secondView = [[ZSHSelectCardNumSecondView alloc]initWithFrame:CGRectZero];
    [self.bottomScrollView addSubview:_secondView];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(200));
        make.height.mas_equalTo(kRealValue(30));
    }];
    
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_titleView);
    }];
    
    int i = 0;
    for (UIButton *btn in _titleView.titleButtons) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleView).mas_equalTo(kRealValue(99.5)*i);
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
            make.top.mas_equalTo(_titleView);
        }];
        i++;
    }
    
    self.bottomScrollView.contentSize = CGSizeMake(2*kScreenWidth, 0);
    CGFloat scrollViewH = (_selectIndex == 0?kRealValue(120):kRealValue(1200));
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(kRealValue(50), 0, 0, 0));
        make.height.mas_equalTo(scrollViewH);
    }];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bottomScrollView);
        make.width.mas_equalTo(KScreenWidth);
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstView.mas_right);
        make.top.mas_equalTo(_bottomScrollView);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(kRealValue(1200));
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

- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-kRealValue(200))/2, kRealValue(200),kRealValue(30))];
        _titleView.selectedBgImage = [UIImage imageNamed:@"seg_press"];
        _titleView.normalTitleFont = kPingFangLight(15);
        _titleView.selectedTitleFont = kPingFangLight(15);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            weakSelf.selectIndex = index;
        };
        _titleView.titleWidth = kRealValue(100);
    }
    return _titleView;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    _titleView.selectedIndex = selectIndex;
    [self.bottomScrollView setContentOffset:CGPointMake(_selectIndex * KScreenWidth, 0) animated:YES];
    if (self.cellHeightBlock) {
        self.cellHeightBlock(_selectIndex);
    }
    
}

#pragma action

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    _selectIndex = index;
    self.titleView.selectedIndex = index;
    if (self.cellHeightBlock) {
        self.cellHeightBlock(index);
    }
}

@end
