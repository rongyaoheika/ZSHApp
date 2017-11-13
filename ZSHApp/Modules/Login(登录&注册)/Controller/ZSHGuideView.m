//
//  ZSHGuideView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideView.h"
#import "iCarousel.h"

@interface ZSHGuideView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) iCarousel        *carousel;
@property (nonatomic, strong) NSArray          *imageArr;
@property (nonatomic, strong) UIPageControl    *pageControl;

@end

@implementation ZSHGuideView

- (void)setup{
    self.imageArr = self.paramDic[@"dataArr"];
    [self addSubview:self.carousel];
    [self.carousel scrollToItemAtIndex:1 animated:NO];
    [self addSubview:self.pageControl];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(440));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-kRealValue(8));
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(8));
        make.centerX.mas_equalTo(self);
    }];
    
}

#pragma mark - getter
- (iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc]init];
        _carousel.dataSource = self;
        _carousel.delegate = self;
        _carousel.backgroundColor = [UIColor clearColor];
        _carousel.type = iCarouselTypeCustom;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = NO;
        _carousel.perspective = -10.0/500.0;
    }
    return _carousel;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = self.imageArr.count;
        _pageControl.currentPageIndicatorTintColor = KWhiteColor;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _pageControl;
}


#pragma mark - delegate
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    CGFloat max_sacle = 1.0f;
    CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope * tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.8, 0.0, 0.0);
}

#pragma mark - datasource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.imageArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    if (!view) {
        view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArr[index]]]];
        view.frame = CGRectMake(kRealValue(37.5), 0, KScreenWidth - 2*kRealValue(37.5), kRealValue(440));

    }
    return view;
    
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    RLog(@"被点击的 是 第%ld 卡片中的 第 %ld",(long)_carousel+1,(long)index+1);
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.imageArr = dic[@"dataArr"];
    [self layoutIfNeeded];
}

@end
