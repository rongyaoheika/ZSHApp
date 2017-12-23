//
//  ZSHEnergyHeadCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef void (^ItemClickBlock)(NSInteger);
@interface ZSHEnergyHeadCell : ZSHBaseCell

@property (nonatomic, copy) ItemClickBlock  itemClickBlock;

@end
