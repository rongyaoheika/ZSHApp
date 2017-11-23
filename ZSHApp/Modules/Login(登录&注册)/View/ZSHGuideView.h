//
//  ZSHGuideView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
#import "TYCyclePagerView.h"

@interface ZSHGuideView : ZSHBaseView

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) UIPageControl    *pageControl;

@end
