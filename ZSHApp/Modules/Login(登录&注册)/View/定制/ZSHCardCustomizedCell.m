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
#import "LXScollTitleView.h"
@interface ZSHCardCustomizedCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) LXScollTitleView          *titleView;
@property (nonatomic, strong) UIScrollView              *bottomScrollView;
@property (nonatomic, strong) ZSHCardCustomizedFirst    *customizedFirstView;
@property (nonatomic, strong) ZSHCardCustomizedSecond   *customizedSecondView;

@end

@implementation ZSHCardCustomizedCell

- (void)setup{
   _titleArr = @[@"定制（200元）",@"定制（800元）",@"放弃定制"];
    [self.contentView addSubview:self.titleView];
    [self.titleView reloadViewWithTitles:self.titleArr];
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
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.left.mas_equalTo(self).offset(kRealValue(40));
        make.width.mas_equalTo(kRealValue(300));
        make.height.mas_equalTo(kRealValue(30));
    }];
    self.bottomScrollView.contentSize = CGSizeMake(3*kScreenWidth, 0);
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

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-kRealValue(300))/2, kRealValue(300), kRealValue(30))];
        _titleView.selectedBgImage = [UIImage imageNamed:@"card_press"];
        _titleView.normalTitleFont = kPingFangLight(14);
        _titleView.selectedTitleFont = kPingFangLight(14);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            NSString *custom = @"";
            switch (index) {
                case 0:
                    custom = @"1";
                    break;
                case 1:
                    custom = @"2";
                    break;
                case 2:
                    custom = @"0";
                    break;
                default:
                    custom = @"0";
                    break;
            }
            [[NSUserDefaults standardUserDefaults] setObject:custom forKey:@"CUSTOM"];
            [strongSelf.bottomScrollView setContentOffset:CGPointMake(index * KScreenWidth, 0) animated:YES];
        };
        _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seg_three_bg"] ];
        _titleView.titleWidth = kRealValue(100);
    }
    return _titleView;
}

#pragma action

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.titleView.selectedIndex = index;
}

@end
