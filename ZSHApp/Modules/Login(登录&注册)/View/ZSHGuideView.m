//
//  ZSHGuideView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideView.h"
#import "TYCyclePagerViewCell.h"

@interface ZSHGuideView ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) UIPageControl    *pageControl;
//@property (nonatomic, assign) CGSize           midImageSize;
@property (nonatomic, strong) NSMutableArray   *imageArr;
@property (nonatomic, assign) CGFloat          min_scale;
@property (nonatomic, assign) CGFloat          withRatio;
@property (nonatomic, assign) CGFloat          contentLeft;

@end

@implementation ZSHGuideView

- (void)setup{
    
    self.imageArr = self.paramDic[@"dataArr"];
    _min_scale = [self.paramDic[@"min_scale"]floatValue];
    _withRatio = [self.paramDic[@"withRatio"]floatValue];
    
    [self addSubview:self.pagerView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo([self.paramDic[@"pageViewHeight"]floatValue]);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealValue(8));
        if (kFromClassTypeValue == FromHotelDetailVCToGuideView) {
             make.width.mas_equalTo(kRealValue(150));
             make.right.mas_equalTo(self);
             make.bottom.mas_equalTo(self).offset(-KLeftMargin);
        } else {
            make.width.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }
    }];
}

#pragma mark - getter
- (TYCyclePagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]init];
        _pagerView.isInfiniteLoop = [self.paramDic[@"infinite"] boolValue];
//        _pagerView.autoScrollInterval = 3.0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        [_pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
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
    return self.imageArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.type = kFromClassTypeValue;
    if ([self.imageArr[index] containsString:@"http"]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[index]]];
    } else {
        cell.imageView.image = [UIImage imageNamed:self.imageArr[index]];
    }
    
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    if (kFromClassTypeValue == FromHotelDetailVCToGuideView) {
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 0;
        layout.layoutType = TYCyclePagerTransformLayoutNormal;
        layout.itemHorizontalCenter = NO;
    } else if (kFromClassTypeValue == FromGoodsDetailVCToGuideView) {
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 0;
        layout.layoutType = TYCyclePagerTransformLayoutNormal;
        layout.itemHorizontalCenter = NO;
//
    } else if (kFromClassTypeValue == FromBuyVCToGuideView){
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 15;
        layout.layoutType = TYCyclePagerTransformLayoutNormal;
        layout.itemHorizontalCenter = YES;
    }else {
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 15;
        layout.layoutType = TYCyclePagerTransformLayoutLinear;
        layout.itemHorizontalCenter = YES;
    }
    // layout.minimumAlpha = 0.3;
    // layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    //RLog(@"%zd ->  %zd",fromIndex,toIndex);
}

- (void)updateViewWithParamDic:(NSDictionary *)paramDic{
    _imageArr = paramDic[@"dataArr"];
    _pageControl.numberOfPages = _imageArr.count;
    [_pagerView reloadData];
    [_pagerView setNeedUpdateLayout];
}

@end
