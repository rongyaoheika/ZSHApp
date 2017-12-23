//
//  ZSHClassCategoryCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
@class ZSHClassGoodsModel;
@interface ZSHClassCategoryCell : ZSHBaseCell

/* 标题数据 */
@property (nonatomic, strong)ZSHClassGoodsModel *titleItem;

/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 指示View */
@property (strong , nonatomic)UIView *indicatorView;

@end
