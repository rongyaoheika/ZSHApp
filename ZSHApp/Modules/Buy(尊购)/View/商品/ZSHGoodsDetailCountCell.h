//
//  ZSHGoodsDetailCountCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCollectionViewCell.h"


typedef void(^JSNumberChangeBlock)(NSInteger count);

@interface ZSHGoodsDetailCountCell : ZSHBaseCollectionViewCell

@property (nonatomic, copy) JSNumberChangeBlock NumberChangeBlock;

@end
