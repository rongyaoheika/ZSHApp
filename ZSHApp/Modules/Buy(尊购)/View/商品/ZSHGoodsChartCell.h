//
//  ZSHGoodsChartCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//


#import "ZSHBaseCollectionViewCell.h"

@interface ZSHGoodsChartCell : ZSHBaseCollectionViewCell

@property (nonatomic, assign) NSInteger row;

- (void)updateCellWithKey:(NSString *)key value:(NSString *)value;

@end
