//
//  ZSHGoodsDetailShufflingHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailShufflingHeadView.h"
#import "ZSHGuideView.h"
#import "ZSHGoodDetailModel.h"


@interface ZSHGoodsDetailShufflingHeadView ()


/* 轮播图 */
@property (nonatomic, strong) ZSHGuideView       *headView;

@end

@implementation ZSHGoodsDetailShufflingHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];
    }
    return self;
}

- (void)setup {
    NSDictionary *nextParamDic = @{KFromClassType:@(FromGoodsDetailVCToGuideView), @"pageViewHeight":@(kRealValue(225)), @"min_scale":@(1.0),@"withRatio":@(1.0),@"pageImage":@"page_press",@"currentPageImage":@"page_normal",@"infinite":@(false)};
    _headView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self addSubview:_headView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Setter Getter Methods
- (void)updateCellWithModel:(ZSHBaseModel *)model{
    ZSHGoodDetailModel *goodDetailModel = (ZSHGoodDetailModel *)model;
    [_headView updateViewWithParamDic:@{@"dataArr":goodDetailModel.PRODUCTIMG}];
}

//- (void)setShufflingArray:(NSArray *)shufflingArray
//{
//    _shufflingArray = shufflingArray;
//    _cycleScrollView.dataArr = [shufflingArray mutableCopy];
//}


@end
