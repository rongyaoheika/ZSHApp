//
//  ZSHLuckCardView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLuckCardView.h"
#import "iCarousel.h"


@interface ZSHLuckCardView()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) iCarousel        *carousel;
@property (nonatomic, strong) NSArray          *imageArr;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) UIImageView      *bgImageView;

@end

@implementation ZSHLuckCardView

- (void)setup{
    [self addSubview:self.carousel];
    [self.carousel scrollToItemAtIndex:1 animated:NO];
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.left.mas_equalTo(self);
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

#pragma mark - delegate

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    RLog(@"点击的index == %ld",carousel.currentItemIndex);
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    CGFloat max_sacle = 1.0f;
    CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope * tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.5, 0.0, 0.0);
}

#pragma mark - datasource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    if(!view){
        view = [self createbgImageView];
    }
    return view;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    RLog(@"被点击的 是 第%ld 卡片中的 第 %ld",(long)_carousel+1,(long)index+1);
}

- (UIView *)createbgImageView{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"luck_card"]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(0, 0, kRealValue(160), kRealValue(215));
    self.bgImageView = bgImageView;

    NSDictionary *descLabelDic = @{@"text":@"每次翻牌需消耗100积分",@"font":kPingFangRegular(10),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *descLabel = [ZSHBaseUIControl createLabelWithParamDic:descLabelDic];
    [bgImageView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.width.mas_equalTo(kRealValue(110));
        make.height.mas_equalTo(kRealValue(10));
        make.bottom.mas_equalTo(bgImageView).offset(-kRealValue(10));
    }];

    NSDictionary *transferBtnDic = @{@"title":@"点击翻牌",@"titleColor":KZSHColor929292,@"font":kPingFangMedium(15),@"backgroundColor":[UIColor colorWithHexString:@"272727"]};
    UIButton *transferBtn = [ZSHBaseUIControl createBtnWithParamDic:transferBtnDic];
    transferBtn.layer.cornerRadius = kRealValue(15);
    [transferBtn addTarget:self action:@selector(transformAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:transferBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(descLabel.mas_bottom).offset(-kRealValue(12.5));
        make.height.mas_equalTo(kRealValue(27));
        make.width.mas_equalTo(kRealValue(95));
    }];

    [self layoutIfNeeded];
    return bgImageView;
}


- (void)transformAction:(UIButton *)btn{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    UIImageView *bgImageView = (UIImageView *)btn.superview;
    [bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
