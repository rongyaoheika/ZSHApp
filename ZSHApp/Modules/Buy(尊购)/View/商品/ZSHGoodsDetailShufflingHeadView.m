//
//  ZSHGoodsDetailShufflingHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailShufflingHeadView.h"
#import "ZSHCycleScrollView.h"

@interface ZSHGoodsDetailShufflingHeadView ()

/* 轮播图 */
@property (nonatomic, strong)ZSHCycleScrollView *cycleScrollView;

@end

@implementation ZSHGoodsDetailShufflingHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = KClearColor;
    _cycleScrollView = [[ZSHCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight * 0.3)];
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.scrollDirection =  ZSHCycleScrollViewHorizontal;
    [self addSubview:_cycleScrollView];
}

#pragma mark - Setter Getter Methods
- (void)setShufflingArray:(NSArray *)shufflingArray
{
    _shufflingArray = shufflingArray;
    _cycleScrollView.dataArr = [shufflingArray mutableCopy];
}


@end
