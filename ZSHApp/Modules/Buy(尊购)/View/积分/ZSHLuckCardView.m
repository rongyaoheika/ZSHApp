//
//  ZSHLuckCardView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLuckCardView.h"
#import "TYCyclePagerView.h"
#import "ZSHLuckCardCell.h"

@interface ZSHLuckCardView()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) NSArray          *imageArr;
@property (nonatomic, strong) UIPageControl    *pageControl;

@end

@implementation ZSHLuckCardView

- (void)setup{
    
    [self addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.left.mas_equalTo(self);
    }];
    
    [self addSubview:self.pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(8));
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark - getter
- (TYCyclePagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]init];
        _pagerView.layer.borderWidth = 1;
        _pagerView.isInfiniteLoop = [self.paramDic[@"infinite"] boolValue];
        //        _pagerView.autoScrollInterval = 3.0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        [_pagerView registerClass:[ZSHLuckCardCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = self.imageArr.count;
        _pageControl.currentPageIndicatorTintColor = KWhiteColor;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        if (self.paramDic[@"pageImage"]) {
            [_pageControl setValue:[UIImage imageNamed:self.paramDic[@"pageImage"]] forKeyPath:@"_pageImage"];
            [_pageControl setValue:[UIImage imageNamed:self.paramDic[@"currentPageImage"]] forKeyPath:@"_currentPageImage"];
        }
        
    }
    return _pageControl;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    ZSHLuckCardCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
//    cell.imageView.image = [UIImage imageNamed:self.imageArr[index]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.5, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 15;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    //    NSLog(@"%zd ->  %zd",fromIndex,toIndex);
}


@end
