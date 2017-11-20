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

@property (nonatomic, strong) LXScollTitleView              *titleView;
@property (nonatomic, strong) UIScrollView                  *bottomScrollView;
@property (nonatomic, strong) ZSHSelectCardNumFirstView     *firstView;
@property (nonatomic, strong) ZSHSelectCardNumSecondView    *secondView;
@property (nonatomic, assign) NSInteger                     selectIndex;

@end

@implementation ZSHSelectCardNumCell

- (void)setup{
    NSArray *btnTitleArr = @[@"随机",@"选号"];
    [self.contentView addSubview:self.titleView];
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
        make.left.mas_equalTo(self).offset((kScreenWidth-kRealValue(200))/2);
        make.width.mas_equalTo(kRealValue(200));
        make.height.mas_equalTo(kRealValue(30));
    }];
    
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
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-kRealValue(200))/2, kRealValue(200), kRealValue(30))];
        _titleView.selectedBgImage = [UIImage imageNamed:@"seg_press"];
        _titleView.normalTitleFont = kPingFangLight(15);
        _titleView.selectedTitleFont = kPingFangLight(15);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            [strongSelf.bottomScrollView setContentOffset:CGPointMake(index * KScreenWidth, 0) animated:YES];
        };
        _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seg_two_bg"] ];
        _titleView.titleWidth = kRealValue(100);
    }
    return _titleView;
}


#pragma action

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.titleView.selectedIndex = index;
}

- (CGFloat)rowHeightWithCellModel:(ZSHBaseModel *)model{
    return CGRectGetMaxY(_bottomScrollView.frame);
}

@end
