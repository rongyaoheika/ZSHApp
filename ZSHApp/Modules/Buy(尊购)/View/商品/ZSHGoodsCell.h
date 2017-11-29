//
//  ZSHGoodsCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

//#import "ZSHBaseCollectionViewCell.h"
#import "ZSHBaseView.h"

@class ZSHGoodModel;

@interface ZSHGoodsCell : ZSHBaseView //ZSHBaseCollectionViewCell

@property (nonatomic, assign) ZSHCellType   cellType;
/* 推荐数据 */
@property (nonatomic, strong) ZSHGoodModel   *goodModel;
/* 相同 */
@property (nonatomic, strong)UIButton       *sameButton;

/** 找相似点击回调 */
@property (nonatomic, copy) dispatch_block_t lookSameBlock;

- (void)updateViewWithModel:(ZSHBaseModel *)model;

@end
