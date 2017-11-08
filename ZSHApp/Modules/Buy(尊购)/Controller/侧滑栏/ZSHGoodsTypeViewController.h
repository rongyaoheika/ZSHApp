//
//  ZSHGoodsTypeViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

@interface ZSHGoodsTypeViewController : RootViewController

@property (nonatomic,assign) ZSHCellType   cellType;
- (void)reloadUIWithCellType:(ZSHCellType)cellType;

@end
