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

@property (nonatomic, assign) CGSize           midImageSize;
@property (nonatomic, strong) NSArray          *imageArr;
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
    [self layoutIfNeeded];
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
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(8));
        if (kFromClassTypeValue == FromHotelDetailVCToGuideView) {
             make.width.mas_equalTo(kRealValue(60));
             make.right.mas_equalTo(self).offset(-kRealValue(7.0));
        } else {
            make.width.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
        }
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
//    cell.backgroundColor = self.imageArr[index];
//    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
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
        layout.itemSize = CGSizeMake(kScreenWidth, CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 0;
    } else {
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 15;
    }
   
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

- (void)updateViewWithParamDic:(NSDictionary *)dic{
    self.imageArr = dic[@"dataArr"];
    [self.pagerView reloadData];
    [self layoutIfNeeded];
}

@end
